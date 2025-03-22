FROM mariadb:latest AS db
COPY ./config/mysql.cnf /etc/mysql/conf.d/mysql.cnf

FROM wordpress:6.7.2-php8.3-fpm-alpine AS wp
RUN set -ex; \
    apk --no-cache add sudo \
    && rm -rf /var/cache/apk/*

VOLUME /var/www/html
WORKDIR /var/www/html
RUN chown -R nobody:nobody /var/www/html
USER nobody

FROM nginx:alpine3.21 AS server
RUN set -x; \
    addgroup -g 1000 -S www-data ; \
    adduser -u 1000 -D -S -G www-data www-data && exit 0 ; exit 1

RUN set -eux; \
    apk update && apk --no-cache add \
    curl \
    && addgroup www-data nginx \
    && rm -rf /var/cache/apk/*

VOLUME /var/www/html
WORKDIR /var/www/html
RUN chown -R nobody:nobody /var/www/html

CMD ["nginx", "-g", "daemon off;"]
