#!/bin/bash
# CGRateS Docker (default)
# https://github.com/lmangani/cgrates-docker

GOROOT=/root/go
GOPATH=/root/code

sqluser=root
sqlpassword=GCRateS.org

PATH_MYSQL_CONFIG=/etc/mysql/my.cnf
perl -p -i -e "s/sql_mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES/sql_mode=NO_ENGINE_SUBSTITUTION/" $PATH_MYSQL_CONFIG
sed '/\[mysqld\]/a max_connections = 1024\' -i $PATH_MYSQL_CONFIG

DATADIR=/var/lib/mysql

# Handy-dandy MySQL run function
function MYSQL_RUN () {
  chown -R mysql:mysql "$DATADIR"
  echo 'Starting mysqld'
  /etc/init.d/mysql start
  #echo 'Waiting for mysqld to come online'
  while [ ! -x /var/run/mysqld/mysqld.sock ]; do
      sleep 1
  done
}

echo "Initializing DBs... "
	# mysql
	chown -R mysql:mysql "$DATADIR"
	mysqld --initialize-insecure=on --user=mysql --datadir="$DATADIR"
	MYSQL_RUN
	mysql -u root -e "SET PASSWORD = PASSWORD('$sqlpassword');" 

	# redis
	sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf

# start services
service rsyslog start
service redis-server start

# setup mysql
cd /usr/share/cgrates/storage/mysql && ./setup_cgr_db.sh root CGRateS.org

# load tariff plan data
#cd /usr/share/cgrates/data/tariffplans/osips_training; cgr-loader

echo "Starting CGRateS.... "
cd /usr/share/cgrates
cgr-engine -config_dir /usr/share/cgrates/data/conf/samples/cgradmin

