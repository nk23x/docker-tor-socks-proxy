FROM alpine:latest

LABEL maintainer="mainwhat"
LABEL name="tor-socks-proxy"
LABEL version="latest"

RUN echo '@ltst_cm https://dl-cdn.alpinelinux.org/alpine/latest-stable/community' >> /etc/apk/repositories && \
    apk upgrade --latest --prune && \
    apk add --latest --quiet --no-cache tor@ltst_cm losetup cryptsetup xfsprogs

RUN echo -e 'Log notice file /dev/null\nSOCKSPort 0.0.0.0:9050\nDataDirectory /var/lib/tor\nUser tor\n' > /etc/tor/torrc && \
    chown tor /etc/tor/torrc 
    
RUN dd if=/dev/urandom of=/tmp/data bs=20M count=1 iflag=fullblock && \
    mkfs.xfs -f -q /tmp/data && \
    mount -o loop -t xfs /tmp/data /var/lib/tor && \
    chown -R tor: /var/lib/tor && \ 
    chmod 700 /var/lib/tor 

USER tor
EXPOSE 9050/tcp

CMD ["/usr/bin/tor", "-f", "/etc/tor/torrc"]

## CMD should include some init file to run
##    umount -f /var/lib/tor && \
##    rm -f /tmp/data 

