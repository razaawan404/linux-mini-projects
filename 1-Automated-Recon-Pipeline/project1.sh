#!/usr/bin/env bash


while getopts "t:p:" opt
do
	case $opt in
		t) target="$OPTARG" ;;
		p) port="$OPTARG" ;;
	 esac
done

echo "Ip: $target"
echo "Port: $port"

final_method(){

	echo "=== RECON REPORT ==="
}

final_method
