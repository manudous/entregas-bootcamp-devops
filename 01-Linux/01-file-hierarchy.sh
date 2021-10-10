#!/bin/bash

if [[ $# -lt 1 ]]; then
  echo "Error: missing argument"
  exit 1
fi

mkdir -p foo/dummy foo/empty && cd foo/dummy
echo $1 > file1.txt
echo '' > file2.txt
