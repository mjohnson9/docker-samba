FROM phusion/baseimage:latest
MAINTAINER Michael Johnson <michael@johnson.computer>

RUN apt-get update \
 && apt-get install -y samba samba-common && \
 apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD smb.conf /etc/samba/smb.conf
ADD create-users.sh /etc/samba/create-users.sh
ADD start.sh /root/start.sh

CMD /etc/samba/create-users.sh && rm /etc/samba/create-users.sh && exec /root/start.sh

VOLUME /data/homes /data/media
EXPOSE 139 445
EXPOSE 137/udp 138/udp
