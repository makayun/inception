FROM alpine:3.16
RUN addgroup -S mysql
RUN adduser --disabled-password --ingroup mysql mysql
RUN apk add --no-cache mariadb mariadb-client
COPY tools/docker-entrypoint.sh /docker-entrypoint.sh
EXPOSE 3306
ENTRYPOINT ["sh", "/docker-entrypoint.sh"]
