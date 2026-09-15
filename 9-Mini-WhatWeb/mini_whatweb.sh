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


	echo -e  "\n\n[TECHNOLOGIES]"
	ext_technologies "$url"

	echo -e "\n\n[MISSING SECURITY HEADERS]"
	ext_missing_sec_headers "$url"

	end=$(date +%s%N)

	elapsed=$((end - start))

	in_sec=$(awk "BEGIN {printf \"%.2f\", $elapsed / 1000000000}")

}
ext_header(){

	urt="$1"
	server=()
	pwrby=()
	cookie=()

	curl -sI "$url" | awk -F: '{
                                                if ($1 == "Server")
                                                {
                                              	   server = $2
						}
						else if ($1 == "X-Powered-By"){

						   poweredby = $2
						}
						else if ($1 == "Set-Cookie"){

						  cookies = $2
						}
			        }
	END {

		printf "[+] %-14s : %s\n", "Server", server
		printf "[+] %-14s : %s\n", "Powered-By", poweredby
		printf "[+] %-14s : %s\n", "Cookie", cookies

	}'


}
ext_technologies(){

	url="$1"

	curl -sI "$url" | awk ' BEGIN {

					 FS = ": "

					 tech_keywords["Apache"]      = 1
					 tech_keywords["Werkzeug"]    = 1
					 tech_keywords["Python"]      = 1
   					 tech_keywords["PHP"]	      = 1
					 tech_keywords["PHPSESSID"]   = 1
					 tech_keywords["wp-content"]  = 1
					 tech_keywords["__VIEWSTATE"] = 1
					 tech_keywords["jquery"]      = 1

				     }

				{

					for (key in tech_keywords) {

						if ($0 ~ key){

						    printf "[+] %-14s %s\n", key, "detected"

						}

					}
				}'
}

ext_missing_sec_headers(){

	url="$1"
}

final_report(){

	echo "Found"
	echo "Time"
}
while getopts ":u:" opts
do

	case "$opts" in 
		u) url="$OPTARG" ;;
	esac
done

main "$url"
