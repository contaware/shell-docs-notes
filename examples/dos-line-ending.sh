#!/bin/sh

echo "Shell interpreter fails when reading a Shebang ending in CRLF..."

# Convert the script to unix line ending:
# tr -d '\r' < dos-line-ending.sh > unix-line-ending.sh
# Note: busybox for Windows works with CRLF line ending. 