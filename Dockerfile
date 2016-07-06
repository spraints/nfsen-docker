FROM ubuntu:12.04.5
MAINTAINER Matt Burke <spraints@gmail.com>

# https://blog.bravi.org/?p=1091

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y nfdump \
  apache2 libapache2-mod-php5 php5-common \
  rrdtool libmailtools-perl librrds-perl libio-socket-ssl-perl

RUN apt-get install -y wget

# NFSEN
WORKDIR /usr/src
#RUN ["wget", "http://sourceforge.net/projects/nfsen/files/stable/nfsen-1.3.7/nfsen-1.3.7.tar.gz"]
RUN ["wget", "http://sourceforge.net/projects/nfsen/files/stable/nfsen-1.3.6p1/nfsen-1.3.6p1.tar.gz"]
RUN ["tar", "zxvf", "nfsen-1.3.6p1.tar.gz"]

WORKDIR /usr/src/nfsen-1.3.6p1

# ADD MAIN CONFIG FILE
ADD ["nfsen.conf", "/etc/nfsen.conf"]

RUN ["mkdir", "-p", "/data/nfsen"]
RUN ["./install.pl", "/etc/nfsen.conf"]

# RUN APACHE2
ADD ["000-default.conf", "/etc/apache2/sites-available/000-default.conf"]
RUN ["/usr/sbin/apache2", "-DFOREGROUND"]

# RUN NFSEN
WORKDIR /data/nfsen/bin
RUN ["./nfsen", "start"]

EXPOSE 80
EXPOSE 9995
