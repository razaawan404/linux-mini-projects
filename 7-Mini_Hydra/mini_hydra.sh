#!/usr/bin/env bash


url_validation(){

	echo "$1"
}

user_validation(){

	echo "$1"
}

wordlist_validation(){

	echo "$1"
}

main(){

	url_validation "$1"
	user_validation "$2"
	wordlist_validation "$3"
}
while getopts "u:U:w:" opts
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
