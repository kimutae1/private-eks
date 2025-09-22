#!/bin/bash

export env="stg"
export ENV="stg"
export account_id=$(aws sts get-caller-identity | jq -r '.Account')


export K8S_HOME=$(pwd)
export YAML_HOME=$K8S_HOME/03.service_yaml
export service_name="service"
export cluster_name="${env}-custom"

export service_zone=custom # Service Zone
#export dns_a=argo # A record

# eks-role = cluster create / node-add
export eks_node_role=$(aws iam get-role --role-name EKS-Node-Role | jq -r '.Role.Arn') # export Cluster, Node Role
export eks_sa_role=$(aws iam get-role --role-name EKS-SA-Role | jq -r '.Role.Arn') # export SA Role
export devops_role=$(aws iam get-role --role-name devops-role | jq -r '.Role.Arn') # export devops_role
export region_code=$(aws configure list |grep region |awk '{print $2}') # Region Code
export vpc_name=$(aws ec2 describe-vpcs  | jq -r '.Vpcs[].Tags[].Value' | grep ${service_zone}) ; # VPC Name
export domain=custompsdev.com # domain


# CidrBlock, VpcId
export $(aws ec2 describe-vpcs --filters Name=tag:Name,Values=${vpc_name} | \
jq -r '.Vpcs[]|{CidrBlock, VpcId}|to_entries|.[]|[.key, .value]|join("=")')

# UserId, Account, RoleArn
export $(aws sts get-caller-identity |jq  -r '.|to_entries|.[]|[.key, .value]|join("=")')


export Subnets=$(aws ec2 describe-subnets --filters "Name=tag:Name,Values=${env}-custom-subnet-private*-${region_code}*" )
export private_a="subnet-0947044bb30ff3138"
export private_b="subnet-01e8f39bc63ff2723"



# Security Group
export SG=sg-0da577e13607dfa16

# Certificate ARN
#export cert_arn=$(aws acm list-certificates | jq -r ".CertificateSummaryList[] | select(.DomainName | contains(\"*.$dns_zone\")) | .CertificateArn")
export cert_arn="arn:aws:acm:ap-northeast-2:381492026218:certificate/f67870a1-7aae-4717-849a-090af81b6455"
