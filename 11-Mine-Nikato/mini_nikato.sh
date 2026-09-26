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

	printf "\n=========================================\n\n"
	printf "%7s %s\n" " " "Mine Nikato"
	printf "%7s %-7s : %s\n" " " "Target" "$url"
	printf "%7s %-7s : %s\n" " " "Date" "$_date"
	printf "\n=========================================\n\n"

}
while getopts ":u:" opts;
do
	case "$opts" in 
		u)  url="$OPTARG"
		;;
	esac
done

main "$url"
