#!/usr/bin/env bash

validation(){

        local -n url="$1"
        local -n file="$3"
	filter=""
	unfilter=""

        while IFS= read -r u; 
        do
                if [[ ! "$u" =~ ^https?:// ]]; then
		    echo "[http://$u]"
		    result=$(curl -s -I -L "http://$u" --max-time 5 | grep -E 'Server|X-Powered-By|Set-Cookie|Location')

		   if [[ -z "$result" ]]; then
		   	echo "No Result"
		   else
			echo "$result"
		   fi

		echo -e "\n"
		else
		    echo "[$u]"
		    result=$(curl -s -I -L "//$u" --max-time 5 | grep -E 'Server|X-Powered-By|Set-Cookie|Location')

		    if [[ -z "$result" ]]; then
			echo "No Result"
		    else
			echo "$result"
		    fi
		echo -e "\n"
		fi
        done < "$url"
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

