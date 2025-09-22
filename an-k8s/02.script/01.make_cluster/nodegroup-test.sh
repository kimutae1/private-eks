cat << EOF > ${YAML_HOME}/${env}-eks-demo-cluster-node.yaml
vpc:
  subnets:
    private:
      `aws ec2 describe-subnets --subnet-ids $private_a |jq -r '.Subnets[].AvailabilityZone'`:
         id: ${private_a}
      `aws ec2 describe-subnets --subnet-ids $private_c |jq -r '.Subnets[].AvailabilityZone'`:
         id: ${private_c}
kind: ClusterConfig
apiVersion: eksctl.io/v1alpha5
metadata:
 name: ${cluster_name}
 region: ${region_code}

managedNodeGroups:
  - name: test-nodegroup # 클러스터의 노드 그룹명
    instanceType: m5.large # 클러스터 워커 노드의 인스턴스 타입
    desiredCapacity: 1 # 클러스터 워커 노드의 갯수
    volumeSize: 30  # 클러스터 워커 노드의 EBS 용량 (단위: GiB)
    max-pods-per-node 110
    privateNetworking: true
    ssh:
      enableSsm: true
    iam:
      instanceRoleARN: $eks_node_role

cloudWatch:
  clusterLogging:
    enableTypes: ["*"]
EOF
