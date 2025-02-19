FROM alpine:3.16
ENV PHPIZE_DEPS="autoconf dpkg-dev dpkg file g++ gcc libc-dev make pkgconf re2c musl-dev openssl-dev php8-pear php8-dev"
RUN apk add --no-cache php8 \
	php8-dom \
	php8-fpm \
	php8-ftp \
	php8-gd \
	php8-openssl \
	php8-phar \
	php8-iconv \
	php8-mbstring \
	php8-mysqli \
	php8-tokenizer \
	php8-zlib \
	mariadb-client
RUN apk --no-cache add $PHPIZE_DEPS \
	&& pecl install -o -f redis \
	&& rm -rf /tmp/pear \
	&& apk del --no-cache $PHPIZE_DEPS
RUN ln -s /usr/sbin/php-fpm8 /usr/sbin/php-fpm

# Get wp-cli to customize WP install in the entrypoint
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -O /usr/local/bin/wp
RUN chmod +x /usr/local/bin/wp
# https://github.com/wp-cli/config-command/issues/141
RUN cp /usr/local/bin/wp /usr/local/bin/wp-cli.phar

COPY tools/docker-entrypoint.sh /docker-entrypoint.sh
EXPOSE 9000
ENTRYPOINT ["sh", "/docker-entrypoint.sh"]
CMD ["php-fpm", "-F"]
