#!/bin/sh

printf 'Do you want to continue [y/N] ? ' # capitalized answer in [y/N] is considered
read -r ans                               # the default when just ENTER is pressed 
if [ "$ans" != "${ans#[Yy]}" ]
then
    echo Yes
else
    echo No
fi
