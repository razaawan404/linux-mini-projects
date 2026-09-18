#!/usr/bin/env bash

validate_file(){

	file="$1"

	if [[ -z "$file" ]]; then

		echo "./log_parser.sh: option requires an argument -- f"
		return 1

	elif [[ ! -f "$file" ]]; then

		echo "File not exist"
		return 1
	fi

	echo "$file"
}

validate_type(){

	type="$1"

	if [[ -z "$type" ]]; then

		echo "./log_parser.sh: option requires an argument -- t"
		return 1

	elif [[ ! "${type,,}" == @(apache|nginx|ssh) ]]; then

		echo "Error: type not found"
		return 1
	fi

	echo "$type"
}
main(){

	file="$1"
	type="$2"

	if ! v_file=$(validate_file "$file"); then

		echo "$v_file"
		exit 1

	elif ! v_type=$(validate_type "$type"); then

		echo "$v_type"
		exit 1
	fi

	#run "$v_file" "$v_type"

	if [[ "${v_type,,}" == "apache" ]]; then

                run_apache "$v_file" "$v_type"

        elif [[ "${v_type,,}" == "ssh" ]]; then

                run_ssh "$v_file" "$v_type"

        elif [[ "${v_type ,,}" == "nginx" ]]; then

                echo "$v_type"
        fi

}
run_apache(){

	file="$1"
	type="$2"

	lines=$(wc -l "$file" | awk '{print $1}')
	_date=$(date +"%Y-%m-%d %H:%M")

	printf "==================================\n"
	printf "%-10s : %s\n" "File" "$file"
	printf "%-10s : %s\n" "Type" "$type"
	printf "%-10s : %s\n" "Lines" "$lines"
	printf "%-10s : %s\n" "Date"  "$_date"
	printf "==================================\n"
}
run_ssh(){

	file="$1"
        type="$2"

        lines=$(wc -l "$file" | awk '{print $1}')
        _date=$(date +"%Y-%m-%d %H:%M")

        printf "==================================\n"
        printf "%-10s : %s\n" "File" "$file"
        printf "%-10s : %s\n" "Type" "$type"
        printf "%-10s : %s\n" "Lines" "$lines"
        printf "%-10s : %s\n" "Date"  "$_date"
        printf "==================================\n"

}
while getopts ":f:t:" opts
do

	case "$opts" in

		f) log_file="$OPTARG" ;;
		t) type="$OPTARG" ;;
	esac
done

main "$log_file" "$type"
