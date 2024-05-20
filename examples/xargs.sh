#!/bin/sh

printf '___ This is the input ___\n'
read_input=$(printf '%s\n%s\n%s\n%s\n%s\n%s'\
                     "Argument split"\
                     '"In double-quotes" "double-quoted on same line"'\
                     "'In single-quotes'"\
                     'Space\ escaped'\
                     'newline\'\
                     'escaped')
printf '%s\n' "$read_input"

printf '\n___ Arguments must be enclosed in quotes to avoid being separated (backslash-escaping newlines works) ___\n'
printf '%s' "$read_input" | xargs ./showargs.sh

printf '\n___ ...if not, then use -I which works per line (backslash-escaping newlines with -I does not always work) ___\n'
printf '%s' "$read_input" | xargs -I {} ./showargs.sh {}

printf '\n___ The null separator of -0 overrides the newline separator of -I ___\n'
printf '%s' "$read_input" | xargs -0 -I {} ./showargs.sh {}
