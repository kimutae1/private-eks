# ArgoCD setting 
> argocd는 보통 helm 으로 많이 설치를 진행 한다. \
> 본 가이드에서도 역시 helm 을 이용 할 예정이다. \
> 그리고 초기 설치 시 쿠버 내부에만 설치가 되기 때문에 외부에서 접속 할 수 있는 방법은 제한적이다. \
> 그렇기에 셋팅시 ALB도 같이 셋팅 되도록 진행 되어야 한다. \
> ingress-controller는 사전에 설치가 되어 있어야 한다. (EKS->3.Addon->ingress.md 참조)


## argocd admin password 생성(선택)
패스워드를 생성한 뒤 이 값을 초기 yaml에 넣으면 초기부터 패스워드 셋팅을 할 수 있다.

```bash
argocd account bcrypt --password admin
$2a$10$AiUkFXDaCy8efAHMRV2Nie1LovFeHJbwBzbgUqellxz5U0qRiU7zu%                   
```

path : an-k8s/02.script/03.addon/argocd/1.argo_install.sh

```bash
❯ ./1.argo_install.sh
"argo" has been added to your repositories
Error from server (AlreadyExists): namespaces "default" already exists
Release "argocd" does not exist. Installing it now.
NAME: argocd LAST DEPLOYED: Mon Aug 12 06:41:00 2024
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
In order to access the server UI you have the following options:

1. kubectl port-forward service/argocd-server -n default 8080:443

    and then open the browser on http://localhost:8080 and accept the certificat e

2. enable ingress in the values file `server.ingress.enabled` and either
      - Add the annotation for ssl passthrough: https://argo-cd.readthedocs.io/en/stable/operator-manual/ingress/#option-1-ssl-passthrough
      - Set the `configs.params."server.insecure"` in the values file and terminate SSL at your ingress: https://argo-cd.readthedocs.io/en/stable/operator-manual/ingress/#option-2-multiple-ingress-objects-and-hosts


After reaching the UI the first time you can login with username: admin and the andom password generated during the installation. You can find the password by 
running:

kubectl -n default get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

(You should delete the initial secret afterwards as suggested by the Getting Started Guide: https://argo-cd.readthedocs.io/en/stable/getting_started/#4-login-using-the-cli)

```

## 설치 확인 
```bash 
k get po -n default

NAME                                                READY   STATUS    RESTARTS   AGE
argocd-application-controller-0                     1/1     Running   0          2m24s
argocd-applicationset-controller-58d64c56f4-j5zf6   1/1     Running   0          2m24s
argocd-dex-server-854c54dd8d-59bmp                  1/1     Running   0          2m23s
argocd-notifications-controller-68c94bb6b9-89lls    1/1     Running   0          2m24s
argocd-redis-765f4cd956-ktqcq                       1/1     Running   0          2m24s
argocd-repo-server-6fb4975c67-7bnpl                 1/1     Running   0          2m24s
argocd-server-69bb5bb68c-jdjzq                      1/1     Running   0          2m24s

```
---

# argo rollout 설치
Argo Rollouts는 Blue/Green, Canary 등의 고급 배포 기능을 지원하는 \
Kubernetes controller이자 CRDs 세트이며 자동 롤백 및 수동 판단 등을 가능하게 한다 

```bash
❯ ./1.argo_rollout_install.sh
NAME: argorollout
LAST DEPLOYED: Tue Aug 13 06:00:16 2024
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
```


