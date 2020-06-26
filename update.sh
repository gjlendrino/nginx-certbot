#!/bin/bash

docker-compose -f docker-compose-clear.yml down -v

Añadir a default.conf
    location ~ /.well-known/acme-challenge {
        allow all;
        root /usr/share/nginx/html;
    }
Se debería persistir /etc/letsencrypt que es el Certbot configuration directory
Según certbot:
"The Certbot packages on your system come with a cron job or systemd timer that will renew your certificates automatically before they expire. You will not need to run Certbot again, unless you change your configuration. You can test automatic renewal for your certificates by running this command:
certbot renew --dry-run"
Una vez generados los certificados se deberían utilizar:
* /etc/letsencrypt/live/predex.duckdns.org/fullchain.pem
* /etc/letsencrypt/live/predex.duckdns.org/privkey.pem

docker-compose -f docker-compose-clear.yml up -d
docker exec -it nginx apt update
docker exec -it nginx apt install -y certbot python-certbot-nginx
docker exec -it nginx mkdir -p /usr/share/nginx/html/.well-known/acme-challenge
docker exec -it nginx chown -R $SFTP_USER:www-data /usr/share/nginx/html/.well-known
docker exec -it nginx chmod 6775 /usr/share/nginx/html/.well-known
docker exec -it nginx certbot certonly --nginx --email gjlendrino.tas@gmail.com --agree-tos --no-eff-email -d predex.duckdns.org
Saving debug log to /var/log/letsencrypt/letsencrypt.log
Plugins selected: Authenticator nginx, Installer nginx
Obtaining a new certificate
Performing the following challenges:
http-01 challenge for predex.duckdns.org
2020/06/26 01:23:16 [notice] 1334#1334: signal process started
Waiting for verification...
Cleaning up challenges
2020/06/26 01:23:21 [notice] 1336#1336: signal process started

IMPORTANT NOTES:
 - Congratulations! Your certificate and chain have been saved at:
   /etc/letsencrypt/live/predex.duckdns.org/fullchain.pem
   Your key file has been saved at:
   /etc/letsencrypt/live/predex.duckdns.org/privkey.pem
   Your cert will expire on 2020-09-24. To obtain a new or tweaked
   version of this certificate in the future, simply run certbot
   again. To non-interactively renew *all* of your certificates, run
   "certbot renew"
 - Your account credentials have been saved in your Certbot
   configuration directory at /etc/letsencrypt. You should make a
   secure backup of this folder now. This configuration directory will
   also contain certificates and private keys obtained by Certbot so
   making regular backups of this folder is ideal.
 - If you like Certbot, please consider supporting our work by:

   Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
   Donating to EFF:                    https://eff.org/donate-le



docker cp $NGINX_CONTAINER_ID:/etc/letsencrypt/archive/predex.duckdns.org/fullchain1.pem fullchain.pem
docker cp $NGINX_CONTAINER_ID:/etc/letsencrypt/archive/predex.duckdns.org/privkey1.pem privkey.pem
docker cp $NGINX_CONTAINER_ID:/etc/letsencrypt/options-ssl-nginx.conf .
docker cp $NGINX_CONTAINER_ID:/etc/letsencrypt/ssl-dhparams.pem .
