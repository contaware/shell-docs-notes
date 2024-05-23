#!/bin/sh

def='default'
printf 'Enter a value [%s]: ' "$def"
read -r ans
ans=${ans:-$def}
echo "You answered: $ans"
