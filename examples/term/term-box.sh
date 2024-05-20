#!/bin/sh

# Box drawing (without UTF-8) supported by most shells
# The Esc(0 enables the Code page 1090, and the sequence Esc(B switches back. 
# https://en.wikipedia.org/wiki/Box-drawing_character#Unix,_CP/M,_BBS
printf '\033(0lqqqqqqqqk\033(B\n'
printf '\033(0x        x\033(B\n'
printf '\033(0tqqqqqqqqu\033(B\n'
printf '\033(0x        x\033(B\n'
printf '\033(0mqqqqqqqqj\033(B\n'

# Box drawing for shells that support UTF-8
# https://en.wikipedia.org/wiki/Box-drawing_character
printf '%b\n' "\u2554\u2550\u2557" # change Shebang to bash to have this working
printf '%b\n' "\342\225\224\342\225\220\342\225\227" # used a UTF-8 to octal converter
printf '╔═╗\n' # if your editor supports UTF-8 chars, that's the most intuitive way
