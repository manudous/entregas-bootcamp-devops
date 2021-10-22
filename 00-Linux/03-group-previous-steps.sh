#!/bin/bash

MYTEXT="Que me gusta la bash!!!"

if [[ "$#" -gt 0 ]]; then
  MYTEXT=$1
fi

./01-file-hierarchy.sh "$MYTEXT"
./02-move-content.sh