#!/bin/sh

# It's possible to get the terminal size with ANSI escapes by 
# saving the current cursor position, setting the cursor position 
# out of screen 999;999 and then calling the get cursor position:
# \033[6n
# that responds to /dev/tty in the following format:
# \033[<LINE>;<COL>R
# Finally restore the cursor position.
#
# There are tools doing the above work for us, we just have to 
# look after them with the command tool.

# gettermlines var
#
# This function returns the terminal number of lines.
gettermlines()
{
    if command -v tput >/dev/null 2>&1
    then
        termlines_temp=$(tput lines)
    elif command -v stty >/dev/null 2>&1
    then
        termlines_temp=$(stty size | cut -d ' ' -f 1) # stty size returns: lines cols
    elif command -v ttysize >/dev/null 2>&1
    then
        termlines_temp=$(ttysize | cut -d ' ' -f 2) # ttysize returns: cols lines
    else
        termlines_temp=$LINES
    fi

    eval "$1=\$termlines_temp"
    return 0
}

# gettermcols var
#
# This function returns the terminal number of columns.
gettermcols()
{
    if command -v tput >/dev/null 2>&1
    then
        termcols_temp=$(tput cols)
    elif command -v stty >/dev/null 2>&1
    then
        termcols_temp=$(stty size | cut -d ' ' -f 2) # stty size returns: lines cols
    elif command -v ttysize >/dev/null 2>&1
    then
        termcols_temp=$(ttysize | cut -d ' ' -f 1) # ttysize returns: cols lines
    else
        termcols_temp=$COLUMNS
    fi

    eval "$1=\$termcols_temp"
    return 0
}
