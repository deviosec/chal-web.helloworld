FROM alpine:3.9

LABEL maintainer="eyJhb <eyjhbb@gmail.com>"

ENV VERSION 1.0

ENV FLAG CTF{1337HelloToYou!}

EXPOSE 80

RUN \
    apk add --no-cache nginx && \
    mkdir -p /run/nginx/ && \
    mkdir -p /var/www/html/

COPY src /

ENTRYPOINT ["./init.sh"]
