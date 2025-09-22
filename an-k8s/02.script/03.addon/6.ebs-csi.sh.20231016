# EBS CSI 플러그 인이 사용자를 대신하여 AWS API를 호출하려면 IAM 권한이 필요합니다
# 클러스터에 기존 IAM OIDC 제공업체가 있는지 확인합니다.
# 클러스터의 OIDC 제공업체 ID를 검색하고 변수에 저장합니다.
oidc_id=$(aws eks describe-cluster --name $cluster_name --query "cluster.identity.oidc.issuer" --output text | cut -d '/' -f 5)

# 클러스터 ID를 가진 IAM OIDC 제공업체가 이미 계정에 있는지 확인합니다.
aws iam list-open-id-connect-providers | grep $oidc_id | cut -d "/" -f4



# IAM 역할을 생성하고 필요한 AWS 관리형 정책을 연결합니다
# IAM 역할을 생성하는 AWS CloudFormation 스택을 배포하고, IAM 정책을 연결하고, 
# IAM 역할의 Amazon 리소스 이름(ARN)으로 기존 ebs-csi-controller-sa 서비스 계정에 주석을 추가.

eksctl create iamserviceaccount \
  --name ebs-csi-controller-sa \
  --namespace kube-system \
  --cluster $cluster_name \
  --attach-policy-arn arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy \
  --approve \
  --role-only \
  --role-name AmazonEKS_EBS_CSI_DriverRole


# EBS 볼륨 암호화를 위한 KMS 사용
cat << EOF > kms-key-for-encryption-on-ebs.json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "kms:CreateGrant",
        "kms:ListGrants",
        "kms:RevokeGrant"
      ],
      "Resource": ["$kms"],
      "Condition": {
        "Bool": {
          "kms:GrantIsForAWSResource": "true"
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ],
      "Resource": ["$kms"]
    }
  ]
}
EOF


# 정책 생성
aws iam create-policy \
  --policy-name KMS_Key_For_Encryption_On_EBS_Policy \
  --policy-document file://kms-key-for-encryption-on-ebs.json \
  --no-cli-pager

# 정책 연결
aws iam attach-role-policy \
  --policy-arn arn:aws:iam::$Account:policy/KMS_Key_For_Encryption_On_EBS_Policy \
  --role-name AmazonEKS_EBS_CSI_DriverRole


# eksctl을 사용하여 Amazon EBS CSI 추가 기능(Add-ons)을 추가합니다
eksctl create addon \
--name aws-ebs-csi-driver \
--cluster $cluster_name \
--service-account-role-arn arn:aws:iam::$Account:role/AmazonEKS_EBS_CSI_DriverRole \
--force