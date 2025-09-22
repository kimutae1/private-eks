helm repo add argo https://argoproj.github.io/argo-helm
helm template my-argocd argo/argo-cd > temp.yaml

cat << EOF > add-config.yaml 
apiVersion: v1
kind: Namespace
metadata:
  name: managed
EOF

cat << EOF > my-values.yaml 
controller:
  replicas: 1

secret:
  argocdServerAdminPassword: devops

server:
  replicas: 1
  extraArgs: 
    - --insecure
  service:
    type: NodePort
    nodePortHttp: 30080
    nodePortHttps: 30443
    servicePortHttp: 80
    servicePortHttps: 443
    servicePortHttpName: http
    servicePortHttpsName: https
    namedTargetPort: true
  ingress:
     enabled: true
     annotations:
      kubernetes.io/ingress.class: alb
      alb.ingress.kubernetes.io/load-balancer-name: alb-${env}-${service_zone}-argo-lucas
      alb.ingress.kubernetes.io/group.name: tg-${env}-${service_znoe}-argo-lucas
      alb.ingress.kubernetes.io/scheme: internet-facing
      alb.ingress.kubernetes.io/target-type: ip
      external-dns.alpha.kubernetes.io/hostname: argo-lucas.dev.kstadium.io


      # SSL Settings
      alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 80}, {"HTTPS":443}]'
      alb.ingress.kubernetes.io/certificate-arn: arn:aws:acm:ap-northeast-2:911781391110:certificate/c4b1fa44-ad4b-404e-aa4d-6e6e2aa3f858
      alb.ingress.kubernetes.io/ssl-redirect: '443'
      alb.ingress.kubernetes.io/actions.ssl-redirect: '{"Type": "redirect", "RedirectConfig": { "Protocol": "HTTPS", "Port": "443", "StatusCode": "HTTP_301"}}'
      external-dns.alpha.kubernetes.io/hostname: argo-lucas.dev.kstadium.io
     labels: {}
     ingressClassName: ""
     hosts: { argo-lucas.dev.kstadium.io }
     #https: true
EOF


# cat << EOF > kustomization.yaml 
# apiVersion: kustomize.config.k8s.io/v1beta1
# kind: Kustomization
# resources:
# - add-config.yaml

# helmCharts:
#   - name: argo-cd
#     repo: https://argoproj.github.io/argo-helm
#     version: 5.42.1
#     releaseName: my-argocd
#     namespace: managed
#     valuesFile: my-values.yaml 
#     includeCRDs: true # CustomResourceDefinition 이 있을 경우 true
# EOF


## 아래와 같은 secret 을 추가로 배포하기 위해 my-secret.yaml 파일을 생성합니다.
cat << EOF > my-secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: namespace-secret
type: Opaque
stringData:
  id: kstadium
  password: devops
EOF

## kustomization.yaml 파일에 my-secret.yaml 리소스를 추가한다.
cat << EOF > kustomization.yaml
helmCharts:
  - name: argo-cd
    repo: https://argoproj.github.io/argo-helm
    version: "5.42.1"
    releaseName: my-argocd
    namespace: managed
    valuesFile: my-values.yaml 
    #includeCRDs: true

resources:
  - my-secret.yaml
EOF

kustomize build . --enable-helm > temp.yaml

kubectl create namespace managed
kubectl apply -f temp.yaml -n managed