#!/bin/sh

. ./term-size.sh

redraw()
{
    gettermlines lines
    gettermcols cols
    printf '\033[2J\033[HLines x Cols: >>%s<< >>%s<<' "$lines" "$cols"
}

# If the WINCH signal is supported use it, otherwise poll the size
if trap redraw WINCH >/dev/null 2>&1
then
    clear
    redraw
    while true
    do
        :
    done
else
    clear
    while true
    do
        redraw
        if command -v usleep >/dev/null 2>&1
        then
            # sleep 0.3 sec
            usleep 300000
        else
            # sleep 1 sec
            sleep 1
        fi
    done
fi
