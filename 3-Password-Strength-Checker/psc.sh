#!/usr/bin/env bash




validation(){

	echo "In validation"
	echo "$1"
}



while getopts "f:" opts
do
	case $opts in
		f) file="$OPTARG"
		;;
	esac
done

validation "$file"
