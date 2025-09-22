#!/bin/bash
rm -rf ~/.kube/config

clusters=(managed service gndchain)
for clusters_name in ${clusters[@]};
  do
    eksctl utils write-kubeconfig --cluster=${env}-${service_zone}-${clusters_name};
  done