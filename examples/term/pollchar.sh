#!/bin/sh

# pollchar_stty var
#
# This is an internal function, use the below pollchar.
#
# The system default trap actions do restore the tty for us, but 
# if you setup a trap in your code you must restore the tty with:
# stty "$saved_tty_settings"
# Function from here:
# https://unix.stackexchange.com/questions/464930/can-i-read-a-single-character-from-stdin-in-posix-shell
# 1. To avoid printing "Illegal byte sequence" we added "2> /dev/null" to "wc -m"
# 2. To have the non-blocking behavior we changed:
#    stty -icanon min 1 time 0
#    to:
#    stty -icanon min 0 time 0   # time N (N is tenths of second), we could also use time 1
pollchar_stty() { # arg: <variable-name>
  if [ -t 0 ]; then
    # if stdin is a tty device, put it out of icanon, set min and
    # time to sane value, but don't otherwise touch other input or
    # or local settings (echo, isig, icrnl...). Take a backup of the
    # previous settings beforehand.
    saved_tty_settings=$(stty -g)
    stty -icanon min 0 time 0
  fi
  eval "$1="
  while
    # read one byte, using a work around for the fact that command
    # substitution strips trailing newline characters.
    c=$(dd bs=1 count=1 2> /dev/null; echo .)
    c=${c%.}

    # break out of the loop on empty input (eof) or if a full character
    # has been accumulated in the output variable (using "wc -m" to count
    # the number of characters).
    [ -n "$c" ] &&
      eval "$1=\${$1}"'$c
        [ "$(($(printf %s "${'"$1"'}" | wc -m 2> /dev/null)))" -eq 0 ]'; do
    continue
  done
  if [ -t 0 ]; then
    # restore settings saved earlier if stdin is a tty device.
    stty "$saved_tty_settings"
  fi
}

# pollchar var
#
# This function is non-blocking, if a key is pressed then the char is
# copied to the provided var, otherwise the empty string is copied.
pollchar() { # arg: <variable-name>
  pollchar_temp=

  # read with the -t option fails when no key is pressed within the 
  # given timeout, and as the the failure codes are not standardized, 
  # we cannot distinguish between timeout and missing option errors. 
  # For this reason the stty method is the first choice, and only if 
  # stty is missing we fallback to read with the most common options
  if command -v stty > /dev/null 2>&1
  then
    pollchar_stty pollchar_temp
  else
    # The following read options work for bash, ksh and busybox, 
    # note that the -t timeout must be greater than 0, otherwise 
    # nothing is read
    IFS= read -r -n1 -t0.01 pollchar_temp
  fi

  eval "$1=\$pollchar_temp"
  return 0
}
