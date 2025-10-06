#!/bin/sh

# Copy given file to provided destination directory in a safe way
#
# safecp.sh srcfile dstdir
#
# - First parameter is the source file to be copied to the destination.
# - Second parameter must be an existing destination directory.
# - If in destination directory there is already a file or a directory 
#   with the name of the source file, then the copied file will have a 
#   numeric suffix appended before its file extension.

# Make sure that the first parameter is not empty
if [ -z "$1" ]; then
    exit 0
fi

# Make sure that the second parameter is not empty
if [ -z "$2" ]; then
    exit 0
fi

# Source file name
fn=${1##*/}
fn_noext=${fn%%.*}

# Source file extension
case $fn in
*.* )
    ext=.${fn#*.}    # file extension with dot
    ;;
* )
    ext=             # if there is no extension
    ;;
esac

# Trim destination directory's trailing slash and make sure it exists
dst=${2%/} 
if [ ! -d "$dst/" ]; then
    exit 1
fi

# Copy the file normally if a file/directory with the given name does 
# not exist in destination directory
if [ ! -e "$dst/${fn_noext}$ext" ]; then
    cp "$1" "$dst/${fn_noext}$ext"
else
    # Find a non-existing name by append a number
    num=1
    while [ -e "$dst/${fn_noext}_$num$ext" ]; do
        num=$((num + 1))
    done
    cp "$1" "$dst/${fn_noext}_$num$ext"
fi
