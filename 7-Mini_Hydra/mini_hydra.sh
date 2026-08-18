#!/usr/bin/env bash

user_given=$user_given

url_validation(){

	url="$1"

	if [[ -z "$url" ]]; then

		echo "./mini_http: option requires an argument -- u"
		exit 1

	elif [[ ! "$url" =~ ^https?://[a-zA-Z0-9_.-]+(:[0-9]+)?(/.*)?$ ]]; then

		echo "Error: Invalid url"
		exit 1
	fi

	echo "$url"
}

user_validation(){

	username="$1"

	if [[ -z "$username" ]]; then

		echo "Error: username required"
		exit 1
	fi

	echo "$username"
}

wordlist_validation(){

	word_list="$1"

	if [[ -z "$word_list" ]]; then

		echo "./mini_hydra: option requires an argument -- w"
		exit 1
	fi

	echo "$word_list"
}

main(){

	url_validation "$1"
	user_validation "$2"
	wordlist_validation "$3"
}
while getopts ":u:U:w:" opts
do

	case "$opts" in
		u) url="$OPTARG"
		   u_given=true ;;

	        U) user="$OPTARG"
	           user_given=true ;;

	        w) wordlist="$OPTARG" 
	           w_given=true ;;

	esac
done

main "$url" "$user" "$wordlist"
