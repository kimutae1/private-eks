#!/bin/bash

# Fargate 기반 Cluster를 생성하는 YAML 파일 작성
cat <<EOF > ${YAML_HOME}/${ENV}-eks-fargate-$cluster_name.yaml
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig
metadata:
 name: ${cluster_name}
 region: ${region_code}

###### fargate noderole = session name !!!!!!!!!!!!!!!
iamIdentityMappings:
  - arn: $eks_sa_role
    groups:
      - system:masters
      - system:bootstrappers
      - system:node-proxier
      - system:nodes
    username: system:node:{{SessionName}}
    noDuplicateARNs: true # prevents shadowing of ARNs

  - arn: $sso_role
    groups:
      - system:masters
      - system:bootstrappers
      - system:node-proxier
      - system:nodes
    username: system:node:{{SessionName}}
    noDuplicateARNs: true # prevents shadowing of ARNs

  - arn: $devops_role
    groups:
      - system:masters
      - system:bootstrappers
      - system:node-proxier
      - system:nodes
    username: system:node:{{SessionName}}
    noDuplicateARNs: true # prevents shadowing of ARNs

vpc:
  id: ${VpcId}
  cidr: ${CidrBlock}
  subnets:
    private:
      `aws ec2 describe-subnets --subnet-ids $private_a |jq -r '.Subnets[].AvailabilityZone'`:
         id: ${private_a}
      `aws ec2 describe-subnets --subnet-ids $private_c |jq -r '.Subnets[].AvailabilityZone'`:
         id: ${private_c}
    public:
      `aws ec2 describe-subnets --subnet-ids $public_a |jq -r '.Subnets[].AvailabilityZone'`:
         id: ${public_a}
      `aws ec2 describe-subnets --subnet-ids $public_c |jq -r '.Subnets[].AvailabilityZone'`:
         id: ${public_c}

fargateProfiles:
  - name: fp-default
    podExecutionRoleARN: $eks_node_role
    selectors:
      - namespace: default
      - namespace: kube-system
      - namespace: managed
      - namespace: aws-observability
    subnets:
      - ${private_a}
      - ${private_c}

iam:
  serviceRoleARN: $eks_node_role
  fargatePodExecutionRoleARN: $eks_node_role
  withOIDC: true
  serviceAccounts:
  - metadata:
      name: eks-sa-role
      namespace: kube-system
    attachRoleARN: $eks_sa_role

addons:
- name: vpc-cni
  version: latest
  serviceAccountRoleARN: $eks_node_role
EOF

cat ${YAML_HOME}/${ENV}-eks-fargate-$cluster_name.yaml

eksctl create cluster -f ${YAML_HOME}/${ENV}-eks-fargate-$cluster_name.yaml  

kubectl create namespace aws-observability

cat << EOF > ${YAML_HOME}/${ENV}-configmap-$cluster_name.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-logging
  namespace: aws-observability
data:
  output.conf: |
    [OUTPUT]
      Name cloudwatch_logs
      Match *
      region ap-northeast-2
      log_group_name $cluster_name-logging
      log_stream_prefix from-
      auto_create_group true
      log_key log
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: cluster-env
  namespace: kube-system
data:
  env: $cluster_env
EOF

kubectl apply -f ${YAML_HOME}/${ENV}-configmap-$cluster_name.yaml
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/high-availability-1.21+.yaml