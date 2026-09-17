#!/usr/bin/env bash

validate_file(){


}

validate_type(){


}
main(){

	file="$1"
	type="$2"

	if ! v_file=$(validate_file "$file"); then

		echo "v_file"
		exit 1

	elif ! v_type=$(validate_type "$type"); then

		echo "v_type"
		exit 1
	fi

	echo "$v_file"
	echo "$t_file" 

}
while getopts ":f:t:" opts
do

	case "$opts" in

		f) log_file="$OPTARG" ;;
		t) type="$OPTARG" ;;
	esac
done

main "$log_file" "$type"
