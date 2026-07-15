#!/usr/bin/env bash

validation(){

	p_url="$2"

        if [[ "$1" = true ]]; then
		if [[ -z "$2" ]]; then
			echo "[!] Error! missing -t option value"
		else
			if [[ ! "$2" =~ ^https?:// ]]; then
				p_url="http://$2"
			fi
		fi
	fi
	if [[ "$3" = true ]]; then
		if [[ -z "$4" ]]; then
			echo "[!] Error! missing -o option value"
		fi
	fi

	extraction "$p_url"
}

extraction(){

	output=$(curl -s "$1" |  sed -E '/<style>/,/<\/style>/d; /<script>/,/<\/script>/d; s/<[a-zA-Z0-9 -="]+>//g; s/<\/[a-zA-Z0-9]+>//g')

	echo "${output,,}" | sort | uniq


}

while getopts "t:o:w:" opt
do
		case "$opt" in
			t) target="$OPTARG" 
			   t_given=true ;;

			o) output_file="$OPTARG" 
			   o_given=true	;;

			w) base="$OPTARG"
			   b_given=true ;;

		       \?) echo "Unknown option: -$OPTARG"
			   exit 1 ;;
		esac
done

validation "$t_given" "$target" "$o_given" "$output_file" "$b_given" "$base"
 

