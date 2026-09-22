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

	start_time=$(date +%s%N)

	apache_extracting_data "$file"
	uniq_ips=$(cat "$file" | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | sort | uniq | wc -l)

	end_time=$(date +%s%N)

	elapsed=$(( end_time - start_time ))
#	in_sec=$(awk "BEGIN {printf \"%.2f\", $elapsed / 1000000000}")
	in_sec=$(awk "BEGIN {printf \"%.2f\", $elapsed / 1000000000}")

	printf "\n====================================\n"
	printf "[*] %-12s : %s\n" "Total lines" "$lines"
	printf "[*] %-12s : %s\n" "Unique Ips" "$uniq_ips"
	printf "[*] %-12s : %ss\n" "Time" "$in_sec"
	printf "====================================\n"

}
apache_extracting_data(){

	file="$1"

	#extracting ips

	echo "[TOP 5 IPs]"
	ips=$(cat "$file" | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]' | sort | uniq -c)
	echo "$ips" | sort -n -r | awk '{printf "%1s %-7s %s\n", " ", $1, $2}' | head -n 5

	if [[ -z "$ips" ]]; then

		echo "[!] NO DATA FOUND"
	fi

	#extracting status

	echo -e "\n\n[STATUS CODES]"
	status_codes=$(cat "$file" | grep -Eo '(200|201|204|301|302|304|400|401|403|404|405|429|500|502|503|504)' | sort | uniq -c)
	echo "$status_codes" | sort -n -r | awk '{printf "%1s %-7s %s\n", " ", $1, $2}'

	if [[ -z "$status_codes" ]]; then

		echo "[!] NO DATA FOUND"
	fi

	#extracting endpoints

	echo -e "\n\n[TOP 5 ENDPOINTS]"
	endpoints=$(cat "$file" | grep -Eo '(GET|POST|PUT|DELETE|PATCH|HEAD|OPTIONS) /[^ ]+' | awk '{print $2}' | sort -n | uniq -c)

	echo "$endpoints" | sort -n -r | awk '{printf "%1s %-7s %s\n", " ", $1, $2}' | head -n 5

	if [[ -z "$endpoints" ]]; then

		echo "[!] NO DATA FOUND"
	fi

	#extracting suspicious activities

	echo -e "\n\n[SUSPICIOUS ACTIVITY]"
	apache_activites "$file" "$ips"
}
apache_activites(){

	file="$1"
	all_ips="$2"

	#Most repeated ip for all time

	top_ip=$(echo "$all_ips" | sort -n -r | awk '{print $2}'| head -n 1)
	top_ip_count=$(echo "$all_ips" | sort -n -r | awk '{print $1}' | head -n 1)
	printf "[!] %-15s → %s\n" "$top_ip" "$top_ip_count requests — possible scanner" 

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

	printf "[!] %-15s → %s\n" "$most_repeated_ip" "$count requests to /admin — brute force suspected"


	#Accessed count of ./env

	env_count=$(cat "$file" | grep -Ec '/\.env')
	printf "[!] %-15s → %s\n" "/.env" "accessed $env_count times — sensitive file probe"

	#Accessed count of /wp-admin

	wp_count=$(cat "$file" | grep -Ec '/wp-admin')
	printf "[!] %-15s → %s\n" "/wp-admin" "accessed $wp_count times — times — WordPress attack"

}
run_ssh(){

	file="$1"
        type="$2"

        lines=$(wc -l "$file" | awk '{print $1}')
        _date=$(date +"%Y-%m-%d %H:%M")

	printf "==================================\n"
        printf "%2s %-10s : %s\n" " " "File"  "$file"
        printf "%2s %-10s : %s\n" " " "Type"  "$type"
        printf "%2s %-10s : %s\n" " " "Lines" "$lines"
        printf "%2s %-10s : %s\n" " " "Date"  "$_date"
        printf "==================================\n\n"

	start_time=$(date +%s%N)

	ssh_extractions "$1"

	end_time=$(date +%s%N)

        elapsed=$(( end_time - start_time ))
        in_sec=$(awk "BEGIN {printf \"%.2f\", $elapsed / 1000000000}")

        printf "\n====================================\n"
        printf "[*] %-12s : %s\n" "Total lines" "$lines"
        printf "[*] %-12s : %s\n" "Unique Ips" "$uniq_ips"
        printf "[*] %-12s : %ss\n" "Time" "$in_sec"
        printf "====================================\n"

}
ssh_extractions(){

	file="$1"

	#failed login for every user
	echo -e "\n[FAILED LOGINS]"
	account=$(cat "$file" | grep -Eio 'failed.*root|failed.*admin|failed.*user|failed.*ubuntu' | sort | uniq -c | awk '{printf "%-7s %s\n", $1, $5}' | sort -nr)
	echo "$account"

	#most repeated ip
	echo -e "\n[TOP ATTACKER IPs]"
	most_rep_ips=$(cat "$file" | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | sort -n | uniq -c | sort -nr | head -n 3 | awk '{printf "%-7s %s\n", $1, $2}')
	echo "$most_rep_ips"

	#successful login
	echo -e "\n[SUCCESSFUL LOGINS]"
	success_data=$(grep -Eoi 'accepted.*(password|publickey|login).*(user|root|ubuntu|guest|admin).*[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' "$file" | 
		       awk '{printf "[+] user: %-6s %s %s\n", $4, $5, $6}' |
		       awk '!seen[$3]++')

	if [[ ! -z "$success_data" ]]; then

		 echo "$success_data"
	else
		 echo "[!] user: [NO DATA FOUND]"
	fi

	#failed attempts
	echo -e "\nSUSPICIOUS ACTIVITY]"

	sus_ips=$(grep -Eio 'failed.*[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' "$file" |
        sort | uniq -c | sort -n -r | head -n 1 |
	awk '{printf "[!] %-7s → %s %s\n", $NF, $1, " failed attempts — targeted attack"}')
	echo "$sus_ips"

}
while getopts ":f:t:" opts
do

	case "$opts" in

		f) log_file="$OPTARG" ;;
		t) type="$OPTARG" ;;
	esac
done

main "$log_file" "$type"
