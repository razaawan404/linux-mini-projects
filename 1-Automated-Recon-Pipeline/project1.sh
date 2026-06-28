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
	port="$3"
	op_dir="$5"

	if [[ "$2" = true ]]; then

		if [[ -z "$target" ]]; then
        	echo "[!] input error: -t option missing for target ip"
        	exit 1
		fi

		if [[ ! "$target" =~ ^((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.){3}(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])$ ]]; then
	        echo "[!] ip error: enter valid ip address 255.255.255.0" 
        	exit 1
		fi
	else
		echo "[!] input error: you did'nt pass -t option value"
		exit
	fi

	if [[ "$4" = true ]]; then

		if [[ -z "$port" ]]; then
		echo "[!] input error: -p option missing for port"
		exit 1
		fi

		if [[ ! "$port" =~ ^[0-9]+$ ]]; then
		echo "[!] input error: only integers are allowed for port!"
		exit 1
		fi

		if [[ "$port" -lt 1 || "$port" -gt 65535 ]]; then 
		echo "[!] range error: valid input range is (1 - 65535)"
		exit 1
		fi
	else
		echo "[!] input error: you did'nt pass -p option value"
		exit 1
	fi
}


while getopts "t:p:o:" opt
do
        case $opt in
                t) 
		target="$OPTARG"
		target_given=true ;;
		
		p)
		port="$OPTARG"
		port_given=true ;;

		o)
		op_dir="$OPTARG"
		op_dir_given=true ;;
         esac
done

echo "$target_given"	
validation "$target" "$target_given" "$port" "$port_given" "$op_dir" "$op_dir_given"

#final_method $target 
