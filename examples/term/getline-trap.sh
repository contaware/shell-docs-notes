#!/bin/sh

trap 'printf "\nINT\n"; exit 0' INT
trap 'printf "EXIT\n"' EXIT

printf 'Press CTRL+C to see what happens\n'
read -r ans
printf 'Answer: >>%s<<\n' "$ans" # this line will not be called when CTRL+C is pressed
