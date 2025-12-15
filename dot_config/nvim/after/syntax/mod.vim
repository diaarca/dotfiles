" Vim syntax file for OPL (IBM CPLEX Optimization Programming Language)
" Language: OPL Model
" Author: Dylan's Custom Syntax
" File Extension: .mod

if exists("b:current_syntax")
  finish
endif

syntax case ignore

" Keywords
syntax keyword oplKeyword maximize minimize execute subject forall sum to
syntax match oplKeyword /\<subject to\>/

" Declarations
syntax keyword oplDeclaration float dvar int range

" Operators
syntax match oplOperator /[=+*<>-]/

" Constraints and Objective Function Symbols
syntax match oplConstraint /<=\|>=/

" Constants and Numbers
syntax match oplNumber /\<\d\+\(\.\d*\)\?\>/

" Single-line Comments
syntax match oplComment "//.*$" contains=oplTodo

" Multi-line Comments (/* ... */)
syntax region oplComment start="/\*" end="\*/" contains=oplTodo

" TODO and FIXME inside comments
syntax keyword oplTodo TODO FIXME contained

" Functions
syntax keyword oplFunction writeln cplex.getObjValue

" Braces and Parentheses
syntax match oplBraces /[{}]/
syntax match oplParentheses /[()]/

" Highlighting groups
highlight def link oplKeyword Keyword
highlight def link oplDeclaration Type
highlight def link oplOperator Operator
highlight def link oplConstraint Special
highlight def link oplNumber Number
highlight def link oplComment Comment
highlight def link oplTodo Todo
highlight def link oplFunction Function
highlight def link oplBraces Delimiter
highlight def link oplParentheses Delimiter

let b:current_syntax = "opl"
