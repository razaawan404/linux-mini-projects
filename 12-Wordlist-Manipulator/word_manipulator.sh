#!/usr/bin/env bash

while getopts ":f:p:o:" opts;
do

	case "$opts" in

		f) file="$OPTARG" ;;
		p) ops+=("$OPTARG") ;;
		o) output="$OPTARG" ;;
	esac
done

echo "$file"
echo "${ops[@]}"
echo "$output"
