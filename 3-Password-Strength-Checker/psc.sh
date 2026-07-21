#!/usr/bin/env bash


validation(){

	echo  "==============================="
        echo  "   Password Strength Checker"
        echo  "==============================="
        echo -e "\n"

	if [[ -f "$1" ]]; then

	read_passwds "$1" "$2"

	else

	echo "File Doesnt Exist"
	exit 1
	fi
}
read_passwds(){

	echo "[*] Reading Passwords $2..."
	echo "[*] $(wc -l $2 | awk '{print $1}') passwords found"
	echo -e "\nChecking passwords...\n"
	sleep 3

	while read -r line;
	do
		strength_rules "$line"
	done < "$1"
}
strength_rules(){

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

	passes=()
	weak_pass=()
	med_pass=()
	strong_pass=()

	if [[ "$2" -ge 0 && "$2" -le 2 ]]; then

		formatted=$(printf '%-15s -> [WEAK]' "$1")
		passes+=("$formatted")

	elif [[ "$2" -ge 3 && "$2" -le 4 ]]; then

		formatted=$(printf '%-15s -> [MEDIUM]' "$1")
                passes+=("$formatted")

	elif [[ "$2" -ge 5 && "$2" -le 6 ]]; then

		formatted=$(printf '%-15s -> [STRONG]' "$1")
                passes+=("$formatted")
	fi

	for pass in "${passes}"
	do
		echo "$pass"
	done
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
