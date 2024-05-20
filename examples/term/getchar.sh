#!/bin/sh

# getchar_stty var
#
# This is an internal function, use the below getchar.
#
# The system default trap actions do restore the tty for us, but 
# if you setup a trap in your code you must restore the tty with:
# stty "$saved_tty_settings"
# Function from here:
# https://unix.stackexchange.com/questions/464930/can-i-read-a-single-character-from-stdin-in-posix-shell
# 1. To avoid printing "Illegal byte sequence" we added "2> /dev/null" to "wc -m"
getchar_stty() { # arg: <variable-name>
  if [ -t 0 ]; then
    # if stdin is a tty device, put it out of icanon, set min and
    # time to sane value, but don't otherwise touch other input or
    # or local settings (echo, isig, icrnl...). Take a backup of the
    # previous settings beforehand.
    saved_tty_settings=$(stty -g)
    stty -icanon min 1 time 0
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

# getchar var
#
# This function blocks until a key is pressed, the read char is 
# copied to the provided var.
getchar() { # arg: <variable-name>
  getchar_temp=

  # 1. Prefer the POSIX compliant method if stty is present 
  # 2. The read option -n1 works in bash, ksh and busybox
  #    (do not use -n 1 because zsh would not fail, that's 
  #     because it has an unrelated alone standing -n option 
  #     and the 1 would mean read into $1)
  # 3. The read option -k1 is for zsh  
  if command -v stty > /dev/null 2>&1
  then
    getchar_stty getchar_temp
  else
    # read fails when an option is not supported, in that case try the
    # next combination. Note that we only hide stderr and not stdout 
    # so that text printed from a trap handler will be shown
    IFS= read -r -n1 getchar_temp 2> /dev/null || IFS= read -r -k1 getchar_temp
  fi

  eval "$1=\$getchar_temp"
  return 0
}
