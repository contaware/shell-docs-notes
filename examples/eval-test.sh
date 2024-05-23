#!/bin/sh

# Debug
set -v

# Sequential output
var=1
echo $var; var=$((var+1)); echo $var

# With single quotes everything is evaluated later on like above
var=1
eval 'echo $var; var=$((var+1)); echo $var'

# We can also use newlines in eval
var=1
eval 'echo $var
var=$((var+1))
echo $var'

# With double-quotes the initial value of var gets substituted over 
# the entire eval command, this means that the second echo still prints 
# the initial value, and only the third echo outputs the incremented value
var=1
eval "echo $var; var=$((var+1)); echo $var"
echo $var
