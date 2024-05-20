#!/bin/sh

# Sample UI drawing with non-blocking key-press input.
# We use ANSI escapes drawing which is really faster than 
# calling tput cup for each cursor position to draw.

# Non-blocking pollchar function
. ./pollchar.sh

# To get the terminal size
. ./term-size.sh

# Show/hide cursor
CUR_SHOW='\033[?25h'
CUR_HIDE='\033[?25l'

term_size_poll_and_clear()
{
    # Do clear if terminal size changed
    gettermlines lines
    gettermcols cols
    doclear=0
    if [ "$prev_lines" != "$lines" ]
    then
        prev_lines=$lines
        doclear=1
    fi
    if [ "$prev_cols" != "$cols" ]
    then
        prev_cols=$cols
        doclear=1    
    fi
    if [ "$doclear" = 1 ]
    then
        clear
        printf "${CUR_HIDE}"
    fi
}

draw()
{
    # Print corners
    printf "\033[1;1H+"
    printf "\033[1;${cols}H+"
    printf "\033[$lines;1H+"
    printf "\033[$lines;${cols}H+"

    # Print top border
    printf '\033[1;2H'
    col=2
    while [ "$col" -lt "$cols" ]
    do
        printf '-'
        col=$((col+1))
    done

    # Print bottom border
    printf "\033[$lines;2H"
    col=2
    while [ "$col" -lt "$cols" ]
    do
        printf '-'
        col=$((col+1))
    done

    # Print left border
    line=2
    while [ "$line" -lt "$lines" ]
    do
        printf "\033[$line;1H|"
        line=$((line+1))
    done

    # Print right border
    line=2
    while [ "$line" -lt "$lines" ]
    do
        printf "\033[$line;${cols}H|"
        line=$((line+1))
    done

    # Print date and time
    printf '\033[3;3H'
    date

    # Print lines x columns
    printf "\033[$((lines-2));3HLines x Cols: %03d %03d" "$lines" "$cols"
}

draw_char()
{
    outline=$((lines/2))
    outcol=$((cols/2 - 9))
    if [ $outcol -lt 3 ]
    then
        outcol=3
    fi
    printf "\033[$outline;${outcol}HPressed key: >>%s<<" "$key_press"
    outline=$((outline+1))
    if [ -z "$key_press" ]
    then
        printf "\033[$outline;${outcol}HCharacter code: none"
    else
        # Print code-point
        charcode_text="Character code: "
        keypress_codepoint=$(printf "%u" "'$key_press") # with a leading-quote printf outputs the code-point
        printf "\033[$outline;${outcol}H%s%s" "$charcode_text" "$keypress_codepoint"

        # Write spaces till end of line
        charcode_text_len=${#charcode_text}
        keypress_codepoint_len=${#keypress_codepoint}
        col=$((outcol + charcode_text_len + keypress_codepoint_len))
        while [ "$col" -lt "$cols" ]
        do
            printf ' '
            col=$((col+1))
        done
    fi
    outline=$((outline+1))
    printf "\033[$outline;${outcol}H(Ctrl+C to quit)"
}

# Setup traps
kills_trap()
{
    clear
    printf "${CUR_SHOW}"
    stty "$init_tty_settings" 2> /dev/null
    exit 0
}
exit_trap()
{
    clear
    printf "${CUR_SHOW}"
    stty "$init_tty_settings" 2> /dev/null
}
trap 'kills_trap' INT TERM HUP QUIT
trap 'exit_trap' EXIT

# Disable character echo
init_tty_settings=$(stty -g 2> /dev/null)
stty -echo 2> /dev/null

# Main loop
key_press=
prev_key_press=
while true
do
    # Poll term size and call clear if it changed
    term_size_poll_and_clear

    # Draw
    time_draw=$(date +%s)
    draw

    # Poll char and draw it, break out at next second
    while true
    do
        while true
        do
            pollchar key_press
            if [ -z "$key_press" ]
            then
                key_press=$prev_key_press
                break
            else
                prev_key_press=$key_press    
            fi
        done
        draw_char

        if [ $(($(date +%s) - $time_draw)) -gt 0 ]
        then
            break
        fi
    done
done
