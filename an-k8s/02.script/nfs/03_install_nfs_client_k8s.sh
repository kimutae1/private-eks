#!/bin/bash

nfs_server="192.168.252.49"
nfs_dir_path="/app"

kubectl create namespace nfs-provisioner
helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/
helm repo update

helm install nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
--set nfs.server=$nfs_server \
--set nfs.path=$nfs_dir_path \
--set storageClass.defaultClass=true



