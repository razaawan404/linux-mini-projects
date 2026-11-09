#!/usr/bin/env bash

validate_file(){

	file="$1"

	if [[ -z "$file" ]]; then

		echo "./word_manipulator.sh: option requires an argument -- f"
		return 1

	elif [[ ! -f "$file" ]]; then

		echo "Error! File not exist"
		return 1
	fi

	echo "$file"
}

validate_ops(){

	ops="$1"

	if [[ -z "$ops" ]]; then

		echo "./word_manipulator.sh: option requires an argument -- ops or o p s"
		return 1
	fi

	case "$ops" in

		upper|lower|cap|reverse|leet|dedupe) ;;
		prepend:*|append:*)                  ;;
        	length:*:*)			     ;;
		*)
		 echo "Error: unknown operation '$op'"
           	 return 1
        ;;

	esac

	echo "$ops" 
}

validate_output(){

	output="$1"

	
}
main(){

	file="$1"
	ops="$2"
	output="$3"

	if ! v_file=$(validate_file "$file"); then

		echo "$v_file"
		return 1
	fi

	if ! v_ops=$(validate_ops "$ops"); then

		echo "$v_ops"
		return 1
	fi

}
while getopts ":f:p:o:" opts;
do

	case "$opts" in

		f) file="$OPTARG" ;;
		p) proc+=("$OPTARG") ;;
		o) output="$OPTARG" ;;
	esac
done

echo "${proc[@]}"
#main "$file" "$proc" "$output"
