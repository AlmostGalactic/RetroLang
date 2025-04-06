# RetroLang: How to Program In

RetroLang is a retro-inspired programming language built entirely in Lua. It’s designed for simplicity, flexibility, and rapid prototyping—making it an ideal platform for both learning programming concepts and developing small projects. This documentation covers the core functionality of RetroLang and provides examples of creative projects you can build with it.

---

## Overview

RetroLang features a custom syntax that emphasizes clarity and ease of use. With its concise keywords and built-in functions, you can quickly get started on projects ranging from simple calculations to interactive text adventures. Some of its key features include:

- **Dynamic variable handling** with block scoping.
- **User-defined functions** for modular, reusable code.
- **Control structures** for conditionals, loops, and recursive functions.
- **Rich built-in functions** for I/O, math, string manipulation, and array operations.
- **Logical operators** (`AND`, `OR`) for compound conditionals.

---

## Language Constructs

### Variables and Expressions

Variables are declared using the `DEC` keyword, and expressions support arithmetic, string manipulation, comparisons, and logical operations. For example:

```retro
DEC x = 10
DEC y = 20
DEC sum = x + y
DEC condition = (x == 10) AND (y == 20)
print("The sum is: " + tostr(sum))
```

### Functions

Functions are defined with the `FN` keyword and terminated with `STOP`. Parameters and return values allow for modular code:

```retro
FN add(a, b)
    RETURN a + b
STOP

print("5 + 3 =", add(5, 3))
```

### Control Structures

RetroLang includes familiar control structures for decision-making and loops:

- **Conditional Statements with Logical Operators:**

```retro
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

- **Loops:**

```retro
DEC counter = 1
WHILE counter <= 5 DO
    print("Count:", counter)
    counter = counter + 1
STOP
```

---

## Built-in Functions

RetroLang comes equipped with a robust set of built-in functions that simplify many common tasks:

### I/O Functions
- **print:** Outputs data with a newline.
- **write:** Outputs data without a newline.
- **get:** Prompts the user for input.
- **alert:** Displays an alert message (useful for debugging).

### String Functions
- **concat:** Joins two strings.
- **uppercase / lowercase:** Converts strings to upper or lower case.
- **substring:** Extracts part of a string.
- **split:** Divides a string into an array based on a delimiter.
- **tostr:** Converts a value to a string.

### Math Functions
- **tonum:** Converts a value to a number.
- **random:** Generates a random number within a specified range.
- **floor / ceil:** Rounds numbers down or up.
- **abs:** Returns the absolute value.

### Array Functions
- **push:** Adds an element to the end of an array.
- **pop:** Removes the last element from an array.
- **len:** Returns the length of an array.
- **reverse:** Reverses the order of elements in an array.
- **set:** Sets a value at a given index in an array.

### Utility Functions
- **typeof:** Returns the type of a variable.

These built-ins allow you to perform many operations without writing complex code from scratch.

---

## Example Projects

Here are a few ideas for projects you can build with RetroLang:

### 1. Simple Calculator

Create a program that takes two numbers as input and performs basic arithmetic operations.

```retro
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

```retro
print("Welcome to RetroQuest!")

DEC choice = get("You're at a crossroads. Choose left or right: ")

IF choice == "left" DO
    print("You meet a wise sage who gives you a quest!")
ELSEIF choice == "right" DO
    print("You discover a hidden treasure!")
ELSE
    print("You wander aimlessly, unsure of your direction.")
STOP
```

### 3. Inventory Management

Simulate an inventory system where you can add or remove items from an array.

```retro
print("Inventory Manager")

DEC inventory = []  // Start with an empty inventory

// Adding items
push(inventory, "Sword")
push(inventory, "Shield")
push(inventory, "Potion")
print("Current Inventory:", inventory)

// Removing an item
DEC removedItem = pop(inventory)
print("Removed Item:", removedItem)
print("Updated Inventory:", inventory)
```

### 4. Logical Operator Demo

Demonstrate logical operators in conditionals:

```retro
DEC a = 10
DEC b = 20
IF (a < b) AND (b < 30) DO
    print("Both conditions are true!")
ELSE
    print("One or both conditions are false.")
STOP
```

---

## Extending RetroLang

RetroLang is designed for modularity and experimentation. You can extend its functionality by:

- **Adding New Keywords or Syntax:**  
  Modify the lexer and parser to introduce additional constructs.
- **Implementing Additional Built-in Functions:**  
  Expand your built-in function set (for example, advanced math functions, file I/O, or networking).
- **Creating Custom Libraries:**  
  Develop modules that can be imported into RetroLang programs for extended functionality.

---

## Contributing

RetroLang is an open platform for creative experimentation. If you have ideas for new features, improvements, or bug fixes, consider contributing by:

- Forking the repository.
- Implementing your changes.
- Submitting a pull request with documentation on your contributions.

---

## Acknowledgments

RetroLang draws inspiration from classic programming paradigms and modern scripting practices. Its design philosophy is to provide an accessible yet powerful platform for creative coding. Whether you're prototyping ideas, building simple games, or exploring programming concepts, RetroLang invites you to experiment and innovate.

---

Enjoy exploring RetroLang, and happy coding!

---

Feel free to adjust the sections or wording further to match your project's details and style.