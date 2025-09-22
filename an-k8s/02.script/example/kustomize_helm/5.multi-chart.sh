#kustomize 추가 기능으로 helm chart 를 여러개 묶어서 배포하는 방법을 알려드리겠습니다. 
#아래 예시는 argoCD 가 redis 를 사용하고 있는데요. 
#내장 redis 대신 추가로 redis 를 설치해서 사용하도록 설정을 해보겠습니다.

## 2개의 helm chart 를 배포하는 kustomization.yaml 을 각각 생성합니다.
## 아래와 같은 폴더 구조를 생성합니다.
./root
  ./argocd
    kustomization.yaml
    my-values.yaml
  ./argocd-redis
    kustomization.yaml
    my-values.yaml
  kustomization.yaml


mkdir -p root/argocd root/argocd-redis

cat << EOF > root/argocd/kustomization.yaml 
helmCharts:
  - name: argo-cd
    repo: https://argoproj.github.io/argo-helm
    version: 3.26.5
    releaseName: my-argocd
    namespace: my-argocd
    valuesFile: my-values.yaml
    includeCRDs: true
EOF

cat << EOF > root/argocd-redis/kustomization.yaml 
helmCharts:
  - name: redis
    repo: https://charts.bitnami.com/bitnami
    version: 16.4.0
    releaseName: my-argocd-redis
    namespace: my-argocd
    valuesFile: my-values.yaml
    includeCRDs: false

## ./kustomization.yaml
bases:
  - argocd
  - argocd-redis
  bases:
  - argocd
  - argocd-redis
EOF

## ./root 폴더에서 kustomize 명령을 실행합니다.
$ kustomize build . --enable-helm > temp.yaml
created temp.yaml

## temp.yaml 파일을 확인합니다.
$ cat temp.yaml
...생략...

## 최종 yaml 파일을 배포합니다.
## my-argocd-redis-master 가 추가로 배포된 것을 확인할 수 있습니다.
$ kubectl apply -f temp.yaml -n my-argocd
...중략...
deployment.apps/my-argocd-application-controller created
deployment.apps/my-argocd-dex-server created
deployment.apps/my-argocd-redis created
deployment.apps/my-argocd-repo-server created
deployment.apps/my-argocd-server created
tatefulset.apps/my-argocd-redis-master created

## pod  확인
## my-argocd-redis-master 가 추가로 배포된 것을 확인할 수 있습니다.
$ kubectl get pod -n my-argocd
NAME                                                READY   STATUS    RESTARTS   AGE
my-argocd-application-controller-57b9d9f584-2gp82   1/1     Running   0          30s
my-argocd-application-controller-57b9d9f584-8jbw6   1/1     Running   0          30s
my-argocd-dex-server-b8cdffbbc-n4jln                1/1     Running   1          29s
my-argocd-redis-7b46b74bc9-v5nsg                    1/1     Running   0          29s
my-argocd-redis-master-0                            1/1     Running   0          28s
my-argocd-repo-server-5745dc9456-47g9g              1/1     Running   0          29s
my-argocd-server-b598c7865-j55wb                    1/1     Running   0          28s
my-argocd-server-b598c7865-kw6lz                    1/1     Running   0          28s