#! /bin/#!/bin/sh
exec 2> /var/log/wp-install/06.log

###################################################################
# Firewall Settings
###################################################################
#
ufw allow in "Apache Full"
ufw allow ssh
yes | ufw enable
#
###################################################################
# Service Restarts
###################################################################
#
systemctl restart mysql
systemctl restart apache2
#
done
