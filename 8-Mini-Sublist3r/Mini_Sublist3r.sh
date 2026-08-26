#!/usr/bin/env bash

while getopts ":d:w:" opts
do

	case "$opts" in 

		d) target="$OPTARG" ;;
		w) wlist="$OPTARG" ;;

	esac
done

echo "$target"
echo "$wlist"


