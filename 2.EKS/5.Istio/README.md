# Istio 

설치 방법 목록 및 방법 선정
설치 방법 선정 기준은 설정 가시성을 최대화하면서 최대한 일반적 k8s 설치 방법을 따르는 것이다. \
아래는 공식 문서에서 논하는 3가지 설치 방법으로, 아래 논의 결과에 따라 helm 을 이용한 설치를 사용한다.

## istioctl
공식 문서에서 가장 먼저 소개하는 방법으로, istioctl은 운영 시 결국은 사용하게 되지만, \
환경 별 variation에 대한 설정 가시성이 좋지 않다 \
Reference :  https://istio.io/latest/docs/setup/install/istioctl/ 

## helm
설치 방법의 일반성의 장점 뿐 아니라 istioctl 에 대비 설정에 대한 가시성이 뛰어나다 \
(앞서 예를 든 PILOT_TRACE_SAMPLING경우 pilot.traceSampling 항목으로 수정 가능) 

https://istio.io/latest/docs/setup/install/helm/  \
https://github.com/istio/istio/blob/master/manifests/charts/istio-control/istio-discovery/README.md 

## istio Operator install
k8s custom resource를 사용하여 application을 관리하는 방법으로, \
istio의 IstioOperator 란 resource를 사용하여 설치하는 방법이나,  istio 공식 사이트에서는 추천하지 않는다


## helm install 

설치 절차 overview
k8s cluster에 istio를 설치하는 절차는 다음과 같다 \
https://istio.io/latest/docs/setup/install/helm/

1. istio helm repo 추가/업데이트
```bash
helm repo add istio https://istio-release.storage.googleapis.com/charts
helm repo update
```

2. istio-system namespace 생성
```bash
k create namespace istio-system
```
3. istio base chart 설치
```bash
#base
helm install istio-base istio/base -n istio-system --set defaultRevision=default
# istiod
helm install istiod istio/istiod -n istio-system --wait
# gateway
kubectl create namespace istio-ingress
helm install istio-ingress istio/gateway -n istio-ingress --wait

```

설치가 완료 되었다면 ingress 가 alb를 생성 하였을 것이다. \ 
콘솔에서 확인해보자

- ingress 관련 설정을 넣은적이 없는데도 불구 하고 alb를 생성 할 수 있는 이유는 helm 템플릿을 보면 알수가 있다. \
```
service:
▏ # Type of service. Set to "None" to disable the service entirely
▏ type: LoadBalancer
▏ ports:
▏ - name: status-port
▏ ▏ port: 15021
▏ ▏ protocol: TCP
▏ ▏ targetPort: 15021
▏ - name: http2
▏ ▏ port: 80                                                                                           
▏ ▏ protocol: TCP
▏ ▏ targetPort: 80
▏ - name: https
▏ ▏ port: 443
▏ ▏ protocol: TCP
▏ ▏ targetPort: 443
▏ annotations: {}
▏ loadBalancerIP: ""
▏ loadBalancerSourceRanges: []
▏ externalTrafficPolicy: ""
▏ externalIPs: []
▏ ipFamilyPolicy: ""
▏ ipFamilies: []
▏ ## Whether to automatically allocate NodePorts (only for LoadBalancers).
▏ # allocateLoadBalancerNodePorts: false


```
service type이 loadbalencer 이면 각 CSP에서 loadbalencer 타입을 지원 할 경우 lb가 만들어진다.


