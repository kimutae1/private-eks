#!/bin/bash

### utils를 사용해 AWS OIDC를 EKS 클러스터와 연결
### approve option은 해당 작업 수행시 EKS의 승인이 필요한 경우 EKSCTL이 자동으로 승인하는 옵션
eksctl utils associate-iam-oidc-provider --cluster $cluster_name --approve

# IamServiceAccount 생성
eksctl create iamserviceaccount \
    --name ${eks_sa_role} \
    --namespace kube-system \
    --cluster $cluster_name \
    --role-name ${eks_service_role_name} \
    --attach-policy-arn=arn:aws:iam::$Account:policy/all-policy \
    --override-existing-serviceaccounts \
    --approve

cat <<EOF > ${eks_sa_role}-cr.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: ${eks_sa_role}-cr
rules:
  - apiGroups: ["*"]
    resources: ["*"]
    verbs: ["*"]

---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: ${eks_sa_role}-crb
subjects:
  - kind: ServiceAccount
    name: ${eks_sa_role}
    namespace: kube-system 
roleRef:
  kind: ClusterRole
  name: ${eks_sa_role}-cr
  apiGroup: rbac.authorization.k8s.io

EOF

kubectl apply -f ${eks_sa_role}-cr.yaml