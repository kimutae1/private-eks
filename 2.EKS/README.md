
## import variable

환경 변수를 셋팅 해주는 쉘 스크립트이다.  \
경로 : custom-project/docs/an-k8s/0.global_env.sh \
작업을 진행 하는 스크립트에 변수가 셋팅 되어 있다면 변수를 import 하고 시작 하도록 하자 \
당장 불러오기 어려운 일부 값들은 수동으로 넣었다. \
작업을 진행 하기 전에 전체 환경변수를 점검 하자  

<details>
<summary> 0.global_env.sh </summary>

```bash
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
echo Subnets |jq -r '.Subnets'
export private_a="subnet-0947044bb30ff3138"
export private_b="subnet-01e8f39bc63ff2723"

# Security Group
export SG=sg-0da577e13607dfa16

# Certificate ARN
#export cert_arn=$(aws acm list-certificates | jq -r ".CertificateSummaryList[] | select(.DomainName | contains(\"*.$dns_zone\")) | .CertificateArn")

```


### run

```
source 0.global_env.sh 
```

### result
```
#확인 명령어 env
env |grep vpc
vpccidr=10.10.0.0/16
vpc_name=vpc-dev-dorian
vpc_ID=vpc-e74bf58
```

</details>

---
# eks cluster 가 생성된 이후에 작업
## cluster 추가
- console에서 진행한다.
  - 1.Cluster 참조

## ~/.kube/config 셋팅 
```
eksctl utils write-kubeconfig --cluster=stg-custom
```


## Node 추가

  - 2.Node 참조
<details>

```
❯ ./02.script/02.make_node/custom_nodegroup_add.sh
Error: error describing cluster stack: no eksctl-managed CloudFormation stacks found for "stg-custom"
2024-08-07 08:58:01 [ℹ]  will use version 1.30 for new nodegroup(s) based on control plane version
2024-08-07 08:58:01 [!]  SSM is now enabled by default; `ssh.enableSSM` is deprecated and will be removed in a future release
2024-08-07 08:58:01 [!]  no eksctl-managed CloudFormation stacks found for "stg-custom", will attempt to create nodegroup(s) on non eksctl-managed cluster
2024-08-07 08:58:02 [ℹ]  nodegroup "nodegroup-m5-xlarge" will use "" [AmazonLinux2023/1.30]
2024-08-07 08:58:02 [ℹ]  1 nodegroup (nodegroup-m5-xlarge) was included (based on the include/exclude rules)
2024-08-07 08:58:02 [ℹ]  will create a CloudFormation stack for each of 1 managed nodegroups in cluster "stg-custom"
2024-08-07 08:58:02 [ℹ]  1 task: { 1 task: { 1 task: { create managed nodegroup "nodegroup-m5-xlarge" } } }
2024-08-07 08:58:02 [ℹ]  building managed nodegroup stack "eksctl-stg-custom-nodegroup-nodegroup-m5-xlarge"
2024-08-07 08:58:03 [ℹ]  deploying stack "eksctl-stg-custom-nodegroup-nodegroup-m5-xlarge"
2024-08-07 08:58:03 [ℹ]  waiting for CloudFormation stack "eksctl-stg-custom-nodegroup-nodegroup-m5-xlarge"
2024-08-07 08:58:33 [ℹ]  waiting for CloudFormation stack "eksctl-stg-custom-nodegroup-nodegroup-m5-xlarge"
2024-08-07 08:59:08 [ℹ]  waiting for CloudFormation stack "eksctl-stg-custom-nodegroup-nodegroup-m5-xlarge"
2024-08-07 09:00:38 [ℹ]  waiting for CloudFormation stack "eksctl-stg-custom-nodegroup-nodegroup-m5-xlarge"
2024-08-07 09:00:38 [ℹ]  no tasks
2024-08-07 09:00:38 [✔]  created 0 nodegroup(s) in cluster "stg-custom"
2024-08-07 09:00:38 [ℹ]  nodegroup "nodegroup-m5-xlarge" has 1 node(s)
2024-08-07 09:00:38 [ℹ]  node "i-097395c6c5a476d1c.ap-northeast-2.compute.internal" is ready
2024-08-07 09:00:38 [ℹ]  waiting for at least 1 node(s) to become ready in "nodegroup-m5-xlarge"
2024-08-07 09:00:38 [ℹ]  nodegroup "nodegroup-m5-xlarge" has 1 node(s)
2024-08-07 09:00:38 [ℹ]  node "i-097395c6c5a476d1c.ap-northeast-2.compute.internal" is ready
2024-08-07 09:00:38 [✔]  created 1 managed nodegroup(s) in cluster "stg-custom"
2024-08-07 09:00:38 [ℹ]  checking security group configuration for all nodegroups
2024-08-07 09:00:38 [ℹ]  all nodegroups have up-to-date cloudformation templates

```

## Node 추가 이후 기본 pod 상태 확인

```
❯ k get po -A
NAMESPACE     NAME                           READY   STATUS    RESTARTS   AGE
kube-system   aws-node-gmfrp                 2/2     Running   0          3m26s
kube-system   coredns-5b9dfbf96-ccjdl        1/1     Running   0          2d1h
kube-system   coredns-5b9dfbf96-d48pd        1/1     Running   0          2d1h
kube-system   eks-pod-identity-agent-w6l8s   1/1     Running   0          3m26s
kube-system   kube-proxy-qj97g               1/1     Running   0          3m26s

```

</details>
