FROM phusion/baseimage
MAINTAINER Julien Hautefeuille <julien.hautefeuille@inserm.fr>

# USE BASEIMAGE INIT
CMD ["/sbin/my_init"]

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y -q wget gcc flex librrd-dev make \
	apache2 libapache2-mod-php5 php5-common libmailtools-perl rrdtool librrds-perl autoconf build-essential

# CLEANING APT
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# NFDUMP 
WORKDIR /usr/src
RUN ["wget", "http://sourceforge.net/projects/nfdump/files/stable/nfdump-1.6.13/nfdump-1.6.13.tar.gz"]
RUN ["tar", "zxvf", "nfdump-1.6.13.tar.gz"]

WORKDIR /usr/src/nfdump-1.6.13
RUN ["./configure", "--enable-nfprofile"]
RUN ["make"]
RUN ["make", "install"]

# NFSEN
WORKDIR /usr/src
RUN ["wget", "http://sourceforge.net/projects/nfsen/files/stable/nfsen-1.3.7/nfsen-1.3.7.tar.gz"]
RUN ["tar", "zxvf", "nfsen-1.3.7.tar.gz"]

WORKDIR /usr/src/nfsen-1.3.7
RUN ["perl", "-MCPAN", "-e", "'install Socket6'"]
RUN ["perl", "-MCPAN", "-e", "'install Mail::Header'"]
RUN ["perl", "-MCPAN", "-e", "'install Mail:Internet'"]

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
