#!/usr/bin/env bash

validate_file(){

	file="$1"

	if [[ -z "$file" ]]; then

		echo "./word_manipulator.sh: option requires an argument -- f"
		return 1
	fi

	echo "$file"
}

validate_ops(){

	ops="$1"

}

validate_output(){

	output="$1"
}
main(){

	file="$1"
	ops="$2"
	output="$3"

	if ! validate_file "$file";

		 

}
while getopts ":f:p:o:" opts;
do

	case "$opts" in

		f) file="$OPTARG" ;;
		p) ops+=("$OPTARG") ;;
		o) output="$OPTARG" ;;
	esac
done

main "$file" "$ops" "$output"
