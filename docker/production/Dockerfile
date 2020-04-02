
ARG SRC_IMAGE=partkeepr/base:latest
FROM ${SRC_IMAGE}

COPY nginx.conf /tmp
RUN apt-get update && \
	apt-get install -y nginx && \
	apt-get clean && \
	rm /etc/nginx/sites-enabled/default && \
	mv /tmp/nginx.conf /etc/nginx/sites-enabled/partkeepr

RUN sed 's@;date.timezone =@date.timezone = UTC@;s@max_execution_time = .*@max_execution_time = 72000@;s@memory_limit = .*@memory_limit = 512M@' /usr/local/etc/php/php.ini-production > /usr/local/etc/php/php.ini

WORKDIR /var/www/pk

ADD partkeepr-docker-build.tar.gz .

VOLUME ["/var/www/pk/data", "/var/www/pk/web"]
