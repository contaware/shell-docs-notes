#!/bin/sh

while getopts ":aZ:" opt
do
  case $opt in
     a)
       echo "Option -a called"
       ;;
     Z)
       echo "Option -Z called with $OPTARG"
       ;;
     \?)
       echo "*** Invalid Option -$OPTARG ***"
       ;;
     :)
       echo "*** Option -$OPTARG requires an Option-Argument ***"
       ;;
     *)
       echo "*** SHOULD NEVER LAND HERE ***"
       ;;
  esac
done
if [ $OPTIND -eq 1 ]
then 
    echo "No Options were passed"
fi
shift $((OPTIND-1))
echo "$# Non-Option Argument(s) (also called Operand(s)) follow:"
for operand in "$@"
do
    echo "$operand"
done
