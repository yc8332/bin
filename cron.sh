#!/bin/sh
#**********************************************************************
# Description       :crontab task  Run 0 0 * * *
# note              : 
# version           : 0.3
#**********************************************************************
#-------------------VAR------------------------------------------------
LOGS_DIR=/home/ywgx/log
RECORD_DIR=/home/ywgx/log/.record
REDISDL=/home/ywgx/bin/redisdl.py
RDB_DIR=/home/ywgx/data
#-------------------FUN------------------------------------------------
main(){
	awk '{print$(NF-2)}' $LOGS_DIR/access.log|sort|uniq -c >> $LOGS_DIR/.UA
	awk '{a[$2]+=$1;}END{for (i in a) print i "\t" a[i];}' $LOGS_DIR/.UA|sort -k2nr > $LOGS_DIR/UA
	sort -n -k 1 -s $LOGS_DIR/access.log|tac|sort -n -k 1 -s -u|awk -F "[()]" '{print$2}'|sed -n 's/;//g;/00/d;/[Hh][Tt][Tt][Pp]/d;/com/d;/%/d;/[jJ]ava/d;/[a-zA-Z]/p;$d'|sort|uniq -c >> $LOGS_DIR/.OS
	awk '{a[$2]+=$1;}END{for (i in a) print i "\t" a[i];}' $LOGS_DIR/.OS|sort -k2nr > $LOGS_DIR/OS
	mv $LOGS_DIR/access.log $RECORD_DIR/$(date -d "yesterday" +"%Y-%m-%d").log
	kill -USR1 $(cat $LOGS_DIR/nginx.pid)
	awk '{print$1}' $RECORD_DIR/$(date -d "yesterday" +"%Y-%m-%d").log|sort|uniq -c|sort -nr > $RECORD_DIR/$(date -d "yesterday" +"%Y-%m-%d").ip
	sleep 7
	$REDISDL > $RDB_DIR/`hostname`-redis.json
	find $RECORD_DIR -mtime +7 -delete
}
#-------------------PROGRAM--------------------------------------------
main
