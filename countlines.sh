#!/usr/bin/env bash

nixfiles=$(find "$(pwd)" -type f -name "*.nix")
counter=0
count2=0

for file in $nixfiles; do
    lines=$(wc -l $file | cut -d' ' -f1)
    filepretty=$(echo "$file" | sed "s|$(pwd)||g")
    echo "$filepretty = $lines lines of nix code"
    counter=$(( $counter + $lines ))
    count2=$(( $count2 + 1))
done
echo ""
echo "total lines: $counter across $count2 files"
