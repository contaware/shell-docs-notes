#!/bin/sh

# Search root directory
if [ -n "$1" ]
then
    findrootdir=$1
else
    findrootdir='./testfiles/'
fi

printf '___ BAD ___\n'
find "$findrootdir" | xargs ../showargs.sh

printf '\n___ BETTER (but filenames with newline are split and those with quotes/apostrophe give troubles) ___\n'
find "$findrootdir" | xargs -I {} ../showargs.sh {}

printf '\n___ GOOD (but not POSIX) ___\n'
find "$findrootdir" -print0 | xargs -0 ../showargs.sh

printf '\n___ GOOD (one call per file like with xargs -I) ___\n'
find "$findrootdir" -exec ../showargs.sh {} \;

printf '\n___ BEST ___\n'
find "$findrootdir" -exec ../showargs.sh {} +

printf '\n___ BEST (with for-loop) ___\n'
find "$findrootdir" -exec sh -c '
printf "Child shell got %d arg(s)\n" $#
for file do
    ../showargs.sh "$file"
done
' sh {} +
