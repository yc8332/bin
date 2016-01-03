#!/bin/sh
{
	inotifywait -mq -e MODIFY,CREATE /home/ywgx/etc/openresty/conf/ /home/ywgx/lib/ |while read file
do
	/home/ywgx/0/openresty/nginx/sbin/nginx -s reload
done
}&
