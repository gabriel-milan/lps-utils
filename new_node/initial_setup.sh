#!/bin/bash

echo "This script will setup a brand new node!"
echo "-- Disclaimer: this script is meant to work only on CentOS!!!"

if [ "$EUID" -ne 0 ]
  then echo "=== This should be ran with root privileges. Exiting..."
  exit
fi

echo "Running yum update..."
yum update -y

echo "Installing few things..."
yum install -y gcc g++ vim net-tools curl

echo "Assuring no version of docker is currently installed..."
yum remove -y docker docker-common docker-selinux docker-engine

echo "Installing dependencies..."
yum install -y yum-utils device-mapper-persistent-data lvm2

echo "Adding docker repository..."
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

echo "Installing docker..."
yum install -y docker-ce

echo "Enabling docker on boot..."
systemctl start docker
systemctl enable docker

echo "Disabling firewall..."
systemctl stop firewalld
systemctl disable firewalld
systemctl mask --now firewalld

echo "Making initial settings for disabling SELinux..."
setenforce 0
