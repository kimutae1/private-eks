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

# 환경변수들은 찾아서 기재!

for svc_name in  ${service_names[@]}  
do
aws ec2 create-vpc-endpoint  \
--subnet-ids subnet-01e8f39bc63ff2723  subnet-0947044bb30ff3138 \
--vpc-id vpc-03f938d63b3dc31d2  \
--service-name  ${svc_name}  \
--vpc-endpoint-type Interface  \
--security-group-id sg-0da577e13607dfa16  
done





#{
#    "Subnets": [
#        {
#            "AvailabilityZone": "ap-northeast-2b",
#            "AvailabilityZoneId": "apne2-az2",
#            "AvailableIpAddressCount": 4090,
#            "CidrBlock": "10.0.144.0/20",
#            "DefaultForAz": false,
#            "MapPublicIpOnLaunch": false,
#            "MapCustomerOwnedIpOnLaunch": false,
#            "State": "available",
#            "SubnetId": "`subnet-01e8f39bc63ff2723",
#            "VpcId": "vpc-03f938d63b3dc31d2",
#            "OwnerId": "381492026218",
#            "AssignIpv6AddressOnCreation": false,
#            "Ipv6CidrBlockAssociationSet": [],
#            "Tags": [
#                {
#                    "Key": "Name",
#                    "Value": "stg-alertnow-subnet-private2-ap-northeast-2b"
#                }
#            ],
#            "SubnetArn": "arn:aws:ec2:ap-northeast-2:381492026218:subnet/subnet-
#01e8f39bc63ff2723",
#            "EnableDns64": false,
#            "Ipv6Native": false,
#            "PrivateDnsNameOptionsOnLaunch": {
#                "HostnameType": "resource-name",
#                "EnableResourceNameDnsARecord": true,
#                "EnableResourceNameDnsAAAARecord": false
#            }
#        },
#        {
#            "AvailabilityZone": "ap-northeast-2a",
#            "AvailabilityZoneId": "apne2-az1",
#            "AvailableIpAddressCount": 4090,
#            "CidrBlock": "10.0.128.0/20",
#            "DefaultForAz": false,
#            "MapPublicIpOnLaunch": false,
#            "MapCustomerOwnedIpOnLaunch": false,
#            "State": "available",
#            "SubnetId": "subnet-0947044bb30ff3138",
#            "VpcId": "vpc-03f938d63b3dc31d2",
#            "OwnerId": "381492026218",
#            "AssignIpv6AddressOnCreation": false,
#            "Ipv6CidrBlockAssociationSet": [],
#            "Tags": [
#                {
#                    "Key": "Name",
#                    "Value": "stg-alertnow-subnet-private1-ap-northeast-2a"
#                }
#            ],
#            "SubnetArn": "arn:aws:ec2:ap-northeast-2:381492026218:subnet/subnet-
#0947044bb30ff3138",
#            "EnableDns64": false,
#            "Ipv6Native": false,
#            "PrivateDnsNameOptionsOnLaunch": {
#                "HostnameType": "resource-name",
#                "EnableResourceNameDnsARecord": true,
#                "EnableResourceNameDnsAAAARecord": false
#            }
#        }
#    ]
#}
