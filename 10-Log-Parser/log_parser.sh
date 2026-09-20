#!/usr/bin/env bash

validate_file(){

	file="$1"

	if [[ -z "$file" ]]; then

		echo "./log_parser.sh: option requires an argument -- f"
		return 1

	elif [[ ! -f "$file" ]]; then

		echo "File not exist"
		return 1
	fi

	echo "$file"
}

validate_type(){

	type="$1"

	if [[ -z "$type" ]]; then

		echo "./log_parser.sh: option requires an argument -- t"
		return 1

	elif [[ ! "${type,,}" == @(apache|nginx|ssh) ]]; then

		echo "Error: type not found"
		return 1
	fi

	echo "$type"
}
main(){

	file="$1"
	type="$2"

	if ! v_file=$(validate_file "$file"); then

		echo "$v_file"
		exit 1

	elif ! v_type=$(validate_type "$type"); then

		echo "$v_type"
		exit 1
	fi

	#run "$v_file" "$v_type"

	if [[ "${v_type,,}" =~ apache|nginx ]]; then

                run_apache "$v_file" "$v_type"

        elif [[ "${v_type,,}" == "ssh" ]]; then

                run_ssh "$v_file" "$v_type"

	fi
}
run_apache(){

	file="$1"
	type="$2"

	lines=$(wc -l "$file" | awk '{print $1}')
	_date=$(date +"%Y-%m-%d %H:%M")

	printf "==================================\n"
	printf "%2s %-10s : %s\n" " " "File" "$file"
	printf "%2s %-10s : %s\n" " " "Type" "$type"
	printf "%2s %-10s : %s\n" " " "Lines" "$lines"
	printf "%2s %-10s : %s\n" " " "Date"  "$_date"
	printf "==================================\n\n"


	extracting_data "$file"
}
extracting_data(){

	file="$1"

	#extracting ips

	echo "[TOP 5 IPs]"
	ips=$(cat "$file" | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]' | sort | uniq -c)
	echo "$ips" | sort -n -r | awk '{printf "%1s %-7s %s\n", " ", $1, $2}' | head -n 5

	#extracting status

	echo -e "\n\n[STATUS CODES]"
	status_codes=$(cat "$file" | grep -Eo '(200|201|204|301|302|304|400|401|403|404|405|429|500|502|503|504)' | sort | uniq -c)
	echo "$status_codes" | sort -n -r | awk '{printf "%1s %-7s %s\n", " ", $1, $2}'

	#extracting endpoints

	echo -e "\n\n[TOP 5 ENDPOINTS]"
	endpoints=$(cat "$file" | grep -Eo '(GET|POST|PUT|DELETE|PATCH|HEAD|OPTIONS) /[^ ]+' | awk '{print $2}' | sort -n | uniq -c)

	echo "$endpoints" | sort -n -r | awk '{printf "%1s %-7s %s\n", " ", $1, $2}' | head -n 5

	#extracting suspicious activities

	echo -e "\n\n[SUSPICIOUS ACTIVITY]"
	activites "$file"
}
activites(){

	file="$1"

	#Most repeated ip for all time

	

	#Most repeated ips for /admin endpoints
	ips=()

	while read -r line;
	do

		if [[ "$line" == *"/admin"* ]]; then


			ip=$(echo "$line" | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+[0-9]+')
			ips+=("$ip")
		fi
	done < "$file"


	most_repeated_ip=$(printf '%s\n' "${ips[@]}" | sort | uniq -c | awk '{print $1, $2}' | sort -n -r | head -n 1)
	count=$(echo "$most_repeated_ip" | awk '{print $1}')

	printf "[!] %-10s → %s\n" "$most_repeated_ip" "$count requests to /admin — brute force suspected"

}
run_ssh(){

	file="$1"
        type="$2"

        lines=$(wc -l "$file" | awk '{print $1}')
        _date=$(date +"%Y-%m-%d %H:%M")

	printf "==================================\n"
        printf "%2s %-10s : %s\n" " " "File" "$file"
        printf "%2s %-10s : %s\n" " " "Type" "$type"
        printf "%2s %-10s : %s\n" " " "Lines" "$lines"
        printf "%2s %-10s : %s\n" " " "Date"  "$_date"
        printf "==================================\n\n"
}
while getopts ":f:t:" opts
do

	case "$opts" in

		f) log_file="$OPTARG" ;;
		t) type="$OPTARG" ;;
	esac
done

main "$log_file" "$type"
