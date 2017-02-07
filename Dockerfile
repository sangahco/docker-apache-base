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

COPY . /setup

RUN set -xe && \
    cp /setup/conf/apache2.conf /etc/apache2/apache2.conf && \
    cp /setup/conf/default-host.conf /etc/apache2/sites-available && \

    # # ENABLE MODS
    /usr/sbin/a2enmod ssl && \
    /usr/sbin/a2enmod rewrite && \
    /usr/sbin/a2enmod proxy && \
    /usr/sbin/a2enmod proxy_http && \
    /usr/sbin/a2ensite default-host.conf && \
    /usr/sbin/a2dissite 000-default.conf && \
    # # FINAL SETTINGS
    cp /setup/docker-entrypoint.sh /entrypoint.sh && \
    mkdir -p /var/log/apache2 && \
    ln -s /var/log/apache2 /etc/apache2/logs && \
    rm -rf /setup

#VOLUME /var/log/apache2

EXPOSE 80
EXPOSE 443

RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]