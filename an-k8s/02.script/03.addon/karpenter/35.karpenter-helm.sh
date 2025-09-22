# Karpenter SA Create
cat << EOF > karpenter-sa-${cluster_name}.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: eks-node-role
  namespace: kube-system
  annotations:
    eks.amazonaws.com/role-arn: ${eks_node_role}
EOF
kubectl apply -f karpenter-sa-${cluster_name}.yaml

# Install Karpenter
helm repo add karpenter https://charts.karpenter.sh/
helm repo update
export KARPENTER_VERSION=v0.29.2
export CLUSTER_ENDPOINT="$(aws eks describe-cluster --name ${cluster_name} --query "cluster.endpoint" --output text)"
helm upgrade --install --namespace kube-system \
  karpenter oci://public.ecr.aws/karpenter/karpenter \
  --version ${KARPENTER_VERSION}\
  --set serviceAccount.annotations."eks\.amazonaws\.com/role-arn"=${eks_node_role} \
  --set settings.aws.clusterName=${cluster_name} \
  --set settings.aws.clusterEndpoint=${CLUSTER_ENDPOINT} \
  --set settings.aws.defaultInstanceProfile=arn:aws:iam::911781391110:instance-profile/eks-2ec56a31-3463-03cf-0279-7f9142eef6d4 \
  --set settings.aws.interruptionQueueName=karpenter-sqs \
  --set nodeSelector."eks\.amazonaws\.com/nodegroup"=nodegroup \
  --set replicas=1

sleep 60

# Karpenter Provisioner Create
cat << EOF > karpenter-provisioner-${cluster_name}.yaml
apiVersion: karpenter.sh/v1alpha5
kind: Provisioner
metadata:
  name: default
spec:
  labels:
    intent: apps
  requirements:
    - key: karpenter.sh/capacity-type
      operator: In
      values: ["spot"]
    - key: karpenter.k8s.aws/instance-size
      operator: In
      values: ["medium"]
    - key: node.kubernetes.io/instance-type
      operator: In
      values: ["t3.medium"]
  limits:
    resources:
      cpu: 1000
      memory: 1000Gi
  ttlSecondsAfterEmpty: 30
  ttlSecondsUntilExpired: 2592000
  providerRef:
    name: default
---
apiVersion: karpenter.k8s.aws/v1alpha1
kind: AWSNodeTemplate
metadata:
  name: default
spec:
  subnetSelector:
    kubernetes.io/cluster/${cluster_name}: owned
  securityGroupSelector:
    aws:eks:cluster-name: ${cluster_name}
  instanceProfile: EKS-Node-Role
  tags:
    KarpenerProvisionerName: "default"
    NodeType: "karpenter-node"
EOF

kubectl apply -f karpenter-provisioner-${cluster_name}.yaml

# Karpenter Scale-Out Test yaml
cat << EOF > karpenter-inflate-${cluster_name}.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: inflate
spec:
  replicas: 0
  selector:
    matchLabels:
      app: inflate
  template:
    metadata:
      labels:
        app: inflate
    spec:
      nodeSelector:
        intent: apps
      containers:
        - name: inflate
          image: public.ecr.aws/eks-distro/kubernetes/pause:3.2
          resources:
            requests:
              cpu: "250m"
              memory: "64Mi"
EOF

kubectl apply -f karpenter-inflate-${cluster_name}.yaml