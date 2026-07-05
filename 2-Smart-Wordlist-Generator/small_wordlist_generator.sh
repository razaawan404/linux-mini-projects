#!/usr/bin/env bash


#inputs(){

	while getopts "t:o:w" opt
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

	echo -e "Target: $target $t_given\nOutput file: $output_file $o_given\nBase: $base $b_given" 
#}

#inputs
