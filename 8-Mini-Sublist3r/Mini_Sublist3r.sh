#!/usr/bin/env bash


validating_target(){

	target="$1"

	if [[ -z "$target" ]]; then

        	echo "./Mini_Sublist3r.sh: option require an argument -- d"

		return 1

	elif [[ ! "$target" =~ ^([a-zA-Z0-9]+\.){2}[a-zA-Z0-9]+$ ]]; then

		echo "Error: invalid url"
		return 1
	fi

	echo "$target"
}
validating_wlist(){

	wlist="$1"

	if [[ -z "$wlist" ]]; then

        	echo "./Mini_Sublist3r.sh: option require an argument -- w"

		return 1

	elif [[ ! -f "$wlist" ]]; then

		echo "File does'nt exist"
		return 1
	fi

	echo "$wlist"
}
main(){

	target="$1"
	wlist="$2"

	if ! target=$(validating_target "$target"); then

		echo "$target"
		exit 1

	elif ! wlist=$(validating_wlist "$wlist") ; then

		echo "$wlist"
		exit 1
	fi

	begin "$target" "$wlist"
}
begin(){

	target="$1"
	wlist="$2"

	domain=$(echo "$target" | awk -F. '{for (i = 2; i <= NF; i++) { if (i != NF) printf $i "."; else printf $i}}')
	wrd_cnt=$(wc -l "$wlist" | awk '{print $1}')
	_date=$(date "+%Y-%m-%d %H:%M")

	echo "========================================="
	echo "	Mini Sublist3r"
	echo "	Domain	: $domain"
	echo "	Words	: $wrd_cnt"
	echo "	Date	: $_date"
	printf "======================================\n\n"


	start=$(date +%s%N)
	attempts=0
	max_jobs=10
	_sub=""
	found=0

	declare -A jobs

	while read -r subs
	do

		[[ -z "$subs" ]] && continue

		printf "[-] %-10s : %s\n" "Trying" "$subs.$domain"
		((attempts++))

		(

			result=$(dig +short "$subs.$domain") 

			 printf '%s\n' "$result" > "/tmp/dig_$BASHPID"

			if [[ ! -z "$result" ]]; then

				exit 0
			else
				exit 1
			fi
		) &

		pid=$!
		jobs["$pid"]="$subs"


		if (( "${#jobs[@]}" >= 10 )); then

			wait -n -p finished_pid "${!jobs[@]}"
			status=$?

			finished_sub="${jobs[$finished_pid]}"
			unset 'jobs[$finished_pid]'

				if (( status == 0 )); then

					trim=$(echo "$result" |   awk '/[0-9]{1,3}(\.[0-9]{1,3}){3}/ {print $1; exit}')
					printf "[+] %-10s : %-20s %s \n" "Found" "$finish_sub.$domain" " → $trim"
					((found++))
				fi


		fi
	done < "$wlist"

	end=$(date +%s%N)
	elasped=$((end - start))
	in_sec=$(awk "BEGIN {printf \"%.2f\", elapsed / 1000000000")
	final_report "$found" "$attempts" "$in_sec" 
}
final_report(){

	found="$1"
	tsted="$2"
	_time="$3"

	printf "\n======================================\n"
	printf "[*] %-10s : %s\n" "Found"  "$found"
	printf "[*] %-10s : %s\n" "Tested" "$tsted"
	printf "[*] %-10s : %ss\n" "Time"   "$_time"
}
while getopts ":d:w:" opts
do

	case "$opts" in 

		d) target="$OPTARG" ;;
		w) wlist="$OPTARG" ;;

	esac
done


main "$target" "$wlist"
