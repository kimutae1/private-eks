#!/bin/bash
### utils를 사용해 AWS OIDC를 EKS 클러스터와 연결
### approve option은 해당 작업 수행시 EKS의 승인이 필요한 경우 EKSCTL이 자동으로 승인하는 옵션
eksctl utils associate-iam-oidc-provider --cluster $cluster_name --approve

### EKS 클러스터 내에서 IAM 서비스 계정을 생성하는 명령어
### override-existing-serviceaccounts는 동일한 이름을 가진 IAM 계정이 이미 존재하는 경우, 덮어쓰는 옵션
eksctl create iamserviceaccount \
  --cluster=$cluster_name \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --attach-policy-arn=arn:aws:iam::${Account}:policy/AWSLoadBalancerControllerIAMPolicy \
  --override-existing-serviceaccounts \
  --approve

### Subnet에 태그 지정
for x in ${public_a} ${public_c} ${private_a} ${private_c} ; do aws ec2 create-tags --resources $x --tags Key=kubernetes.io/cluster/$cluster_name,Value=owned ; done
for x in ${public_a} ${public_c}  ; do aws ec2 create-tags --resources $x --tags Key=kubernetes.io/role/elb,Value=1 ; done
for x in ${private_a} ${private_c}  ; do aws ec2 create-tags --resources $x --tags Key=kubernetes.io/role/internal-elb,Value=1 ; done


### EKS 클러스터의 kube-system 네임스페이스에 위치한 aws-load-balancer-controller IAM 서비스 계정에 대한 정보를 조회
### 이를 통해 해당 서비스 계정의 ARN(Amazon Resource Name), 관련된 역할(Role) 및 정책(Policy) 등의 세부 정보를 확인할 수 있음
eksctl get iamserviceaccount --cluster $cluster_name --name aws-load-balancer-controller --namespace kube-system

### Helm 차트 저장소를 추가하여, 해당 저장소에 있는 EKS 관련 차트를 설치 및 관리 가능
helm repo add eks https://aws.github.io/eks-charts

### eks-charts라는 Helm 저장소의 해당 경로에 위치한 CRDs를 가져와서 Kubernetes 클러스터에 적용
kubectl apply -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller//crds?ref=master"

### Helm을 사용하여 aws-load-balancer-controller를 설치하고, 필요한 구성 요소와 옵션을 지정하여 AWS 리소스와 EKS 클러스터를 통합
### 이를 통해 로드 밸런서 컨트롤러를 사용하여 로드 밸런서와 관련된 기능을 EKS 클러스터에서 사용할 수 있음
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  --set clusterName=$cluster_name \
  --set serviceAccount.create=false \
  --set region=$region_code \
  --set vpcId=$VpcId \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set subnets.public.enabled=true \
  -n kube-system

### AWS Fargate에서 애플리케이션을 실행하고 AWS 로드 밸런서 컨트롤러를 사용하는 설정을 구성하는 작업을 수행
# eksctl create fargateprofile --cluster $cluster_name --region $region_code --name your-alb-sample-app --namespace game-2048

# sleep 60

# kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.4.4/docs/examples/2048/2048_full.yaml