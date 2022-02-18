FROM mariadb:10.5.9

RUN apt update && \
    apt install -y logrotate locales && \
    localedef -i ko_KR -c -f UTF-8 -A /usr/share/locale/locale.alias ko_KR.UTF-8

ENV LANG ko_KR.utf8

COPY docker/conf/mariadb/mariadb.cnf  /etc/mysql/mariadb.cnf
COPY docker/conf/logrotate/mysql-server /etc/logrotate.d/
COPY docker/conf/docker-entrypoint-initdb.d  /docker-entrypoint-initdb.d

RUN chmod 644 /etc/logrotate.d/mysql-server && chmod 644 /etc/crontab

CMD /bin/bash -c "cron && /usr/local/bin/docker-entrypoint.sh mysqld"
