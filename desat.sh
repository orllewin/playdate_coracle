#!/bin/bash

find . -name "*.$1" -print0 | while read -d $'\0' file
do
       convert -modulate 100,0,100 "$file" "${file%.*}.$1"
done