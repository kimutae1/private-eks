helm repo add argo https://argoproj.github.io/argo-helm
helm repo update argo 

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
        server: https://32633C8E33BB641BE124B58DDA292C6A.gr7.ap-northeast-2.eks.amazonaws.com
        labels:
          argocd.argoproj.io/secret-type: cluster
        config:
          awsAuthConfig:
            clusterName: dev-kstadium-service
            roleARN: arn:aws:iam::911781391110:role/dev-kstadium-service-eks-svc-role
          tlsClientConfig:
            insecure: false # TLS 인증x
            #insecure: true # TLS 인증x
            caData: "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURCVENDQWUyZ0F3SUJBZ0lJWkU2TTg4WitMcE13RFFZSktvWklodmNOQVFFTEJRQXdGVEVUTUJFR0ExVUUKQXhNS2EzVmlaWEp1WlhSbGN6QWVGdzB5TXpBNE1Ea3dPREUyTXpKYUZ3MHpNekE0TURZd09ERTJNekphTUJVeApFekFSQmdOVkJBTVRDbXQxWW1WeWJtVjBaWE13Z2dFaU1BMEdDU3FHU0liM0RRRUJBUVVBQTRJQkR3QXdnZ0VLCkFvSUJBUURFdzlqa2NYUExtcVNVK0l0ek9WeFVwa3M5UlAybFkwMWh2WnBxckN4b3RCYTNKQ3h3ZE55VW10eEsKSWViUG1WcWk2Zk85MmkzY2xTamZ4MEYvV09EQXVqQ09WUDVuQkFCMnByQWgzR1ZjSmZaaEF6dmpISmRmMUQ2TQp3Q2t3YVpHeVdZaExhaXpkVlhxSGlFVWVmcHpGMGtsZnI3d2F3M0FLakdGb1hETzdvVFpqTDNUQjZQdXVrcEswCk13d1RkbVZCYWNSNlFkQTdYdElaOTQ3VXphOEZmY2pyZEczQnhkSVFnMFhiM21EbTBUalVOQmh1OGVSNXlaR08KejVtT1VuQ1FKRjl3dmxKc1pKQlhIQXRjZGJ4a20xSUU4WWVWVXN4Zy84SHN5V1dqZTRVY05vSDVWRW0xcm40SgphWUI5RTFVMXBMSE9JaGh2WjlybklDQlFCTFNQQWdNQkFBR2pXVEJYTUE0R0ExVWREd0VCL3dRRUF3SUNwREFQCkJnTlZIUk1CQWY4RUJUQURBUUgvTUIwR0ExVWREZ1FXQkJTVHAzRGh0cWU5cDVWb3FFWW40d2J5aW1DaTd6QVYKQmdOVkhSRUVEakFNZ2dwcmRXSmxjbTVsZEdWek1BMEdDU3FHU0liM0RRRUJDd1VBQTRJQkFRREJTZDhhVVU2MgpCLzQxWjVTNDhYbUJxTnluMmRJZzk2T0RUd3BMclF6VFl5Z0hYMkNvVVdXYm95OE9qNDh6K3pGakh6cHVPeGMzClVEb2UwekNLZVdXZHhXcE0xZXVoWldDcmp5bTd0VFpONFpWM05MTlNCV1ZLUmhFYTZrMkpJS25wcXZ2UHZKWHQKZHZjK2d1czhXangxZHBnQlE2a01VOHBJZnZIRUI5eVlVVHI4MUkzZzZpaVNIVmxlVlpIdy8wWmU0NkZjK0ZyQQoySmJsRmxudGlmTkREc1EyNkpWU28reWRSaElYdk0wK2F2TWtjTE93bFpxRS8xRnRnMHB2VjVCc1dIcWN3bGVnCkUzeS8yaTlZNllLWkk5WDVJQmRaOThITVE4c0pzQUpYSDIxRll3Z1VWNENNczQxbXFJVFVBeHFaQ08rcFVpK3MKN3lLYWdhM1FPZzRXCi0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K"
      - name: dev-kstadium-gndchain
        server: https://60444EA20E53E07C53875F6DC1A82CCC.gr7.ap-northeast-2.eks.amazonaws.com
        config:
          awsAuthConfig:
            clusterName: dev-kstadium-gndchain
            roleARN: arn:aws:iam::911781391110:role/dev-kstadium-gndchain-eks-svc-role
          tlsClientConfig:
            insecure: false # TLS 인증x
            caData: "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURCVENDQWUyZ0F3SUJBZ0lJSDhvaFlLS29VbTB3RFFZSktvWklodmNOQVFFTEJRQXdGVEVUTUJFR0ExVUUKQXhNS2EzVmlaWEp1WlhSbGN6QWVGdzB5TXpBNU1ERXdOVEkxTWpSYUZ3MHpNekE0TWprd05USTFNalJhTUJVeApFekFSQmdOVkJBTVRDbXQxWW1WeWJtVjBaWE13Z2dFaU1BMEdDU3FHU0liM0RRRUJBUVVBQTRJQkR3QXdnZ0VLCkFvSUJBUURzYmpoTTA2bnlJQTZ5YVdLK2w4V3N3TzFLODdYODg2RVVRdG50RXB5dTZCQUZjenJ2WWJ2NDZERGYKWWkrMGJKNW42aXNPam43d1huRm9kcUlzd0VBd2ZIbEYyUDlUZ3J2YTJUTHBLTGJ2d2FQZXhqYWhpYnN1K0FpQQpVSWN5YUhUNzg1KytQSG01TXZmcVdRNEM2U0tOQXJHWVo5QWVlK050TjR2M2RydGdkTm5ZTjZXektzVG1PUUVPCnhQTFVFSGdQUzRJL3FKUzdoMmttUVJzQTRadFUyZi9IZVgySTZ1VTFqcC9VajBORjlDRnRhT1NHai9zbEcyVHUKd2NPS2pGaGVzYjExeXpJTTFjU0ZTM1ZIWG9ZaFo3ZFdqaC90MXBEMWhmRXlTekZlRGhmSHczQzJiREd2UmhobgpZTVJpVUR6VWFRcTNjdzRCWlhtTkwxYTdROUR0QWdNQkFBR2pXVEJYTUE0R0ExVWREd0VCL3dRRUF3SUNwREFQCkJnTlZIUk1CQWY4RUJUQURBUUgvTUIwR0ExVWREZ1FXQkJTYnJIc1pXRU9pOHNqTHZBWCtVWWR5UnhlVFVEQVYKQmdOVkhSRUVEakFNZ2dwcmRXSmxjbTVsZEdWek1BMEdDU3FHU0liM0RRRUJDd1VBQTRJQkFRREozZ2Y3UEtqMwpJa0tQbTlNaGkvZng2Nk5GMFNVR3ZQQTJRLzdocmtnNEhadWtpMG11bTNPZWJzYVJDelFqYmlWRjhGZGE3a21JCnUvZkJFT09Pbi9BL05FK2pZR0cwS1FoaElRd0Znb1NzMTFPZlV5U1gxVHpkM0ZGdUV1cENpQnZHdFpoVkFDTWwKNjA0Y0RuK0lqaFgrdUVaWkNTLytHUGpTaS9zdUMxUEMyaHRzc204SVhLdlRNRVRBdjVYZXBJVEJ4QlRqQTJtWgpVY3RaUVNxVVZsNGpBT3VCTWtCaVM1d1R1ei95ZzdtV3dUeW0xcVNLdVJlZkhhQ05XQVg0SGNCWW1ydG5rb0dyClRubjdNdnpDaTVuQndvajlVOStWNllNUTl6ZWlIWjFraVhTQ1dvYndwVkVzQW5qZVV5eU0wdTRFM09wTTcrdkEKQ2FYOXhSSnU3RkNkCi0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K"

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
    hosts:
      #- argo.dev.kstadium.io
      - $full_domain
    paths:
      - /
    pathType: Prefix

  serviceAccount:
    create: true
    name: argocd-server
    annotations: 
        eks.amazonaws.com/role-arn: "arn:aws:iam::911781391110:role/dev-kstadium-lio-eks-svc-role"
    automountServiceAccountToken: true

controller:
  serviceAccount:
    create: true
    name: argocd-application-controller
    annotations: 
        eks.amazonaws.com/role-arn: "arn:aws:iam::911781391110:role/dev-kstadium-lio-eks-svc-role"
    automountServiceAccountToken: true


EOF


kubectl create namespace managed
#kubectl apply -f lucas-argo-sa.yaml
helm install -n managed argocd argo/argo-cd -f argo-values.yaml
helm upgrade -f argo-values.yaml --namespace managed argocd argo/argo-cd