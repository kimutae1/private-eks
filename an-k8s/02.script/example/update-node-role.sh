#!/bin/zsh

if [ $# -eq 0 ] ; then
    echo "input arguments ex) ./update-node-role.sh '$eks_node_role'"
    exit 0
fi

# 변수 설정
#cluster_name="victor-demo-node"
#eks_node_role_name=$(basename ${eks_node_role})
eks_node_role_name=$(basename $1)

additional_policies=("AdministratorAccess" "AmazonEKS_CNI_Policy" "AmazonEC2ContainerRegistryReadOnly" "AmazonEKS_CNI_Policy" "AmazonEKSClusterPolicy" "AmazonEKSWorkerNodePolicy" "AmazonSSMManagedInstanceCore" "AWSXRayDaemonWriteAccess")

## 이전 신뢰정책에서 Federated 값 가져오기
federated_info=$(aws iam get-role --role-name "$eks_node_role_name" --output json | jq -r '.Role.AssumeRolePolicyDocument.Statement[] | select(.Action == "sts:AssumeRoleWithWebIdentity")')
arn_count=$(echo $federated_info| jq -r '.Principal' |grep arn |wc -l)

# Federated 값 조회
if [[ $arn_count -eq 0 ]]; then
  old_federated=()
elif [[ $arn_count -eq 1 ]]; then
  # Federated 값이 1개인 경우
   old_federated=$(echo $federated_info| jq -r '.Principal.Federated')
else
  # Federated 값이 2개 이상인 경우
  old_federated=$(echo $federated_info| jq -r '.Principal.Federated[]')
fi

# 새로운 Federated 값 추가
oidc_url=$(aws eks describe-cluster --name "$cluster_name" --query "cluster.identity.oidc.issuer" --output text)
oidc_arn="arn:aws:iam::$(aws sts get-caller-identity --query 'Account' --output text):oidc-provider/${oidc_url#https://}"
add_federated=("$oidc_arn")


# CASE 1: 기존 Federated 값이 배열인 경우
for value in "${old_federated[@]}"; do
    add_federated+=("$value")
done


new_federated=$(printf '%s\n' "${add_federated[@]}" | jq -R . | jq -s .)

#echo "Old Federated: ${old_federated[*]}"
#echo "New Federated: $new_federated"

role_info=$(aws iam get-role --role-name "$eks_node_role_name" --output json)


echo "### $(date) #####"
echo "###############  SCRIPT START #################"
echo "ROLE : "$eks_node_role_name" "
echo "기존 정책 : $(aws iam get-role --role-name "$eks_node_role_name" --output json | jq .Role.AssumeRolePolicyDocument)"
echo "권한 : $(aws iam list-attached-role-policies --role-name "$eks_node_role_name"|jq -r '.AttachedPolicies[].PolicyName')"
echo "추가 될 OIDC :  $oidc_arn "
echo "----------------------------------"


updated_role_info=$(echo "$role_info" | jq --arg new_federated "$new_federated" '(.Role.AssumeRolePolicyDocument.Statement[] | select(.Action == "sts:AssumeRoleWithWebIdentity")).Principal.Federated = ($new_federated | fromjson)')
updated_role_info=$(echo $updated_role_info|jq -r '.Role.AssumeRolePolicyDocument')


#echo "$updated_role_info"
aws iam update-assume-role-policy --role-name "$eks_node_role_name" --policy-document "$updated_role_info" &


# 추가 정책 연결
for policy in "${additional_policies[@]}"; do
    aws iam attach-role-policy --role-name "$eks_node_role_name" --policy-arn "arn:aws:iam::aws:policy/$policy" &
done

echo "신규 정책 : $(aws iam get-role --role-name "$eks_node_role_name" --output json| jq .Role.AssumeRolePolicyDocument)"
echo "권한 : $(aws iam list-attached-role-policies --role-name "$eks_node_role_name"|jq -r '.AttachedPolicies[].PolicyName')"
echo "###############  SCRIPT END #################"
