#!/usr/bin/env bash
#!/bin/bash
# install ansible (http://docs.ansible.com/intro_installation.html)
#apt-get -y install software-properties-common
#apt-add-repository -y ppa:ansible/ansible
#apt-get update
#apt-get -y install ansible
yum install ansible -y >/dev/null 2>&1
yum update
ansible --version

# Disable SELinux
echo "[TASK 4] Disable SELinux"
setenforce 0
sed -i --follow-symlinks 's/^SELINUX=enforcing/SELINUX=disabled/' /etc/sysconfig/selinux

# Stop and disable firewalld
echo "[TASK 5] Stop and Disable firewalld"
systemctl disable firewalld >/dev/null 2>&1
systemctl stop firewalld

# Disable swap
echo "[TASK 7] Disable and turn off SWAP"
sed -i '/swap/d' /etc/fstab
swapoff -a

# Enable ssh password authentication
echo "[TASK 11] Enable ssh password authentication"
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl reload sshd

# Set Root password
echo "[TASK 12] Set root password"
echo "kubeadmin" | passwd --stdin root >/dev/null 2>&1

# Update vagrant user's bashrc file
echo "export TERM=xterm" >> /etc/bashrc


# copy examples into /home/vagrant (from inside the mgmt node)
#cp -a /vagrant/examples/* /home/vagrant
chown -R vagrant:vagrant /home/vagrant

# ssh key generation
sudo -i
ssh-keygen -t rsa
#cat .ssh/id_rsa.pub
touch .ssh/authorized_keys
#ssh-copy-id root@10.0.15.16 -yes

# configure hosts file for our internal network defined by Vagrantfile
cat >> /etc/hosts <<EOL
# vagrant environment nodes
10.0.15.15  mgmt
10.0.15.16  lb
EOL
