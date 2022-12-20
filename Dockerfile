FROM php:8.0-alpine

RUN apk update && apk upgrade
RUN apk add bash
RUN apk add nginx
RUN apk add php8-opcache php8-fpm
RUN apk add php8-gd php8-zlib php8-curl

COPY server/etc/nginx /etc/nginx
COPY server/etc/php /etc/php8
COPY src /usr/share/nginx/html
RUN mkdir /var/run/php
EXPOSE 80

STOPSIGNAL SIGTERM

CMD ["/bin/bash", "-c", "php-fpm8 && chmod 777 /var/run/php/php8-fpm.sock && chmod 755 /usr/share/nginx/html/* && nginx -g 'daemon off;'"]
