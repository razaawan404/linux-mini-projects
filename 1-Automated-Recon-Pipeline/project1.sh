#!/usr/bin/env bash


SECONDS=0


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

	op_method "$1"
}

op_method(){

	dns=$(dig "$1" | awk 'NR==12')

	ports=$(nmap "$1" 2>/dev/null | grep -E -i 'open' | awk -F/ '{print $1}')
	
	servs=$(nmap "$1" 2>/dev/null | grep -E -i 'open' | awk '{print $3}')


	flags "$1" "$dns" "$ports" "$servs"

}
flags(){

	mins=$(( SECONDS / 60 ))
        secs=$(( SECONDS % 60 ))

	

 	echo "=== RECON REPORT ==="
	printf "%-10s : %s\n" "Target" "$(whois "$1" | grep -i netname | awk -F: '{ gsub(/[ ]/, "", $2); print $2}')"
	echo "Date      : $(date +"%Y-%m-%d")"
        echo "Duration  : ${mins}m ${secs}s"

	echo -e "\n"
	echo "[DNS]"
	echo "$2"

	echo -e "\n"
	echo "[OPEN PORTS]"
	echo "$3"

	echo -e "\n"
	echo "[SERVICES]"
	echo "$4"

	echo -e "\n"
	echo "[FLAGS]"
	if [[ "$3" = *21* ]]; then echo "[HIGH] Port 21 open - test anonymous FTP"
	elif [[ "$3" = *3306* ]]; then echo "[HIGH] Port 3306 open - flag exposed mysql"
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


validation "$target" "$target_given" "$port" "$port_given" "$op_dir" "$op_dir_given"

#final_method $target 
