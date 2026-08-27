#!/usr/bin/env bash


main(){

	target="$1"
	wlist="$2"

	echo "$target"
	echo "$wlist"
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

