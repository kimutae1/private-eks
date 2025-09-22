#!/bin/bash

# Fargate profile 생성 yaml
cat <<EOF > ${YAML_HOME}/${ENV}-eks-fargate-profile.yaml
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig
metadata:
 name: ${cluster_name}
 region: ${region_code}

fargateProfiles:
  - name: fp-default
    podExecutionRoleARN: $eks_engine_role
    selectors:
      - namespace: default
      - namespace: kube-system
      - namespace: managed
    subnets:
      - ${private_a}
      - ${private_c}
EOF

cat ${YAML_HOME}/${ENV}-eks-fargate-profile.yaml

eksctl create fargateprofile -f ${YAML_HOME}/${ENV}-eks-fargate-profile.yaml  