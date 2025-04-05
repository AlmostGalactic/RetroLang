-- Lexer.lua

local Lexer = {}

-- Updated keywords for the unique syntax:
local keywords = {
    ["DEC"]       = true,  -- variable declaration
    ["FN"]        = true,  -- function declaration
    ["RETURN"]    = true,
    ["IF"]        = true,
    ["DO"]        = true,  -- used after IF and WHILE conditions
    ["ELSE"]      = true,
    ["ELSEIF"]    = true,
    ["WHILE"]     = true,
    ["STOP"]      = true,  -- ends any block (functions, if, while)
    ["IMPORT"]    = true,
}

local function isAlpha(c)
    return c and c:match("[_%a]")
end

local function isDigit(c)
    return c and c:match("%d")
end

local function isWhitespace(c)
    return c and c:match("%s")
end

function Lexer.tokenize(code)
    -- If code is a table, join it.
    if type(code) == "table" then
        code = table.concat(code, "\n")
    end
    if type(code) ~= "string" then
        error("Lexer.tokenize expects a string, got " .. tostring(code))
    end

    local tokens = {}
    local length = #code
    local pos = 1
    local line = 1
    local col = 1

    local function currentChar()
        if pos > length then return nil end
        return code:sub(pos, pos)
    end

    local function advance(n)
        n = n or 1
        for _ = 1, n do
            if pos <= length then
                local c = code:sub(pos, pos)
                if c == "\n" then
                    line = line + 1
                    col = 1
                else
                    col = col + 1
                end
            end
            pos = pos + 1
        end
    end

    local function addToken(tType, tValue)
        table.insert(tokens, { type = tType, value = tValue, line = line, col = col })
    end

    while pos <= length do
        local c = currentChar()
        local nextC = (pos < length) and code:sub(pos+1, pos+1) or nil

        if isWhitespace(c) then
            advance()

        -- Single-line comment using '//'
        elseif c == "/" and nextC == "/" then
            advance(2)
            while currentChar() and currentChar() ~= "\n" do
                advance()
            end

        -- Multi-line comment using '/* ... */'
        elseif c == "/" and nextC == "*" then
            advance(2)
            while true do
                if not currentChar() then break end
                if currentChar() == "*" and code:sub(pos+1, pos+1) == "/" then
                    advance(2)
                    break
                end
                advance()
            end

        elseif isAlpha(c) then
            local startPos = pos
            while isAlpha(currentChar()) or isDigit(currentChar()) do
                advance()
            end
            local word = code:sub(startPos, pos - 1)
            if keywords[word] then
                addToken("KEYWORD", word)
            else
                addToken("IDENTIFIER", word)
            end

        elseif isDigit(c) then
            local startPos = pos
            while isDigit(currentChar()) do
                advance()
            end
            if currentChar() == '.' then
                advance()
                while isDigit(currentChar()) do
                    advance()
                end
            end
            local numStr = code:sub(startPos, pos - 1)
            addToken("NUMBER", tonumber(numStr))

        elseif c == '"' then
            advance()  -- skip opening quote
            local startPos = pos
            while currentChar() ~= '"' and currentChar() do
                advance()
            end
            local strValue = code:sub(startPos, pos - 1)
            advance()  -- skip closing quote
            addToken("STRING", strValue)

        elseif (c == '=' or c == '!' or c == '<' or c == '>') and nextC == '=' then
            addToken("SYMBOL", c .. nextC)
            advance(2)

        else
            addToken("SYMBOL", c)
            advance()
        end
    end

    return tokens
end

return Lexer
