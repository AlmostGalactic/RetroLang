-- Parser.lua

local Parser = {}

function Parser.new(tokens)
    local self = {
        tokens  = tokens,
        current = 1
    }

    ------------------------------------------------------------------------
    -- Basic token-handling helpers
    ------------------------------------------------------------------------
    local function peek()
        return self.tokens[self.current]
    end

    local function isAtEnd()
        return self.current > #self.tokens
    end

    local function advance()
        if not isAtEnd() then
            self.current = self.current + 1
        end
        return self.tokens[self.current - 1]
    end

    local function check(tokenType, tokenValue)
        if isAtEnd() then return false end
        local t = peek()
        if t.type ~= tokenType then return false end
        if tokenValue and t.value ~= tokenValue then return false end
        return true
    end

    local function match(tokenType, tokenValue)
        if check(tokenType, tokenValue) then
            return advance()
        end
        return nil
    end

    local function consume(tokenType, tokenValue, errMsg)
        if check(tokenType, tokenValue) then
            return advance()
        end
        local actual = peek()
        error(errMsg .. " (got " ..
            (actual and (actual.type .. " " .. tostring(actual.value)) or "EOF") ..
            ")")
    end

    ------------------------------------------------------------------------
    -- Forward Declarations
    ------------------------------------------------------------------------
    local parseProgram, parseStatement, parseBlock
    local parseExpression, parseComparison, parseTerm, parseFactor, parsePrimary
    local parseBasePrimary
    local parseVarDeclaration, parseFunctionDeclaration
    local parseReturnStatement, parseIfStatement, parseWhileStatement

    ------------------------------------------------------------------------
    -- PROGRAM -> ( statement )*
    ------------------------------------------------------------------------
    function parseProgram()
        local statements = {}
        while not isAtEnd() do
            table.insert(statements, parseStatement())
        end
        return { type = "Program", body = statements }
    end

    ------------------------------------------------------------------------
    -- STATEMENT
    ------------------------------------------------------------------------
    function parseStatement()
        local t = peek()
        if not t then return nil end

        if check("KEYWORD", "DEC") then
            return parseVarDeclaration()
        end
        if check("KEYWORD", "FN") then
            return parseFunctionDeclaration()
        end
        if check("KEYWORD", "RETURN") then
            return parseReturnStatement()
        end
        if check("KEYWORD", "IF") then
            return parseIfStatement()
        end
        if check("KEYWORD", "WHILE") then
            return parseWhileStatement()
        end

        local expr = parseExpression()
        if not expr then
            error("Unexpected token in parseStatement: " ..
                (peek() and peek().value or "EOF"))
        end

        if match("SYMBOL", "=") then
            if expr.type ~= "Identifier" then
                error("Left side of assignment must be an identifier in this simple parser.")
            end
            local valueExpr = parseExpression()
            return {
                type = "AssignmentStatement",
                target = expr,
                value = valueExpr
            }
        else
            return { type = "ExpressionStatement", expression = expr }
        end
    end

    ------------------------------------------------------------------------
    -- varDeclaration -> "DEC" IDENTIFIER "=" expression
    ------------------------------------------------------------------------
    function parseVarDeclaration()
        consume("KEYWORD", "DEC", "Expected 'DEC'")
        local nameTok = consume("IDENTIFIER", nil, "Expected variable name")
        consume("SYMBOL", "=", "Expected '=' after variable name")
        local initExpr = parseExpression()
        return {
            type = "VarDeclaration",
            name = nameTok.value,
            initializer = initExpr
        }
    end

    ------------------------------------------------------------------------
    -- functionDeclaration -> "FN" IDENTIFIER "(" paramList? ")" block "STOP"
    ------------------------------------------------------------------------
    function parseFunctionDeclaration()
        consume("KEYWORD", "FN", "Expected 'FN'")
        local nameTok = consume("IDENTIFIER", nil, "Expected function name")
        consume("SYMBOL", "(", "Expected '(' after function name")
        local params = {}
        if not check("SYMBOL", ")") then
            repeat
                local p = consume("IDENTIFIER", nil, "Expected parameter name")
                table.insert(params, p.value)
            until not match("SYMBOL", ",")
        end
        consume("SYMBOL", ")", "Expected ')' after parameters")
        local body = parseBlock()
        consume("KEYWORD", "STOP", "Expected 'STOP' after function body")
        return {
            type = "FunctionDeclaration",
            name = nameTok.value,
            params = params,
            body = body
        }
    end

    ------------------------------------------------------------------------
    -- returnStatement -> "RETURN" expression?
    ------------------------------------------------------------------------
    function parseReturnStatement()
        consume("KEYWORD", "RETURN", "Expected 'RETURN'")
        if check("IDENTIFIER") or check("NUMBER") or check("STRING") or check("SYMBOL", "(") then
            local expr = parseExpression()
            return { type = "ReturnStatement", expression = expr }
        else
            return { type = "ReturnStatement", expression = nil }
        end
    end

    ------------------------------------------------------------------------
    -- ifStatement -> "IF" expression "DO" block (ELSEIF expression "DO" block)* (ELSE block)? "STOP"
    ------------------------------------------------------------------------
    function parseIfStatement()
        consume("KEYWORD", "IF", "Expected 'IF'")
        local condExpr = parseExpression()
        consume("KEYWORD", "DO", "Expected 'DO' after IF condition")
        local thenBranch = parseBlock()

        local elseIfs = {}
        while check("KEYWORD", "ELSEIF") do
            advance()  -- consume ELSEIF
            local elseifCondition = parseExpression()
            consume("KEYWORD", "DO", "Expected 'DO' after ELSEIF condition")
            local elseifBranch = parseBlock()
            table.insert(elseIfs, { condition = elseifCondition, branch = elseifBranch })
        end

        local elseBranch = nil
        if check("KEYWORD", "ELSE") then
            advance()  -- consume ELSE
            elseBranch = parseBlock()
        end

        consume("KEYWORD", "STOP", "Expected 'STOP' after IF statement")
        return {
            type = "IfStatement",
            condition = condExpr,
            thenBranch = thenBranch,
            elseIfs = elseIfs,
            elseBranch = elseBranch
        }
    end

    ------------------------------------------------------------------------
    -- whileStatement -> "WHILE" expression "DO" block "STOP"
    ------------------------------------------------------------------------
    function parseWhileStatement()
        consume("KEYWORD", "WHILE", "Expected 'WHILE'")
        local condExpr = parseExpression()
        consume("KEYWORD", "DO", "Expected 'DO' after WHILE condition")
        local body = parseBlock()
        consume("KEYWORD", "STOP", "Expected 'STOP' after WHILE loop")
        return {
            type = "WhileStatement",
            condition = condExpr,
            body = body
        }
    end

    ------------------------------------------------------------------------
    -- block -> ( statement )*
    -- stops if it sees "STOP", "ELSE", or "ELSEIF"
    ------------------------------------------------------------------------
    function parseBlock()
        local statements = {}
        while not isAtEnd() do
            if check("KEYWORD", "STOP") or check("KEYWORD", "ELSE") or check("KEYWORD", "ELSEIF") then
                break
            end
            table.insert(statements, parseStatement())
        end
        return statements
    end

    ------------------------------------------------------------------------
    -- EXPRESSIONS
    --
    -- expression     -> comparison
    -- comparison     -> term (( "==" | "!=" | "<" | "<=" | ">" | ">=" ) term)*
    -- term           -> factor (( "+" | "-" ) factor)*
    -- factor         -> primary (( "*" | "/" ) primary)*
    -- primary        -> parseBasePrimary then optional function calls or index expressions
    ------------------------------------------------------------------------
    function parseExpression()
        return parseComparison()
    end

    function parseComparison()
        local expr = parseTerm()
        while true do
            if check("SYMBOL", "==") or check("SYMBOL", "!=")
               or check("SYMBOL", "<") or check("SYMBOL", ">")
               or check("SYMBOL", "<=") or check("SYMBOL", ">=") then
                local op = advance().value
                local right = parseTerm()
                expr = {
                    type = "BinaryExpression",
                    operator = op,
                    left = expr,
                    right = right
                }
            else
                break
            end
        end
        return expr
    end

    function parseTerm()
        local expr = parseFactor()
        while true do
            if check("SYMBOL", "+") or check("SYMBOL", "-") then
                local op = advance().value
                local right = parseFactor()
                expr = {
                    type = "BinaryExpression",
                    operator = op,
                    left = expr,
                    right = right
                }
            else
                break
            end
        end
        return expr
    end

    function parseFactor()
        local expr = parsePrimary()
        while true do
            if check("SYMBOL", "*") or check("SYMBOL", "/") then
                local op = advance().value
                local right = parsePrimary()
                expr = {
                    type = "BinaryExpression",
                    operator = op,
                    left = expr,
                    right = right
                }
            else
                break
            end
        end
        return expr
    end

    ------------------------------------------------------------------------
    -- parsePrimary: parse a base expression, then check for function calls or index expressions
    ------------------------------------------------------------------------
    function parsePrimary()
        local expr = parseBasePrimary()
        while true do
            if match("SYMBOL", "(") then
                local args = {}
                if not check("SYMBOL", ")") then
                    repeat
                        table.insert(args, parseExpression())
                    until not match("SYMBOL", ",")
                end
                consume("SYMBOL", ")", "Expected ')' after function call")
                expr = {
                    type = "CallExpression",
                    callee = expr,
                    arguments = args
                }
            elseif match("SYMBOL", "[") then
                local indexExpr = parseExpression()
                consume("SYMBOL", "]", "Expected ']' after index expression")
                expr = {
                    type = "IndexExpression",
                    object = expr,
                    index = indexExpr
                }
            else
                break
            end
        end
        return expr
    end

    ------------------------------------------------------------------------
    -- parseBasePrimary: NUMBER, STRING, IDENTIFIER, or parenthesized expression
    ------------------------------------------------------------------------
    function parseBasePrimary()
        local t = peek()
        if not t then return nil end

        if t.type == "NUMBER" then
            advance()
            return { type = "NumericLiteral", value = t.value }
        end
        if t.type == "STRING" then
            advance()
            return { type = "StringLiteral", value = t.value }
        end
        if t.type == "IDENTIFIER" then
            advance()
            return { type = "Identifier", name = t.value }
        end
        if t.type == "SYMBOL" and t.value == "(" then
            advance() -- consume '('
            local expr = parseExpression()
            consume("SYMBOL", ")", "Expected ')' after expression")
            return expr
        end
        return nil
    end

    ------------------------------------------------------------------------
    -- Main parse entry
    ------------------------------------------------------------------------
    function self:parse()
        return parseProgram()
    end

    return self
end

return Parser
