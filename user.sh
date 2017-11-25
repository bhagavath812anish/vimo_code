

#!/bin/sh
echo -n "Enter username: "
read user
#if getent passwd $1 > /dev/null 2>&1; then
 #  echo "the user exists"
  # exit 1
#fi
adduser $user
echo $user " ALL=(ALL:ALL) ALL" >> /etc/sudoers
mkdir /home/$user/.ssh
chown $user:$user /home/$user/.ssh
cp /root/.ssh/* /home/$user/.ssh/
chown $user:$user /home/$user/.ssh/*
chmod 700 /home/$user/.ssh
cp /root/.bashrc /home/$user/.bashrc
chown $user:$user /home/$user/.bashrc 
