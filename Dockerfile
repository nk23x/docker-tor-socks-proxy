FROM alpine:3

LABEL maintainer="mainwhat"
LABEL name="tor-socks-proxy"
LABEL version="0.2"

RUN apk upgrade --prune && \
    apk add --quiet --no-cache tor  

RUN echo -e 'Log notice file /dev/null\nSOCKSPort 0.0.0.0:9050\nDataDirectory /var/lib/tor\nUser tor\n' > /etc/tor/torrc && \
    chown tor /etc/tor/torrc 
    
RUN chown -R tor: /var/lib/tor && \ 
    chmod 700 /var/lib/tor 

USER tor
EXPOSE 9050/tcp

CMD ["/usr/bin/tor", "-f", "/etc/tor/torrc"]

