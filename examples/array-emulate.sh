#!/bin/sh

# In POSIX there is no native array type, but there are different 
# possibilities. To be coherent with the positional parameters and with 
# tools like cut, sed, awk, sort, one-based indexing is used here.


printf '1. Space separated string (if elements have no spaces):\n'
array='0 1.3 4.2 6 8.7 16.2'           # init array

array='-1 '$array                      # add to start
array=$array' 32.1'                    # append to end

for item in $array                     # loop array
do
    printf '"%s"\n' "$item"
done

i=4
item=$(echo "$array" | cut -d' ' -f$i) # get item with index $i
printf '%s=>"%s"\n' $i "$item"

printf '\n*******************************************************************\n'


printf '\n2. Using positional parameters (gives us only one array):\n'
set -- 'Item 1' 'Item 2' 'Item 3'      # add items (array is first cleared)

set -- 'Item start' "$@"               # add to start
set -- "$@" 'Item end'                 # append to end

shift 1                                # delete first item

n=1 len=$#
for item in "$@"                       # delete last item
do
    if [ $n = 1 ]; then set --         # in first run empty "$@"
    elif [ $n = $len ]; then break; fi # stop before processing the last item
    set -- "$@" "$item"
    n=$((n+1))
done

for item in "$@"                       # loop array
do
    printf '"%s"\n' "$item"
done

i=2
eval "item=\${$i}"                     # get item with index $i
printf '%s=>"%s"\n' $i "$item"

printf '\n*******************************************************************\n'


printf '\n3. Using multiple shell variables:\n'
len=3 n=1
while [ $n -le $len ]                  # create items
do
    eval "array$n=\"Item ${n}\""
    n=$((n+1))
done

n=1
while [ $n -le $len ]                  # loop array
do
    eval "item=\$array$n"
    printf '"%s"\n' "$item"
    n=$((n+1))
done

i=3
eval "item=\$array$i"                  # get item with index $i
printf '%s=>"%s"\n' $i "$item"
