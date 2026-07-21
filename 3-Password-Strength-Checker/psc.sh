#!/usr/bin/env bash


validation(){

	if [[ -f "$1" ]]; then

	echo "$1"

	else

	echo "File Doesnt Exist"
	exit 1
	fi

	read_passwds "$1" "$2"
}
read_passwds(){

	echo  "=============================="
   	echo    "Password Strength Checker"
	echo  "=============================="

	echo "[*] Reading Passwords $2"

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
	point=0

	if [[ "${#1}" -ge 8 && "${#1}" -lt 12 ]]; then
		((point += 1))

	fi

	if [[ "${#1}" -ge 12 ]]; then
		((point += 1))
	fi

	if [[ "$1" =~ [A-Z] ]]; then
		((point += 1))
	fi

	if [[ "$1" =~ [a-z] ]]; then
		((point += 1))

	fi

	if [[ "$1" =~ [0-9] ]]; then
		((point += 1))

	fi

	if [[ "$1" =~ [!@#$%^\&*] ]]; then
		((point += 1))
	fi

	categories "$1" "$point"
}
categories(){

	weak_pass=()
        med_pass=()
        strong_pass=()
        point=0


}

while getopts "f:" opts
do
	case $opts in
		f) file="$OPTARG"
		   filename="$OPTARG"
		;;
	esac
done

if [[ -z "$file" ]]; then
exit 1
else
validation "$file" "$filename"
fi
