#!/bin/bash

# Repo 설치
helm repo add external-dns https://kubernetes-sigs.github.io/external-dns/
helm repo update external-dns

# external-dns helm에서 사용할 values.yaml 생성
cat << EOF > ${YAML_HOME}/${ENV}-my-values.yaml
serviceAccount:
  create: false
  name: eks-sa-role

sources:
  - service
  - ingress

policy: upsert-only
registry: txt
domainFilters: [$dns_list]
provider: aws
EOF


# Helm Values를 통해 External DNS 설치
helm upgrade --install -f ${YAML_HOME}/${ENV}-my-values.yaml --namespace kube-system external-dns external-dns/external-dns