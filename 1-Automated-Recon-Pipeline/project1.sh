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
	fi

	if [[ "$4" = true ]]; then

		if [[ -z "$port" ]]; then
		echo "[!] input error: -p option missing for port"
		exit 1
		fi

		if [[ ! "$port" =~ ^-?[0-9]+$ ]]; then
		echo "[!] input error: only integers are allowed for port!"
		exit 1
		fi

		if [[ "$port" -lt 1 || "$port" -gt 65535 ]]; then 
		echo "[!] range error: valid input range is (1 - 65535)"
		exit 1
		fi
	fi

	if [[ "$6" = true ]]; then

		if [[ -z "$5" ]]; then
		echo "[!] input error: -o option missing for port"
		exit 1
		fi

		if [[ "$5" == "*/*" ]]; then
		echo "[!] No path allowed! only current directory files"
		exit 1
		fi

		touch "$5"
	fi

	dns_method "$1"
	open_port "$1"
	banners "$1"
}

dns_method(){

	echo -e "\n"
	echo "[DNS]"
	dig "$1" | awk 'NR==12'
}
open_port(){

	echo -e "\n"
	echo "[OPEN PORTS]"
	nmap "$1" 2>/dev/null | grep -E -i 'open' | awk -F/ '{print $1}'
}
banners(){

	echo -e "\n"
	echo "[SERVICE BANNERS]"
	nmap "$1" 2>/dev/null | grep -E -i 'open' | awk '{print $3}'
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


validation "$target" "$target_given" "$port" "$port_given" "$op_dir" "$op_dir_given"

#final_method $target 
