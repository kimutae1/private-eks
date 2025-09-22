helm repo add argo https://argoproj.github.io/argo-helm

cat << 'EOF' > argo-values.yaml
configs:
  secret:
    argocdServerAdminPassword: "$2a$10$sfqdMyMy9VbA4XDy6VMPVu2SrI5cGkNfCUbIbIs6SZEpQWi/2uRtC%"
    argocdServerAdminPasswordMtime: "2023-08-02T15:04:05Z"
    
  repositories:
    private-repo:
      url: git@github.com:the-medium/kstadium-k8s.git
      name: kstadium-k8s
      type: git
      sshPrivateKey: |
        -----BEGIN OPENSSH PRIVATE KEY-----
        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
        P6KiOv/zxpZ6QFAAAAB2xpb0BMaW8BAgM=
        -----END OPENSSH PRIVATE KEY-----
EOF



cat << EOF >> argo-values.yaml
  clusterCredentials:
      - name: dev-kstadium-service
        server: https://F294B0B9B7223FA43697EC693DA7E794.gr7.ap-northeast-2.eks.amazonaws.com
        labels:
          argocd.argoproj.io/secret-type: cluster
        config:
          awsAuthConfig:
            clusterName: dev-kstadium-service
            roleARN: arn:aws:iam::911781391110:role/dev-kstadium-service-eks-svc-role
          tlsClientConfig:
            insecure: false # TLS 인증x
            #insecure: true # TLS 인증x
            caData: "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURCVENDQWUyZ0F3SUJBZ0lJQjhxYndmVjV2bGd3RFFZSktvWklodmNOQVFFTEJRQXdGVEVUTUJFR0ExVUUKQXhNS2EzVmlaWEp1WlhSbGN6QWVGdzB5TXpBNU1EWXdNekEwTlRCYUZ3MHpNekE1TURNd016QTBOVEJhTUJVeApFekFSQmdOVkJBTVRDbXQxWW1WeWJtVjBaWE13Z2dFaU1BMEdDU3FHU0liM0RRRUJBUVVBQTRJQkR3QXdnZ0VLCkFvSUJBUUNiRTJtSzFBaEprSkM2Nk05eERqV0RkQlBMV0xCb29Hd2M5K2pBK2lTR1ZwRHdMbWZiUlRMUUNhZEgKUjdhcDIyQ2YzY09QYzVyc2tJd28zYjhjMlRrVWg0eVIrR09iQ2pOZDhQV05GdElJVG5ac0dpQ0FEajBuZDMxZwp5N0xDTTBOMnVoQkw2ODFNdER4NnNYYkdqUlcxTm0rQ3ptdEFJSHAzREJOK0pFMVN6SXhaWkNZbTdrS0dQZExICjNzbUoreHNNbWRsTDNPanliWTVyWUphWmk3VXNUcVl1VndhWGFYVHNVR2YxbWpkMTBYTnJLYkxzWG1KcWRTQm8KMmFGSklweG90WkViR3ljcDZxREhwb3J1cWZ5ZlhWOEpPQXpPZkIwemtnK0I1N0ZJUXNqbWI4SENKcTNiWFFlNgo5NnB0Q2xRYVdKZTdkbXp4dDRUTFVnZ3o1czBUQWdNQkFBR2pXVEJYTUE0R0ExVWREd0VCL3dRRUF3SUNwREFQCkJnTlZIUk1CQWY4RUJUQURBUUgvTUIwR0ExVWREZ1FXQkJUNHlYc2JhTlFGa3A2dm0yY3ZOVnV5MERtY3B6QVYKQmdOVkhSRUVEakFNZ2dwcmRXSmxjbTVsZEdWek1BMEdDU3FHU0liM0RRRUJDd1VBQTRJQkFRQjNZWDJvaWM4dwpNcytFQWlWR0pXN1dNMXlYbWk1YmJjRFYwNHdYSlVpRGFlUG94U2NMYmFkVExHb0RadUpxNmcySzlTTW43dnZNClVvcjhoTXhzaWVVTFhCdWdjdlR0b3EzdXBoa0NMb0NWSUhDUVlVSlJKY0dsZjZrb1BQaDZsOWlxb3NqSmdpZkIKRzdRT3crY3ZFcWtlYms5Q1JlTWYxbXMyaHpiOEdYc0ZXWDhOQ1FHWitTeXlMdWljWEtvc2dWeCtVb29iOWVDUQpud2VyUm1vbmk5aFQ5K0gySU50MllOengzdi9VN2pEYkVQNkVkNi9saVdmeFlnV2VIYW5STjI5dFFNbWs5cFVzCklQRkNISHVFQlcrdG10Qm1DV2hqR0k1TjhkUy9acUVoYkl1MXhKdFZITWduNS9VWlVVRWV6dWFhL21rNXIyaU4KNEFMbTFiQzR6QUJFCi0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K"


      - name: dev-kstadium-gndchain
        server: https://79FBC12066FB5384CBC2C8C6BB7B2AB3.gr7.ap-northeast-2.eks.amazonaws.com
        config:
          awsAuthConfig:
            clusterName: dev-kstadium-gndchain
            roleARN: arn:aws:iam::911781391110:role/dev-kstadium-gndchain-eks-svc-role
          tlsClientConfig:
            insecure: false # TLS 인증x
            caData: "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURCVENDQWUyZ0F3SUJBZ0lJSlNOTmc2TmhzR293RFFZSktvWklodmNOQVFFTEJRQXdGVEVUTUJFR0ExVUUKQXhNS2EzVmlaWEp1WlhSbGN6QWVGdzB5TXpBNU1EUXdPRE0wTURKYUZ3MHpNekE1TURFd09ETTBNREphTUJVeApFekFSQmdOVkJBTVRDbXQxWW1WeWJtVjBaWE13Z2dFaU1BMEdDU3FHU0liM0RRRUJBUVVBQTRJQkR3QXdnZ0VLCkFvSUJBUUM3dkM1SG1sUVRwYzlSUnQ1ajhaVDVEK2pnVm8ybFdZODlCcWFxMzlsc1lqVmJZdndqUTkwY3VhbkUKcTI0bW1ISFY0d0xqV3IxbTUySWFuQjA4amgrWUZsQlB6L1hNMzlmYWtZNHc0b0s0cHdjcXlDaU1hOEJwMUsvOApKZ2p1NGF0L210VTJQMWpFSDhrQnJZRTlkSGxobERCN0w5N2NLaTlnalB6U21RTGkrL21zR000OGIzb1d1SElRCm9ZWjdURUg5eDN0MTBOempaMTJYdWl1b2trMSt6WTMvZ0UvZWNYajI0bkFZYjArNjJ0RGx3QkhOWmJnT2NtTGsKeVFwVmVUbHV4MC9vVU1hWjBObVRPTHNBZlM4VGxNTWV6bXRrRHdmKzRZb05RWnFROHduS2ZPMFljd04raWVvYwpJL0pwNERtZXRnaTBET3NRSnRZYWRqcFFRbzFCQWdNQkFBR2pXVEJYTUE0R0ExVWREd0VCL3dRRUF3SUNwREFQCkJnTlZIUk1CQWY4RUJUQURBUUgvTUIwR0ExVWREZ1FXQkJTMEdXWnd2RGhPSmJtTzljKzM0Y0RzTG9vbFNEQVYKQmdOVkhSRUVEakFNZ2dwcmRXSmxjbTVsZEdWek1BMEdDU3FHU0liM0RRRUJDd1VBQTRJQkFRQ0VZY1V0b29zVgpCUEoxVXRkQm9PM0MwQVZ0MWY3WmhONHdwVDhWSHlWdGR1bk42MzFYUTNUN1lRV2tHbXRJUVc5T21MeHkxc2hTCk5KSDhLckpYUnZsQUJKTjFpRlJ5aWlqY0VHbmZzNFluNG1CT2gyOFJHZlJmUW1YWjJ5RzNtS2dSL3FtYUU1cmUKYU5HTmRzbUY3aGRVbnBIdkpyWGplT21lR1pnQUNkTXJqMys3L0VrbHVrakRTMU9WZmxBdnJydUFqSlRLSWVyUgpYVndnVmUybVJlT1l3c054YW54c1N4UHJEQUJnTHh5dDBmZXlmTlg1NVNJd0ozUXhscGRFanVnUmFvTHdWUDJFClNQTTVhdXRUQjh6VTk2MjZ0bFVjdkE3UzJ5RVJ1dy9rY29DNUtYY1ljL3AvcGVCOXpaVE8zcUtZVDhhdHZHQ2YKcnZac2hwVHlNV0xWCi0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K"

EOF

cat << EOF >> argo-values.yaml
global:
  logging:
    format: text
    level: debug

server:
  ingress:
    enabled: true
    annotations:
      kubernetes.io/ingress.class: alb
      alb.ingress.kubernetes.io/load-balancer-name: alb-${cluster_name}-argo
      alb.ingress.kubernetes.io/group.name: tg-${cluster_name}-argo
      alb.ingress.kubernetes.io/scheme: internet-facing
      alb.ingress.kubernetes.io/certificate-arn: $cert_arn
      alb.ingress.kubernetes.io/ssl-policy: ELBSecurityPolicy-2016-08
      alb.ingress.kubernetes.io/backend-protocol: HTTPS
      alb.ingress.kubernetes.io/healthcheck-path: /
      alb.ingress.kubernetes.io/target-type: 'ip'
      alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 80}, {"HTTPS":443}]'
      alb.ingress.kubernetes.io/ssl-redirect: '443'
      alb.ingress.kubernetes.io/actions.ssl-redirect: {"Type": "redirect", "RedirectConfig": { "Protocol": "HTTPS", "Port": "443", "StatusCode": "HTTP_301"}}
      external-dns.alpha.kubernetes.io/hostname: $full_domain
    paths:
      - /
    pathType: Prefix

  serviceAccount:
    create: true
    name: argocd-server
    annotations: 
        eks.amazonaws.com/role-arn: "${eks_service_role}"
    automountServiceAccountToken: true
controller:
  serviceAccount:
    create: true
    name: argocd-application-controller
    annotations: 
        eks.amazonaws.com/role-arn: "${eks_service_role}"
    automountServiceAccountToken: true


EOF


kubectl create namespace managed
#kubectl apply -f lucas-argo-sa.yaml
#helm install -n managed argocd argo/argo-cd -f argo-values.yaml
helm upgrade --install -f argo-values.yaml --namespace managed argocd argo/argo-cd