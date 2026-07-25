#!/usr/bin/env bash


echo "======================================"
echo "	Container Map"
echo "	Date: $(date +'%Y-%m-%d %H:%m')"
echo "======================================"


echo -e "\n[IP ADDRESS]"
hostname -I | awk '{print $1}'

echo -e "\n[LISTINING PORTS]"
hex_ports=$(cat /proc/net/tcp | awk '{print $2, $4}' | grep -E '0A$' | awk -F: '{print $2}' | awk '{print $1}')

ports=()
for p in $hex_ports
do
	ports=$(printf "%d\n" 0x$p)
done


