# RetroLang: How to Program In

RetroLang is a retro-inspired programming language built entirely in Lua. It’s designed for simplicity, flexibility, and rapid prototyping—making it an ideal platform for both learning programming concepts and developing small projects. This documentation covers the core functionality of RetroLang and provides examples of creative projects you can build with it.

---

## Overview

RetroLang features a custom syntax that emphasizes clarity and ease of use. With its concise keywords and rich set of built-in functions, you can quickly get started on projects ranging from simple calculations to interactive text adventures. Key features include:

• Dynamic variable handling with block scoping  
• User-defined functions defined with FN and ended with STOP  
• Control structures for conditionals, loops, and recursion (using DO to begin blocks and STOP to end them)  
• Built-in support for objects (using array-like syntax for object literals and the dot operator for member access)  
• Logical operators AND and OR for compound conditionals  
• Module import functionality via IMPORT, which executes a module file and returns its value

---

## Language Constructs

### Variables and Expressions

Variables are declared using the DEC keyword. Expressions support arithmetic, string manipulation, comparisons, and logical operations. For example:
```go
    DEC x = 10
    DEC y = 20
    DEC sum = x + y
    DEC condition = (x == 10) AND (y == 20)
    print("The sum is: " + tostr(sum))
```
### Functions

Functions are defined using FN and terminated with STOP. Parameters and return values allow for modular, reusable code. For example:
```go
    FN add(a, b)
        RETURN a + b
    STOP

    print("5 + 3 =", add(5, 3))
```
Functions can also be defined as first-class values and assigned to variables or used as object properties.

### Control Structures

RetroLang supports familiar control structures:

**Conditional Statements:**
```go
    DEC temperature = 25

    IF temperature > 30 DO
        print("It is hot outside!")
    ELSEIF temperature < 10 DO
        print("It is cold outside!")
    ELSEIF (temperature >= 10) AND (temperature <= 30) DO
        print("The weather is moderate.")
    ELSE
        print("Invalid temperature value.")
    STOP
```
**Loops:**
```go
    DEC counter = 1
    WHILE counter <= 5 DO
        print("Count:", counter)
        counter = counter + 1
    STOP
```
### Objects and Arrays

RetroLang supports both array and object literals. An array literal is written using square brackets with comma-separated values. For example:
```go
    DEC list = [ 1, 2, 3, 4 ]
```
An object literal uses the same brackets but defines key-value pairs using an equals sign. For example:
```go
    DEC obj = [ test = 123, name = "RetroLang" ]
    print(obj.test)   // Outputs 123
    print(obj.name)   // Outputs RetroLang
```
Functions can also be stored as object properties:
```go
    DEC obj = [
        tempfunc = FN (name)
            print(name)
        STOP
    ]
    obj.tempfunc("User")   // Outputs "User"
```
### Logical Operators

RetroLang now supports the logical operators AND and OR for compound conditions:
```go
    DEC a = 10
    DEC b = 20
    IF (a < b) AND (b < 30) DO
        print("Both conditions are true!")
    ELSE
        print("One or both conditions are false.")
    STOP
```
### Module Import

RetroLang supports Lua-style modules via the IMPORT keyword. When you write an import expression, the specified file is loaded, executed, and the first top-level RETURN encountered is returned as the module’s value. For example, given a module file (e.g., module.rl) with:
```go
    DEC value = 123
    RETURN value
```
you can import and use the module like this:
```go
    DEC mod = IMPORT "module.rl"
    print(mod)   // Outputs: 123
```
---

## Built-in Functions

RetroLang comes with a robust set of built-in functions:

**I/O Functions:**  
• print – Outputs data with a newline  
• write – Outputs data without a newline  
• get – Prompts the user for input (when needed)  
• alert – Displays an alert message for debugging

**String Functions:**  
• concat – Joins two strings  
• uppercase / lowercase – Converts strings to upper or lower case  
• substring – Extracts a portion of a string  
• split – Divides a string into an array based on a delimiter  
• tostr – Converts a value to a string

**Math Functions:**  
• tonum – Converts a value to a number  
• random – Generates a random number within a specified range  
• floor / ceil – Rounds numbers down or up  
• abs – Returns the absolute value
• mod – Returns the modulos of the two arguments

**Array Functions:**  
• push – Adds an element to the end of an array  
• pop – Removes the last element from an array  
• len – Returns the length of an array  
• reverse – Reverses the order of elements in an array  
• set – Sets a value at a given index in an array
• inTable – Takes 2 inputs and checks if the first input is in the second input  | Second input is table only

**Utility Functions:**  
• typeof – Returns the type of a variable

These built-in functions allow you to perform many operations without writing complex code from scratch.

---

## Example Projects

### 1. Simple Calculator

Create a program that takes two numbers as input and performs basic arithmetic operations.
```go
    FN calculator()
        print("Welcome to the Simple Calculator!")
        print("Operations available: +, -, *, /")
        
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
```
### 2. Text Adventure Game

Develop a simple text-based adventure where the player makes choices that affect the outcome.
```go
    print("Welcome to RetroQuest!")
    
    DEC choice = get("You're at a crossroads. Choose left or right: ")
    
    IF choice == "left" DO
        print("You meet a wise sage who gives you a quest!")
    ELSEIF choice == "right" DO
        print("You discover a hidden treasure!")
    ELSE
        print("You wander aimlessly, unsure of where to go.")
    STOP
```
### 3. Inventory Management

Simulate an inventory system where you can add or remove items from an array.
```go
    print("Inventory Manager")
    
    DEC inventory = []  // Start with an empty inventory
    
    // Adding items to the inventory
    push(inventory, "Sword")
    push(inventory, "Shield")
    push(inventory, "Potion")
    print("Current Inventory:", inventory)
    
    // Removing an item from the inventory
    DEC removedItem = pop(inventory)
    print("Removed Item:", removedItem)
    print("Updated Inventory:", inventory)
```
### 4. Logical Operator Demo

Demonstrate logical operators in conditionals:
```go
    DEC a = 10
    DEC b = 20
    IF (a < b) AND (b < 30) DO
        print("Both conditions are true!")
    ELSE
        print("One or both conditions are false.")
    STOP
```
### 5. Object and Function Properties

Showcase objects, member access, and functions as object properties:
```go
    DEC obj = [
        test = 123,
        tempfunc = FN (name)
            print(name)
        STOP
    ]
    print(obj.test)           // Outputs 123
    obj.tempfunc("User")      // Outputs "User"
```

### 6. Module Import

Demonstrate Lua-style module usage by importing a module and using its returned value. Suppose there is a module file named module.rl containing:
```go
    DEC value = 123
    RETURN value
```
You can import and use it like this:
```go
    DEC mod = IMPORT "module.rl"
    print(mod)   // Outputs: 123
```
---

## Extending RetroLang

RetroLang is designed for modularity and experimentation. You can extend its functionality by:

• Adding new keywords or syntax (modify the lexer and parser).  
• Implementing additional built-in functions (e.g., advanced math functions, file I/O).  
• Creating custom libraries that can be imported into RetroLang programs.

---

## Contributing

RetroLang is an open platform for creative experimentation. If you have ideas for new features, improvements, or bug fixes, consider contributing by forking the repository, implementing your changes, and submitting a pull request with clear documentation of your contributions.

---

## Acknowledgments

RetroLang draws inspiration from classic programming paradigms and modern scripting practices. Its design philosophy is to provide an accessible yet powerful platform for creative coding. Whether you're prototyping ideas, building simple games, or exploring programming concepts, RetroLang invites you to experiment and innovate.

---
