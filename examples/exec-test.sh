#!/bin/sh

# Uncomment alternatively point 1. or 2. to see what happens:

# 1. exec with command
exec date 1> ./exec-test-out.txt

# 2. exec without command
#exec 1> ./exec-test-out.txt

# Will never reach here if choosing point 1.
awk 'BEGIN { srand(); print int(rand()*32768) }'
