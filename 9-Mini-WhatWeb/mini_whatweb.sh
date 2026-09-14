#!/usr/bin/env bash


validate_url(){

	url="$1"

	if [[ ! "$url" =~ ^https?://[a-zA-Z0-9.-]+(:[0-9]+)?(/.*)?$ ]]; then

		echo "Invalid Url: Correct Format (http(s)//target.com)"
		return 1
	fi
	echo "$url"
}
main(){

	url="$1"

	if ! v_url=$(validate_url "$url"); then
		echo "$v_url"
	fi

	execution_inline "$v_url"	
}

execution_inline(){

	url="$1"
	_date=$(date +"%Y-%m-%d %H:%M")

	printf "\n======================================\n"
	printf "%18s\n" "Mini WhatWeb"
	printf "%5s %-10s : %s\n" " " "Target" "$url"
	printf "%5s %-10s : %s\n" " " "Date" "$_date"
	printf "=======================================\n\n"


	start=$(date +%s%N)

	echo -e "[*] Fetching target...\n\n"

	echo -e "[HEADERS]"
	ext_header "$url"


	echo "[TECHNOLOGIES]"
	ext_technologies "$url"

	echo "[MISSING SECURITY HEADERS]"
	ext_missing_sec_headers "$url"

	end=$(date +%s%N)

	elapsed=((end - start))

}
ext_header(){

	urt="$1"

	 curl -sI "$url" | awk -F: '{ 
                                                if ($1 == "Server")
                                                {
                                                        server_string = server_string $2 ", "

						}
        }
	END { 

        	print "[SERVER] : "  server_string

	}'


}
ext_technologies(){

	url="$1"
}

ext_missing_sec_headers(){

	url="$1"
}
while getopts ":u:" opts
do

	case "$opts" in 
		u) url="$OPTARG" ;;
	esac
done

main "$url"
