#!/usr/bin/env bash

validation_url(){

	url="$1"

	if [[ -z "$url" ]]; then

		echo "./mini_nikato: option requires an argument -- u"
		return 1

	elif [[ ! "$url" =~ ^https?://[a-zA-Z0-9._-]+(:[0-9]+)?(/.*)?$ ]]; then

		echo "Invalid Url: Correct Format (http(s)//target.com)"
		return 1
	fi

	echo "$url" 
}
main(){

	url="$1"

	if ! v_url=$(validation_url "$url"); then

		echo "$v_url"
		return 1
	fi

	run "$v_url"
}
run(){

	url="$1"

	_date=$(date +"%Y-%m-%d %H-%M")

	printf "\n============================================\n\n"
	printf "%7s %s\n" " " "Mine Nikato"
	printf "%7s %-7s : %s\n" " " "Target" "$url"
	printf "%7s %-7s : %s\n" " " "Date" "$_date"
	printf "\n============================================\n\n"


       echo -e "[*] Starting scan..\n\n"
       server_info "$url"

       expose_file "$url"

       collecting_dngrs_methods "$url"

       miss_config "$url"
}
server_info(){

	url="$1"

	echo "[SERVER INFO]"

	header=$(curl -sI "$url" |  grep -Ei 'server|powered-by' | awk -F: '{printf "[+] %-12s : %s\n", $1, $2}')

	echo "$header" 
}
expose_file(){

	url="$1"

	echo -e "\n\n[EXPOSED FILES]"
	while read -r paths;
	do

		status=$(curl -sI "$url$paths" | grep -Eo '200')

		if [[ "$status" == 200 ]]; then

			if [[ "$paths" =~ \.env ]]; then

				printf "%-7s %-20s → %s sensitive file exposed\n" "[HIGH]" "$paths" "$status"

			elif [[ "$paths" =~ backup\. ]]; then

				printf "%-7s %-20s → %s backup file exposed\n" "[HIGH]" "$paths" "$status"

			elif [[ "$paths" =~ /admin ]]; then

				printf "%-7s %-20s → %s admin panel accessible\n" "[MED]" "$paths" "$status"

			elif [[ "$paths" =~ /php ]]; then

				printf "%-7s %-20s → %s PHP info exposed\n" "[MED]" "$paths" "$status"
			else
				printf "%-7s %-20s → %s found\n" "[LOW]" "$paths" "$status"
			fi
		fi

	done < path_names.txt
}
collecting_dngrs_methods(){

	url="$1"

	echo -e "\n\n[DANGEROUS METHODS]"

	while read -r line;
	do

		put_method=$(curl -sI -X PUT "$url$line" | grep -Eo 200)
		del_method=$(curl -sI -X DELETE "$url$line" | grep -Eo 200)
		post_method=$(curl -sI -X POST "$url$line" | grep -Eo 200)
		get_method=$(curl -sI -X GET "$url$line" | grep -Eo 200)
		trace_method=$(curl -sI -X TRACE "$url$line" | grep -Eo 200)

		if [[ ! -z "$put_method" ]]; then

			printf "[!] %-7s %-20s → %s\n" "[HIGH]" "PUT" "enabled — file upload possible"

		elif [[ ! -z "$del_method" ]]; then

			printf "[!] %-7s %-20s → %s\n" "[HIGH]" "DELETE" "enabled — file deletion possible"

		elif [[ ! -z "$post_method" ]]; then

			printf "[!] %-7s %-20s → %s\n" "[HIGH]" "POST" "enabled — file upload possible"

		elif [[ ! -z "get_method" ]]; then

			printf "[!] %-7s %-20s → %s\n" "[MED]" "GET" "enabled — file upload possible"
		else

			printf "[!] %-7s %-20s → %s\n" "[MED]" "TRACE" "enabled — XST attack possible"

		fi
	done < path_names.txt
}
miss_config(){

	url="$1"
	echo -e "\n\n[MISCONFIGS]"
}
while getopts ":u:" opts;
do
	case "$opts" in 
		u)  url="$OPTARG"
		;;
	esac
done

main "$url"
