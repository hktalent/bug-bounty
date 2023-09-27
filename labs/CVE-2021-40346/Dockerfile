FROM haproxy:2.4.3-alpine

USER root
RUN apk add nodejs

COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg
COPY app.js /
COPY start.sh /

CMD ["/start.sh"]
