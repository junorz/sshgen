#!/bin/bash
#====================================================================
# A SSH keygen script for VPS Server 
#
# Copyright (c) 2011-2015 Junorz.com All rights reserved.
# 
#====================================================================

# Check root permission 
if [ $(id -u) != "0" ]; then
    echo "Error:Please login as root to run this script"
    exit 1
fi

# Check if file /root/.ssh/keys exist
if [ -f /root/.ssh/authorized_keys ] || [ -f /root/.ssh/id_rsa ] || [ -f /root/.ssh/id_rsa.pub ] ; then
    read -p "Error:/root/.ssh/keys exist. Would you like to delete it? [Y/N]" deletekey
    if [ "$deletekey" = "Y" ] || [ "$deletekey" = "y" ]; then
        rm -rf /root/.ssh/authorized_keys
        rm -rf /root/.ssh/id_rsa
        rm -rf /root/.ssh/id_rsa.pub
        echo "Keys under /root/.ssh have been deleted."
    else
        echo "Script faild."
        exit 1
    fi
fi

read -p "Warning: Please keep the directory of key files by default [Enter]"

ssh-keygen -t rsa

myip=$(/sbin/ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:")
echo "Now please download id_rsa file you have generated just now and press Enter"
read -p "e.g. scp root@$myip:/root/.ssh/id_rsa ~/Documents/keys/id_rsa [Press Enter if you have done]"

echo "Renaming id_rsa.pub to authorized_keys..."
mv /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys

echo "Changing authorized_keys' permission to 600..."
chmod 600 /root/.ssh/authorized_keys

echo "Backing up sshd_config..."
backuptime=$(date "+%Y%m%d_%H%M%S")
cp /etc/ssh/sshd_config /etc/ssh/sshd_config_backup_$backuptime
echo "sshd_config has backed up to sshd_config_backup_$backuptime"

echo "Setting RSAAuthentication yes..."
sed -i "s/^#RSAAuthentication yes$/RSAAuthentication yes/g" /etc/ssh/sshd_config

echo "Setting PubkeyAuthentication yes..."
sed -i "s/^#PubkeyAuthentication yes$/RSAAuthentication yes/g" /etc/ssh/sshd_config

/etc/init.d/sshd restart

echo "Please try logging in with key file, if it succeed please enter Y."
read -p "e.g. ssh root@$myip -i ~/Documents/keys/id_rsa [Y/N]" loginsucceed
if [ "$loginsucceed" = "Y" ] || [ "$loginsucceed" = "y" ]; then 
    sed -i "s/^PasswordAuthentication yes$/PasswordAuthentication no/g" /etc/ssh/sshd_config
    /etc/init.d/sshd restart
    echo "Done.You can add your key path to ~/.ssh/config to enable auto login."
    echo "Here is an example:"
    echo "========================================="
    echo "Host yourhost"
    echo "Hostname yourIP"
    echo "IdentityFile ~/path/yourprivate.key"
    echo "User root"
    echo "========================================="
    echo "View https://www.junorz.com/archives/523.html to see more information."
else
    echo "Script failed. Please check it manually."
fi
