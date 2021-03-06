# docker pull 32bit/ubuntu:14.04 && docker tag 32bit/ubuntu:14.04 nfsen-base:latest
# docker pull ubuntu:12.04.5     && docker tag ubuntu:12.04.5     nfsen-base:latest
FROM nfsen-base:latest
MAINTAINER Matt Burke <spraints@gmail.com>

# https://blog.bravi.org/?p=1091

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y nfdump \
  apache2 libapache2-mod-php5 php5-common \
  rrdtool libmailtools-perl librrds-perl libio-socket-ssl-perl

RUN apt-get install -y wget rsyslog

# NFSEN
WORKDIR /usr/src
#RUN ["wget", "http://sourceforge.net/projects/nfsen/files/stable/nfsen-1.3.7/nfsen-1.3.7.tar.gz"]
RUN ["wget", "--no-check-certificate", "http://sourceforge.net/projects/nfsen/files/stable/nfsen-1.3.6p1/nfsen-1.3.6p1.tar.gz"]
RUN ["tar", "zxvf", "nfsen-1.3.6p1.tar.gz"]

WORKDIR /usr/src/nfsen-1.3.6p1

# ADD MAIN CONFIG FILE
ADD ["nfsen.conf", "/etc/nfsen.conf"]

RUN ["mkdir", "-p", "/data/nfsen"]
RUN rsyslogd -c5; ipcs -s; ./install.pl /etc/nfsen.conf || (ipcrm sem 0 && ./install.pl /etc/nfsen.conf)

# RUN APACHE2
ADD ["000-default.conf", "/etc/apache2/sites-available/000-default.conf"]

# RUN NFSEN
WORKDIR /data/nfsen/bin
ENTRYPOINT rsyslogd -c5 && apachectl start && ./nfsen start && bash -l

EXPOSE 80
EXPOSE 9995
