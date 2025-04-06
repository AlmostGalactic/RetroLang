-- Interpreter.lua
local Interpreter = {}
local Lexer       = require("./Lexer")
local Parser      = require("./Parser")

function Interpreter.new()
    local self = {}

    ------------------------------------------------
    -- ENVIRONMENT STACK (for variables)
    ------------------------------------------------
    local envStack = {}

    local function pushEnv()
        local parent = envStack[#envStack]
        local newEnv = { variables = {}, parent = parent }
        table.insert(envStack, newEnv)
    end

    local function popEnv()
        table.remove(envStack)
    end

    local function currentEnv()
        return envStack[#envStack]
    end

    local function declareVar(name, value)
        currentEnv().variables[name] = value
    end

    local function getVar(name)
        local env = currentEnv()
        while env do
            if env.variables[name] ~= nil then
                return env.variables[name]
            end
            env = env.parent
        end
        error("Undefined variable '" .. name .. "'")
    end

    local function setVar(name, value)
        local env = currentEnv()
        while env do
            if env.variables[name] ~= nil then
                env.variables[name] = value
                return
            end
            env = env.parent
        end
        error("Undefined variable '" .. name .. "'. Use DEC to declare it.")
    end

    ------------------------------------------------
    -- BUILT-IN FUNCTIONS
    ------------------------------------------------
    local function prettyPrint(value, indent, visited)
        indent = indent or 0
        visited = visited or {}
    
        if type(value) ~= "table" then
            print(string.rep(" ", indent) .. tostring(value))
            return
        end
    
        if visited[value] then
            print(string.rep(" ", indent) .. "*recursive*")
            return
        end
        visited[value] = true
    
        for k, v in pairs(value) do
            local prefix = string.rep(" ", indent) .. tostring(k) .. ": "
            if type(v) == "table" then
                print(prefix)
                prettyPrint(v, indent + 2, visited)
            else
                print(prefix .. tostring(v))
            end
        end
    end

    local builtIns = {
        execute = function(args)
            if args[1] then
                local interp = Interpreter.new()
                interp:interpret(args[1])
            end
        end,
    
        write = function(args)
            for i, a in ipairs(args) do
                if type(a) == "table" then
                    prettyPrint(a)
                else
                    io.write(tostring(a))
                end
                if i < #args then io.write(" ") end
            end
        end,
        
        print = function(args)
            for i, a in ipairs(args) do
                if type(a) == "table" then
                    prettyPrint(a)
                else
                    io.write(tostring(a))
                    io.write("\n")
                end
                if i < #args then io.write(" ") end
            end
        end,
        
        alert = function(args)
            print("[ALERT]:", table.unpack(args))
        end,
        
        concat = function(args)
            return (args[1] .. args[2])
        end,
        
        get = function(args)
            if args[1] then
                print(args[1])
            end
            return io.read()
        end,
        
        push = function(args)
            local arr = args[1]
            if type(arr) ~= "table" then
                error("push() first argument must be an array/table")
            end
            local value = args[2]
            table.insert(arr, value)
            return #arr
        end,
    
        len = function(args)
            if args[1] == nil then
                return 0
            end
            return #args[1]
        end,
    
        pop = function(args)
            local arr = args[1]
            local where = args[2] or #arr
            if type(arr) ~= "table" then
                error("pop() argument must be an array/table")
            end
            local lastVal = arr[where]
            arr[#arr] = nil
            return lastVal
        end,
    
        set = function(args)
            local arr = args[1]
            local index = args[2]
            local value = args[3]
            if type(arr) ~= "table" then
                error("set() expects an array as first argument")
            end
            arr[index] = value
            return arr
        end,
        
        tostr = function(args)
            return tostring(args[1])
        end,
    
        tonum = function(args)
            return tonumber(args[1])
        end,
                
        uppercase = function(args)
            local str = args[1]
            if type(str) ~= "string" then
                error("uppercase() expects a string.")
            end
            return string.upper(str)
        end,
    
        lowercase = function(args)
            local str = args[1]
            if type(str) ~= "string" then
                error("lowercase() expects a string.")
            end
            return string.lower(str)
        end,

        char = function(args)
            if args[1] then
                return string.char(args[1])
            end
        end,

        getAscii = function(args)
            if args[1] then
                return string.byte(args[1])
            end
        end,
    
        substring = function(args)
            local str = args[1]
            local start = args[2] or 1
            local len = args[3] or (#str - start + 1)
            if type(str) ~= "string" then
                error("substring() expects a string first argument.")
            end
            return string.sub(str, start, start + len - 1)
        end,
    
        random = function(args)
            local min = args[1] or 1
            local max = args[2] or 10
            math.randomseed(os.time())
            return math.random(min, max)
        end,
    
        floor = function(args)
            return math.floor(args[1] or 0)
        end,
    
        ceil = function(args)
            return math.ceil(args[1] or 0)
        end,
    
        abs = function(args)
            return math.abs(args[1] or 0)
        end,
        
        reverse = function(args)
            local arr = args[1]
            if type(arr) ~= "table" then
                error("reverse() expects an array.")
            end
            local i, j = 1, #arr
            while i < j do
                arr[i], arr[j] = arr[j], arr[i]
                i = i + 1
                j = j - 1
            end
            return arr
        end,
      
        typeof = function(args)
            local val = args[1]
            return type(val)
        end,
    
        split = function(args)
            local s = args[1]
            local delim = args[2]
            
            if type(s) ~= "string" then
                error("split() first argument must be a string")
            end
            if type(delim) ~= "string" then
                error("split() second argument must be a string delimiter")
            end
        
            local result = {}
            
            if delim == "" then
                -- Special case: split into individual characters
                for i = 1, #s do
                    result[i] = s:sub(i, i)
                end
                return result
            end
        
            -- Build pattern normally for non-empty delimiter
            local pattern = "([^" .. delim .. "]+)"
            for piece in string.gmatch(s, pattern) do
                table.insert(result, piece)
            end
            return result
        end
        
    }

    ------------------------------------------------
    -- USER-DEFINED FUNCTIONS
    ------------------------------------------------
    local userFunctions = {}

    local function callUserFunction(fnData, argVals)
        pushEnv()
        for i, paramName in ipairs(fnData.params) do
            declareVar(paramName, argVals[i])
        end
        local returnValue = nil
        for _, stmt in ipairs(fnData.body) do
            local r = executeStatement(stmt)
            if r and r.returned then
                returnValue = r.value
                break
            end
        end
        popEnv()
        return returnValue
    end

    ------------------------------------------------
    -- EVALUATE EXPRESSIONS
    ------------------------------------------------
    local function evaluateExpression(expr)
        local etype = expr.type

        if etype == "NumericLiteral" then
            return expr.value

        elseif etype == "StringLiteral" then
            return expr.value
        
        elseif etype == "ArrayLiteral" then
            local arr = {}
            for i, element in ipairs(expr.elements) do
                arr[i] = evaluateExpression(element)
            end
            return arr
        
        elseif etype == "IndexExpression" then
            local obj = evaluateExpression(expr.object)
            local idx = evaluateExpression(expr.index)
            if type(obj) ~= "table" then
                error("Cannot index a non-table: " .. tostring(obj))
            end
            return obj[idx]
        
        elseif etype == "Identifier" then
            return getVar(expr.name)
        
        elseif etype == "CallExpression" then
            local callee = expr.callee
            local argVals = {}
            for _, argExpr in ipairs(expr.arguments) do
                table.insert(argVals, evaluateExpression(argExpr))
            end
            if callee.type == "Identifier" then
                local fnName = callee.name
                if builtIns[fnName] then
                    return builtIns[fnName](argVals)
                elseif userFunctions[fnName] then
                    return callUserFunction(userFunctions[fnName], argVals)
                else
                    error("Undefined function '"..fnName.."'")
                end
            else
                error("CallExpression callee must be an identifier in this simple example.")
            end
        
        elseif etype == "BinaryExpression" then
            local leftVal  = evaluateExpression(expr.left)
            local rightVal = evaluateExpression(expr.right)
            local op = expr.operator
        
            if op == "+" then
                return (tonumber(leftVal) or 0) + (tonumber(rightVal) or 0)
            elseif op == "-" then
                return (tonumber(leftVal) or 0) - (tonumber(rightVal) or 0)
            elseif op == "*" then
                return (tonumber(leftVal) or 0) * (tonumber(rightVal) or 0)
            elseif op == "/" then
                return (tonumber(leftVal) or 0) / (tonumber(rightVal) or 1)
            elseif op == "==" then
                return leftVal == rightVal
            elseif op == "!=" then
                return leftVal ~= rightVal
            elseif op == ">" then
                return (tonumber(leftVal) or 0) > (tonumber(rightVal) or 0)
            elseif op == "<" then
                return (tonumber(leftVal) or 0) < (tonumber(rightVal) or 0)
            elseif op == ">=" then
                return (tonumber(leftVal) or 0) >= (tonumber(rightVal) or 0)
            elseif op == "<=" then
                return (tonumber(leftVal) or 0) <= (tonumber(rightVal) or 0)
            elseif op == "AND" then
                -- For logical AND, if leftVal is false (or nil), return it immediately.
                return leftVal and rightVal
            elseif op == "OR" then
                -- For logical OR, if leftVal is true, return it; otherwise, return rightVal.
                return leftVal or rightVal
            else
                error("Unknown binary operator: " .. tostring(op))
            end
        
        else
            error("Unknown expression type: " .. tostring(etype))
        end
    end

    ------------------------------------------------
    -- EXECUTE A STATEMENT
    ------------------------------------------------
    function executeStatement(stmt)
        local stype = stmt.type

        if stype == "VarDeclaration" then
            local initVal = evaluateExpression(stmt.initializer)
            declareVar(stmt.name, initVal)
        
        elseif stype == "AssignmentStatement" then
            local val = evaluateExpression(stmt.value)
            setVar(stmt.target.name, val)
        
        elseif stype == "ExpressionStatement" then
            evaluateExpression(stmt.expression)
        
        elseif stype == "FunctionDeclaration" then
            userFunctions[stmt.name] = { params = stmt.params, body = stmt.body }
        
        elseif stype == "ReturnStatement" then
            local rv = nil
            if stmt.expression then
                rv = evaluateExpression(stmt.expression)
            end
            return { returned = true, value = rv }
        
        elseif stype == "IfStatement" then
            local condVal = evaluateExpression(stmt.condition)
            if condVal then
                for _, s in ipairs(stmt.thenBranch) do
                    local r = executeStatement(s)
                    if r and r.returned then return r end
                end
            else
                local handled = false
                if stmt.elseIfs then
                    for _, elseifClause in ipairs(stmt.elseIfs) do
                        if evaluateExpression(elseifClause.condition) then
                            for _, s in ipairs(elseifClause.branch) do
                                local r = executeStatement(s)
                                if r and r.returned then return r end
                            end
                            handled = true
                            break
                        end
                    end
                end
                if not handled and stmt.elseBranch then
                    for _, s in ipairs(stmt.elseBranch) do
                        local r = executeStatement(s)
                        if r and r.returned then return r end
                    end
                end
            end
        
        elseif stype == "WhileStatement" then
            while true do
                local condVal = evaluateExpression(stmt.condition)
                if not condVal then break end
                for _, s in ipairs(stmt.body) do
                    local r = executeStatement(s)
                    if r and r.returned then return r end
                end
            end
        
        else
            error("Unknown statement type: " .. tostring(stype))
        end
    end

    ------------------------------------------------
    -- PUBLIC INTERPRET
    ------------------------------------------------
    function self:interpret(code)
        if type(code) ~= "string" then
            error("interpret() expects a string, got " .. tostring(code))
        end

        local tokens = Lexer.tokenize(code)
        local parser = Parser.new(tokens)
        local ast = parser:parse()

        if ast.type ~= "Program" then
            error("AST root must be a Program node")
        end

        if #envStack == 0 then
            envStack = {}
            pushEnv()
            declareVar("true", true)
            declareVar("false", false)
        end

        for _, stmt in ipairs(ast.body) do
            local r = executeStatement(stmt)
            if r and r.returned then
                -- Handle top-level return if needed.
            end
        end
    end

    return self
end

return Interpreter
