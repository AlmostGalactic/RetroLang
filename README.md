# RetroLang : How to program in

RetroLang is a retro-inspired programming language built entirely in Lua. It’s designed for simplicity, flexibility, and rapid prototyping, making it an ideal platform for both learning programming concepts and developing small projects. This documentation focuses on the functionality of RetroLang and provides examples of creative projects you can build with it.

---

## Overview

RetroLang features a custom syntax that emphasizes clarity and ease of use. With its concise keywords and built-in functions, you can quickly get started on projects ranging from simple calculations to interactive text adventures. The language offers:

- **Dynamic variable handling** with block scoping.
- **User-defined functions** for modular code.
- **Control structures** for conditionals and loops.
- **Rich built-in functions** for I/O, math, strings, arrays, and more.

---

## Language Constructs

### Variables and Expressions

Variables are declared using the `DEC` keyword, and expressions support arithmetic, string manipulation, and comparisons. For example:

```retro
DEC x = 10
DEC y = 20
DEC sum = x + y
print("The sum is: " + tostr(sum))
```

### Functions

Functions are defined with the `FN` keyword and terminated with `STOP`. Parameters and return values allow for code reuse and abstraction:

```retro
FN add(a, b)
    RETURN a + b
STOP

print("5 + 3 =", add(5, 3))
```

### Control Structures

RetroLang includes familiar control structures for decision-making and loops:

- **Conditional Statements:**

```retro
DEC temperature = 25

IF temperature > 30 DO
    print("It is hot outside!")
ELSEIF temperature < 10 DO
    print("It is cold outside!")
ELSE
    print("The weather is moderate.")
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
- **alert:** Displays an alert message for debugging.

### String Functions
- **concat:** Joins two strings.
- **uppercase / lowercase:** Converts strings to upper or lower case.
- **substring:** Extracts a part of a string.
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
- **set:** Sets an index of a specified array to a value.

### Utility Functions
- **typeof:** Returns the type of a variable.

These functions allow you to perform a wide range of operations without having to implement complex logic from scratch.

---

## Example Projects

Here are a few ideas of projects you could build with RetroLang:

### 1. Simple Calculator

Create a program that takes two numbers as input and performs basic arithmetic operations.

```retro
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
```

### 2. Text Adventure Game

Develop a simple text-based adventure where the player makes choices that affect the outcome of the story.

```retro
print("Welcome to RetroQuest!")

DEC choice = get("You are at a crossroads. Choose left or right: ")

IF choice == "left" DO
    print("You encounter a friendly wizard who offers you a quest!")
ELSEIF choice == "right" DO
    print("You stumble upon a hidden treasure chest!")
ELSE
    print("You wander in circles, unsure of where to go.")
STOP
```

### 3. Inventory Management

Simulate a basic inventory system where you can add or remove items from an array.

```retro
print("Inventory Manager")

DEC inventory = []  // Starting with an empty inventory

// Adding items to the inventory
push(inventory, "Sword")
push(inventory, "Shield")
push(inventory, "Potion")

print("Current Inventory: ", inventory)

// Removing an item from the inventory
DEC removedItem = pop(inventory)
print("Removed Item: ", removedItem)
print("Updated Inventory: ", inventory)
```

### 4. Recursive Function Example

Implement a recursive function, such as calculating Fibonacci numbers.

```retro
FN fibonacci(n)
    IF n <= 1 DO
        RETURN n
    ELSE
        RETURN fibonacci(n - 1) + fibonacci(n - 2)
    STOP
STOP

DEC num = 10
print("Fibonacci of ", num, " is ", fibonacci(num))
```

---

## Extending RetroLang

RetroLang is designed with modularity in mind. You can easily extend its functionality by:

- **Adding New Keywords or Syntax:**  
  Modify the lexer and parser to introduce new language constructs.

- **Implementing Additional Built-in Functions:**  
  Expand the built-in function set in the interpreter to cover more complex tasks, such as file I/O, network operations, or advanced math functions.

- **Custom Libraries:**  
  Integrate new modules that can be imported into your RetroLang programs to provide extended functionality without bloating the core language.

This extensible design makes RetroLang an excellent platform for experimentation and learning about language development.

---

## Contributing

RetroLang is an open platform for experimentation. If you have ideas for new features, improvements, or bug fixes, consider contributing by:
- Forking the project.
- Implementing your changes.
- Submitting a pull request with clear documentation of your contributions.

Every contribution helps expand the possibilities of what you can build with RetroLang.

---

## Acknowledgments

RetroLang draws inspiration from classic programming paradigms and modern scripting practices. Its design philosophy is to provide an accessible, yet powerful, platform for creative coding. Whether you're using it to prototype ideas, build simple games, or explore programming concepts, RetroLang invites you to experiment and innovate.

---

Enjoy exploring RetroLang, and happy coding!
