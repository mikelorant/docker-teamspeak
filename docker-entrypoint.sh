#!/bin/sh

parse_ini() {
  cat ${1} | grep "${2}=" | awk -F'=' '{print $2}'
}

TS_ENTRYPOINT='/opt/teamspeak/ts3server_minimal_runscript.sh'
TS_CMD='dbplugin=ts3db_mariadb dbpluginparameter=ts3db_mariadb.ini'
TS_CMD_CREATE='dbsqlcreatepath=create_mariadb/'

cd `dirname ${ENTRYPOINT}`

SQL_HOST=$(parse_ini ts3db_mariadb.ini host)
SQL_USERNAME=$(parse_ini ts3db_mariadb.ini username)
SQL_PASSWORD=$(parse_ini ts3db_mariadb.ini password)
SQL_DATABASE=$(parse_ini ts3db_mariadb.ini database)

if getent hosts ${SQL_HOST}; then
  dockerize -timeout 30s -wait tcp://${SQL_HOST}:3306
  if mysqlshow -h${SQL_HOST} -u${SQL_USERNAME} -p${SQL_PASSWORD} ${SQL_DATABASE} | grep -q teamspeak3_metadata; then
    $TS_ENTRYPOINT $TS_CMD
  else
    $TS_ENTRYPOINT} $TS_CMD $TS_CMD_CREATE
  fi
else
  $TS_ENTRYPOINT
fi
