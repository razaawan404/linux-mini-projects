#!/usr/bin/env bash

validate_file(){

}

validate_ops(){


}

validate_output(){


}
main(){

	file="$1"
	ops="$2"
	output="$3"



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
