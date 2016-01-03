#!/bin/bash
#**********************************************************************
# note              : 
# version           : 0.3
#**********************************************************************
{
	inotifywait -mq -e MODIFY,CREATE /home/ywgx/lib/ | while read file
do
	rsync -zur /home/ywgx/lib nodebb.cn:/home/ywgx/
	rsync -zur /home/ywgx/lib xabc.wang:/home/ywgx/
done
}&
{
	inotifywait -mq -e MODIFY,CREATE /home/ywgx/bin/ | while read file
do
	rsync -zur /home/ywgx/bin nodebb.cn:/home/ywgx/
	rsync -zur /home/ywgx/bin xabc.wang:/home/ywgx/
done
}&
{
	inotifywait -mq -e MODIFY,CREATE /home/ywgx/doc/ | while read file
do
	rsync -zur /home/ywgx/doc nodebb.cn:/home/ywgx/
	rsync -zur /home/ywgx/doc xabc.wang:/home/ywgx/
done
}&
{
	inotifywait -mq -e MODIFY,CREATE /home/ywgx/usr/ | while read file
do
	rsync -zur /home/ywgx/usr nodebb.cn:/home/ywgx/
	rsync -zur /home/ywgx/usr xabc.wang:/home/ywgx/
done
}&
{
	inotifywait -mq -e MODIFY,CREATE /home/ywgx/3/css/ | while read file
do
	rsync -zur /home/ywgx/3 nodebb.cn:/home/ywgx/
	rsync -zur /home/ywgx/3 xabc.wang:/home/ywgx/
done
}&
{
	inotifywait -mq -e MODIFY,CREATE /home/ywgx/.ywgx/bin/ | while read file
do
	rsync -zur /home/ywgx/.ywgx nodebb.cn:/home/ywgx/
	rsync -zur /home/ywgx/.ywgx xabc.wang:/home/ywgx/
done
}&
{
	inotifywait -mq -e MODIFY,CREATE /home/ywgx/etc/openresty/conf/ | while read file
do
	rsync -zur /home/ywgx/etc nodebb.cn:/home/ywgx/
	rsync -zur /home/ywgx/etc xabc.wang:/home/ywgx/
done
}&
