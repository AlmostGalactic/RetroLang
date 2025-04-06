FN calculator()
    print("Welcome to the Simple Calculator!")
    print("You can perform the following operations: +, -, *, /")

    // Prompt for the operation
    DEC operation = get("Enter the operation (+, -, *, /): ")

    // Prompt for the numbers
    DEC num1_str = get("Enter the first number: ")
    DEC num2_str = get("Enter the second number: ")
    DEC num1 = tonum(num1_str)
    DEC num2 = tonum(num2_str)

    IF operation == "+" DO
        DEC result = num1 + num2
        print("The result is:", result)
    ELSEIF operation == "-" DO
        DEC result = num1 - num2
        print("The result is:", result)
    ELSEIF operation == "*" DO
        DEC result = num1 * num2
        print("The result is:", result)
    ELSEIF operation == "/" DO
        IF num2 != 0 DO
            DEC result = num1 / num2
            print("The result is:", result)
        ELSE
            print("Error! Division by zero.")
        STOP
    ELSE
        print("Invalid operation.")
    STOP
STOP

calculator()
