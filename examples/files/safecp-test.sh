#!/bin/sh

# Recursively copy files to a single directory avoiding overwriting 
# the files with the same name.

# Source directory
if [ -n "$1" ]
then
    srcdir=${1%/}
else
    srcdir='./testfiles'
fi

# Destination directory
if [ -n "$2" ]
then
    dstdir=${2%/}
else
    dstdir='./outfiles'
fi
if [ ! -d "$dstdir/" ]; then
    mkdir "$dstdir/"
fi
if [ ! -d "$dstdir/safecp/" ]; then
    mkdir "$dstdir/safecp/"
fi
if [ ! -d "$dstdir/backup/" ]; then
    mkdir "$dstdir/backup/"
fi

# Copy with our safecp.sh script filtering by given file extensions
find "$srcdir/" -type f \( -name '*.txt' -o -name '*.log' \) -exec ./safecp.sh {} "$dstdir/safecp/" \;

# There is also the --backup option of cp, but then the duplicated files 
# suffix is placed at the end after the file extension
find "$srcdir/" -type f \( -name '*.txt' -o -name '*.log' \) -exec cp --backup=numbered {} "$dstdir/backup/" \;

# The --backup option is only supported by the GNU cp and not by the BSD 
# version used on MacOS for example. For MacOS it's possible to install 
# gcp from GNU Coreutils via Homebrew:
# ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
# brew install coreutils
