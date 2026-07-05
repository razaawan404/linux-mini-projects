#!/usr/bin/env bash


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

validation(){

	if [[ "$1" = true ]]; then
} 

