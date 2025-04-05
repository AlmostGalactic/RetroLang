print("RETRO LANG REPL v1.0 (Enter 'exit' to quit)")

DEC exit = false

WHILE exit == false DO
    print("---------------------------------CODE INPUT---------------------------------")
    DEC input = get("RetroLang: ")
    IF input == "exit" DO
        exit = true
    ELSE
        print("-----------------------------------OUTPUT-----------------------------------")
        execute(input)
    STOP
STOP
