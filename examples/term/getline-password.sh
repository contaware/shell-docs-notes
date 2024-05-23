#!/bin/sh

printf 'Enter password: '
if read -s -r your_passwd >/dev/null 2>&1 # fails if -s is not supported (unfortunately ksh has -s but with another meaning)
then
    printf '\nGot through read -s: %s\n' "$your_passwd"
else
    saved_tty_settings=$(stty -g)
    stty -echo
    read -r your_passwd
    stty "$saved_tty_settings"
    printf '\nGot through stty -echo: %s\n' "$your_passwd"
fi
