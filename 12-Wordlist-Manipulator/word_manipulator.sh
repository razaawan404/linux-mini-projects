#!/usr/bin/env bash

OUTPUT_STATUS=0

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

validate_proc(){

	proc="$1"

	if [[ -z "$proc" ]]; then

		echo "./word_manipulator.sh: option requires an argument -- p"
		return 1
	fi

	case "$proc" in

		upper|lower|cap|reverse|leet|dedupe) ;;
		prepend:*|append:*)                  ;;
        	length:*:*)			     ;;
		*)
		 echo "Error: unknown operation proc"
           	 return 1
        ;;

	esac

	echo "$proc" 
}

main(){

	file="$1"
	proc="$2"
	output="$3"

	if ! v_file=$(validate_file "$file"); then

		echo "$v_file"
		return 1
	fi

	if ! v_proc=$(validate_proc "$proc"); then

		echo "$v_proc"
		return 1
	fi


	run "$v_file" "$v_proc"
}
run(){




}
while getopts ":f:p:o:" opts;
do

	case "$opts" in

		f) file="$OPTARG" ;;
		p) proc+=("$OPTARG") ;;
		o) output="$OPTARG" ;;
	esac
done

if [[ ! -z "$o" ]]; then

	OUTPUT_STATUS=1
fi

echo "$OUTPUT_STATUS"
main "$file" "$proc" 
