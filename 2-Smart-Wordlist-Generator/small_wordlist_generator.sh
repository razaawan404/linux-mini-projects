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
		else
			echo "[+] $2"
		fi
	fi

	echo "$p_url"
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
		esac
done

validation "$t_given" "$target" "$o_given" "$output_file" "$b_given" "$base"
 

