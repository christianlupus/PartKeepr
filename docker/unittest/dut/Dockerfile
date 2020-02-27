
FROM partkeepr/development:latest
ARG WWW_DATA_UID=999
RUN apt-get update && apt-get install -y lsb-release patch mariadb-client rsync

RUN sed "s@www-data:x:[0-9]*@www-data:x:$WWW_DATA_UID@" -i /etc/passwd && chown www-data /var/www/ /var/www/pk

RUN mkdir /test-data /image /report
COPY config_test.patch /test-data/config_test.patch

COPY entrypoint.sh /entrypoint.sh

USER www-data
ENTRYPOINT ["/entrypoint.sh"]
