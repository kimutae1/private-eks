cat << EOF > ${YAML_HOME}/${ENV}-nodegroup_add.yaml
kind: ClusterConfig
apiVersion: eksctl.io/v1alpha5
metadata:
    name: ${cluster_name}
    region: ${region_code}



vpc:
  id: ${VpcId}
  cidr: ${CidrBlock}
  subnets:
    private:
      `aws ec2 describe-subnets --subnet-ids $private_a |jq -r '.Subnets[].AvailabilityZone'`:
         id: ${private_a}
      `aws ec2 describe-subnets --subnet-ids $private_b |jq -r '.Subnets[].AvailabilityZone'`:
         id: ${private_b}
  securityGroup: ${SG}

managedNodeGroups:

  - name: nodegroup-m5-xlarge # 클러스터의 노드 그룹명
    instanceType: m5.xlarge # 클러스터 워커 노드의 인스턴스 타입
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


eksctl utils update-legacy-subnet-settings --cluster ${cluster_name}
#eksctl create nodegroup --cluster=$cluster_name --name="${cluster_name}-Node" --region $region_code --config-file=nodegroup_add.yaml
eksctl create nodegroup --config-file=${YAML_HOME}/${ENV}-nodegroup_add.yaml
