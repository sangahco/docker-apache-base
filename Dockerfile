FROM debian:jessie
MAINTAINER Emanuele Disco <emanuele.disco@gmail.com>

RUN apt-get update && apt-get -y install \
    apache2 \
    libapache2-mod-jk \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

COPY . /usr/local/src/

RUN set -xe && \
    cp /usr/local/src/conf/apache2.conf /etc/apache2/apache2.conf && \
    cp /usr/local/src/conf/default-host.conf /etc/apache2/sites-available/ && \
    cp /usr/local/src/conf/ss-cert.pem /etc/ssl/private/ && \

    # # ENABLE MODS
    /usr/sbin/a2enmod ssl && \
    /usr/sbin/a2enmod rewrite && \
    /usr/sbin/a2enmod proxy && \
    /usr/sbin/a2enmod proxy_http && \
    /usr/sbin/a2dissite 000-default && \
    /usr/sbin/a2ensite default-host && \

    # attach the log to stdout
    ln -sf /proc/self/fd/1 ${APACHE_LOG_DIR}/access.log && \
    ln -sf /proc/self/fd/1 ${APACHE_LOG_DIR}/error.log && \
    
    # # FINAL SETTINGS
    cp /usr/local/src/docker-entrypoint.sh /entrypoint.sh && \
    mkdir -p /var/log/apache2 && \
    ln -s /var/log/apache2 /etc/apache2/logs && \
    rm -rf /usr/local/src

#VOLUME /var/log/apache2

EXPOSE 80
EXPOSE 443

RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]