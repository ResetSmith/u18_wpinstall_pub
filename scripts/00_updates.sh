#! /bin/sh
exec 2> /var/log/wp-install/00.log

###################################################################
# Server Updates
###################################################################
#
apt-get -y update
apt-get -y upgrade
#
###################################################################
# User account creation
###################################################################
#
# creates user home, and .ssh folders
mkdir -p /home/$USER/.ssh
#
# creates the authorized_keys file for ssh keys
touch /home/$USER/.ssh/authorized_keys
#
# adds user to the 'sudo' group
useradd -d /home/$USER $USER
usermod -aG sudo $USER
#
# updates permisisons for the user and folders
chown -R $USER:$USER /home/$USER
chown root:root /home/$USER
chmod 700 /home/$USER/.ssh
chmod 644 /home/$USER/.ssh/authorized_keys
#
# sets temporary password for user
echo $USER:$USER_PASS | chpasswd
#
# forces user to update password on next login
#passwd -e $USER
#
done
