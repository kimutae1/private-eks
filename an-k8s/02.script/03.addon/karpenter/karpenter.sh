# cat << EOF > karpenter-sqs.yaml
# AWSTemplateFormatVersion: "2010-09-09"
# Description: Resources used by https://github.com/aws/karpenter
# Parameters:
#   ClusterName:
#     Type: String
#     Description: "EKS cluster name"
# Resources:
#   KarpenterInterruptionQueue:
#     Type: AWS::SQS::Queue
#     Properties:
#       QueueName: !Sub "karpenter-${cluster_name}"
#       MessageRetentionPeriod: 300
#       SqsManagedSseEnabled: true
#   KarpenterInterruptionQueuePolicy:
#     Type: AWS::SQS::QueuePolicy
#     Properties:
#       Queues:
#         - !Ref KarpenterInterruptionQueue
#       PolicyDocument:
#         Id: EC2InterruptionPolicy
#         Statement:
#           - Effect: Allow
#             Principal:
#               Service:
#                 - events.amazonaws.com
#                 - sqs.amazonaws.com
#             Action: sqs:SendMessage
#             Resource: !GetAtt KarpenterInterruptionQueue.Arn
#   ScheduledChangeRule:
#     Type: 'AWS::Events::Rule'
#     Properties:
#       Name: karpenter-${cluster_name}-ScheduledChangeRule
#       EventPattern:
#         source:
#           - aws.health
#         detail-type:
#           - AWS Health Event
#       Targets:
#         - Id: KarpenterInterruptionQueueTarget
#           Arn: !GetAtt KarpenterInterruptionQueue.Arn
#   SpotInterruptionRule:
#     Type: 'AWS::Events::Rule'
#     Properties:
#       Name: karpenter-${cluster_name}-SpotInterruptionRule
#       EventPattern:
#         source:
#           - aws.ec2
#         detail-type:
#           - EC2 Spot Instance Interruption Warning
#       Targets:
#         - Id: KarpenterInterruptionQueueTarget
#           Arn: !GetAtt KarpenterInterruptionQueue.Arn
#   RebalanceRule:
#     Type: 'AWS::Events::Rule'
#     Properties:
#       Name: karpenter-${cluster_name}-RebalanceRule
#       EventPattern:
#         source:
#           - aws.ec2
#         detail-type:
#           - EC2 Instance Rebalance Recommendation
#       Targets:
#         - Id: KarpenterInterruptionQueueTarget
#           Arn: !GetAtt KarpenterInterruptionQueue.Arn
#   InstanceStateChangeRule:
#     Type: 'AWS::Events::Rule'
#     Properties:
#       Name: karpenter-${cluster_name}-InstanceStateChangeRule
#       EventPattern:
#         source:
#           - aws.ec2
#         detail-type:
#           - EC2 Instance State-change Notification
#       Targets:
#         - Id: KarpenterInterruptionQueueTarget
#           Arn: !GetAtt KarpenterInterruptionQueue.Arn
# EOF

# aws cloudformation deploy \
#   --stack-name karpenter-${cluster_name} \
#   --template-file karpenter-sqs.yaml \
#   --parameter-overrides ClusterName=${cluster_name}

# export KARPENTER_VERSION=v0.29.2
# TEMPOUT=$(mktemp)
# curl -fsSL https://raw.githubusercontent.com/aws/karpenter/"${KARPENTER_VERSION}"/website/content/en/preview/getting-started/getting-started-with-karpenter/cloudformation.yaml > $TEMPOUT \
# && aws cloudformation deploy \
#   --stack-name Karpenter-${cluster_name} \
#   --template-file ${TEMPOUT} \
#   --capabilities CAPABILITY_NAMED_IAM \
#   --parameter-overrides ClusterName=${cluster_name}

# eksctl create iamidentitymapping \
#   --username system:node:{{EC2PrivateDNSName}} \
#   --cluster  ${cluster_name} \
#   --arn arn:aws:iam::${Account}:role/KarpenterNodeRole-${cluster_name} \
#   --group system:bootstrappers \
#   --group system:nodes

# eksctl create iamserviceaccount \
#   --cluster $cluster_name --name karpenter --namespace kube-system \
#   --role-name "${cluster_name}-karpenter" \
#   --attach-policy-arn arn:aws:iam::${Account}:policy/KarpenterControllerPolicy-$cluster_name \
#   --role-only \
#   --approve

# # 1. helm update
# helm repo add karpenter https://charts.karpenter.sh/
# helm repo update

# 2. Install Karpenter
# export KARPENTER_VERSION=v0.29.2
# export CLUSTER_ENDPOINT="$(aws eks describe-cluster --name ${cluster_name} --query "cluster.endpoint" --output text)"
# helm upgrade --install --namespace kube-system \
#   karpenter oci://public.ecr.aws/karpenter/karpenter \
#   --version ${KARPENTER_VERSION}\
#   --set serviceAccount.annotations."eks\.amazonaws\.com/role-arn"=${eks_sa_role} \
#   --set settings.aws.clusterName=${cluster_name} \
#   --set settings.aws.clusterEndpoint=${CLUSTER_ENDPOINT} \
#   --set settings.aws.defaultInstanceProfile=arn:aws:iam::911781391110:instance-profile/EKS-SA-Role \
#   --set settings.aws.interruptionQueueName=karpenter-${cluster_name} \
#   --set nodeSelector."eks\.amazonaws\.com/nodegroup"=nodegroup \
#   --set replicas=1

# 2. Install Karpenter
# export KARPENTER_VERSION=v0.29.2
# export CLUSTER_ENDPOINT="$(aws eks describe-cluster --name ${cluster_name} --query "cluster.endpoint" --output text)"
# helm upgrade --install --namespace kube-system \
#   karpenter oci://public.ecr.aws/karpenter/karpenter \
#   --version ${KARPENTER_VERSION}\
#   --set serviceAccount.annotations."eks\.amazonaws\.com/role-arn"=${eks_node_role} \
#   --set settings.aws.clusterName=${cluster_name} \
#   --set settings.aws.clusterEndpoint=${CLUSTER_ENDPOINT} \
#   --set settings.aws.defaultInstanceProfile=arn:aws:iam::911781391110:instance-profile/eks-2ec56a31-3463-03cf-0279-7f9142eef6d4 \
#   --set settings.aws.interruptionQueueName=karpenter-${cluster_name} \
#   --set nodeSelector."eks\.amazonaws\.com/nodegroup"=nodegroup \
#   --set replicas=1

#2. Install Karpenter
# export KARPENTER_VERSION=v0.29.2
# export KARPENTER_IAM_ROLE_ARN="arn:aws:iam::${Account}:role/${cluster_name}-karpenter"
# export CLUSTER_ENDPOINT="$(aws eks describe-cluster --name ${cluster_name} --query "cluster.endpoint" --output text)"
# helm upgrade --install --namespace kube-system \
#   karpenter oci://public.ecr.aws/karpenter/karpenter \
#   --version ${KARPENTER_VERSION}\
#   --set serviceAccount.annotations."eks\.amazonaws\.com/role-arn"=${KARPENTER_IAM_ROLE_ARN} \
#   --set settings.aws.clusterName=${cluster_name} \
#   --set settings.aws.clusterEndpoint=${CLUSTER_ENDPOINT} \
#   --set settings.aws.defaultInstanceProfile=KarpenterNodeInstanceProfile-${cluster_name} \
#   --set settings.aws.interruptionQueueName=${cluster_name} \
#   --set nodeSelector."eks\.amazonaws\.com/nodegroup"=nodegroup \
#   --set replicas=1

cat << EOF > karpenter-provisioner.yaml
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
      operator: NotIn
      values: [nano, micro, small, medium, large]
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
    karpenter.sh/discovery: ${cluster_name}
  securityGroupSelector:
    karpenter.sh/discovery: ${cluster_name}
  instanceProfile: ${eks_node_role}
  tags:
    KarpenerProvisionerName: "default"
    NodeType: "karpenter-node"
    IntentLabel: "apps"
EOF

kubectl apply -f karpenter-provisioner.yaml

cat << EOF > karpenter-inflate.yaml
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
              cpu: 1
              memory: 1.5Gi
EOF

kubectl apply -f karpenter-inflate.yaml