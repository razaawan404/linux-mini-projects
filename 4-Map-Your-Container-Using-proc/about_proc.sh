#!/usr/bin/env bash


echo "======================================"
echo "	Container Map"
echo "	Date: $(date +'%Y-%m-%d %H:%m')"
echo "======================================"


echo -e "\n[IP ADDRESS]"
hostname -I | awk '{print $1}'

echo -e "\n[LISTINING PORTS]"
