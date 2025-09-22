#!/bin/bash
#cluster_name=hector-node-role2
eks_node_role_name=EKS-Node-Role
eks_sa_role_name=EKS-SA-Role

# EKS 클러스터 목록 가져오기
clusters=$(aws eks list-clusters --output json --query "clusters")

# 배열 형식으로 추출
cluster_array=($(echo "$clusters" | jq -r '.[]'))

# EKS OIDC를 위한 배열 생성
oidc_array=()

# 각 클러스터에서 OIDC 값을 추출하여 배열에 추가
for cluster in "${cluster_array[@]}"; do
  # EKS 클러스터의 OIDC 공급자 URL 가져오기
  oidc_url=$(aws eks describe-cluster --name "$cluster" --query "cluster.identity.oidc.issuer" --output text)
  oidc_arn="arn:aws:iam::$(aws sts get-caller-identity --query 'Account' --output text):oidc-provider/${oidc_url#https://}"
  oidc_array+=("$oidc_arn")
done

# EKS 클러스터가 없을 경우 임시 OIDC ARN 추가
if [ ${#cluster_array[@]} -eq 0 ]; then
  oidc_array+=("arn:aws:iam::ACCOUNT-ID:oidc-provider/oidc.eks.REGION.amazonaws.com/id/TEMP")
fi

# OIDC 배열을 JSON 형식으로 변환
oidc_json=$(printf '%s\n' "${oidc_array[@]}" | jq -R . | jq -s .)


echo "Clusters: ${cluster_array[*]}"
echo "OIDC Array: ${oidc_array[*]}"
echo "OIDC JSON: $oidc_json"

# 신뢰정책 템플릿에 OIDC 배열 삽입
trust_policy=$(cat <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": $oidc_json
            },
            "Action": "sts:AssumeRoleWithWebIdentity"
        },
        {
            "Effect": "Allow",
            "Principal": {
                "Service": [
                    "eks.amazonaws.com",
                    "eks-fargate-pods.amazonaws.com",
                    "ec2.amazonaws.com"
                ]
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
)

echo "Trust Policy Template:"
echo "$trust_policy"

aws iam create-role --role-name $eks_node_role_name --assume-role-policy-document "$trust_policy" &
aws iam create-role --role-name $eks_sa_role_name --assume-role-policy-document "$trust_policy" &

