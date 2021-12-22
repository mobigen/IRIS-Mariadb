FROM mariadb:10.5.9

RUN apt update && apt install -y logrotate

COPY conf/mariadb/mariadb.cnf  /etc/mysql/mariadb.cnf
COPY conf/logrotate/mysql-server /etc/logrotate.d/
COPY conf/crontab /etc/

EXPOSE 3306
CMD /bin/bash -c "cron && /usr/local/bin/docker-entrypoint.sh mysqld"
