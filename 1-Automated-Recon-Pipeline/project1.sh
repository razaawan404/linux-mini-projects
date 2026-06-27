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

validation(){

	target="$1"
	port="$2"
	op_dir="$3"

	if [[ -z "$target" ]]; then
        echo "input error: -t option missing for target ip"
        exit 1

        else if [[ -z "$port" ]]; then
	echo "input error: -p option missing for port"

	else if [[ -z "$

        if [[ ! "$target" =~ ^((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.){3}(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])$ ]]; then
        echo "ip error: enter valid ip address 255.255.255.0" 
        exit 1


}


while getopts "t:p:o:" opt
do
        case $opt in
                t) target="$OPTARG" ;;
         esac
done

validation "$1" "$2" "$3"

#final_method $target 
