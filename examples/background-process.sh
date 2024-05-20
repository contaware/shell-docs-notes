#!/bin/sh

background_process()
{
    doexit=0

    # dash:    INT signal is not reaching this background process when sent with
    #          kill -INT, we use the TERM signal which correctly arrives here
    # busybox: background process traps are not called (it just exits when a signal arrives)
    trap 'doexit=1' TERM

    # Loop
    while [ "$doexit" = 0 ]
    do
        printf '\033[1;1H'
        date
        sleep 1
    done

    # Exit message
    printf '\nExiting background_process()\n'
}

do_exit_trap()
{
    kill $background_process_pid
    wait $background_process_pid
    exit 0
}

# Setup trap
trap 'do_exit_trap' INT

# Clear screen
clear

# Start the background process
background_process &
background_process_pid=$!

# Do some foreground work
while true
do
    :
done
