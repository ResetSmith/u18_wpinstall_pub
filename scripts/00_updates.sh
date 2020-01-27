#! /bin/sh
exec 2> /var/log/wp-install/00.log

###################################################################
# Server Updates
###################################################################
#
apt-get -y update
apt-get -y upgrade
#
done
