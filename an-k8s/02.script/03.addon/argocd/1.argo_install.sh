#helm repo add argo https://argoproj.github.io/argo-helm

cat << 'EOF' > $env-argo-values.yaml
configs:
  secret:
    argocdServerAdminPassword: "$2a$10$AiUkFXDaCy8efAHMRV2Nie1LovFeHJbwBzbgUqellxz5U0qRiU7zu%" 
    argocdServerAdminPasswordMtime: "2023-08-02T15:04:05Z"
    
EOF

cat << EOF >> $env-argo-values.yaml
global:
  logging:
    format: text
    level: debug
  #domain: argo.makgoon.com

server:
  ingress:
    enabled: true
    annotations:
      kubernetes.io/ingress.class: alb
      alb.ingress.kubernetes.io/load-balancer-name: alb-${cluster_name}-argo
      alb.ingress.kubernetes.io/group.name: tg-${cluster_name}-argo
      #alb.ingress.kubernetes.io/scheme: internet-facing
      alb.ingress.kubernetes.io/certificate-arn: $cert_arn
      alb.ingress.kubernetes.io/ssl-policy: ELBSecurityPolicy-2016-08
      alb.ingress.kubernetes.io/backend-protocol: HTTPS
      alb.ingress.kubernetes.io/healthcheck-path: /
      alb.ingress.kubernetes.io/target-type: 'ip'
      alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 80}, {"HTTPS":443}]'
      alb.ingress.kubernetes.io/ssl-redirect: '443'
      alb.ingress.kubernetes.io/target-group-attributes: stickiness.enabled=true,stickiness.lb_cookie.duration_seconds=60
      alb.ingress.kubernetes.io/actions.ssl-redirect: {"Type": "redirect", "RedirectConfig": { "Protocol": "HTTPS", "Port": "443", "StatusCode": "HTTP_301"}}
      external-dns.alpha.kubernetes.io/hostname: argo.
    hostname: "argo.makgoon.com"
    paths: /
    pathType: Prefix

  serviceAccount:
    create: true
    name: argocd-server
    annotations: 
        eks.amazonaws.com/role-arn: $eks_sa_role
    automountServiceAccountToken: true
controller:
  serviceAccount:
    create: true
    name: argocd-application-controller
    annotations: 
        eks.amazonaws.com/role-arn: $eks_sa_role
    automountServiceAccountToken: true


EOF


#kubectl create namespace default
helm upgrade --install -f $env-argo-values.yaml --namespace default argocd argo/argo-cd
