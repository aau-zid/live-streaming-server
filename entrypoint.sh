#!/bin/sh
export DOLLAR='$'
if [ "${ENABLE_SSL_CERTBOT}" = "true" ] 
then
    cd /etc/nginx/templates && cat nginx.conf.header.template nginx.conf.ssl.template nginx.conf.footer.template > nginx.conf.template
    envsubst < /etc/nginx/templates/nginx.conf.template > /etc/nginx/nginx.conf
    certbot certonly --standalone -d $STREAMING_SERVER_DOMAIN --email $STREAMING_SERVER_EMAIL -n --agree-tos --expand --deploy-hook "nginx -s reload"
else
    cd /etc/nginx/templates && cat nginx.conf.header.template nginx.conf.no_ssl.template nginx.conf.footer.template > nginx.conf.template
   envsubst < /etc/nginx/templates/nginx.conf.template > /etc/nginx/nginx.conf 
fi  

/usr/sbin/nginx -g "daemon off;"