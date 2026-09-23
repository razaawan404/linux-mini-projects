#!/usr/bin/env bash

while getopts ":u:" opts;
do
	case "$opts" in 
		u)  url="$OPTARG"
		;;
	esac
done

echo "$url"
