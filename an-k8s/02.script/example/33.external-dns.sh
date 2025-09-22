eksctl create iamserviceaccount \
    --name external-dns \
    --namespace kube-system \
    --cluster $cluster_name \
    --role-name $cluster_name-external-dns \
    --attach-policy-arn=arn:aws:iam::911781391110:policy/AllowExternalDNSUpdates \
    --override-existing-serviceaccounts \
    --approve

cat <<EOF > ${YAML_HOME}/${ENV}-external-dns.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: external-dns
  namespace: kube-system
  # If you're using Amazon EKS with IAM Roles for Service Accounts, specify the following annotation.
  # Otherwise, you may safely omit it.
  annotations:
    # Substitute your account ID and IAM service role name below.
    eks.amazonaws.com/role-arn: arn:aws:iam::911781391110:role/${cluster_name}-external-dns
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: external-dns
rules:
- apiGroups: [""]
  resources: ["services","endpoints","pods"]
  verbs: ["get","watch","list"]
- apiGroups: ["extensions","networking.k8s.io"]
  resources: ["ingresses"]
  verbs: ["get","watch","list"]
- apiGroups: [""]
  resources: ["nodes"]
  verbs: ["list","watch"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: external-dns-viewer
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: external-dns
subjects:
- kind: ServiceAccount
  name: external-dns
  namespace: kube-system
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: external-dns
  namespace: kube-system
spec:
  selector:
    matchLabels:
      app: external-dns
  template:
    metadata:
      labels:
        app: external-dns
    spec:
      serviceAccountName: external-dns
      containers:
      - name: external-dns
        image: k8s.gcr.io/external-dns/external-dns:v0.10.2
        args:
        - --source=service
        - --source=ingress
        - --domain-filter=${dns_zone}
        - --provider=aws
        - --policy=upsert-only
        - --aws-zone-type=public
        - --registry=txt
        - --txt-owner-id=Z03689522Y6K96S9DKQ8U
EOF

kubectl apply -f ${YAML_HOME}/${ENV}-external-dns.yaml