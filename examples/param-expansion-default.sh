#!/bin/sh

var=
def=*


printf '\n___ ${var:-$def} ___\n'
echo ${var:-$def}

printf '\n___ "${var:-$def}" ___\n'
echo "${var:-$def}"

printf '\n___ ${var:-"$def"} ___\n'
echo ${var:-"$def"}

printf '\n___ "${var:-"$def"}" ___\n'
echo "${var:-"$def"}"


printf '\n___ ${var:-*} ___\n'
echo ${var:-*}

printf '\n___ "${var:-*}" ___\n'
echo "${var:-*}"

printf '\n___ ${var:-"*"} ___\n'
echo ${var:-"*"}

printf '\n___ "${var:-"*"}" ___\n'
echo "${var:-"*"}"
