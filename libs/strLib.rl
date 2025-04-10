DEC string = [
    up = FN (text) RETURN uppercase(text) STOP,
    low = FN (text) RETURN lowercase(text) STOP,
    cap = FN (text)
        DEC spl = split(text, "")
        set(spl, 1, uppercase(spl[1]))

        DEC indx = 0
        DEC finish = ""
        WHILE indx < len(spl) DO
            indx = indx + 1
            finish = concat(finish, spl[indx])
        STOP
        RETURN finish
    STOP,
    rev = FN (text)
        DEC spl = split(text, "")
        DEC indx = len(spl)
        DEC finish = ""
        WHILE indx > 0 DO
            finish = concat(finish, spl[indx])
            indx = indx - 1
        STOP
        RETURN finish
    STOP,
    mess = FN (text) //Makes every other letter capitalized
        DEC finish = ""
        DEC spl = split(text, "")
        DEC indx = 0
        WHILE indx < len(spl) DO
            indx = indx + 1
            IF mod(indx, 2) == 0 DO
                finish = concat(finish, uppercase(spl[indx]))
            ELSE
                finish = concat(finish, lowercase(spl[indx]))
            STOP
        STOP
        RETURN finish
    STOP,
    revMess = FN (text) //Makes every other letter capitalized and reverses the string
        DEC finish = ""
        DEC spl = split(text, "")
        DEC indx = len(spl)
        WHILE indx > 0 DO
            IF mod(indx, 2) == 0 DO
                finish = concat(finish, uppercase(spl[indx]))
            ELSE
                finish = concat(finish, lowercase(spl[indx]))
            STOP
            indx = indx - 1
        STOP
        RETURN finish
    STOP,
    table = [
        concat = FN (table, sep)
            IF typeof(table) != "table" DO
                RETURN "Argument needs to be a table, else, use concat function. USAGE: concat(arg1, arg2)"
            STOP
            DEC finish = ""
            DEC indx = 0
            WHILE indx < len(table) DO
                indx = indx + 1
                IF indx == len(table) DO
                    finish = concat(finish, table[indx])
                ELSE
                    finish = concat(finish, concat(table[indx], sep))
                STOP
            STOP
            RETURN finish
        STOP,
    ]
    

] RETURN string