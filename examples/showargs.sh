#!/bin/sh

test $# -ne 1 && s=s
printf '%s %s\n' "$0" "got $# arg$s:"
# for arg is equivalent to: for arg in "$@"
for arg
do
    printf '>>%s<<\n' "$arg"
done 
