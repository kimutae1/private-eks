#!/bin/bash

apt update
apt install -y nfs-kernel-server

shared_directory="/app"
export_options="rw,sync,no_root_squash"
allowed_subnet="192.168.252.0/24"


echo "$shared_directory $allowed_subnet($export_options)" | sudo tee -a /etc/exports

# 설정 적용 및 서비스 재시작
exportfs -a
systemctl restart nfs-kernel-server
systemctl enable nfs-kernel-server

echo "NFS 서버가 성공적으로 구성되었습니다."