### Subnet에 태그 지정
#for x in ${public_a} ${public_c} ${private_a} ${private_c} ; do aws ec2 create-tags --resources $x --tags Key=kubernetes.io/cluster/$cluster_name,Value=owned ; done
#for x in ${public_a} ${public_c}  ; do aws ec2 create-tags --resources $x --tags Key=kubernetes.io/role/elb,Value=1 ; done
#for x in ${private_a} ${private_c}  ; do aws ec2 create-tags --resources $x --tags Key=kubernetes.io/role/internal-elb,Value=1 ; done


for x in ${private_a} ${private_b} ; do aws ec2 create-tags --resources $x --tags Key=kubernetes.io/cluster/$cluster_name,Value=owned ; done
for x in ${private_a} ${private_b}  ; do aws ec2 create-tags --resources $x --tags Key=kubernetes.io/role/internal-elb,Value=1 ; done

### EKS 클러스터의 kube-system 네임스페이스에 위치한 aws-load-balancer-controller IAM 서비스 계정에 대한 정보를 조회
### 이를 통해 해당 서비스 계정의 ARN(Amazon Resource Name), 관련된 역할(Role) 및 정책(Policy) 등의 세부 정보를 확인할 수 있음
# eksctl get iamserviceaccount --cluster $cluster_name --name $eks_sa_name --namespace kube-system

### Helm 차트 저장소를 추가하여, 해당 저장소에 있는 EKS 관련 차트를 설치 및 관리 가능
helm repo add eks https://aws.github.io/eks-charts
helm repo update

### eks-charts라는 Helm 저장소의 해당 경로에 위치한 CRDs를 가져와서 Kubernetes 클러스터에 적용
kubectl apply -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller/crds?ref=master"

### Helm을 사용하여 aws-load-balancer-controller를 설치하고, 필요한 구성 요소와 옵션을 지정하여 AWS 리소스와 EKS 클러스터를 통합
### 이를 통해 로드 밸런서 컨트롤러를 사용하여 로드 밸런서와 관련된 기능을 EKS 클러스터에서 사용할 수 있음
helm upgrade --install aws-load-balancer-controller eks/aws-load-balancer-controller \
  --set clusterName=$cluster_name \
  --set serviceAccount.create=true \
  --set region=$region_code \
  --set vpcId=$VpcId \
  --set serviceAccount.name=eks-sa-role \
  --set subnets.public.enabled=false \
  -n kube-system
