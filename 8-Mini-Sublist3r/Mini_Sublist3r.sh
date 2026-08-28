#!/usr/bin/env bash


validating_target(){

	target="$1"

	if [[ -z "$target" ]]; then

        	echo "./Mini_Sublist3r.sh: option require an argument -- d"

		return 1

	elif [[ ! "$target" =~ ^([a-zA-Z0-9]+\.){2}[a-zA-Z0-9]+$ ]]; then

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

	if ! validating_target "$target"; then

		echo "$target"
		exit 1

	elif ! validating_wlist "$wlist" ; then

		echo "$wlist"
		exit 1
	fi

	begin "$target" "$wlist"
}
begin(){

	target="$1"
	wlist="$2"

	echo "=============================="
	echo "	Mini Sublist3r"
	echo "	Domain	: $target"
	echo "	Words	: "
	echo "	Date	: "
	printf "==============================\n\n"
	echo "Target: $target"

	while read -r subs
	do
		echo "subs"

	done < "$wlist"
}
while getopts ":d:w:" opts
do

	case "$opts" in 

		d) target="$OPTARG" ;;
		w) wlist="$OPTARG" ;;

	esac
done


main "$target" "$wlist"
