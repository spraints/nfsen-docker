Docker and nfsen
================

This is a test.

How to run image ?
------------------

###Run image

	docker run -t -i -e "APACHE_RUN_USER=www-data" -e "APACHE_RUN_GROUP=www-data" -e "APACHE_LOG_DIR=/var/log/apache2" -e "APACHE_PID_FILE=/tmp/apache2.pid" -e "APACHE_LOCK_DIR=/tmp" -p 8080:80 -p 9995:9995 --ipc="host" nfsen:v5 /sbin/my_init -- bash -l

