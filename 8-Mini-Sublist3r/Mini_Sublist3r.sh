#!/usr/bin/env bash


validating_target(){

	target="$1"

	if [[ ! "$target" =~ ^([a-zA-Z0-9]+\.){2}[a-zA-Z0-9]+$ ]]; then

		return 1
	fi

	return 0
}
main(){

	target="$1"
	wlist="$2"

	if ! validating_target "$target"; then

		exit 1
	fi

	echo "$target"
}
while getopts ":d:w:" opts
do

	case "$opts" in 

		d) target="$OPTARG" ;;
		w) wlist="$OPTARG" ;;

	esac
done

if [[ -z "$target" ]]; then

	echo "./Mini_Sublist3r.sh: option require an argument -- d"

elif [[ -z "$wlist" ]]; then

	echo "./Mini_Sublist3r.sh: option require an argument -- w"
else

	main "$target" "$wlist"
fi

