#!/usr/bin/env bash


validation(){

	echo "[-] Validtion..."	

	if [[ -f "$1" ]]; then

	echo "$1"

	else

	echo "File Doesnt Exist"
	exit 1
	fi

	while read -r line;
	do
		echo "$line"
	done < "$1"
}



while getopts "f:" opts
do
	case $opts in
		f) file="$OPTARG"
		;;
	esac
done

if [[ -z "$file" ]]; then
exit 1
else
validation "$file"
fi
