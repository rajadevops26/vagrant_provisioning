#!/usr/bin/env bash
#!/bin/bash

# install java and jenkins
yum -y update ca-certificates
sudo yum install java-1.8.0-openjdk-devel -y
curl --silent --location http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo | sudo tee /etc/yum.repos.d/jenkins.repo
sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
sudo yum install jenkins -y
sudo systemctl start jenkins
systemctl status jenkins
sudo systemctl enable jenkins


# scp -P 2200 vagrant@127.0.0.1:/vagrant/some-file.txt .


# Disable SELinux
echo "[TASK 1] Disable SELinux"
setenforce 0
sed -i --follow-symlinks 's/^SELINUX=enforcing/SELINUX=disabled/' /etc/sysconfig/selinux

# Stop and disable firewalld
echo "[TASK 2] Stop and Disable firewalld"
systemctl disable firewalld >/dev/null 2>&1
systemctl stop firewalld

# Disable swap
echo "[TASK 3] Disable and turn off SWAP"
sed -i '/swap/d' /etc/fstab
swapoff -a

# Enable ssh password authentication
echo "[TASK 4] Enable ssh password authentication"
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl reload sshd


# Update vagrant user's bashrc file
echo "export TERM=xterm" >> /etc/bashrc


# copy examples into /home/vagrant (from inside the mgmt node)
cp -a file1.txt /home/vagrant
chown -R vagrant:vagrant /home/vagrant
