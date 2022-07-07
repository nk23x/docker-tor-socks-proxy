FROM alpine:latest

LABEL maintainer="mainwhat"
LABEL name="tor-socks-proxy"
LABEL version="latest"

RUN echo '@ltst_cm https://dl-cdn.alpinelinux.org/alpine/latest-stable/community' >> /etc/apk/repositories && \
    apk -U upgrade && \
    apk --no-cache  --quiet add tor@ltst_cm losetup cryptsetup xfsprogs && \
    echo -e 'Log notice file /dev/null\nSOCKSPort 0.0.0.0:9050\nDataDirectory /var/lib/tor\nUser tor\n' > /etc/tor/torrc && \
    chown tor /etc/tor/torrc && \
    dd if=/dev/urandom of=/tmp/data bs=20M count=1 iflag=fullblock && \
    losetup /dev/loop0 /tmp/data && \
    cryptsetup open --use-urandom /dev/loop0 data && \
    mkfs.xfs -f -q /dev/mapper/data && \
    mount -t xfs /dev/mapper/data /var/lib/tor && \
    chown -R tor: /var/lib/tor && \ 
    chmod 700 /var/lib/tor 

USER tor
EXPOSE 9050/tcp

CMD ["/usr/bin/tor", "-f", "/etc/tor/torrc"]

## CMD should include some init file to run
##    umount -f /var/lib/tor && \
##    cryptsetup close data && \
##    losetup --detach /dev/loop0 && \
##    rm -f /tmp/data 

