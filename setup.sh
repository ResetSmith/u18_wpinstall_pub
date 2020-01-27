#! /bin/sh

###################################################################
# Lightweight WordPress Installer
###################################################################
#
clear
#
# defines the 'pause' function which pauses script waiting for [enter] to be pressed
function pause () {
    read -p "$*"
}
###################################################################
# Interactive Section
###################################################################
#
echo -e "\nThis script was created to help automate the installation and configuration
of WordPress sites on Ubuntu 18 servers. It will prompt you for some basic information
regarding the site and then use that to configure the server. It is best to run this
on a freshly created Ubuntu 18 VPS.

The only information you will need to complete this script is your website's Fully
Qualified Domain Name (FQDN). The rest of the information like Usernames and Passwords
you can come up with as we go. "
#
pause '
Please press [Enter] to proceed'
#
clear
echo "
Please input the 'Fully Qualified Domain Name' (FQDN) for the new site. The
FQDN is the complete domain name and suffix, ie: 'example.com'. At this time the
script does not support domains beginning with www."
# 'checker' and 'flag' variables are used to check inputs for spaces
CHECKER="[[:space:]]+"
FLAG=1
while [ ${FLAG} -eq 1 ];
do
  echo  "
  What is the FQDN of this site?"
  read FQDN
  if [[ "${FQDN}" =~ $CHECKER ]];
    then
    echo ""
    echo "The FQDN cannot contain spaces. Please re-enter a valid site name."
    echo ""
  else
    sleep 2
    FLAG=0
    clear
  fi
done

echo "
Please input a password for the MySql database root user. The root user is the
maintenance account for the database. This is similar to an admin account."
FLAG=1
while [ ${FLAG} -eq 1 ];
do
  echo  "
  What should the database root password be?"
  read SQLPASS
  if [[ "${SQLPASS}" =~ $CHECKER ]];
    then
    echo ""
    echo "The Password cannot contain spaces. Please re-enter a valid Password."
    echo ""
  else
    sleep 2
    FLAG=0
    clear
  fi
done

echo "
Please input a password for the Wordpress MySql user. This password is for the
user that wordpress uses to write to the database and edit the site. It should
be different from the root user password. The Wordpress username will be auto
generated based on the website name."
FLAG=1
while [ ${FLAG} -eq 1 ];
do
  echo  "
  What should the Wordpress User password be?"
  read WPPASSWORD
  if [[ "${WPPASSWORD}" =~ $CHECKER ]];
    then
    echo ""
    echo "The Password cannot contain spaces. Please re-enter a valid Password."
    echo ""
  else
    sleep 2
    FLAG=0
    clear
  fi
done

# takes FQDN and removes the suffix to create the hostname
# removes the last 4 characters from the FQDN
# this willnot work if suffix is longer than .com/.org etc...
HOSTNAME=$(sed 's/....$//' <<< "$FQDN")
# generates the wordpress database and user names
# capitalizes the hostname variable
WPHOSTNAME="WP_${HOSTNAME^^}"
WPUSERNAME="USER_${HOSTNAME^^}"
#
echo "This script will create a Wordpress site using the following information.
Be sure to review these fields before continuing."

echo "
The FQDN (site address) will be:
$FQDN"
echo -ne ".\r"
sleep .5
echo -ne "..\r"
sleep .5
echo -ne "...\r"
sleep .5
echo ""

echo "
The Hostname will be:
$HOSTNAME"
echo -ne ".\r"
sleep .5
echo -ne "..\r"
sleep .5
echo -ne "...\r"
sleep .5
echo ""

echo "
The MySql Wordpress database will be:
$WPHOSTNAME"
echo -ne ".\r"
sleep .5
echo -ne "..\r"
sleep .5
echo -ne "...\r"
sleep .5
echo ""

echo "
The MySql root user password will be:
$SQLPASS"
echo -ne ".\r"
sleep .5
echo -ne "..\r"
sleep .5
echo -ne "...\r"
sleep .5
echo ""

echo "
The MySql Wordpress user will be:
$WPUSERNAME"
echo -ne ".\r"
sleep .5
echo -ne "..\r"
sleep .5
echo -ne "...\r"
sleep .5
echo ""

echo "
The MySql Wordpress user password will be:
$WPPASSWORD"
echo -ne ".\r"
sleep .5
echo -ne "..\r"
sleep .5
echo -ne "...\r"
sleep .5
echo ""
# calls the pause function
pause '

Copy this information down before proceeding.
Press [Enter] key to continue with the installation.
Or press [Ctrl-C] to stop the installation.'

clear
#
###################################################################
# General Settings
# Server settings, updates, and dependency installs
###################################################################
#
echo "Installing needed dependencies for this script."
echo -ne ".\r"
sleep 1
echo -ne "..\r"
sleep 1
echo -ne "...\r"
sleep 1
echo -ne "....\r"
sleep 1
echo -ne ".....\r\n"
#
# sets server updates to be done unattended
export DEBIAN_FRONTEND=noninteractive
#
# checks for log folder and creates it if it doesn't exist
if [ ! -d /var/log/wp-install ]; then
    mkdir -p /var/log/wp-install
fi
#
# checks for updates
apt-get -y update
#
# installs 'pv' to act as progress bar during script
apt-get -y install pv
#
# clears screen
clear
#
###################################################################
# Script Section
###################################################################
#
# amends a line to the logfile to make it easier to read
echo -e "\n\n\n----------Server Updates----------\n" >> /var/log/wp-install/install.log
# prints line to screen to label the loading bar
echo -n "\nServer Updates"
# runs script while using 'pv' to show some status info
while source ./scripts/00_updates.sh; do echo "server updates"; sleep 1; done|pv -N 01_Server_Updates >> /var/log/wp-install/install.log
# Pauses before moving to next section
sleep 5
#
echo -e "\n\n\n----------MySql Installation----------\n" >> /var/log/wp-install/install.log
echo -n "\nMySql Installation"
while source ./scripts/01_mysql.sh; do echo "mysql"; sleep 1; done|pv -N 01_MySql_Install >> /var/log/wp-install/install.log
sleep 5
#
echo -e "\n\n\n----------Apache Installation----------\n" >> /var/log/wp-install/install.log
echo -n "\nApache Installation"
while source ./scripts/02_apache.sh; do echo "apache"; sleep 1; done|pv -N 02_Apache_Install >> /var/log/wp-install/install.log
sleep 5
#
echo -e "\n\n\n----------PHP Installation----------\n" >> /var/log/wp-install/install.log
echo -n "\nPHP Installation"
while source ./scripts/03_php.sh; do echo "PHP"; sleep 1; done|pv -N 03_PHP_Install >> /var/log/wp-install/install.log
sleep 5
#
echo -e "\n\n\n----------WordPress Installation----------\n" >> /var/log/wp-install/install.log
echo -n "\nWordPress Installation"
while source ./scripts/04_wordpress.sh; do echo "WordPress"; sleep 1; done|pv -N /var/log/wp-install/install.log
sleep 5
#
echo -e "\n\n\n----------CertBot Installation----------\n" >> /var/log/wp-install/install.log
echo -n "\nCertBot Installation"
while source ./scripts/05_certbot.sh; do echo "CertBot"; sleep 1; done|pv -N 05_CertBot_Install >> /var/log/wp-install/install.log
sleep 5
#
echo -e "\n\n\n----------Services----------\n" >> /var/log/wp-install/install.log
echo -n "\nFirewall Settings and Service Restarts"
while source ./scripts/06_restarts.sh; do echo "Restarts"; sleep 1; done|pv -N 06_Services >> /var/log/wp-install/install.log
sleep 5
#
# changes interactive updates back to default
unset DEBIAN_FRONTEND
# calls the pause function to wait for reboot
pause '

Installation has completed. After rebooting you should connect as the new user account
and then disable remote login as root for security purposes. Logs for the installation
can be found in /var/log/wp-install/.
Please press [Enter] to continue.'
#
echo -e "\nInstallation has completed. Server will reboot in 25 seconds."
echo -ne '[.........................]\r'
sleep 5
echo -ne '[#####....................]\r'
sleep 5
echo -ne '[##########...............]\r'
sleep 5
echo -ne '[###############..........]\r'
sleep 5
echo -ne '[####################.....]\r'
sleep 5
echo -ne '[#########################]\r'
sleep 2
echo -e "\nGood Bye"
#
# reboots server
reboot
