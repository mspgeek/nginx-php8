FROM php:8.0-alpine

RUN apk update && \
    apk upgrade && \
    apk add --no-cache bash nginx php8-opcache php8-fpm php8-gd php8-zlib php8-curl php8-dom php8-mbstring php8-mysqli php8-openssl php8-session php8-xml php8-simplexml php8-xmlreader php8-xmlwriter php8-zip php8-exif gmp php8-gmp php8-phar php8-ctype openssl

COPY server/etc /etc
COPY src /usr/share/nginx/html

RUN mkdir /var/run/php && \
    mkdir -p /usr/share/nginx/html/applications /usr/share/nginx/html/datastore /usr/share/nginx/html/plugins /usr/share/nginx/html/uploads/logs && \
    echo "* * * * * /usr/bin/php -d memory_limit=-1 -d max_execution_time=0 /usr/share/nginx/html/applications/core/interface/task/task.php fb05731ced1c5f8ddecb7a9719df7c94" >> /var/spool/cron/crontabs/root

WORKDIR /usr/share/nginx/html

RUN chmod -R 777 /usr/share/nginx/html/applications /usr/share/nginx/html/datastore /usr/share/nginx/html/plugins /usr/share/nginx/html/uploads /usr/share/nginx/html/uploads/logs

EXPOSE 80

STOPSIGNAL SIGTERM

CMD ["/bin/bash", "-c", "php-fpm8 && chmod 777 /var/run/php/php8-fpm.sock && nginx -g 'daemon off;'"]
