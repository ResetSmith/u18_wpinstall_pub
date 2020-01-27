#! /bin/sh
exec 2> /var/log/wp-install/05.log

###################################################################
# CertBot Installation
###################################################################
#
# installs needed repositories
add-apt-repository -y universe
add-apt-repository -y ppa:certbot/certbot
# CertBot download and install
apt-get -y update
apt-get -y install software-properties-common
apt-get -y install certbot python-certbot-apache
#
#
# Run CertBot
certbot certonly --noninteractive --agree-tos -m webmaster@casat.org \
-d $FQDN --webroot -w /var/www/$HOSTNAME
#
###################################################################
# Apache VHost update
###################################################################
# overwrites apache virtualhost file with a new one that supports SSL
cat << EOF > /etc/apache2/sites-available/$HOSTNAME.conf
<VirtualHost *:80>
        ServerName  $FQDN
        ServerAlias www.$FQDN
	Redirect permanent / https://$FQDN
</VirtualHost>

<VirtualHost *:443>
        ServerAdmin webmaster@casat.org
        DocumentRoot /var/www/$HOSTNAME
        ServerName  $FQDN
        ServerAlias www.$FQDN
        SSLEngine on
        SSLCertificateFile    /etc/letsencrypt/live/$FQDN/fullchain.pem
        SSLCertificateKeyFile /etc/letsencrypt/live/$FQDN/privkey.pem
      <Directory /var/www/$HOSTNAME/>
            Options FollowSymLinks
            AllowOverride All
            Require all granted
      </Directory>

  ErrorLog  \${APACHE_LOG_DIR}/error.log
  CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF
# enables ssl access in apache
a2enmod ssl
#
done
