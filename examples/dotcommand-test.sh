#!/bin/sh

# In POSIX shell the dot command does not support passing 
# arguments to the called script (pass them as variables)

# The arguments shown are the ones of the parent script
. ./showargs.sh

echo "------------------------------------------"

# No arguments shown
./showargs.sh
