# Repo 설치
helm repo add external-dns https://kubernetes-sigs.github.io/external-dns/
helm repo update external-dns

# external-dns helm에서 사용할 values.yaml 생성
cat << EOF > my-values.yaml
serviceAccount:
  create: false
  annotations: {
    eks.amazonaws.com/role-arn: arn:aws:iam::911781391110:role/${cluster_name}-eks-all-role-sa
    }
  name: "eks-all-role-sa"

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