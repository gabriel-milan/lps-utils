#!/bin/bash

echo "This script will clear all docker images and docker containers on this machine, besides clearing all files from Rancher, in order to setup a brand new cluster"

if [ "$EUID" -ne 0 ]
  then echo "=== This should be ran with root privileges. Exiting..."
  exit
fi

echo "Clearing docker containers..."
CLIST=$(docker ps -qa)
if [ "x"$CLIST == "x" ]; then
  echo "No containers exist - skipping container cleanup"
else
  docker rm -f $CLIST
fi

echo "Clearing docker networks..."
NLIST=$(docker network ls -q)
if [ "x"$NLIST == "x" ]; then
  echo "No networks exist - skipping..."
else
  docker network rm $NLIST
fi

echo "Clearing docker images..."
ILIST=$(docker images -a -q)
if [ "x"$ILIST == "x" ]; then
  echo "No images exist - skipping image cleanup"
else
  docker rmi -f $ILIST
fi

echo "Clearing docker volumes..."
VLIST=$(docker volume ls -q)
if [ "x"$VLIST == "x" ]; then
  echo "No volumes exist - skipping volume cleanup"
else
  docker volume rm -f $VLIST
fi

echo "Clearing Rancher dirs..."
DLIST="/var/lib/etcd /etc/kubernetes /etc/cni /opt/cni /var/lib/cni /var/run/calico /opt/rke"
for dir in $DLIST; do
  echo "Removing $dir"
  rm -rf $dir
done
