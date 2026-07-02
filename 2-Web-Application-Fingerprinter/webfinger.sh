#!/usr/bin/env bash

while getopts "l:o:" opt
do
    case "$opt" in
        l) urls="$OPTARG" ;;
        o) op_file="$OPTARG" ;;
    esac
done

echo "Urls: ${urls[@]}"
echo "Output file: $op_file"
