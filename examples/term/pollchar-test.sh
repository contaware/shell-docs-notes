#!/bin/sh

. ./pollchar.sh

# Always clean-up the stty settings modified below in both handlers:
# 1. In kills_trap() because exit_trap() may not always be called
# 2. In exit_trap() because the shell itself may restore the stty 
#    changes made for read calls in its INT TERM HUP QUIT handlers, 
#    and those handlers are often called after our kills_trap(), 
#    thus making the clean-up in our kills_trap() useless
kills_trap()
{
    stty "$init_tty_settings" 2> /dev/null
    exit 0
}
exit_trap()
{
    stty "$init_tty_settings" 2> /dev/null
}
trap 'kills_trap' INT TERM HUP QUIT
trap 'exit_trap' EXIT

# Disable character echo
init_tty_settings=$(stty -g 2> /dev/null)
stty -echo 2> /dev/null

# Main loop
while true
do
    pollchar char_pressed
    printf 'Got: >>%s<<\n' "$char_pressed"
done
