#!/bin/sh

# Shell variable
printf "SHELL variable (not an indication of what the script runs-in):\n%s\n\n" "$SHELL"

# Guess shell through defined variables
printf "Guess shell through defined variables:\n"
if test -n "$ZSH_VERSION"; then
  PROFILE_SHELL='zsh'
elif test -n "$BASH_VERSION"; then
  PROFILE_SHELL='bash'
elif test -n "$KSH_VERSION"; then
  PROFILE_SHELL='ksh'
elif test -n "$FCEDIT"; then
  PROFILE_SHELL='ksh'
elif test -n "$PS3"; then
  PROFILE_SHELL='unknown'
else
  PROFILE_SHELL='sh'
fi
printf '%s\n\n' "$PROFILE_SHELL"

# Command associated with the script's pid
# Note: unfortunately the -p option is not well supported by ps,
#       otherwise we could do: SCRIPT_CMD_LINE=$(ps -o args= -p "$$")
printf "Command associated with the script's pid:\n"
SCRIPT_CMD_LINE=$(ps -o pid=----PID----,args= | grep "^[[:space:]]*$$" | cut -c 13-)
printf '%s\n' "$SCRIPT_CMD_LINE"
printf "Resolve link of command:\n"

# Split the command line to get the shell command running our script
# Note: xargs is the correct way of doing the parsing, it take into 
#       account a possible quoting of the arguments. In case that 
#       xargs is missing, we can use cut to split at first space:
#       SCRIPT_CMD=$(printf '%s' "$SCRIPT_CMD_LINE" | cut -d ' ' -f 1)
SCRIPT_CMD=$(printf '%s' "$SCRIPT_CMD_LINE" | xargs -n 1 printf '%s\n' 2>/dev/null | head -n 1)

readlink -f "$SCRIPT_CMD"
printf '\n'
