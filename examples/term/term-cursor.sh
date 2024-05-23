#!/bin/sh

# ANSI escapes (\033 is ESC)
# CSI (Control Sequence Introducer)
# commands are defined like:
# \033[<PARAMS><INTER><SINGLE>
# <PARAMS>    semicolon-separated numbers
#             (missing numbers are treated as 0)
#             or:
#             : < = > ?
# <INTER>     intermediate bytes:
#             ! " # $ % & ' ( ) * + , - . /
# <SINGLE>    final command byte

# Move cursor to absolute position
# \033[<LINE>;<COL>H
# the values are 1-based and default to 1 if omitted
# -> move the cursor to home with:
CUR_HOME='\033[H'

# Move cursor up NUM lines
# \033[<NUM>A
# Move cursor down NUM lines
# \033[<NUM>B
# Move cursor right NUM columns
# \033[<NUM>C
# Move cursor left NUM columns
# \033[<NUM>D

# Show/hide cursor
CUR_SHOW='\033[?25h'
CUR_HIDE='\033[?25l'

# Save/Restore cursor position
CUR_SAVE='\033[s'
CUR_RESTORE='\033[u'

# Clear the screen
CLEAR_SCR='\033[2J'
CLEAR_SCR_FULL='\033[3J'  # clears also the scrollback buffer

# Erasing will not move the cursor, use \r to return the cursor
# to the start of the current line
# Erase the entire current line
LINE_DEL='\033[2K'
# Erase from cursor position (inclusive) to end of line
CUR_DEL_END='\033[K'
# Erase from cursor position (inclusive) to start of line
CUR_DEL_START='\033[1K'
# Erase from cursor position (inclusive) down to bottom of screen
CUR_DEL_BOTTOM='\033[J'
# Erase from cursor position (inclusive) up to top of screen
CUR_DEL_TOP='\033[1J'

printf "${CLEAR_SCR}${CUR_HOME}Hello World!"
sleep 2
printf '\033[2;1HSecond line'
sleep 2
printf "${CUR_HOME}${LINE_DEL}Goodbye"
sleep 1
printf '\n.'
sleep 1
printf '..'
sleep 1
printf 'over'
sleep 1
printf 'write\n'
sleep 1
printf 'cursor about to hide '
sleep 1
printf "${CUR_HIDE}"
sleep 2
printf "${CUR_SHOW}\ndone\n"
