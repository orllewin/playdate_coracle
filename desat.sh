#!/bin/bash

find . -name "*.gif" -print0 | while read -d $'\0' file
do
       convert -modulate 100,0,100 "$file" "${file%.*}.gif"
done