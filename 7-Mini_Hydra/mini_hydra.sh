#!/usr/bin/env bash


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

echo "$url $user $wordlist"
