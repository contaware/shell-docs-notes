#!/bin/sh

. ./getchar.sh

printf 'Please press a key: '
getchar char_pressed
printf '\nGot: >>%s<<\n' "$char_pressed"
