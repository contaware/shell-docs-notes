#!/bin/sh

printf '___ This is the input ___\n'
read_input=$(printf '    First line with leading spaces.\nSecond line with      spaces and a backslash escape <\\\\>.\nLast line.')
printf '%s\n' "$read_input"

printf '\n___ Just the read command ___\n'
printf '%s' "$read_input" | while read line
do
	printf '%s\n' "$line"
done

printf '\n___ Last line shown ___\n'
printf '%s' "$read_input" | while read line || [ -n "$line" ]
do
	printf '%s\n' "$line"
done

printf '\n___ Added -r switch ___\n'
printf '%s' "$read_input" | while read -r line || [ -n "$line" ]
do
	printf '%s\n' "$line"
done

printf '\n___ Maintaining also leading/trailing spaces ___\n'
printf '%s' "$read_input" | while IFS= read -r line || [ -n "$line" ]
do
	printf '%s\n' "$line"
done
