#!/bin/sh

TS_ENTRYPOINT='/opt/teamspeak/ts3server_minimal_runscript.sh'
TS_CMD='dbplugin=ts3db_mariadb dbpluginparameter=ts3db_mariadb.ini'
TS_CMD_CREATE='dbsqlcreatepath=create_mariadb/'
TS_LOG='/var/log/teamspeak/teamspeak.log'
TS_DIRECTORY=$(dirname $TS_ENTRYPOINT)

cd $TS_DIRECTORY

if getent hosts ${MYSQL_HOST}; then
  cat > ${TS_DIRECTORY}/ts3db_mariadb.ini << EOF
[config]
host=${MYSQL_HOST}
port=3306
username=${MYSQL_USERNAME}
password=${MYSQL_PASSWORD}
database=${MYSQL_DATABASE}
EOF

  dockerize -timeout 60s -wait tcp://${MYSQL_HOST}:3306
  if mysqlshow -h${MYSQL_HOST} -u${MYSQL_USERNAME} -p${MYSQL_PASSWORD} ${MYSQL_DATABASE} | grep -q teamspeak3_metadata; then
    $TS_ENTRYPOINT $TS_CMD 2>&1 | tee -a $TS_LOG
  else
    $TS_ENTRYPOINT $TS_CMD $TS_CMD_CREATE 2>&1 | tee -a $TS_LOG
  fi
else
  echo $TS_ENTRYPOINT
  $TS_ENTRYPOINT 2>&1 | tee -a $TS_LOG
fi
