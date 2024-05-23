#!/bin/sh

# Search root directory
if [ -n "$1" ]
then
    findrootdir=${1%/}          # trim trailing slash
else
    findrootdir='./testfiles'   # do not provide a trailing slash!
fi

printf '___ Matches nothing as globbing does not work in quotes ___\n'
for file in '*' "*"
do
    printf '"%s"\n' "$file"
done

printf '\n___ Match non-dot files/dirs ___\n'
for file in "$findrootdir"/*
do
    # Guard against self-expansion if there is no match
    if [ -e "$file" ]
    then
        printf '"%s"\n' "$file"
    fi
done

printf '\n___ Match non-dot files ___\n'
for file in "$findrootdir"/*
do
    # Test for ordinary file
    if [ -f "$file" ]
    then
        printf '"%s"\n' "$file"
    fi
done

printf '\n___ Match non-dot dirs ___\n'
for file in "$findrootdir"/*/
do
    # Guard against self-expansion if there is no match
    if [ -e "$file" ]
    then
        printf '"%s"\n' "$file"
    fi
done

printf '\n___ Match dot files/dirs (also . and .. are matched) ___\n'
for file in "$findrootdir"/.*
do
    # Guard against self-expansion if there is no match
    if [ -e "$file" ]
    then
        printf '"%s"\n' "$file"
    fi
done

printf '\n___ Match dot files/dirs ___\n'
for file in "$findrootdir"/.[!.]* "$findrootdir"/..?*
do
    # Guard against self-expansion if there is no match
    if [ -e "$file" ]
    then
        printf '"%s"\n' "$file"
    fi
done

printf '\n___ Match dot dirs ___\n'
for file in "$findrootdir"/.[!.]*/ "$findrootdir"/..?*/
do
    # Guard against self-expansion if there is no match
    if [ -e "$file" ]
    then
        printf '"%s"\n' "$file"
    fi
done
