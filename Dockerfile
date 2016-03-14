FROM frolvlad/alpine-glibc
MAINTAINER Michael Lorant <mikel@mlvision.com.au>

RUN apk add mariadb-client w3m --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing && \
    TS_SERVER_VER=`w3m -dump https://www.teamspeak.com/downloads | grep -m 1 'Server 64-bit' | awk '{print $NF}'` && \
    wget http://dl.4players.de/ts/releases/${TS_SERVER_VER}/teamspeak3-server_linux_amd64-${TS_SERVER_VER}.tar.bz2 -O /tmp/teamspeak.tar.bz2 && \
    mkdir /opt && \
    tar jxf /tmp/teamspeak.tar.bz2 -C /opt && \
    mv /opt/teamspeak3-server_* /opt/teamspeak && \
    rm /tmp/teamspeak.tar.bz2 && \
    apk del w3m

RUN apk add curl --no-cache && \
    curl -L -O https://github.com/jwilder/dockerize/releases/download/v0.2.0/dockerize-linux-amd64-v0.2.0.tar.gz && \
    tar -C /usr/local/bin -xzvf dockerize-linux-amd64-v0.2.0.tar.gz && \
    rm dockerize-linux-amd64-v0.2.0.tar.gz && \
    apk del curl

RUN adduser -D -h /opt/teamspeak teamspeak teamspeak

COPY files/ts3db_mariadb.ini /opt/teamspeak/

RUN ln -s redist/libmariadb.so.2 /opt/teamspeak/

COPY docker-entrypoint.sh /entrypoint.sh

EXPOSE 9987/udp 10011 30033
USER teamspeak

ENTRYPOINT ["/entrypoint.sh"]
