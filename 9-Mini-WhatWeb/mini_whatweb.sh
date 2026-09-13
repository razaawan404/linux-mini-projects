#!/usr/bin/env bash


validate_url(){

	url="$1"

	if [[ ! "$url" =~ ^https?://[a-zA-Z0-9.-]+(:[0-9]+)?(/.*)?$ ]]; then

		echo "Invalid Url: Correct Format (http(s)//target.com)"
		return 1
	fi
	echo "in validation"
	echo "$url"
}
main(){

	url="$1"

	if ! v_url=$(validate_url "$url"); then
		echo "$v_url"
	fi	

	echo "$v_url"	
}
while getopts ":u:" opts
do

	case "$opts" in 
		u) url="$OPTARG" ;;
	esac
done

main "$url"
