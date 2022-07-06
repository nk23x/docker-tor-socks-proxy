FROM alpine:latest

LABEL maintainer="mainwhat"
LABEL name="tor-socks-proxy"
LABEL version="latest"

RUN echo '@ltst_cm https://dl-cdn.alpinelinux.org/alpine/latest-stable/community' >> /etc/apk/repositories && \
    apk -U upgrade && \
    apk -v add tor@ltst_cm curl && \
    chmod 700 /var/lib/tor && \
    rm -rf /var/cache/apk/* && \
    tor --version
COPY --chown=tor:root torrc /etc/tor/

USER tor
EXPOSE 8853/udp 9150/tcp

CMD ["/usr/bin/tor", "-f", "/etc/tor/torrc"]
