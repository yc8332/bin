#!/bin/sh
#**********************************************************************
# Description       :ctl
# version           :2.3
#**********************************************************************
#-------------------VAR------------------------------------------------
ACTION=$1
NodeBB=$2
PROG_NAME=$0
REDIS_VER=3.0.6
OPENRESTY_VER=1.9.7.1
HOME_USER=ywgx
HOME_DIR=/home/$HOME_USER
REDIS_DUMP=$HOME_DIR/data/`hostname`-redis.json
LIB_DIR=$HOME_DIR/lib
BIN_DIR=$HOME_DIR/bin
SERVER_DIR=$HOME_DIR/0
HANDLE_DIR=$HOME_DIR/1
DB_DIR=$HOME_DIR/2/redis
NODEBB_DIR=$HOME_DIR/1/NodeBB
REDIS_SERVER=$HOME_DIR/2/redis/bin
REDIS_CONF=$HOME_DIR/2/redis/etc/redis.conf
BUILD_DIR=/tmp/$HOME_USER
LOGS_DIR=$HOME_DIR/log
RECORD_DIR=$HOME_DIR/log/.record
#-------------------FUN------------------------------------------------
base(){
	apt-get install unzip vifm vim curl tmux inotify-tools -y
	apt-get install git npm tcl libxml2 libreadline-dev libpcre3-dev libssl-dev cmake libncurses5-dev build-essential  fakeroot dpkg-dev -y
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
	pip install redis-py-cluster
        pip install pycrypto-on-pypi
	pip install dnspython
	pip install torndb
	pip install tornado
	pip install pymongo
	pip install redis
	pip install psutil
	pip install flask
	pip install ipy
}
varnish(){
	apt-get install python-docutils -y
	[ -d $BUILD_DIR ] || mkdir -p $BUILD_DIR
	[ -d $VARNISH_DIR ] || mkdir -p $VARNISH_DIR
	cd $BUILD_DIR
	wget  https://repo.varnish-cache.org/source/varnish-4.1.0.tar.gz 
	tar xzf varnish-4.1.0.tar.gz 
	cd varnish*
	./configure --prefix=$VARNISH_DIR 
	make && make install
}
redis(){
	[ -d $BUILD_DIR ] || mkdir -p $BUILD_DIR
	[ -d $DB_DIR ] || mkdir -p $DB_DIR
	cd $BUILD_DIR
	wget http://download.redis.io/releases/redis-${REDIS_VER}.tar.gz -T 120
	tar xzf redis*.gz
	cd redis*/
	make MALLOC=libc && make install
	./utils/install_server.sh
	rm -rf $BUILD_DIR
}
openresty(){
	[ -d $BUILD_DIR ] || mkdir -p $BUILD_DIR
	[ -d $SERVER_DIR ] || mkdir -p $SERVER_DIR
	cd $BUILD_DIR
	wget http://openresty.org/download/ngx_openresty-${OPENRESTY_VER}.tar.gz -T 120
	tar xzf ngx*.gz
	cd ngx*/
	./configure --prefix=$SERVER_DIR/openresty --with-luajit --without-http_auth_basic_module --without-http_autoindex_module --without-http_fastcgi_module --without-http_uwsgi_module --without-http_scgi_module --without-http_memcached_module --without-http_redis2_module
	make && make install
	chown -R $HOME_USER.$HOME_USER $SERVER_DIR
	chown root.$HOME_USER $SERVER_DIR/openresty/nginx/sbin/nginx
	chmod +s $SERVER_DIR/openresty/nginx/sbin/nginx
	rm -rf $BUILD_DIR
	[ -d $RECORD_DIR ] || mkdir -p $RECORD_DIR
	chown -R $HOME_USER.$HOME_USER $LOGS_DIR
	rm -rf $HOME_DIR/0/openresty/nginx/conf/
	ln -s $HOME_DIR/etc/openresty/conf/ $HOME_DIR/0/openresty/nginx/
}
nodebb(){
	$BIN_DIR/shdn-redis.py &>/dev/null
	cd $HOME_DIR
	wget https://github.com/NodeBB/NodeBB/archive/master.zip -T 120
	unzip master.zip
	[ -d $HANDLE_DIR ] || mkdir $HANDLE_DIR
	mv -f NodeBB-master $NODEBB_DIR
	rm $HOME_DIR/master.zip
	cd $NODEBB_DIR;npm install --production
	sed -i '/title/s/NodeBB/'$NodeBB'/;/allowFileUploads/s/0/1/;/maximumFileSize/s/2048/20480/;/maximumProfileImageSize/s/256/2560/' $NODEBB_DIR/install/data/defaults.json
	sed -i '/storage.googleapis.com/d'  $NODEBB_DIR/src/views/admin/header.tpl
	sed -i '/h1/d' $NODEBB_DIR/node_modules/nodebb-theme-persona/templates/categories.tpl
	sed -i 's/428bca/57b382/;s/5cb85c/57b382/;s/5bc0de/57b382/;s/f0ad4e/57b382/;s/8a6d3b/666666/;s/fcf8e3/edf4ed/' $NODEBB_DIR/node_modules/nodebb-theme-persona/less/bootstrap/variables.less
	sed -i 's/428bca/57b382/;s/5cb85c/57b382/;s/5bc0de/57b382/;s/f0ad4e/57b382/;s/8a6d3b/666666/;s/fcf8e3/edf4ed/' $NODEBB_DIR/node_modules/nodebb-theme-vanilla/less/bootstrap/variables.less
	sed -i '/createWelcomePost,/d' $NODEBB_DIR/src/install.js
	sed -i 's/googleapis/useso/g' $NODEBB_DIR/node_modules/nodebb-theme-persona/less/style.less
	for i in `grep https://fonts.google $NODEBB_DIR/* -R -l`;do sed -i 's/https/http/g' $i;done
	for i in `grep fonts.google $NODEBB_DIR/* -R -l`;do sed -i 's/fonts.googleapis/fonts.useso/g' $i;done
	for i in `grep "#ffffff" $NODEBB_DIR/* -R -l`;do sed -i 's/#ffffff/#edf4ed/g' $i;done
	rm -rf $NODEBB_DIR/public/uploads/
	rm -rf $HOME_DIR/data/language/en_US
	rm -rf $HOME_DIR/data/language/zh_CN
	mv $NODEBB_DIR/public/language/en_US $HOME_DIR/data/language/
	mv $NODEBB_DIR/public/language/zh_CN $HOME_DIR/data/language/
	rm -rf $NODEBB_DIR/public/language/
	ln -s $NODEBB_DIR/public/logo.png $NODEBB_DIR/public/apple-touch-icon-120x120-precomposed.png
	ln -s $NODEBB_DIR/public/logo.png $NODEBB_DIR/public/apple-touch-icon-120x120.png
	ln -s $NODEBB_DIR/public/logo.png $NODEBB_DIR/public/apple-touch-icon.png
	ln -s $HOME_DIR/data/$NodeBB-uploads  $NODEBB_DIR/public/uploads
	ln -s $HOME_DIR/data/language $NODEBB_DIR/public/language
	$BIN_DIR/lang.sh
	$REDIS_SERVER/redis-server $REDIS_CONF
	chown $HOME_USER.$HOME_USER $HANDLE_DIR
	$NODEBB_DIR/nodebb setup
}
mysql(){
	apt-get install mysql-server -y
}
mongodb(){
	apt-get install mongodb -y
}
saltm(){
	apt-get install salt-master -y
	apt-get install salt-ssh -y
}
salt(){
	apt-get install salt-minion -y
}
perl(){
	apt-get install libmime-perl -y
	apt-get install libmime-lite-perl -y
}
nodeb(){
	npm config set registry http://registry.cnpmjs.org
}
mail(){
	apt-get install sendmail sendmail-cf mailutils sharutils -y
}
start(){
	$SERVER_DIR/openresty/nginx/sbin/nginx
	crontab -l  > /tmp/crontab
	cat <<- EOF >> /tmp/crontab
	0 0 * * * $HOME_DIR/bin/cron.sh &>/dev/null
	EOF
	sort /tmp/crontab|uniq > /tmp/task
	crontab /tmp/task
	$HOME_DIR/bin/safed.sh 
	rm -f /tmp/task
	rm -f /tmp/crontab
}
stop(){
	killall -9 rootd.sh        &>/dev/null
	killall -9 safed.sh        &>/dev/null
	killall -9 nginx           &>/dev/null
	killall -9 inotifywait     &>/dev/null
	crontab -r                 &>/dev/null
}
safe(){
	sed -i '/PasswordAuthentication/s/yes/no/;/PermitRootLogin/s/yes/no/' /etc/ssh/sshd_config
}
shutdown(){
	$NODEBB_DIR/nodebb stop
	$BIN_DIR/shdn-redis.py
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
	userdel -rf lp
	userdel -rf irc
	userdel -rf list
	userdel -rf games
	userdel -rf gnats
	userdel -rf backup
	userdel -rf www-data
	userdel -rf landscape
}
main(){
	case "$ACTION" in
		$ACTION)
			$ACTION
			;;
	esac
}
#-------------------PROGRAM--------------------------------------------
main
