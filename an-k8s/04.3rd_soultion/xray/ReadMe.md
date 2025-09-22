# AWS X-Ray 사용법


### 1. xray-daemon.yaml 을 실행
### 2. 필요한 Appliction 에 변수설정
```
- name: AWS_XRAY_DAEMON_ADDRESS
  value: xray-service.kube-system:2000
  # X-ray Daemon의 서비스 등록
```

참고
---
https://docs.aws.amazon.com/ko_kr/xray/latest/devguide/xray-sdk-java.html

https://archive.eksworkshop.com/intermediate/245_x-ray/