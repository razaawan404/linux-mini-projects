#!/usr/bin/env bash

start=time.time()

final_method(){

	end=time.time()
	echo "=== RECON REPORT ==="
	echo "Target	: $1"
	echo "Date	: $(date +"%Y-%m-%d")"
	echo "Duration	: $((end-start))"
}


while getopts "t:p:" opt
do
        case $opt in
                t) target="$OPTARG" ;;
         esac
done

target="$1"

final_method $target 
