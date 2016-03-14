mikelorant/teamspeak
====================

Docker image for Teamspeak using MariaDB backend.

Based off of frolvlad:alphine-glibc.
Inspired by mbentley/docker-teamspeak

To pull this image:

```
docker pull mikelorant/teamspeak
```

Setup:

```
apt-get install python-pip
pip install docker-compose
```

Example usage:

```
docker-compose up -d
```
