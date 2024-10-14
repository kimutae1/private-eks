# AWS

## VPC
>
> 실제 고객사에 들어가게 되면 private subnet만 구성이 되어 있을 것이다. \
> 이 경우에 밖으로 인터넷이 통하게 되는 IGW , NAT 등은 구성이 되어 있지 않다. \
> 여기서 문제가 되는 경우는 private subnet으로 만 구성을 할 경우 \
> AWS 내부 서비스도 API 호출이 되지 않는데 그렇기에 VPC EndPoint 를 구성 해서 해결 할 수 있다

- subnet
- NAT
- G/W
- ENDPOINT
- EKS , ECS , 주요 연동 시 필요한 endpoint는 아래와 같다.\
  최소이자 필수 endpoint 이니 기본으로 설치하자

```
com.amazonaws.ap-northeast-2.s3
com.amazonaws.ap-northeast-2.sts
com.amazonaws.ap-northeast-2.ec2
com.amazonaws.ap-northeast-2.rds
com.amazonaws.ap-northeast-2.ecs
com.amazonaws.ap-northeast-2.ecr.api
com.amazonaws.ap-northeast-2.ecr.dkr
com.amazonaws.ap-northeast-2.cloudformation
com.amazonaws.ap-northeast-2.secretsmanager
com.amazonaws.ap-northeast-2.logs
com.amazonaws.ap-northeast-2.sqs
com.amazonaws.ap-northeast-2.eks
com.amazonaws.ap-northeast-2.codecommit
com.amazonaws.ap-northeast-2.elasticloadbalancing
com.amazonaws.ap-northeast-2.git-codecommit
com.amazonaws.ap-northeast-2.s3
com.amazonaws.ap-northeast-2.dynamodb
com.amazonaws.ap-northeast-2.dynamodb
com.amazonaws.ap-northeast-2.sns
com.amazonaws.ap-northeast-2.ssm
```

일괄 설치 스크립트는 다음과  같다/
../scripts/vpc_endpoint_mng.sh

<details>

```bash
#!/bin/bash
#############################
## all vpc endpoint delete ## 
#############################

#vpce_ids=(vpce-00374486f175f2047  vpce-073a65081908f0d65  vpce-08de61b814a694f20  vpce-0b927a697e9357d0f  vpce-0e3c1c6c1474b83d9 vpce-02071541b9ad01187  vpce-07f60d3a3e07b9304  vpce-091c7e02a2ca59c7a  vpce-0c453ebf70b79df8b   vpce-035acfc28e81f7b9f  vpce-086b66cdf50c244e7  vpce-092593750b5057712  vpce-0d8815b50d48f63cc  vpce-06b33c81a183eb6fa  vpce-08c17dea6020f15e2  vpce-0a3bd77c45ccc26ee  vpce-0e19874ed24e1fb3c)
#
#for x in ${vpce_ids[@]} ;do aws --no-cli-pager ec2 delete-vpc-endpoints --vpc-endpoint-ids $x; done

#aws ec2 create-vpc-endpoint \
#    --vpc-id vpc-1a2b3c4d \
#    --service-name com.amazonaws.us-east-1.sts \
#    --vpc-endpoint-type Interface \
#    --subnet-ids subnet-7b16de0c \
#    --security-group-id sg-1a2b3c4d
#
#############################
## all vpc endpoint create ## 
#############################


export service_names=(
com.amazonaws.ap-northeast-2.s3 
com.amazonaws.ap-northeast-2.sts
com.amazonaws.ap-northeast-2.ec2
com.amazonaws.ap-northeast-2.rds
com.amazonaws.ap-northeast-2.ecs
com.amazonaws.ap-northeast-2.ecr.api
com.amazonaws.ap-northeast-2.ecr.dkr
com.amazonaws.ap-northeast-2.cloudformation
com.amazonaws.ap-northeast-2.secretsmanager
com.amazonaws.ap-northeast-2.logs
com.amazonaws.ap-northeast-2.sqs
com.amazonaws.ap-northeast-2.eks
com.amazonaws.ap-northeast-2.codecommit
com.amazonaws.ap-northeast-2.elasticloadbalancing
com.amazonaws.ap-northeast-2.git-codecommit
com.amazonaws.ap-northeast-2.s3
com.amazonaws.ap-northeast-2.dynamodb
com.amazonaws.ap-northeast-2.dynamodb
com.amazonaws.ap-northeast-2.sns
com.amazonaws.ap-northeast-2.ssm
)

#vpc-id , subnetid, security group은 수작업으로 기입!

for svc_name in  ${service_names[@]}  
do
aws ec2 create-vpc-endpoint  \
--subnet-ids subnet-01e8f39bc63ff2723  subnet-0947044bb30ff3138 \
--vpc-id vpc-03f938d63b3dc31d2  \
--service-name  ${svc_name}  \
--vpc-endpoint-type Interface  \
--security-group-id sg-0da577e13607dfa16  
done
```

</details>

- IAM
- SecretManager
- EC2
- MQ
- RDS
- DynamoDB
- Route53

> 여기까지가 기본이고 하다보면 더 생길수도..
