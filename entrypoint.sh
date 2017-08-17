#!/bin/bash
# CGRateS Docker (default)
# https://github.com/lmangani/cgrates-docker

function set_defaults () {
	sqluser=root
	sqlpassword=GCRateS.org
	GOROOT=/root/go
	GOPATH=/root/code
	PATH_MYSQL_CONFIG=/etc/mysql/my.cnf
	DATADIR=/var/lib/mysql
}

function MYSQL_RUN () {
  chown -R mysql:mysql "$DATADIR"
  echo 'Starting mysqld'
  /etc/init.d/mysql start
  while [ ! -x /var/run/mysqld/mysqld.sock ]; do
      sleep 1
  done
}

echo "Initializing... "

	# set defaults
	set_defaults
	perl -p -i -e "s/sql_mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES/sql_mode=NO_ENGINE_SUBSTITUTION/" $PATH_MYSQL_CONFIG
	sed '/\[mysqld\]/a max_connections = 1024\' -i $PATH_MYSQL_CONFIG

	# mysql
	chown -R mysql:mysql "$DATADIR"
	mysqld --initialize-insecure=on --user=mysql --datadir="$DATADIR"
	MYSQL_RUN
	mysql -u root -e "SET PASSWORD = PASSWORD('$sqlpassword');"

	# redis
	sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf

	# enable service
	# sed -i 's/ENABLE=false/ENABLE=true/g' /etc/default/cgrates

	# start services
	service rsyslog start
	service redis-server start

	# setup mysql
	cd /usr/share/cgrates/storage/mysql && ./setup_cgr_db.sh root CGRateS.org

echo "Starting CGRateS.... "

if [ ! -z "$TUTORIAL" ]; then
	cgr-engine -config_dir /usr/share/cgrates/conf/samples/tutlocal/
elif [ "$TUTORIAL" == "asterisk" ]; then
	# Asterisk
	echo "Asterisk Preset"
	/usr/share/cgrates/tutorials/asterisk_ari/cgrates/etc/init.d/cgrates start
elif [ "$TUTORIAL" == "freeswitch" ]; then
	#FreeSwitch
	echo "FreeSWITCH Preset"
	/usr/share/cgrates/tutorials/fs_evsock/freeswitch/etc/init.d/freeswitch start
elif [ "$TUTORIAL" == "kamailio" ]; then
	#Kamailio
	echo "Kamailio Preset"
	/usr/share/cgrates/tutorials/kamevapi/kamailio/etc/init.d/kamailio start
elif [ "$TUTORIAL" == "opensips" ]; then
	#OpenSIPS
	echo "OpenSIPS Preset"
	/usr/share/cgrates/tutorials/osips_async/opensips/etc/init.d/opensips start
fi

