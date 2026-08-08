#!/usr/bin/env bash

data=""
validate_flag_m(){

	if [[ ! "$1" =~ ^(GET|POST|get|post|Post|Get)$ ]]; then

		echo "Error! $1 method does'nt exits"
		exit 0
	fi
}
validate_flag_u(){

	if [[ ! "$1" =~ ^https?://127.0.0.1 ]]; then

		echo "Error! $1 url is not valid"
		exit 0
	fi
}

validate_flag_d(){

	echo "$1"
}
main(){

	validate_flag_m "$1"
	validate_flag_u "$2"
}
while getopts "m:u:d:" opts
do

	case "$opts" in
		m) method="$OPTARG"
		   m_flag_given=true ;;

		u) url="$OPTARG"
		   u_flag_given=true;;

		d) d="$OPTARG"
		   d_flag_given=true;;
	esac
done

"$data"="$d"
echo "$data"
main "$method" "$url"
