#!/bin/bash
set -e

if [ $# -eq 0 ]; then
    if [ "$APACHE_SSL-0" -eq "1" ]; then
        echo "Executing Apache with SSL" 
        /usr/sbin/a2enconf ssl.conf;
        #/usr/sbin/a2ensite default-ssl \
    else
        echo "Executing Apache without SSL"
    fi

    # if no arguments are supplied start apache
    exec /usr/sbin/apache2ctl -DFOREGROUND
fi

exec "$@"