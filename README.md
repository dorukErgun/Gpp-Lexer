# Gpp-Lexer

This project implements the lexer for below defined language with two approaches. One using the language LISP, one using the tool Flex.

## Gpp syntax
- Lisp like syntax
- Imperative, non-object oriented
- Static scope, static binding, strongly typed

## Gpp Lexical Syntax

### Keyword
and, or, not, equal, less, nil, list, append, concat, set, deffun, for, if, exit, load, disp, true, false

### Operators
\+, -, /, *, (, ), **, “ “ ,

### Comment
Line starting with ;;

### Terminals
• Keywords\
• Operators\
• Value: Any combination of digits with no leading zeros. 0 is
considered a value.\
• Identifier: Any combination of alphabetical characters and digits
with no leading digit.\

### Gpp Lexer Tokens

- KW_AND, KW_OR, KW_ NOT, KW_EQUAL, KW_LESS, KW_NIL, KW_LIST, KW_APPEND, KW_CONCAT, KW_SET, KW_DEFFUN, KW_FOR, KW_IF, KW_EXIT, KW_LOAD, KW_DISP, KW_TRUE, KW_FALSE, OP_PLUS, OP_MINUS, OP_DIV, OP_MULT, OP_OP, OP_CP, OP_DBLMULT, OP_OC, OP_CC, OP_COMMA
- COMMENT
- VALUE
- IDENTIFIER
