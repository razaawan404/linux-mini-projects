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
}
server_info(){

	url="$1"

	echo "[SERVER INFO]"

	header=$(curl -sI "$url" |  grep -Ei 'server|powered-by' | awk -F: '{printf "[+] %-12s : %s\n", $1, $2}')

	echo "$header" 
}
expose_file(){

	url="$1"

	
}
while getopts ":u:" opts;
do
	case "$opts" in 
		u)  url="$OPTARG"
		;;
	esac
done

main "$url"
