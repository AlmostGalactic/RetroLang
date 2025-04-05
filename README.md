# RetroLang

RetroLang is a simple, retro-inspired programming language built entirely in Lua. It comes with its own lexer, parser, interpreter, and a REPL, making it a lightweight platform for learning and rapid prototyping.

## Overview

RetroLang is designed to be straightforward and easy to extend. It features a clear syntax with custom keywords and built-in functions that handle common programming tasks such as I/O, arithmetic, string manipulation, and array handling.

## Features

- **Simple Syntax:** Uses clear keywords such as `DEC` for variable declaration and `FN` for function definition.
- **Control Structures:** Supports conditional (`IF`, `ELSEIF`, `ELSE`, `DO`, `STOP`) and looping (`WHILE`, `DO`, `STOP`) constructs.
- **Expressions & Operators:** Handles arithmetic operations, comparisons, and function calls.
- **Built-in Functions:** Offers a variety of functions for I/O, math operations, string manipulation, and array operations.
- **REPL Support:** Comes with an interactive Read-Eval-Print Loop for experimenting with code on the fly.

## File Structure

- **Lexer.lua:**  
  Tokenizes the source code into a series of tokens. It recognizes keywords, identifiers, numbers, strings, and symbols.

- **Parser.lua:**  
  Parses the tokens from the lexer into an Abstract Syntax Tree (AST) that represents the program's structure.

- **Interpreter.lua:**  
  Walks the AST to evaluate expressions, execute statements, and manage variable scopes via an environment stack. It also integrates built-in and user-defined functions.

- **main.lua:**  
  Serves as the entry point for executing RetroLang programs from files. It reads a file provided as a command-line argument, tokenizes, parses, and interprets its contents.

- **repl.rl:**  
  A REPL (Read-Eval-Print Loop) implemented in RetroLang's own syntax, allowing interactive coding sessions. Type `exit` to quit the REPL.

## Language Syntax and Keywords

RetroLang uses a unique syntax defined by several custom keywords:

- **`DEC`**: Declares a variable.
- **`FN`**: Declares a function.
- **`RETURN`**: Returns a value from a function.
- **`IF`**, **`ELSEIF`**, **`ELSE`**: Control structures for conditional logic.
- **`DO`**: Marks the start of a block for conditionals and loops.
- **`WHILE`**: Begins a loop.
- **`STOP`**: Ends a block (functions, loops, or conditionals).
- **`IMPORT`**: Reserved for module inclusion (future use).

## Getting Started

### Prerequisites

- **Lua:** Ensure that Lua is installed on your system. You can download it from [Lua.org](https://www.lua.org/).

### Running a RetroLang Program

1. **Create a RetroLang File:**  
   Write your RetroLang code in a file (e.g., `example.rl`).

2. **Execute the File:**  
   Run the interpreter from the command line:
   ```bash
   lua main.lua example.rl
   ```
### Using the REPL

To interact with RetroLang in an interactive mode:

1. **Start the REPL:**  
   Run the REPL file:
   ```bash
   lua main.lua repl.rl
   ```

2. **Interactive Session:**  
   Enter your RetroLang code at the prompt. Type `exit` to quit the REPL.

## Example Code

Below is a simple example demonstrating variable declaration, function definition, and output:
```retro
DEC x = 10
DEC y = 20

FN add(a, b)
    RETURN a + b
STOP

print(add(x, y))
```

## Built-in Functions

RetroLang includes several built-in functions to simplify common operations:

- **I/O Functions:**
  - `print`: Outputs data with a newline.
  - `write`: Outputs data without a newline.
  - `get`: Prompts the user for input.
  - `alert`: Displays an alert message.

- **String Functions:**
  - `concat`: Concatenates two strings.
  - `uppercase`: Converts a string to uppercase.
  - `lowercase`: Converts a string to lowercase.
  - `substring`: Extracts a substring.
  - `split`: Splits a string into an array based on a delimiter.
  - `tostr`: Converts a value to a string.

- **Math Functions:**
  - `tonum`: Converts a value to a number.
  - `random`: Generates a random number within a specified range.
  - `floor`: Returns the largest integer less than or equal to a given number.
  - `ceil`: Returns the smallest integer greater than or equal to a given number.
  - `abs`: Returns the absolute value of a number.

- **Array Functions:**
  - `push`: Appends a value to an array.
  - `pop`: Removes and returns the last element of an array.
  - `len`: Returns the length of an array.
  - `reverse`: Reverses the order of elements in an array.

- **Utility Functions:**
  - `typeof`: Returns the type of a given variable.

## Extending RetroLang

RetroLang is designed to be modular and extensible:
- **Lexer and Parser:**  
  Modify `Lexer.lua` and `Parser.lua` to add new tokens, keywords, or syntax.
- **Interpreter:**  
  Extend `Interpreter.lua` to incorporate new built-in functions or change runtime behavior.

## Contributing

Contributions are welcome! Feel free to fork the repository, make enhancements, and submit pull requests to improve RetroLang.

## License

RetroLang is released under the MIT License. See the LICENSE file for more details.

## Acknowledgments

RetroLang is inspired by classic programming languages and modern scripting paradigms, aiming to offer a nostalgic yet practical tool for developers and learners alike.

---

Enjoy coding with RetroLang!
