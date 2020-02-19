
FROM docker.pkg.github.com/christianlupus/partkeepr/base:latest

RUN sed 's@;date.timezone =@date.timezone = UTC@;s@max_execution_time = .*@max_execution_time = 72000@;s@memory_limit = .*@memory_limit = 512M@' /usr/local/etc/php/php.ini-production > /usr/local/etc/php/php.ini

WORKDIR /var/www/pk

VOLUME ["/var/www/pk/data", "/var/www/pk/web"]
