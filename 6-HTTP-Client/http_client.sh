#!/usr/bin/env bash

validate_flag_m(){

	if [[ ! "$1" =~ ^(GET|POST|get|post|Post|Get)$ ]]; then

		echo "Error! $1 method does'nt exits"
		exit 0
	else

		echo "Method: $1"
	fi
}
validate_flag_u(){

	echo "$1"
}

validate_flag_d(){

	echo "$1"
}
main(){

	validate_flag_m "$1"
	validate_flag_u "$2"
	validate_flag_d "$3"

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

if [[ "$m_flag_given" != true ]]; then 

	echo "./http_client.sh: option requires an argument -- m"
fi

if [[ "$u_flag_given" != true ]]; then

	echo "./http_client.sh: option requires an argument -- u"
fi
if [[ "$d_flag_given" != true ]]; then

	echo "./http_client.sh: option requires an argument -- d"
fi

main "$method" "$url" "$data"
