#!/bin/bash

# There is array support in ksh, bash (both 0-indexed) and zsh (1-indexed)

# Init
myarray=(1 2 3 4 5 6 7)

# Accessing an element
# Note: $myarray in ksh and bash is equivalent to ${myarray[0]}
#       while in zsh it refers to the whole array, 
#       and in zsh braces are unnecessary:
printf 'First element for ksh/bash or all for zsh: %s\n' "$myarray"
printf 'Second element for ksh/bash or first for zsh: %s\n' "${myarray[1]}"
printf 'Second element written wrong for ksh/bash or first for zsh: %s\n' "$myarray[1]"

# Number of elements
printf 'Array has %s elements:\n' "${#myarray[@]}"

# Get To get all elements as separate parameters, use the index @ 
# (and make sure to double quote):
for item in "${myarray[@]}"
do
    printf '%s\n' "$item"
done

# To get all elements as a single parameter, concatenated by the first 
# character in IFS, use the index * (and make sure to double quote):
for item in "${myarray[*]}"
do
    printf '%s\n' "$item"
done

# The ${myarray[@]:offset:length} syntax works identically for ksh, bash and zsh,
# without the length all elements from offset till end are returned:
printf 'First element in all shells is: %s\n' "${myarray[@]:0:1}"
printf 'First to third elements in all shells are: %s\n' "${myarray[*]:0:3}"
printf 'Delete second and third in all shells: '
myarray=("${myarray[@]:0:1}" "${myarray[@]:3}")
printf '%s\n' "${myarray[*]}"
