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

# CSI<n>m 	  is the SGR (Select Graphic Rendition) command
#     0       Reset text formatting and colors
#     1       Bold
#     4       Underline
#     7       Reversed
# FG    BG    Color
# 30 	40 	  Black
# 31 	41 	  Red
# 32 	42 	  Green
# 33 	43 	  Yellow
# 34 	44 	  Blue
# 35 	45 	  Magenta
# 36 	46 	  Cyan
# 37 	47 	  White
NC='\033[0m'
BOLD='\033[1m'
UNDERLINE='\033[4m'
REVERSED='\033[7m'
BLACK_FG='\033[30m'
RED_FG='\033[31m'
GREEN_FG='\033[32m'
YELLOW_FG='\033[33m'
BLUE_FG='\033[34m'
MAGENTA_FG='\033[35m'
CYAN_FG='\033[36m'
WHITE_FG='\033[37m'
BLACK_BG='\033[40m'
RED_BG='\033[41m'
GREEN_BG='\033[42m'
YELLOW_BG='\033[43m'
BLUE_BG='\033[44m'
MAGENTA_BG='\033[45m'
CYAN_BG='\033[46m'
WHITE_BG='\033[47m'

printf "${RED_FG}RED\n${GREEN_FG}GREEN\n${YELLOW_FG}YELLOW\n${BLUE_FG}BLUE\n${MAGENTA_FG}MAGENTA\n${CYAN_FG}CYAN\n"
printf "${WHITE_FG}${RED_BG}WHITE on RED${NC}\n${BOLD}BOLD${NC}\n${REVERSED}REVERSED${NC}\n${UNDERLINE}UNDERLINE${NC}\nNormal\n"
