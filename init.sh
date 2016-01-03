#!/bin/sh
#**********************************************************************
# Description       :init root
# version           : 1.0
#**********************************************************************
#-------------------VAR------------------------------------------------
ACTION=$1
PROG_NAME=$0
BIN_DIR=/home/ywgx/bin
#-------------------FUN------------------------------------------------
base(){
	apt-get install vifm vim curl tmux inotify-tools -y
	apt-get install git npm tcl libxml2 libreadline-dev libpcre3-dev libssl-dev cmake libncurses5-dev build-essential -y
	apt-get install nodejs-legacy -y
	apt-get install imagemagick -y
	apt-get install gccgo-go -y
	apt-get install nodejs -y
	apt-get install luajit -y
}
python(){
	apt-get install python-mysqldb  -y
	apt-get install python-imaging  -y
	apt-get install python-dev -y
	apt-get install python-pip -y
	pip install torndb
	pip install tornado
	pip install pymongo
	pip install redis
	pip install dnspython
	pip install psutil
	pip install ipy
}
mysql(){
	apt-get install mysql-server -y
}
mongodb(){
	apt-get install mongodb -y
}
saltm(){
	apt-get install salt-master -y
}
saltc(){
	apt-get install salt-minion -y
}
perl(){
	apt-get install libmime-perl -y
	apt-get install libmime-lite-perl -y
}
mail(){
	apt-get install sendmail sendmail-cf mailutils sharutils -y
}
safe(){
	sed -i '/PasswordAuthentication/s/yes/no/;/PermitRootLogin/s/yes/no/' /etc/ssh/sshd_config
}
close(){
	chattr +i /etc/passwd 
	chattr +i /etc/shadow
	chattr +i /etc/group
	chattr +i /etc/gshadow
	chattr +i /etc/services
}
open(){
	chattr -i /etc/passwd 
	chattr -i /etc/shadow
	chattr -i /etc/group
	chattr -i /etc/gshadow
	chattr -i /etc/services
}
clean(){
	userdel -rf games
	userdel -rf lp
	userdel -rf www-data
	userdel -rf backup
	userdel -rf irc
	userdel -rf gnats
	userdel -rf list
}
main(){
}
#-------------------PROGRAM--------------------------------------------
main
