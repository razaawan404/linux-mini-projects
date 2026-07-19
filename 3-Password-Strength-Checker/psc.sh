#!/usr/bin/env bash


validation(){

	if [[ -f "$1" ]]; then

	echo "$1"

	else

	echo "File Doesnt Exist"
	exit 1
	fi

	read_passwds "$1"
}
read_passwds(){

	count=0
	echo "[*] Reading Passwords"

	while read -r line;
	do
		((count++))
		strength_rules "$line"
		printf "%s %-3s : %s\n" "[*]" "$count" "$line"
	done < "$1"
}
strength_rules(){

	weak_pass=()
	med_pass=()
        strong_pass=()
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
