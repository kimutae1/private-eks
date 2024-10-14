#!/bin/bash

nfs_server="192.168.252.49"   # nfs server 의 IP
nfs_dir_path="/app"            # nfs server의 shared dir
client_dir="/mnt/example/crypted" # client 에 mount할 dir

apt update
apt install -y nfs-common

mkdir -p $client_dir
mount -t nfs $nfs_server:$nfs_dir_path $client_dir
ls $client_dir


#자동 마운트
echo "$nfs_server:$nfs_dir_path $client_dir nfs defaults 0 0" | sudo tee -a /etc/fstab


