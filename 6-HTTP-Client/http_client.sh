#!/usr/bin/env bash

validate_flag_m(){

	echo "$1"
}
validate_flag_u(){

	echo "$1"
}

vlidate_flag_d(){

	echo "$1"
}
main(){

	validate_flag_m
	validate_flag_m
	validate_flag_m

}
while getopts "m:u:d:" opts
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
