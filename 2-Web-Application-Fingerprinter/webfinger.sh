#!/usr/bin/env bash

validation(){

        local -n url="$1"
        local -n file="$3"
	filter=""
	unfilter=""

        while IFS= read -r u; 
        do
                if [[ ! "$u" =~ ^(https?) ]]; then
		    filter+="http://$u"
		else
		    unfilter+="$u"
		fi
        done < "$url"

	cat "Filter: $filter"

}



while getopts "l:o:" opt
do
    	case "$opt" in
       		l) urls="$OPTARG"
		   url_given=true ;;
        	o) op_file="$OPTARG"
		   file_given=true ;;
    	esac
	done

validation "urls" "$url_give" "op_file" "$file_give"

