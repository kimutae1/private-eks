# privateEKS  Install Hands On

<div style="text-align: right;"> 작성자 : dorian </div>

## AWS

- VPC
- IAM
- SecretManager
- EC2
- MQ
- RDS
- DynamoDB
- Route53

## Component

- Provisioning
  - menual

## EKS

- Resource
  - NameSpace
  - ServiceAccount
  - Ingress
- ArgoRollOut
  - deployment
  - svc(service)
  - Mesh : Istio

## CICD

- CI : Jenkins
- CD : ArgoCD
- SCM : AWS CodeCommit

## workload 특징

- 작업자 PC 특성
- network 구조
- IAM 정책

---
eks cluster 가 생성된 이후에 작업
cluster 추가
eksctl utils write-kubeconfig --cluster=private-eks-Prod
eksctl utils write-kubeconfig --cluster=private-eks-ArgoCD-Prod

ex_shell)

```
#!/bin/bash
rm -rf ~/.kube/config

clusters=(xxx yyy zzz)
for clusters_name in ${clusters[@]};
  do
    eksctl utils write-kubeconfig --cluster=${env}-${service_zone}-${clusters_name};
  done

```
