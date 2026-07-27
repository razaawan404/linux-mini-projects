#!/usr/bin/env bash

declare -A PORTS=(
    [20]="FTP-DATA"
    [21]="FTP"
    [22]="SSH"
    [23]="TELNET"
    [25]="SMTP"
    [53]="DNS"
    [67]="DHCP-SERVER"
    [68]="DHCP-CLIENT"
    [69]="TFTP"
    [80]="HTTP"
    [110]="POP3"
    [111]="RPCBIND"
    [123]="NTP"
    [135]="MSRPC"
    [137]="NETBIOS-NS"
    [138]="NETBIOS-DGM"
    [139]="NETBIOS-SSN"
    [143]="IMAP"
    [161]="SNMP"
    [389]="LDAP"
    [443]="HTTPS"
    [445]="SMB"
    [465]="SMTPS"
    [515]="LPD"
    [587]="SMTP-SUBMISSION"
    [631]="IPP"
    [636]="LDAPS"
    [873]="RSYNC"
    [993]="IMAPS"
    [995]="POP3S"
    [1080]="SOCKS"
    [1433]="MSSQL"
    [1521]="ORACLE"
    [1723]="PPTP"
    [2049]="NFS"
    [2375]="DOCKER"
    [3000]="NODEJS"
    [3306]="MYSQL"
    [3389]="RDP"
    [5432]="POSTGRESQL"
    [5900]="VNC"
    [5985]="WINRM"
    [6379]="REDIS"
    [8000]="HTTP-ALT"
    [8009]="AJP13"
    [8080]="HTTP-PROXY"
    [8443]="HTTPS-ALT"
    [9000]="PHP-FPM"
    [9090]="PROMETHEUS"
    [9200]="ELASTICSEARCH"
    [9418]="GIT"
    [10000]="WEBMIN"
    [11211]="MEMCACHED"
    [27017]="MONGODB"
)

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

	if [[ -v PORTS[$ports] ]]; then
		echo "$ports	(${PORTS[$ports]})"

	elif [[ -v PORTS[$ports] ]]; then
		echo "$ports	(${PORTS[$ports]})"

	elif [[ -v PORTS[$ports] ]]; then
		echo "$ports	(${PORTS[$ports]})"

	else
		echo "$ports	(UNKNOWN)"
	fi
done


echo -e "\n[RUNNING PROCESSES]"
printf "%-15s %-15s %s\n" "PID" "NAME" "UID"

for file in /proc/*/status
do
        awk '/^[[:space:]]*Name:|^[[:space:]]*Pid:|^[[:space:]]*Uid:|^[[:space:]]*State:/ {


			if ( $1 == "Name:" )
				name=$2

			else if ($1 == "State:" )
                                state=$2

			else if ( $1 == "Pid:" )
				pid=$2

			else if ( $1 == "Uid:" )
				uid=$2

}
END{

	if (state == "R")
		printf "%-15s %-15s %s\n", pid, name, uid
}' "$file"
done

echo -e "\n[NETWORK]"
