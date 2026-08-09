#!/usr/bin/env bash

v_dta=""
v_url=""
v_mtd=""

validate_flag_m(){

	if [[ ! "$1" =~ ^(GET|POST|get|post|Post|Get)$ ]]; then

		echo "Error! $1 method does'nt exits"
		exit 0
	fi

	echo "$1"
}
validate_flag_u(){

	if [[ ! "$1" =~ ^https?://127.0.0.1 ]]; then

		echo "Error! $1 url is not valid"
		exit 0
	fi

	echo "$1"
}
validate_flag_d(){

	if [[ ! "$1" =~ '^user=[a-zA-Z0-9]+&pass=[a-zA-Z0-9]+$' ]]; then 

		echo "Error! $1 invalid data, no user or pass added"
		exit 0

	fi

	echo "$1"
}
main(){

	v_mtd=$(validate_flag_m "$method")
	v_url=$(validate_flag_u "$url")
	v_dta=$(validate_flag_d "$data")

	echo "$v_mtd"
	echo "$v_url"
	echo "$v_dta"
}
while getopts ":m:u:d:" opts
do

	case "$opts" in
		m) method="$OPTARG"
		   m_flag_given=true ;;

		u) url="$OPTARG"
		   u_flag_given=true;;

		d) data="$OPTARG"
		   d_flag_given=true;;
	esac
done

if [[ -z "$method" ]]; then

	echo "./http_client: option requires an argument -- m"
	exit 0
fi

if [[ -z "$url" ]]; then

	echo "./http_client: option requires an argument -- u"
	exit 0
fi

if [[ -z "$data" ]]; then

	echo "./http_client: option requires an argument -- d"
	exit 0
fi
main
