#! /bin/sh
exec 2> /var/log/wp-install/01.log

###################################################################
# MySql Script
###################################################################
#
# downloads and installs mysql-server
apt-get -y install mysql-server
#
# runs through the settings that would be set by running mysql_secure_installation
mysql -e "UPDATE mysql.user SET authentication_string= '$SQLPASS' WHERE User= 'root';"
mysql -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
mysql -e "DELETE FROM mysql.user WHERE User='';"
mysql -e "FLUSH PRIVILEGES;"
#
# Creates the table needed for Wordpress, defines user and password, and grants permission
mysql -e "CREATE DATABASE $WPHOSTNAME DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
mysql -e "GRANT ALL ON $WPHOSTNAME.* TO '$WPUSERNAME'@'localhost' IDENTIFIED BY '$WPPASSWORD';"
#
done
