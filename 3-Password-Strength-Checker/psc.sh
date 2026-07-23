#!/usr/bin/env bash


weak_pass=()
med_pass=()
strong_pass=()

validation(){

	echo  "==============================="
        echo  "   Password Strength Checker"
        echo  "==============================="
        echo -e "\n"

	if [[ -f "$1" ]]; then

	read_passwds "$1" "$2"
	show_cat
	summary

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

	if [[ "$2" -ge 0 && "$2" -le 2 ]]; then

		printf '%-15s -> [WEAK]\n' "$1"
		weak_pass+=("$1")

	elif [[ "$2" -ge 3 && "$2" -le 4 ]]; then

		printf '%-15s -> [MEDIUM]\n' "$1"
		med_pass+=("$1")

	elif [[ "$2" -ge 5 && "$2" -le 6 ]]; then

		printf '%-15s -> [STRONG]\n' "$1"
		strong_pass+=("$1")
	fi

}

show_cat()
{
	echo -e "\n======================================="

	echo "[WEAK]"
	for pass in "${weak_pass[@]}"
	do
		echo "	- $pass"
	done

	echo -e "\n"

	echo "[MEDIUM]"
	for pass in "${med_pass[@]}"
	do
		echo "	- $pass"
	done

	echo -e "\n"

	echo "[STRONG]"
	for pass in "${strong_pass[@]}"
	do
		echo "	- $pass"
	done
}
summary(){

	echo -e "\n==============================================="
	echo 	"	Summary"
	echo 	"==============================================="

	echo "Weak	: ${#weak_pass[@]}"
	echo "Medium	: ${#med_pass[@]}"
	echo "Strong	: ${#strong_pass[@]}"

	total=$(("${#weak_pass[@]}" + "${#med_pass[@]}" + "${#strong_pass[@]}"))

	echo "Total	: $total"

	echo -e "\n[*] Done...."
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
