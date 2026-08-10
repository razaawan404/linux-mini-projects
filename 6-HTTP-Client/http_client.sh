#!/usr/bin/env bash

v_dta=""
v_url=""
v_mtd=""

validate_flag_m(){

	if [[ ! "$1" =~ ^(GET|POST|get|post|Post|Get)$ ]]; then

		echo "Error! $1 method does'nt exits" >&2
		return 1
	fi

	echo "$1"
}
validate_flag_u(){

	if [[ ! "$1" =~ ^https?://127\.0\.0\.1:[0-9]+(/.*)?$ ]]; then

		echo "Error! $1 url is not valid" >&2
		return 1
	fi

	echo "$1"
}
validate_flag_d(){

	if [[ ! "$1" =~ ^user=[a-zA-Z0-9]+'&'pass=[a-zA-Z0-9]+$ ]]; then 

		echo "Error! $1 invalid data, no user or pass added" >&2
		return 1

	fi

	echo "$1"
}
main(){

	if ! v_mtd=$(validate_flag_m "$method"); then
		exit 1
	fi

	if ! v_url=$(validate_flag_u "$url"); then
		exit 1
	fi

	if ! v_dta=$(validate_flag_d "$data"); then
		exit 1
	fi

	trimming "$v_mtd" "$v_url" "$v_data"
}
trimming(){

	echo "Method: $1"
	echo "Url: $2"
	echo "Data: $3"
}
tcp_connection(){

	echo "=================================="
	echo "	Bash HTTP Client"
	echo "	Method	:	$1"
	echo "	Host	:	$2"
	echo "	Path	:	$(echo $2 | awk -F/ '{for(i = 0; i <= NF, i++) printf "%s%s", $i, ($i < NF ? "/" : "\n" }')"
	echo "	Port	:	$(echo $2 | awk -F: '{print $3}' | awk -F/ '{print $1}')"
	echo "=================================="
	echo -e "\n"

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
elif [[ -z "$url" ]]; then

	echo "./http_client: option requires an argument -- u"
	exit 0
elif [[ -z "$data" ]]; then

	echo "./http_client: option requires an argument -- d"
	exit 0
else
	main
fi
