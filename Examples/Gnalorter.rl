DEC string = IMPORT "libs/strLib.rl"

FN runReverse(code)
    DEC fixedCode = string.rev(code) // unreverses the code
    execute(fixedCode)
STOP

FN REPL()
    DEC code = ""
    DEC running = true
    WHILE running DO
        DEC line = get(">>> ")
        IF line == "run" DO
            running = false
        ELSE
            code = concat(code, concat(line, char(10)))
        STOP
    STOP
    runReverse(code)
STOP

REPL()