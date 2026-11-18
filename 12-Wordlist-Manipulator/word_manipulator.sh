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
	local raw_proc=("$@")
	local expanded_proc=()

	if [[ ${#raw_proc[@]} -eq 0 || -z "${raw_proc}" ]]; then
		echo "./word_manipulator.sh: option requires an argument -- p"
		return 1
	fi

	# Split any comma-separated items into individual elements
	for raw_item in "${raw_proc[@]}"; do
		IFS=',' read -ra split_items <<< "$raw_item"
		for item in "${split_items[@]}"; do
			# Catch trailing/double commas like "lower,,upper"
			if [[ -z "$item" ]]; then
				echo "Error: empty operation in -p"
				return 1
			fi
			expanded_proc+=("$item")
		done
	done

	# Validate every individual operation
	for item in "${expanded_proc[@]}"; do
		case "$item" in
			upper|lower|cap|reverse|leet|dedupe) ;;
			prepend:*|append:*)                  ;;
			length:*:*)                          ;;
			*)
				echo "Error: unknown operation proc: $item"
				return 1
				;;
		esac
	done

	# Print each validated operation on its own line
	printf -v ops_str "%s," "${expanded_proc[@]}"
	echo "${ops_str%,}"
}

validate_output(){

	local output="$1"

	if [[ -z "$output" ]]; then

		echo "./word_manipulator.sh: option requires an argument -- o"
		return 1
	fi

}
main(){
	local file="$1"
	local output="$2"
	shift 2
	local proc=("$@")

	if ! v_file=$(validate_file "$file"); then
		echo "$v_file"
		return 1
	fi

	# Fix 1: Pass the full array using "${proc[@]}"
	if ! v_proc=$(validate_proc "${proc[@]}"); then
		echo "$v_proc"
		return 1
	fi

	# Fix 2: Set OUTPUT_STATUS without exiting early if output is optional
	if v_o=$(validate_output "$output"); then
		OUTPUT_STATUS=1
	else
		OUTPUT_STATUS=0
		echo "$v_o"
		return 1
	fi

	echo "Output status: $OUTPUT_STATUS"
	if [[ "$OUTPUT_STATUS" -eq 1 ]]; then
		run "$v_file" "$v_proc" "$v_o"
	else
		# Fix 3: Corrected typo from $v_proce to $v_proc
		run "$v_file" "$v_proc" "No Output"
	fi
}

run(){

	file="$1"
	proc="$2"
	output="$3"

	count=$(wc -l "$file" | awk '{print $1}')

	printf "\n=================================\n"
	printf "%5s %-10s\n" " " "Wordlist Manipulator"
	printf "%5s %-10s : %s\n" " " "File" "$file"
	printf "%5s %-10s : %s\n" " " "Output" "$output"
	printf "%5s %-10s : %s\n" " " "Ops" "${proc[@]}"
	printf "%5s %-10s : %s\n" " " "Words" "$count"
	printf "%5s %-10s : %s\n" " " "Date" "NAN"
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

main "$file" "$output" "${proc[@]}"
