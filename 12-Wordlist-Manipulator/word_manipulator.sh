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
validate_output(){

	output="$1"

	if [[ -z "$output" ]]; then

		echo "./word_manipulator.sh: option requires an argument -- o"
		return 1
	else

		$OUTPUT_STATUS=1
	fi
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

	if ! v_o=$(validate_output "$output"); then

		echo "$v_o"
		return 1
	fi

	if [[ "$OUTPUT_STATUS" -eq 1 ]]; then

		run "$v_file" "$v_proc" "v_o"
	else
		run "$v_file" "$v_proce" "No Output"
	fi
}
run(){

	file="$1"
	proc="$2"
	output="$3"

	printf "\n=================================\n"
	printf "%5s %-10s\n" " " "Wordlist Manipulator"
	printf "%5s %-10s : %s\n" " " "File" "$file"
	printf "%5s %-10s : %s\n" " " "Output" "$output"
	printf "%5s %-10s :\n" " " "Ops" "$proc"
	printf "%5s %-10s :\n" " " "Words"
	printf "%5s %-10s :\n" " " "Date"
	printf "\n=================================\n"

	
}
while getopts ":f:p:o:" opts;
do

	case "$opts" in

		f) file="$OPTARG" ;;
		p) proc+=("$OPTARG") ;;
		o) output="$OPTARG" ;;
	esac
done

main "$file" "$proc" "$proc"
