#!/bin/sh
#**********************************************************************
# Description       : safe
# note              : 
# version           : 1.0
#**********************************************************************
#-------------------VAR------------------------------------------------
LOGS_DIR=/home/ywgx/log
IPTABLES_BIN=/sbin/iptables
IPTABLES_SAVE=/sbin/iptables-save
IPV4_RESTORE=/sbin/iptables-restore
IPV6_RESTORE=/sbin/ip6tables-restore
#-------------------FUN------------------------------------------------
sys(){
	chattr +i /etc/passwd 
	chattr +i /etc/shadow
	chattr +i /etc/group
	chattr +i /etc/gshadow
	chattr +i /etc/services
	chmod 700 /bin/chmod 
}
ipv4(){
	cat <<- EOF > /tmp/filter4
	*filter
	:INPUT ACCEPT [0:0]
	:FORWARD ACCEPT [0:0]
	:OUTPUT ACCEPT [0:0]
	-A INPUT -i lo -j ACCEPT
	-A INPUT -d 127.0.0.0/8 -j REJECT
	-A INPUT -p tcp --dport 80 -j ACCEPT
	-A INPUT -p icmp --icmp-type 3 -j ACCEPT
	-A INPUT -p icmp --icmp-type 8 -j ACCEPT
	-A INPUT -p icmp --icmp-type 11 -j ACCEPT
	-A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
	-A INPUT -p tcp -m state --state NEW -m tcp --dport 22 -j ACCEPT
	-A INPUT -p tcp -m multiport --dports 4505,4506,5000,5001,5002 -m state --state NEW -j ACCEPT
	-A INPUT -j REJECT --reject-with icmp-host-prohibited
	-A FORWARD -j REJECT --reject-with icmp-host-prohibited
	COMMIT
	EOF
	$IPV4_RESTORE < /tmp/filter4
	rm -f /tmp/filter4
}
ipv6(){
	cat <<- EOF > /tmp/filter6
	*filter
	-A INPUT -j REJECT
	-A FORWARD -j REJECT
	-A OUTPUT -j REJECT
	COMMIT
	EOF
	$IPV6_RESTORE < /tmp/filter6
	rm -f /tmp/filter6
}
log(){
	cd $LOGS_DIR
	while true
	do
		tail access.log -n 20|awk '{if ($4 == "_") {print $1}}'|sort|uniq -c|sort -nr|awk '{if ($2 !=null && $1>3) {print $2}}' > .drop
		tail access.log -n 20|grep -Ew '404'|grep -E 'x16|x00'|awk '{print$1}'|sort|uniq -c|sort -nr|awk '{if ($2!=null && $1>5) {print $2}}' >> .drop
		tail access.log -n 20|awk '{if($0~/404/ && $0~/chmod|echo/) print$1}'|sort|uniq -c|sort -nr|awk '{if ($2!=null && $1>0) {print $2}}' >> .drop
		tail access.log -n 20|awk '{if (($(NF-2) == "-") && ($(NF-1) == "-" ) && ($4 == "_" )) {print $1}}'|sort|uniq -c|sort -nr|awk '{if ($2 !=null && $1>2) {print $2}}' >> .drop
		tail access.log -n 20|grep -Ew '404'|awk '{if (($(NF-2) == "-") || ($(NF-1) == "-" )) {print $1}}'|sort|uniq -c|sort -nr|awk '{if ($2 !=null && $1>15) {print $2}}' >> .drop
		tail access.log -n 20|grep -Ew '403|499'|awk '{print$1}'|sort|uniq -c|sort -nr|awk '{if ($2!=null && $1>10) {print $2}}' >> .drop
		tail /var/log/auth.log -n 20|grep -Ew ': Failed' |awk '{print$11}'|grep '[0-9]\.'|sort|uniq -c|sort -nr|awk '{if ($2!=null && $1>2) {print $2}}' >> .drop
		if [ -s .drop ]
		then
			sort ./.drop|uniq > .dropIP
			for i in `cat .dropIP`
			do
				$IPTABLES_BIN -nL INPUT|grep $i -q
				if [ $? != 0 ]
				then
					$IPTABLES_BIN -I INPUT -s $i -j DROP
					$IPTABLES_SAVE > ./.iptables
					echo "`date` $i" >> blackip
				fi
			done
		fi
		sleep 21
	done
}
main(){
	sys
	ipv4
	ipv6
	log	
}
#-------------------PROGRAM--------------------------------------------
main &
