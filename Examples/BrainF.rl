DEC input = get("Enter some BF code")
DEC code = split(input, "")

DEC cells = []
DEC x = 0
WHILE x < 1000 DO
    x = x + 1
    push(cells, 0)
STOP

DEC cp = 1      // Code pointer (1-indexed)
DEC pointer = 1 // Data pointer (1-indexed)

FN PrintCell(point)
    write(char(cells[point]))
STOP

WHILE cp <= len(code) DO
    DEC instruction = code[cp]
    IF instruction == "+" DO
        set(cells, pointer, cells[pointer] + 1)
    ELSEIF instruction == "-" DO
        set(cells, pointer, cells[pointer] - 1)
    ELSEIF instruction == ">" DO
        pointer = pointer + 1
        // If the pointer goes beyond the tape, extend the tape.
        IF pointer > len(cells) DO
            push(cells, 0)
        STOP
    ELSEIF instruction == "<" DO
        pointer = pointer - 1
        // Prevent moving left of the tape.
        IF pointer < 1 DO
            pointer = 1
        STOP
    ELSEIF instruction == "." DO
        PrintCell(pointer)
    ELSEIF instruction == "," DO
        DEC ch = get("Input a character:")
        set(cells, pointer, getAscii(ch))
    ELSEIF instruction == "[" DO
        // If current cell is zero, jump forward to after the matching ']'
        IF cells[pointer] == 0 DO
            DEC bracket = 1
            WHILE bracket > 0 DO
                cp = cp + 1
                IF code[cp] == "[" DO
                    bracket = bracket + 1
                ELSEIF code[cp] == "]" DO
                    bracket = bracket - 1
                STOP
            STOP
        STOP
    ELSEIF instruction == "]" DO
        // If current cell is nonzero, jump back to after the matching '['
        IF cells[pointer] != 0 DO
            DEC bracket = 1
            WHILE bracket > 0 DO
                cp = cp - 1
                IF code[cp] == "]" DO
                    bracket = bracket + 1
                ELSEIF code[cp] == "[" DO
                    bracket = bracket - 1
                STOP
            STOP
        STOP
    ELSE
        // Ignore unknown characters.
    STOP
    cp = cp + 1
STOP
