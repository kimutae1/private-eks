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
      `aws ec2 describe-subnets --subnet-ids $private_b |jq -r '.Subnets[].AvailabilityZone'`:
         id: ${private_b}

EOF
cat ${YAML_HOME}/${ENV}-eks-demo-cluster.yaml
eksctl create cluster -f ${YAML_HOME}/${env}-eks-demo-cluster.yaml
eksctl utils write-kubeconfig --cluster=${cluster_name}

#nodeRole에 신규 클러스터의 OICD를  iam 신뢰관계에 등록
echo "#### UPDATE NODE ROLE ####"
./update-node-role.sh $eks_node_role >> update-node-role.log
./update-node-role.sh $eks_sa_role >> update-node-role.log

kubectl set env daemonset aws-node -n kube-system ENABLE_PREFIX_DELEGATION=true
kubectl set env ds aws-node -n kube-system WARM_PREFIX_TARGET=1

cat << EOF > ${YAML_HOME}/${ENV}-eks-demo-cluster-node.yaml
vpc:
kind: ClusterConfig
apiVersion: eksctl.io/v1alpha5
metadata:
 name: ${cluster_name}
 region: ${region_code}

managedNodeGroups:
  - name: nodegroup # 클러스터의 노드 그룹명
    instanceType: m5.medium # 클러스터 워커 노드의 인스턴스 타입
    desiredCapacity: 1 # 클러스터 워커 노드의 갯수
    volumeSize: 30  # 클러스터 워커 노드의 EBS 용량 (단위: GiB)
    privateNetworking: true
    maxPodsPerNode: 50
    ssh:
      enableSsm: true
    iam:
      instanceRoleARN: $eks_node_role

cloudWatch:
  clusterLogging:
    enableTypes: ["*"]
EOF

cat ${YAML_HOME}/${env}-eks-demo-cluster-node.yaml
#eksctl create nodegroup --config-file=${YAML_HOME}/${env}-eks-demo-cluster-node.yaml


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
kubectl apply -f ${YAML_HOME}/cluster-sa-role.yaml
