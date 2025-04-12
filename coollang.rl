FN tokenize(code)
    DEC spl = split(code, "")
    DEC tokens = []
    DEC indx = 0

    FN advance()
        indx = indx + 1
    STOP

    FN getChar()
        DEC char = spl[indx]
        RETURN char
    STOP

    FN pushToken(TokenType, value)
        push(tokens, [TokenType, value])
    STOP

    FN isAlpha(char)
        DEC asciiCode = getAscii(char)
        IF asciiCode >= 65 AND asciiCode <= 90 OR asciiCode >= 97 AND asciiCode <= 122 DO
            RETURN true
        ELSE
            RETURN false
        STOP
    STOP

    FN isDigit(char)
        DEC asciiCode = getAscii(char)
        IF asciiCode >= 48 AND asciiCode <= 57 DO
            RETURN true
        ELSE
            RETURN false
        STOP
    STOP

    WHILE indx < len(spl) DO
        advance()
        IF getChar() == char(10) OR getChar() == char(13) OR getChar() == char(9) OR getChar() == " " DO
            // do nothing
        ELSEIF getChar() == "(" DO
            pushToken("LPAREN", getChar())
        ELSEIF getChar() == ")" DO
            pushToken("RPAREN", getChar())
        ELSEIF getChar() == "{" DO
            pushToken("LBRACE", getChar())
        ELSEIF getChar() == "}" DO
            pushToken("RBRACE", getChar())
        ELSEIF getChar() == "[" DO
            pushToken("LBRACKET", getChar())
        ELSEIF getChar() == "]" DO
            pushToken("RBRACKET", getChar())
        ELSEIF getChar() == "," DO
            pushToken("COMMA", getChar())
        ELSEIF getChar() == "." DO
            pushToken("DOT", getChar())
        ELSEIF getChar() == ":" DO
            pushToken("COLON", getChar())
        ELSEIF getChar() == ";" DO
            pushToken("SEMICOLON", getChar())
        ELSEIF getChar() == "!" DO
            pushToken("BANG", getChar())
        ELSEIF getChar() == "=" DO
            pushToken("EQUAL", getChar())
        ELSEIF getChar() == "+" DO
            pushToken("PLUS", getChar())
        ELSEIF getChar() == "-" DO
            pushToken("MINUS", getChar())
        ELSEIF getChar() == "*" DO
            pushToken("STAR", getChar())
        ELSEIF getChar() == "/" DO
            pushToken("SLASH", getChar())
        ELSEIF getChar() == ">" DO
            pushToken("GREATER", getChar())
        ELSEIF getChar() == "<" DO
            pushToken("LESS", getChar())
        ELSEIF getChar() == "&" DO
            pushToken("AMPERSAND", getChar())
        ELSE
            IF isAlpha(getChar()) DO
                DEC value = ""
                WHILE isAlpha(getChar()) OR isDigit(getChar()) DO
                    value = concat(value, getChar())
                    advance()
                STOP
                indx = indx - 1
                pushToken("IDENTIFIER", value)
            ELSEIF isDigit(getChar()) DO
                DEC value = ""
                DEC decimalCount = 0
                WHILE isDigit(getChar()) OR getChar() == "." DO
                    IF getChar() == "." DO
                        decimalCount = decimalCount + 1
                    STOP
                    IF decimalCount > 1 DO
                        indx = len(spl) + 1
                    ELSE
                        value = concat(value, getChar())
                    STOP
                    advance()
                STOP
                indx = indx - 1
                pushToken("NUMBER", tonum(value))
            ELSE
                pushToken("UNKNOWN", getChar())
            STOP
        STOP
    STOP
    RETURN tokens
STOP

print(tokenize("Hello, World! 123.321"))
