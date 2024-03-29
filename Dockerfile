FROM alpine

RUN apk add --no-cache --update lighttpd git bash

COPY ./conf/lighttpd.conf /etc/lighttpd/lighttpd.conf 

COPY docker-entrypoint.sh /run.sh

WORKDIR /var/www/htdocs

EXPOSE 8080

CMD /run.sh && lighttpd -Df /etc/lighttpd/lighttpd.conf
