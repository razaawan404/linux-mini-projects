#!/usr/bin/env bash


SECONDS=0

final_method(){

	mins=$(( SECONDS / 60 ))
	secs=$(( SECONDS % 60 ))

	echo "=== RECON REPORT ==="
	echo "Target	: $1"
	echo "Date	: $(date +"%Y-%m-%d")"
	echo "Duration	: ${mins}m ${secs}s"
}


while getopts "t:p:o:" opt
do
        case $opt in
                t) target="$OPTARG" ;;
         esac
done

target="$1"
port="$2"
output_dir="$3"

	if [[ -z "$target" ]]; then
	echo "input error: -t option use for ip"
	exit 1
	fi

	if [[ ! "$target" =~ ^((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.){3}(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])$ ]]; then
	echo "ip error: enter valid ip address 255.255.255.0" 
	exit 1
	else
	echo "ip OK"
	fi

echo "$target	$port	$output_dir"
#final_method $target 
