#!/bin/sh

VAR='This is a var'

cut -c1- << ENDTXT1
Here doc delimiter not in quotes
$VAR
ENDTXT1

echo "------------------------------------------"

cut -c1- << 'ENDTXT2'
Here doc delimiter in single-quotes
$VAR
ENDTXT2

echo "------------------------------------------"

cut -c1- << "ENDTXT3"
Here doc delimiter in double-quotes
(exact same behavior as in single-quotes)
$VAR
ENDTXT3
