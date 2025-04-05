-- Interpreter.lua
local Interpreter = {}
local Lexer       = require("./Lexer")   -- Adjust path as needed
local Parser      = require("./Parser")  -- Adjust path as needed

function Interpreter.new()
    local self = {}

    ------------------------------------------------
    -- ENVIRONMENT STACK (for variables)
    ------------------------------------------------
    local envStack = {}

    local function pushEnv()
        local parent = envStack[#envStack]
        local newEnv = { variables={}, parent=parent }
        table.insert(envStack, newEnv)
    end

    local function popEnv()
        table.remove(envStack)
    end

    local function currentEnv()
        return envStack[#envStack]
    end

    -- Put a new variable in the current environment
    local function declareVar(name, value)
        currentEnv().variables[name] = value
    end

    -- Look for a variable (including parents)
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

    -- Set an existing variable
    local function setVar(name, value)
        local env = currentEnv()
        while env do
            if env.variables[name] ~= nil then
                env.variables[name] = value
                return
            end
            env = env.parent
        end
        error("Undefined variable '" .. name .. "'. Use VAR to declare it.")
    end

    ------------------------------------------------
    -- BUILT-IN FUNCTIONS
    ------------------------------------------------
    local function prettyPrint(value, indent, visited)
        indent = indent or 0
        visited = visited or {}
    
        if type(value) ~= "table" then
            -- For non-table, just print it and return
            print(string.rep(" ", indent) .. tostring(value))
            return
        end
    
        -- If we've already visited this table, print "*recursive*" to avoid looping
        if visited[value] then
            print(string.rep(" ", indent) .. "*recursive*")
            return
        end
        visited[value] = true
    
        -- For a table, iterate over its keys/values
        for k, v in pairs(value) do
            -- Indent, print the key, then either print or recurse for the value
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
                    local interp = Interpreter.new()  -- Create a fresh interpreter
                    interp:interpret(args[1])
                end
            end,
        
    
            write = function(args)
                for i,a in ipairs(args) do
                    if type(a) == "table" then
                    prettyPrint(a)
                    else
                    io.write(tostring(a))
                    end
                    if i < #args then io.write(" ") end
                end
            end,
            
            print = function(args)
                for i,a in ipairs(args) do
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
                return (args[1]..args[2])
            end,
            
            get = function(args)
                if args[1] then
                print(args[1])
                end
                return (io.read())
            end,
            
        push = function(args)
            -- We expect args[1] to be the array, args[2] to be the value
            local arr = args[1]
            if type(arr) ~= "table" then
                error("push() first argument must be an array/table")
            end
    
            local value = args[2]
            table.insert(arr, value)  -- appends at the end (Lua uses 1-based indexing)
            
            -- Optionally return the new length of the array:
            return #arr
        end,

        len = function(args)
            if args[1] == nil then
                return 0
            end
            return #args[1]
        end,
    
        pop = function(args)
            -- We expect args[1] to be the array
            local arr = args[1]
            local where = args[2] or #arr
            if type(arr) ~= "table" then
                error("pop() argument must be an array/table")
            end
    
            -- Remove and return the last element
            local lastVal = arr[where]
            arr[#arr] = nil
            return lastVal
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

        substring = function(args)
            local str = args[1]
            local start = args[2] or 1
            local len = args[3] or (#str - start + 1)
            if type(str) ~= "string" then
                error("substring() expects a string first argument.")
            end
            return string.sub(str, start, start + len - 1) -- 1-based indexing
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
            return arr -- possibly return the same table
        end,
      
        typeof = function(args)
            local val = args[1]
            return type(val)
        end,

        split = function(args)
            local s = args[1]
            local delim = args[2]
            
            -- Check argument types
            if type(s) ~= "string" then
                error("split() first argument must be a string")
            end
            if type(delim) ~= "string" then
                error("split() second argument must be a string delimiter")
            end
    
            local result = {}
            -- This pattern: "([^DELIM]+)" matches sequences of characters
            -- that are not the delimiter
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

    -- Helper to call a user-defined function
    local function callUserFunction(fnData, argVals)
        -- fnData = { params, body }
        pushEnv()
        -- bind parameters
        for i, paramName in ipairs(fnData.params) do
            declareVar(paramName, argVals[i])
        end

        local returnValue = nil
        -- run each statement in the function body
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
        
        elseif etype == "IndexExpression" then
            local obj = evaluateExpression(expr.object)
            local idx = evaluateExpression(expr.index)
            if type(obj) ~= "table" then
                error("Cannot index a non-table: " .. tostring(obj))
            end
            return obj[idx]  -- For 1-based arrays in Lua
        
        elseif etype == "Identifier" then
            return getVar(expr.name)

        elseif etype == "CallExpression" then
            -- Evaluate arguments
            local callee = expr.callee
            local argVals = {}
            for _, argExpr in ipairs(expr.arguments) do
                table.insert(argVals, evaluateExpression(argExpr))
            end

            -- If callee is an Identifier, check built-ins or userFunctions
            if callee.type == "Identifier" then
                local fnName = callee.name
                -- Check built-in first
                if builtIns[fnName] then
                    return builtIns[fnName](argVals)
                elseif userFunctions[fnName] then
                    return callUserFunction(userFunctions[fnName], argVals)
                else
                    error("Undefined function '".. fnName .."'")
                end
            else
                error("CallExpression callee must be an identifier in this simple example.")
            end

        elseif etype == "BinaryExpression" then
            -- Evaluate left/right
            local leftVal  = evaluateExpression(expr.left)
            local rightVal = evaluateExpression(expr.right)
            local op = expr.operator

            -- Convert to numbers for arithmetic
            if op == "+" then
                return (tonumber(leftVal) or 0) + (tonumber(rightVal) or 0)
            elseif op == "-" then
                return (tonumber(leftVal) or 0) - (tonumber(rightVal) or 0)
            elseif op == "*" then
                return (tonumber(leftVal) or 0) * (tonumber(rightVal) or 0)
            elseif op == "/" then
                return (tonumber(leftVal) or 0) / (tonumber(rightVal) or 1)

            -- Comparisons
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

            else
                error("Unknown binary operator: " .. tostring(op))
            end

        else
            error("Unknown expression type: " .. tostring(etype))
        end
    end

    ------------------------------S------------------
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
            -- Evaluate the main IF condition.
            local condVal = evaluateExpression(stmt.condition)
            if condVal then
                for _, s in ipairs(stmt.thenBranch) do
                    local r = executeStatement(s)
                    if r and r.returned then return r end
                end
            else
                local handled = false
                -- Process each ELSEIF clause in order.
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

        -- Only initialize the global environment if not already initialized.
        if #envStack == 0 then
            envStack = {}
            pushEnv()  -- initialize global environment
            declareVar("true", true)
            declareVar("false", false)
        end

        for _, stmt in ipairs(ast.body) do
            local r = executeStatement(stmt)
            if r and r.returned then
                -- Handle top-level return if needed.
            end
        end

        -- Do not pop the global environment so that variables persist between calls.
    end

    return self
end

return Interpreter
