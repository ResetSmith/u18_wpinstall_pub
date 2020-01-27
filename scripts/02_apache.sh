#! /bin/sh
exec 2> /var/log/wp-install/02.log

###################################################################
# Apache Install Script
###################################################################
#
# download and install apache server
apt-get -y install apache2
#
# amends the hostname to the apache2.conf file
echo "servername $HOSTNAME" >> /etc/apache2/apache2.conf
# creates virtualhost file
touch /etc/apache2/sites-available/$HOSTNAME.conf
# VirtualHost File
# during the certbot installation this will be replaced
# with a SSL compatible vhost file
cat << EOF > /etc/apache2/sites-available/$HOSTNAME.conf
<VirtualHost *:80>
ServerAdmin webmaster@casat.org
ServerName $FQDN
ServerAlias www.$FQDN
DocumentRoot /var/www/$HOSTNAME

<Directory /var/www/$HOSTNAME/>
Options FollowSymLinks
AllowOverride All
Require all granted
</Directory>

ErrorLog \${APACHE_LOG_DIR}/error.log
CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF
# enables new virtualhost file
a2ensite $HOSTNAME.conf
# disables apache default virtualhost file
a2dissite 000-default.conf
# enables rewrites from within virtualhost file
a2enmod rewrite
#
done
