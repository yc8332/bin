#!/bin/bash
#**********************************************************************
# Description       : /etc/rc.local 
# version           : 0.2
#**********************************************************************
#-------------------VAR------------------------------------------------
FULL_NAME=`basename $0`
FILE_NAME=${FULL_NAME%.*}
EXTENSION=${FULL_NAME#*.}
IPTABLES_FILTER=/home/ywgx/log/.iptables
IPTABLES_BIN=/sbin/iptables
IPTABLES_RESTORE=/sbin/iptables-restore
HOME_DIR=/home/ywgx
REDIS_SERVER=$HOME_DIR/2/redis/bin
REDIS_CONF=$HOME_DIR/2/redis/etc/redis.conf
RECORD=/home/ywgx/log/.record
LOG="/home/ywgx/log/${FILE_NAME}.log"
#-------------------FUN------------------------------------------------
main(){
	$REDIS_SERVER/redis-server $REDIS_CONF	
	while true
	do
		ps aux|grep nginx|grep -v grep
		if [ $? != 0 ]
		then
			if [ ! -d $RECORD ];then
				mkdir -p $RECORD
				chown ywgx.ywgx /home/ywgx/log
			fi
			/home/ywgx/bin/ctl.sh stop
			cd /home/ywgx/1/NodeBB;./nodebb stop
			killall rootd.sh
			killall safed.sh
			sleep 3
			/home/ywgx/bin/ctl.sh start
			sleep 3
			/home/ywgx/bin/rootd.sh
			sleep 7
			cd /home/ywgx/1/NodeBB;./nodebb start
			wait
			if [ -e $IPTABLES_FILTER ]
			then
				$IPTABLES_RESTORE < $IPTABLES_FILTER
			fi
			echo "`date '+%x %X'` reboot" >> $LOG
		else
			sleep 81
		fi
	done
}
#-------------------PROGRAM--------------------------------------------
main & &>/dev/null
