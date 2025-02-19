FROM alpine:3.16
RUN apk add --no-cache nginx openssl
COPY tools/docker-entrypoint.sh /docker-entrypoint.sh
EXPOSE 443

ENTRYPOINT ["sh", "/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
