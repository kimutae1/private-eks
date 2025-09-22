{{- define "ingress.setCertArn" -}}
  {{- if eq .Values.Domain "Kstadium" -}}
    {{- with index .Values.AWS  ( camelcase .Values.Env ) -}}
      {{- .Domain.Kstadium.CertArn -}}
    {{- end -}}
  {{- end -}}  
{{- end -}}

{{- define "ingress.setListenPort" -}}
  {{- if empty .Values.ListenPort -}}
    '[{"HTTP":80}, {"HTTPS":443}]'
  {{- else -}}
    {{- if and (ne (int .Values.ListenPort) 80) (ne (int .Values.ListenPort) 443) -}}
      {{- $port := .Values.ListenPort -}}
        '[{"HTTP":80}, {"HTTPS":443}, {"HTTPS":{{ $port }}}]'
    {{- else -}}
      {{- fail "Error! Already 80 and 443 are set for ListenPort in ingress.setListenPort. Please set to another numbers or delete ListenPort in values.yaml" -}}
    {{- end -}}
  {{- end -}}    
{{- end -}}

{{- define "ingress.setHostname" -}}
  {{- if eq .Values.Domain "Kstadium" -}}
    {{- $ARecord := .Values.ARecord -}}
    {{- with index .Values.AWS  ( camelcase .Values.Env ) -}}
      eks-{{- $ARecord -}}.{{- .Domain.Kstadium.HostingZone -}}
    {{- end -}}
  {{- end -}} 
{{- end -}}

######################
# ingress template
{{- define "ingress.template" -}}
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ .Values.Env }}-{{ .Release.Name }}
  namespace: {{ .Release.Namespace }}
  annotations:
    kubernetes.io/ingress.class: {{ .Values.LbConfig.ElbType }}
    alb.ingress.kubernetes.io/load-balancer-name: eks-{{ .Values.LbConfig.ElbType }}-{{ .Values.Env }}-{{ .Release.Name }}
    alb.ingress.kubernetes.io/group.name: eks-tg-{{ .Values.Env }}-{{ .Release.Name }}
    alb.ingress.kubernetes.io/scheme: {{ .Values.LbConfig.ElbPubOrPri }}
    alb.ingress.kubernetes.io/certificate-arn: {{ include "ingress.setCertArn" . }}
    alb.ingress.kubernetes.io/ssl-policy: {{ .Values.LbConfig.SslPolicy }}
    alb.ingress.kubernetes.io/backend-protocol: {{ .Values.LbConfig.BackendProtocol }}
    alb.ingress.kubernetes.io/healthcheck-path: {{ .Values.LbConfig.HealthCheck }}
    alb.ingress.kubernetes.io/target-type: {{ .Values.LbConfig.TargetType }}
    alb.ingress.kubernetes.io/listen-ports: {{ include "ingress.setListenPort" . }}
    alb.ingress.kubernetes.io/ssl-redirect: '443'
    alb.ingress.kubernetes.io/actions.ssl-redirect: '[{"Type": "redirect", "RedirectConfig": {"Protocol": "HTTPS", "Port": "443", "StatusCode": "HTTP_301"}]'
    external-dns.alpha.kubernetes.io/hostname: {{ include "ingress.setHostname" . }}
spec:
  rules:
  - http:
      paths: 
      - path: /
        pathType: Prefix
        backend:
          service:
            name: {{ .Values.Env }}-{{ .Release.Name }}
            port:
              number: 443
{{- end -}}