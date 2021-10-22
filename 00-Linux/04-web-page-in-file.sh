#!/bin/bash

#File name
FILENAME=englishquiz-response.txt

# Save the web name in a variable
URL=https://englishquiz.fun

# Save the web code in a variable
curl ${URL} -o ${FILENAME} 2>/dev/null

# Look for the word and show Line Number

SEARCHEDWORD="linkMenuFooter"

if [[ "$#" -gt 0 ]]; then
   SEARCHEDWORD=$1
fi

grep -in "linkMenuFooter" < $FILENAME | awk -F: '{print $2" - Line number : "$1}'

# Delete File
rm -r $FILENAME