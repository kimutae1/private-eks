## terraform 구성은 인터넷 연결 등 해결 해야 할 이슈가 많아 사용 안하는 것으로 결정 

```
terraform init                                                                                                                                                ✔  1956  09:42:14  
Initializing the backend...

Successfully configured the backend "s3"! Terraform will automatically
use this backend unless the backend configuration changes.
Error refreshing state: Unable to access object "prod/terraform.tfstate" in S3 bucket 
"alertnow-terraform-state-prod": operation error S3: HeadObject, https response error StatusCode: 403, 
RequestID: EJPGT1K9J8132RN7, HostID: b1OQ/DLKVNtxuE+QK744WE8+kqcLUxawzmPlfG7mSOlay+Ys5Q2tXo8YpenY3K23JGKdaZQvg+Q=, 
api error Forbidden: Forbidden
```


# s3에 backend 생성 
- bucket 명은 고유 해야 하기 때문에 버킷명에 kbds를 추가


```
aws s3 mb s3://kbds-alertnow-terraform-state-prod                 

make_bucket failed: s3://alertnow-terraform-state-prod An error occurred
(BucketAlreadyExists) when calling the CreateBucket operation: 
The requested bucket name is not available. The bucket namespace is shared by all users of the system. 
Please select a different name and try again.
```


```
terraform init
terraform plan
terraform apply

```


## error 수정 중 
```
Message_: "The key pair 'Alertnow-prod-key-pair' does not exist"
```

```
# AWS CLI를 사용하여 키페어 생성
aws ec2 create-key-pair --key-name Alertnow-prod-key-pair 
{
    "KeyFingerprint": "95:d0:7a:0b:40:05:2c:57:17:ad:63:7c:d4:d7:2c:c8:f3:d0:39:89",
    "KeyMaterial": "-----BEGIN RSA PRIVATE KEY-----\nMIIEpAIBAAKCAQEAuO20M16GfKpDOGjR4ecSgI4ab68W
9Mh2gX9wW+6VjX8E9sxm\nT9ad8zxx4sLg5m/4XcMNM04zld0ojnKvnEENdrEVeedfIjyegkJyGXQNdtie9vTB\nEuKHW+v7C
8SZETN25yUYP4xOjWSUF/M8xRKj/M+osXgtLEyFTigZZj31KsD7t84D\n1YapDvXFuPaU6432EtlHlIY0ySaUfwE5HxmkWex/
+jpKf1CNvMbAgv0Erj5BXuBk\nLmmI1sTJo5BDnDsB0Uh5pJH+mj7NOmZKVn3cTqu/yAfk3R2D9dUtmYNgICCcoWx5\n7OHiX
ECU0eJKdLw9amFy+VD3BEt6LbxcAdinbwIDAQABAoIBACrsoeM6kaTmMGwr\niGwTIqxMT76UuZNf5IHyfrYYDwak8RYII8ds
XYVUBmtIKMPUQaYh3DKIeFjU2NEX\ntcNjJijiucVt+xsLTw+VNL7LvURUy7Eu5pHnmtuvTrpQi+b+Nx838QTvIFyZd/aH\nM
xfbV80atmFbL8EUkeyuShb9Uqb1dxWDuLRJ5rQN1qDcNCbwI1l6y3VjC650/s8B\nImRkG6cFwRmcALDPE0+KSf0HjIDi6iCn
B6GBlBqE3F9rmo/Rf/5VDTEtCjBvYtBQ\nhtZpJeIhVTJNCCV66ksKpFP/anrByf0TG04tPxpTwqI3Im+8EPN2xX3Krb+rI7V
b\nM/oCuyECgYEA7TIAEgzWhDw3W0EbbOmzGvm5XfjiCD+kj2h659tjWtYyFxWo44bY\nChcvrz64pXJc6iWGSK4BqjAKR8rS
v4gTmvDCN3G6w6kds+SXF1osB9+ya/hHe0wN\nyEW8Dvr0HpBrBEOYYPBDXyTCUFU9vUzqWRo+vDwMbQK9CuvzajKgCV0CgYE
Ax5bs\nMvHoki15xseCfCpw7jA+uiXMJCotldDatRFANybxrGu372et9ed2/+kp5CycBcej\nEoolZwfH6+5IFbD/Wjl/ZoLo
invW7h+y8OZgB0THy2/bbpKxXGdhw24Yzozgqhbt\nVZ3DPsOpq3It3RPrdcoMWV0SQyah1PZGiE5VizsCgYAAuGElrOJN3nz
wiv8RUphX\noaB9d48AJWlTgia1Y4YmtXXLeiZcIoGvbiiX6KHY5sL/dwO0XsrkgGbXlvcS28/r\nbYW5c1/0ziOn8y6+RGjT
0UsSZtuYtT9pd0S96uco3Jlmlun0iWY6+LqaUdfxJjWj\n9Z9xJOGIxzRZvyOrE+JGhQKBgQCGKgeAf2iMypDvdDFccdMT6c5
gpwPA07Fs4cYC\nrSPzbvRJqOctwQ4JHJy7jeqg/POsVvRhhAd8aJiVGcnO+vnLlpbzO9BBNtnVm+1X\nTiUC/dMoB3sDqwwa
R0xKaHm4bq6e52aGhNQ4HqKxIsF9uOQwe68tawjZpuBmHV5w\nRefu/QKBgQClyqT8CgMLRuFi24hvpGNTaz5b67b2iSVZ3bF
hQ7NKtOAE5Avnd4j1\nVryYVT+kUjcy/L25VdMuqJ50mSEECL3CZdGApKbe23aCPOIwW7IxXvm8qkqTgC2P\nurh3YMrxdxFf
Jh6Kp2cuhaQgOhfXG8BCvWnG6nArMO2E86LfRzBVHA==\n-----END RSA PRIVATE KEY-----",
    "KeyName": "Alertnow-prod-key-pair",
    "KeyPairId": "key-00cb80116fb8affe5"

#aws ec2 create-key-pair --key-name Alertnow-prod-key-pair --query 'KeyMaterial' --output text > Alertnow-prod-key-pair.pem
```


provisioning 소요 시간 : 15분


