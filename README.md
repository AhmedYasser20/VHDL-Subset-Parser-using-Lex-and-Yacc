# VHDL-Subset-Parser-using-Lex-and-Yacc
This project implements a simple parser for a subset of VHDL (Very High Speed Integrated Circuit Hardware Description Language) using Lex and Yacc.

## Features

- Parses basic VHDL structures: entity declarations, architecture definitions, signal declarations, and assignments
- Case-insensitive keyword recognition
- Checks for entity name consistency
- Validates signal declarations and assignments
- Provides error reporting with line numbers

## Prerequisites

To build and run this project, you'll need:

- GCC compiler
- Flex (for Lex)
- Bison (for Yacc)
- Make

## Building the Project

1. Clone this repository:
   ```
   git clone https://github.com/yourusername/vhdl-subset-parser.git
   cd vhdl-subset-parser
   ```

2. Build the parser:
   ```
   make
   ```

This will generate the `parser` executable.

## Running the Parser

To parse a VHDL file:

```
./parser < your_vhdl_file.vhd
```

## Running Tests

To run the provided test cases:

```
./testScript.sh
```

This script will run the parser against several test cases located in the `testCases` directory.

## Project Structure

- `lexer.l`: Lexical analyzer definitions
- `parser.y`: Grammar rules and semantic actions
- `makefile`: Build instructions
- `testScript.sh`: Script to run test cases
- `testCases/`: Directory containing test VHDL files

## Limitations

This parser implements a subset of VHDL. It supports:

- Single entity-architecture pairs
- Basic signal declarations and assignments
- Simple type checking

It does not support full VHDL syntax or advanced features.


## Contact

[Your contact information or link to issues page]
