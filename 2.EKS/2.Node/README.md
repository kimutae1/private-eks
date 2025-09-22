## Node 추가

```
❯ ./02.script/02.make_node/custom_nodegroup_add.sh
Error: error describing cluster stack: no eksctl-managed CloudFormation stacks found for "stg-custom"
2024-08-07 08:58:01 [ℹ]  will use version 1.30 for new nodegroup(s) based on control plane version
2024-08-07 08:58:01 [!]  SSM is now enabled by default; `ssh.enableSSM` is deprecated and will be removed in a future release
2024-08-07 08:58:01 [!]  no eksctl-managed CloudFormation stacks found for "stg-custom", will attempt to create nodegroup(s) on non eksctl-managed cluster
2024-08-07 08:58:02 [ℹ]  nodegroup "nodegroup-m5-xlarge" will use "" [AmazonLinux2023/1.30]
2024-08-07 08:58:02 [ℹ]  1 nodegroup (nodegroup-m5-xlarge) was included (based on the include/exclude rules)
2024-08-07 08:58:02 [ℹ]  will create a CloudFormation stack for each of 1 managed nodegroups in cluster "stg-custom"
2024-08-07 08:58:02 [ℹ]  1 task: { 1 task: { 1 task: { create managed nodegroup nodegroup-m5-xlarge" } } }
2024-08-07 08:58:02 [ℹ]  building managed nodegroup stack "eksctl-stg-custom-nodegroup-nodegroup-m5-xlarge"
2024-08-07 08:58:03 [ℹ]  deploying stack "eksctl-stg-custom-nodegroup-nodegroup-m5-xlarge"
2024-08-07 08:58:03 [ℹ]  waiting for CloudFormation stack "eksctl-stg-custom-nodegroup-nodegroup-m5-xlarge"
2024-08-07 08:58:33 [ℹ]  waiting for CloudFormation stack "eksctl-stg-custom-nodegroup-nodegroup-m5-xlarge"
2024-08-07 08:59:08 [ℹ]  waiting for CloudFormation stack "eksctl-stg-custom-nodegroup-nodegroup-m5-xlarge"
2024-08-07 09:00:38 [ℹ]  waiting for CloudFormation stack "eksctl-stg-custom-nodegroup-nodegroup-m5-xlarge"
2024-08-07 09:00:38 [ℹ]  no tasks
2024-08-07 09:00:38 [✔]  created 0 nodegroup(s) in cluster "stg-custom"
2024-08-07 09:00:38 [ℹ]  nodegroup "nodegroup-m5-xlarge" has 1 node(s)
2024-08-07 09:00:38 [ℹ]  node "i-097395c6c5a476d1c.ap-northeast-2.compute.internal" is ready
2024-08-07 09:00:38 [ℹ]  waiting for at least 1 node(s) to become ready in "nodegroup-m5-xlarge"
2024-08-07 09:00:38 [ℹ]  nodegroup "nodegroup-m5-xlarge" has 1 node(s)
2024-08-07 09:00:38 [ℹ]  node "i-097395c6c5a476d1c.ap-northeast-2.compute.intern al" is ready
2024-08-07 09:00:38 [✔]  created 1 managed nodegroup(s) in cluster "stg-custom "
2024-08-07 09:00:38 [ℹ]  checking security group configuration for all nodegroups
2024-08-07 09:00:38 [ℹ]  all nodegroups have up-to-date cloudformation templates
```

## Node 추가 이후 기본 pod 상태 확인

```
❯ k get po -A
NAMESPACE     NAME                           READY   STATUS    RESTARTS   AGE
kube-system   aws-node-gmfrp                 2/2     Running   0          3m26s
kube-system   coredns-5b9dfbf96-ccjdl        1/1     Running   0          2d1h
kube-system   coredns-5b9dfbf96-d48pd        1/1     Running   0          2d1h
kube-system   eks-pod-identity-agent-w6l8s   1/1     Running   0          3m26s
kube-system   kube-proxy-qj97g               1/1     Running   0          3m26s

```

## aws-auth 에 사용자 or role 등록
먼저 ConfigMap 을 확인 하자

```
k get -n kube-system configmaps aws-auth -o yaml
apiVersion: v1
data:
  mapRoles: |
    - groups:
      - system:bootstrappers
      - system:nodes
      rolearn: arn:aws:iam::123456789012:role/eks-node-role
      username: system:node:{{EC2PrivateDNSName}}
kind: ConfigMap
metadata:
  creationTimestamp: "2024-08-07T08:58:54Z"
  name: aws-auth
  namespace: kube-system
  resourceVersion: "445101"

```
기본 적인 role 하나만 등록되어 있을 것이다.
사용자를 추가 하여 보자

추가 하기 전에 아래 정보 미리 메모해두자

```
❯ aws sts get-caller-identity
    "UserId": "AIDAVRUVSLNVOTJAXOWWL",
    "Account": "123456789012",
    "Arn": "arn:aws:iam::123456789012:user/user@example.com"
```


configmap 수정은 edit를 써서 진행 
```
k edit -n kube-system configmaps aws-auth                    

# Please edit the object below. Lines beginning with a '#' will be ignored,
# and an empty file will abort the edit. If an error occurs while saving this file will be
# reopened with the relevant failures.

apiVersion: v1
data:
  mapRoles: |
    - groups:
      - system:bootstrappers
      - system:nodes
      rolearn: arn:aws:iam::123456789012:role/eks-node-role
      username: system:node:{{EC2PrivateDNSName}}
  mapUsers: |
    - groups:
      - system:bootstrappers
      - system:nodes
      - system:masters
      userarn: arn:aws:iam::123456789012:user/user@example.com
      username: user@example.com

    - groups:
      - system:bootstrappers
      - system:nodes
      - system:masters
      userarn: arn:aws:iam::123456789012:user/dongjoon.kim@bespinglobal.com
      username: dongjoon.kim@bespinglobal.com
```

동준님 계정으로 컨택스트 스왑 하고 pod를 조회 해보자

```
k config use-context dongjoon.kim@bespinglobal.com@stg-custom.ap-northeast-2.eksctl.io
Switched to context "dongjoon.kim@bespinglobal.com@stg-custom.ap-northeast-2.eksctl.io".
❯ k get po -A
NAMESPACE     NAME                           READY   STATUS    RESTARTS   AGE
kube-system   aws-node-gmfrp                 2/2     Running   0          4d17h
kube-system   coredns-5b9dfbf96-ccjdl        1/1     Running   0          6d18h
kube-system   coredns-5b9dfbf96-d48pd        1/1     Running   0          6d18h
kube-system   eks-pod-identity-agent-w6l8s   1/1     Running   0          4d17h
kube-system   kube-proxy-qj97g               1/1     Running   0          4d17h

```


## portal 용 nodegroup 추가 
portal 서비스는 docker image가 arm 으로 되어 있어 기존 x86 node로는 띄울 수가 없다.
그렇기에 nodegroup  을 arm을 지원하는 그라비톤 아키텍처를 지정하고
taint와 affinity를 이용 하여 node를 구성 하도록 하자


c6g로 만들었다가 이것도 만들수 있는 종류는 한정적이라는 것을 알았다.
https://eksctl.io/usage/arm-support/
```
2024-08-14 06:09:54 [✖]  could not select subnets from subnet IDs (allSubnets=v1alpha5.AZSubnet
Mapping{"ap-northeast-2a":v1alpha5.AZSubnetSpec{ID:"subnet-0947044bb30ff3138", AZ:"ap-northeast
-2a", CIDR:(*ipnet.IPNet)(0xc000e8da70), CIDRIndex:0, OutpostARN:""}, "ap-northeast-2b":v1alpha
5.AZSubnetSpec{ID:"subnet-01e8f39bc63ff2723", AZ:"ap-northeast-2b", CIDR:(*ipnet.IPNet)(0xc000e
8da10), CIDRIndex:0, OutpostARN:""}} localZones=[]string(nil) subnets=[]string{"subnet-0947044b
b30ff3138", "subnet-01e8f39bc63ff2723"}): failed to select subnet subnet-0947044bb30ff3138: can
not create nodegroup arm in availability zone ap-northeast-2a as it does not support all requir
ed instance types
```

m6g로 다시 지정 하고 성공 

```
❯ ./custom_nodegroup_add_arm.sh
2024-08-14 06:13:11 [ℹ]  will use version 1.30 for new nodegroup(s) based on control plane vers
ion
2024-08-14 06:13:11 [!]  SSM is now enabled by default; `ssh.enableSSM` is deprecated and will 
be removed in a future release
2024-08-14 06:13:11 [!]  no eksctl-managed CloudFormation stacks found for "stg-custom", will
 attempt to create nodegroup(s) on non eksctl-managed cluster
2024-08-14 06:13:12 [ℹ]  nodegroup "arm" will use "" [AmazonLinux2023/1.30]
2024-08-14 06:13:12 [ℹ]  2 existing nodegroup(s) (ng-arm,nodegroup-m5-xlarge) will be excluded
2024-08-14 06:13:12 [ℹ]  1 nodegroup (arm) was included (based on the include/exclude rules)
2024-08-14 06:13:12 [ℹ]  will create a CloudFormation stack for each of 1 managed nodegroups in
 cluster "stg-custom"
2024-08-14 06:13:12 [ℹ]  1 task: { 1 task: { 1 task: { create managed nodegroup "arm" } } }
2024-08-14 06:13:12 [ℹ]  building managed nodegroup stack "eksctl-stg-custom-nodegroup-arm"
2024-08-14 06:13:12 [ℹ]  deploying stack "eksctl-stg-custom-nodegroup-arm"
2024-08-14 06:13:12 [ℹ]  waiting for CloudFormation stack "eksctl-stg-custom-nodegroup-arm"
2024-08-14 06:13:42 [ℹ]  waiting for CloudFormation stack "eksctl-stg-custom-nodegroup-arm"
2024-08-14 06:14:33 [ℹ]  waiting for CloudFormation stack "eksctl-stg-custom-nodegroup-arm"
2024-08-14 06:15:42 [ℹ]  waiting for CloudFormation stack "eksctl-stg-custom-nodegroup-arm"
2024-08-14 06:15:42 [ℹ]  no tasks
2024-08-14 06:15:42 [✔]  created 0 nodegroup(s) in cluster "stg-custom"
2024-08-14 06:15:42 [ℹ]  nodegroup "arm" has 2 node(s)
2024-08-14 06:15:42 [ℹ]  node "i-02b188b07304431c6.ap-northeast-2.compute.internal" is ready
2024-08-14 06:15:42 [ℹ]  node "i-0429c332df6891d04.ap-northeast-2.compute.internal" is ready
2024-08-14 06:15:42 [ℹ]  waiting for at least 2 node(s) to become ready in "arm"
2024-08-14 06:15:42 [ℹ]  nodegroup "arm" has 2 node(s)
2024-08-14 06:15:42 [ℹ]  node "i-02b188b07304431c6.ap-northeast-2.compute.internal" is ready
2024-08-14 06:15:42 [ℹ]  node "i-0429c332df6891d04.ap-northeast-2.compute.internal" is ready
2024-08-14 06:15:42 [✔]  created 1 managed nodegroup(s) in cluster "stg-custom"
2024-08-14 06:15:42 [ℹ]  checking security group configuration for all nodegroups
2024-08-14 06:15:42 [ℹ]  all nodegroups have up-to-date cloudformation templates
```

### 확인 
```
❯ eksctl get nodegroup --cluster $cluster_name
CLUSTER         NODEGROUP               STATUS  CREATED                 MIN SIZE        MAX SIZE        DESIRE D CAPACITY      INSTANCE TYPE   IMAGE ID                ASG NAME                                             TYPE
stg-custom    arm                     ACTIVE  2024-08-14T06:13:21Z    2               2               2    m 6g.large        AL2023_ARM_64_STANDARD  eks-arm-ccc8a7c2-775c-0635-7e99-1cfc3aecae4a                    managed
stg-custom    nodegroup-m5-xlarge     ACTIVE  2024-08-07T08:58:11Z    1               1               1    m 5.xlarge        AL2023_x86_64_STANDARD  eks-nodegroup-m5-xlarge-e2c89607-aae3-d82c-b5c9-98f4333ed1b8    managed
```
