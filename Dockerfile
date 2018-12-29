FROM alpine:latest
LABEL MAINTAINER="Tobias Watzl <twatzl@gmx.at>" \
    Description="Simple and lightweight Samba docker container, based on Alpine Linux." \
    Version="1.1.0"

# upgrade base system and install samba and supervisord
RUN apk --no-cache upgrade && apk --no-cache add samba samba-common-tools supervisor

# create a dir for the config and the share
RUN mkdir -p /config/supervisord /config/etc /shares

# volume mappings
VOLUME /config /shares

# exposes samba's default ports (137, 138 for nmbd and 139, 445 for smbd)
EXPOSE 137/udp 138/udp 139 445

ADD ./scripts /scripts
ADD ./config /default_config

CMD ["supervisord", "-c", "/config/supervisord/supervisord.conf"]
