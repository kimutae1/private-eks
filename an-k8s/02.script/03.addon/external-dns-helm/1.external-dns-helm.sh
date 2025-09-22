# IamServiceAccount 생성
eksctl create iamserviceaccount \
    --name external-dns \
    --namespace kube-system \
    --cluster $cluster_name \
    --role-name $cluster_name-external-dns \
    --attach-policy-arn=arn:aws:iam::911781391110:policy/AllowExternalDNSUpdates \
    --override-existing-serviceaccounts \
    --approve

# Repo 설치
helm repo add external-dns https://kubernetes-sigs.github.io/external-dns/
helm repo update external-dns

# external-dns helm에서 사용할 values.yaml 생성
cat << EOF > my-values.yaml
serviceAccount:
  create: true
  annotations: {
    eks.amazonaws.com/role-arn: arn:aws:iam::911781391110:role/${cluster_name}-external-dns
    }
  name: "external-dns"

sources:
  - service
  - ingress

policy: upsert-only
registry: txt
txtOwnerId: "Z03689522Y6K96S9DKQ8U"
domainFilters: [$dns_zone]
provider: aws
EOF


# Helm Values를 통해 External DNS 설치
helm upgrade --install -f my-values.yaml \
  --namespace kube-system external-dns external-dns/external-dns