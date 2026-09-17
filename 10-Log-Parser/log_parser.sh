#!/usr/bin/env bash

validate_file(){

	file="$1"

	if [[ ! -f "$file" ]]; then

		echo "File not exist"
		return 1
	fi

	echo "$file"
}

validate_type(){

	type="$1"

	if [[ ! "${type,,}" == @(apache|nginx|ssh) ]]; then

		echo "Error: type not found"
		return 1
	fi

	echo "$type" 
}
main(){

	file="$1"
	type="$2"

	if ! v_file=$(validate_file "$file"); then

		echo "$v_file"
		exit 1

	elif ! v_type=$(validate_type "$type"); then

		echo "$v_type"
		exit 1
	fi

	echo "$v_file"
	echo "$v_type" 

}
while getopts ":f:t:" opts
do

	case "$opts" in

		f) log_file="$OPTARG" ;;
		t) type="$OPTARG" ;;
	esac
done

main "$log_file" "$type"
