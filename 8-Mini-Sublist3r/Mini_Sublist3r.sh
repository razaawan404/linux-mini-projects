#!/usr/bin/env bash


validating_target(){

	target="$1"

	if [[ -z "$target" ]]; then

        	echo "./Mini_Sublist3r.sh: option require an argument -- d"

		return 1

	elif [[ ! "$target" =~ ^([a-zA-Z0-9]+\.){2}[a-zA-Z0-9]+$ ]]; then

		echo "Error: invalid url"
		return 1
	fi

	echo "$target"
}
validating_wlist(){

	wlist="$1"

	if [[ -z "$wlist" ]]; then

        	echo "./Mini_Sublist3r.sh: option require an argument -- w"

		return 1

	elif [[ ! -f "$wlist" ]]; then

		echo "File does'nt exist"
		return 1
	fi

	echo "$wlist"
}
main(){

	target="$1"
	wlist="$2"

	if ! target=$(validating_target "$target"); then

		echo "$target"
		exit 1

	elif ! wlist=$(validating_wlist "$wlist") ; then

		echo "$wlist"
		exit 1
	fi

	begin "$target" "$wlist"
}
begin(){

	target="$1"
	wlist="$2"

	domain=$(echo "$target" | awk -F. '{for (i = 2; i <= NF; i++) { if (i != NF) printf $i "."; else printf $i}}')
	wrd_cnt=$(wc -l "$wlist" | awk '{print $1}')
	_date=$(date "+%Y-%m-%d %H:%M")

	echo "========================================="
	echo "	Mini Sublist3r"
	echo "	Domain	: $domain"
	echo "	Words	: $wrd_cnt"
	echo "	Date	: $_date"
	printf "======================================\n\n"

	while read -r subs
	do
		echo "[-] Trying: $subs.$domain"

	done < "$wlist"

	final_report
}
final_report(){

	found=""
	tsted=""
	_time=""

	printf "\n======================================\n"
	printf "[*] %-10s : %s\n" "Found"  "$found"
	printf "[*] %-10s : %s\n" "Tested" "$tsted"
	printf "[*] %-10s : %s\n" "Time"   "$_time"
}
while getopts ":d:w:" opts
do

	case "$opts" in 

		d) target="$OPTARG" ;;
		w) wlist="$OPTARG" ;;

	esac
done


main "$target" "$wlist"
