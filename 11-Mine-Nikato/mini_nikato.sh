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

	if ! validation_url "$url"; then

		echo "$url"
	fi

	echo "$url"
}
while getopts ":u:" opts;
do
	case "$opts" in 
		u)  url="$OPTARG"
		;;
	esac
done

main "$url"
