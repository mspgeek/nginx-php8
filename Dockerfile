FROM php:8.0-alpine

RUN apk update && apk upgrade
RUN apk add bash
RUN apk add nginx
RUN apk add php8-opcache php8-fpm
RUN apk add php8-gd php8-zlib php8-curl php8-dom php8-mbstring php8-mysqli php8-openssl php8-session php8-xml php8-simplexml 
RUN apk add php8-xmlreader php8-xmlwriter php8-zip php8-exif gmp php8-gmp php8-phar php8-ctype

RUN echo "* * * * * /usr/bin/php -d memory_limit=-1 -d max_execution_time=0 /usr/share/nginx/html/applications/core/interface/task/task.php fb05731ced1c5f8ddecb7a9719df7c94" >> /etc/crontabs/root

COPY server/etc/nginx /etc/nginx
COPY server/etc/php /etc/php8
COPY src /usr/share/nginx/html
RUN mkdir /var/run/php
ONBUILD RUN chmod 0777 /usr/share/nginx/html/applications
ONBUILD RUN chmod 0777 /usr/share/nginx/html/datastore
ONBUILD RUN chmod 0777 /usr/share/nginx/html/plugins
ONBUILD RUN chmod 0777 /usr/share/nginx/html/uploads
ONBUILD RUN chmod 0777 /usr/share/nginx/html/uploads/logs
EXPOSE 80

STOPSIGNAL SIGTERM

CMD ["/bin/bash", "-c", "php-fpm8 && chmod 777 /var/run/php/php8-fpm.sock && nginx -g 'daemon off;'"]
