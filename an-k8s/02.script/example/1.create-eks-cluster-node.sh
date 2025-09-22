cat << EOF > ${YAML_HOME}/${ENV}-eks-demo-cluster.yaml
---
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig
metadata:
 name: ${cluster_name}
 region: ${region_code}

iamIdentityMappings:
  - arn: $eks_node_role
    groups:
      - system:masters
      - system:bootstrappers
      - system:nodes
    username: system:node:{{EC2PrivateDNSName}}
    noDuplicateARNs: true # prevents shadowing of ARNs

  - arn: $eks_sa_role
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

  - arn: $sso_role
    groups:
      - system:masters
      - system:bootstrappers
      - system:node-proxier
      - system:nodes
    username: system:node:{{SessionName}}
    noDuplicateARNs: true # prevents shadowing of ARNs

iam:
  serviceRoleARN: $eks_node_role
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

managedNodeGroups:
  - name: nodegroup # 클러스터의 노드 그룹명
    instanceType: t3.medium # 클러스터 워커 노드의 인스턴스 타입
    desiredCapacity: 1 # 클러스터 워커 노드의 갯수
    volumeSize: 30  # 클러스터 워커 노드의 EBS 용량 (단위: GiB)
    privateNetworking: true
    ssh:
      enableSsm: true
    iam:
      instanceRoleARN: $eks_node_role

cloudWatch:
  clusterLogging:
    enableTypes: ["*"]
EOF

cat ${YAML_HOME}/${ENV}-eks-demo-cluster.yaml

eksctl create cluster -f ${YAML_HOME}/${ENV}-eks-demo-cluster.yaml

cat << EOF > ${YAML_HOME}/${ENV}-create-sa.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: eks-sa-role 
  namespace: default
  annotations:
    eks.amazonaws.com/role-arn: $eks_sa_role
EOF

#metric
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/high-availability-1.21+.yaml
kubectl apply -f ${YAML_HOME}/${ENV}-create-sa.yaml
