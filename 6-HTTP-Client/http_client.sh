#!/usr/bin/env bash

validate_flag_m(){


}
validate_flag_u(){

}

vlidate_flag_d(){

}
main(){


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
