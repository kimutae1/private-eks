helm repo add argo https://argoproj.github.io/argo-helm
helm template my-argocd argo/argo-cd > temp.yaml

cat << EOF > my-values.yaml 
controller:
  replicas: 1

configs:
  secret:
    argocdServerAdminPassword: \$2a\$10\$sfqdMyMy9VbA4XDy6VMPVu2SrI5cGkNfCUbIbIs6SZEpQWi/2uRtC%
    argocdServerAdminPasswordMtime: "2023-08-02T15:04:05Z"


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
     namespace: kube-system
     annotations:
      kubernetes.io/ingress.class: alb
      alb.ingress.kubernetes.io/load-balancer-name: alb-${env}-${service_zone}-argo
      alb.ingress.kubernetes.io/group.name: tg-${env}-${service_znoe}-argo
      alb.ingress.kubernetes.io/scheme: internet-facing
      alb.ingress.kubernetes.io/target-type: ip
      external-dns.alpha.kubernetes.io/hostname: argo.dev.kstadium.io


      # SSL Settings
      alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 80}, {"HTTPS":443}]'
      alb.ingress.kubernetes.io/certificate-arn: arn:aws:acm:ap-northeast-2:911781391110:certificate/c4b1fa44-ad4b-404e-aa4d-6e6e2aa3f858
      alb.ingress.kubernetes.io/ssl-redirect: '443'
      alb.ingress.kubernetes.io/actions.ssl-redirect: '{"Type": "redirect", "RedirectConfig": { "Protocol": "HTTPS", "Port": "443", "StatusCode": "HTTP_301"}}'
      external-dns.alpha.kubernetes.io/hostname: argo.dev.kstadium.io
     labels: {}
     ingressClassName: ""
     hosts: { argo.dev.kstadium.io }
     #https: true
EOF


## kustomization.yaml 파일에 my-secret.yaml 리소스를 추가한다.
cat << EOF > kustomization.yaml
kind: Kustomization

helmCharts:
  - name: argo-cd
    repo: https://argoproj.github.io/argo-helm
    version: 5.43.2
    releaseName: my-argocd
    namespace: managed
    valuesFile: my-values.yaml 
    includeCRDs: false

EOF

#kustomize build argo/argo-cd --enable-helm > temp1.yaml
kustomize build  --enable-helm . > temp1.yaml
kubectl create namespace managed
kubectl apply -f temp1.yaml -n managed