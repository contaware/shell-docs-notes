#!/bin/sh

traverse() 
{
    for file in "${1%/}"/*
    do
        if [ -e "$file" ] # guard against self-expansion if there is no match
        then
            if [ -d "$file" ]
            then
                traverse "$file"
            else
                printf '"%s"\n' "$file"
            fi
        fi
    done
}

# Search root directory
if [ -n "$1" ]
then
    findrootdir=$1
else
    findrootdir='./testfiles/'
fi

traverse "$findrootdir"
