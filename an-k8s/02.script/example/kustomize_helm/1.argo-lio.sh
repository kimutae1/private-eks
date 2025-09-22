helm repo add argo https://argoproj.github.io/argo-helm

cat << EOF > values-lio.yaml
configs:
  secret:
    argocdServerAdminPassword: $2a$10$sfqdMyMy9VbA4XDy6VMPVu2SrI5cGkNfCUbIbIs6SZEpQWi/2uRtC%
    argocdServerAdminPasswordMtime: "2023-08-02T15:04:05Z"

server:
  ingress:
    enabled: true
    annotations:
      kubernetes.io/ingress.class: alb
      alb.ingress.kubernetes.io/scheme: internet-facing
      alb.ingress.kubernetes.io/certificate-arn: 'arn:aws:acm:ap-northeast-2:911781391110:certificate/c4b1fa44-ad4b-404e-aa4d-6e6e2aa3f858'
      alb.ingress.kubernetes.io/ssl-policy: ELBSecurityPolicy-2016-08
      alb.ingress.kubernetes.io/backend-protocol: HTTPS
      alb.ingress.kubernetes.io/healthcheck-path: /
      alb.ingress.kubernetes.io/target-type: 'ip'
      alb.ingress.kubernetes.io/listen-ports: '[{"HTTP":80,"HTTPS": 443}]'
      alb.ingress.kubernetes.io/actions.ssl-redirect: '{"Type": "redirect", "RedirectConfig": { "Protocol": "HTTPS", "Port": "443", "StatusCode": "HTTP_301"}}'
    hosts:
      - lio-argo.dev.kstadium.io
    paths:
      - /
    pathType: Prefix
EOF

helm install -n managed argocd argo/argo-cd -f values-lio.yaml   