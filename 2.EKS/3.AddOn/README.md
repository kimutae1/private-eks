# Addon 설치
>  단순하게 pod를 하나 올리려고 한다면 굳이 addon을 설치를 할 필요는 없다 \
>  그러나 AWS의 자원을 kubernetes에서 관리를 하려면 중간에 조종기 역할을 하는 controller 를 설치해야 \
>  중간에서 alb나 ebs를 관리 할수 있다. 


## 필요한 준비물들
- aws-lb-controller
  - 2.EKS/3.AddOn/1.ingress.md
- csi-controller
