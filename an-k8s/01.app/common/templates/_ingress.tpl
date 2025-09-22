{{- define "ingress.setLBName" -}}
  {{- if eq .Values.Domain "Kstadium" -}}
    eks-{{ .Values.LbConfig.ElbType }}-{{ lower .Values.Domain | replace "kstadium" "ks" }}-{{ .Values.Env }}-{{ include "ingress.setPubOrPri" . }}-{{ lower .Values.AppType }}
  {{- else if eq .Values.Domain "Dex" (or .Values.Domain "Flux") -}}
    eks-{{ .Values.LbConfig.ElbType }}-{{ lower .Values.Domain }}-{{ .Values.Env }}-{{ include "ingress.setPubOrPri" . }}-{{ lower .Values.AppType }} 
  {{- else -}}
    {{- fail "Error! at ingress.setLBName, Please check conditions" -}}
  {{- end -}}  
{{- end -}}

{{- define "ingress.setGroupName" -}}
  {{- $LBName := include "ingress.setLBName" . -}}
  {{- trimPrefix "eks-alb-" $LBName -}}
{{- end -}}

{{- define "ingress.setPubOrPri" -}}
  {{- if eq .Values.LbConfig.ElbPubOrPri "internet-facing" -}}
    ex
  {{- else if eq .Values.LbConfig.ElbPubOrPri "internal" -}}
    in
  {{- else -}}
    {{- fail "Error! at ingress.setPubOrPri, Please set correctly in .Values.LbConfig.ElbPubOrPri" -}}
  {{- end -}}  
{{- end -}}

{{- define "ingress.setCertArn" -}}
  {{- if eq .Values.Domain "Kstadium" -}}
    {{- with index .Values.AWS  ( camelcase .Values.Env ) -}}
      {{- .Domain.Kstadium.CertArn -}}
    {{- end -}}
  {{- else if eq .Values.Domain "Dex" -}}
    {{- with index .Values.AWS  ( camelcase .Values.Env ) -}}
      {{- .Domain.Dex.CertArn -}}
    {{- end -}}  
  {{- else if eq .Values.Domain "Flux" -}}
    {{- with index .Values.AWS  ( camelcase .Values.Env ) -}}
      {{- .Domain.Flux.CertArn -}}        
    {{- end -}}
  {{- else -}}
    {{- fail "Error! in ingress.setCertArn, Please check conditions" -}}
  {{- end -}}
{{- end -}}

{{- define "ingress.setListenPort" -}}
  [{{- range $key, $value := .Values.LbConfig.ListenPorts }}
    {{- printf "{\"%s\":%d}" $value.protocol (int $value.port) }}
    {{- if lt $key (sub (len $.Values.LbConfig.ListenPorts) 1) }}, {{ end }}
  {{- end }}]
{{- end -}}

{{- define "ingress.setHostname" -}}
  {{- if eq .Values.Domain "Kstadium" -}}
    {{- $ARecord := .Values.ARecord -}}
    {{- with index .Values.AWS  ( camelcase .Values.Env ) -}}
      {{- $ARecord -}}.{{- .Domain.Kstadium.HostingZone -}}
    {{- end -}}
  {{- else if eq .Values.Domain "Dex" -}}
    {{- if empty .Values.ARecord -}}
      {{- with index .Values.AWS  ( camelcase .Values.Env ) -}}
        {{- .Domain.Dex.HostingZone -}}
      {{- end -}}
    {{- else -}}      
    {{- $ARecord := .Values.ARecord -}}
    {{- with index .Values.AWS  ( camelcase .Values.Env ) -}}
      {{- $ARecord -}}.{{- .Domain.Dex.HostingZone -}}
    {{- end -}}
    {{- end -}}
  {{- else if eq .Values.Domain "Flux" -}}
    {{- if empty .Values.ARecord -}}
    {{- with index .Values.AWS  ( camelcase .Values.Env ) -}}
      {{- .Domain.Flux.HostingZone -}}
    {{- end -}}
    {{- else -}}
    {{- $ARecord := .Values.ARecord -}}
    {{- with index .Values.AWS  ( camelcase .Values.Env ) -}}
      {{- $ARecord -}}.{{- .Domain.Flux.HostingZone -}}
    {{- end -}}
    {{- end -}}
  {{- else -}}
    {{- fail "Error! in ingress.setHostname, Please check conditions" -}}    
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
    alb.ingress.kubernetes.io/load-balancer-name: {{ include "ingress.setLBName" . }}
    alb.ingress.kubernetes.io/group.name: {{ include "ingress.setGroupName" . }}
    alb.ingress.kubernetes.io/scheme: {{ .Values.LbConfig.ElbPubOrPri }}
    alb.ingress.kubernetes.io/certificate-arn: {{ include "ingress.setCertArn" . }}
    alb.ingress.kubernetes.io/ssl-policy: {{ .Values.LbConfig.SslPolicy }}
    alb.ingress.kubernetes.io/backend-protocol: {{ .Values.LbConfig.BackendProtocol }}
    alb.ingress.kubernetes.io/healthcheck-path: {{ .Values.LbConfig.HealthCheck }}
    alb.ingress.kubernetes.io/target-type: {{ .Values.LbConfig.TargetType }}
    alb.ingress.kubernetes.io/listen-ports: {{ include "ingress.setListenPort" . | squote }}
    alb.ingress.kubernetes.io/ssl-redirect: '443'
    alb.ingress.kubernetes.io/actions.ssl-redirect: '[{"Type": "redirect", "RedirectConfig": {"Protocol": "HTTPS", "Port": "443", "StatusCode": "HTTP_301"}]'
    # external-dns.alpha.kubernetes.io/hostname: eks-{{ include "ingress.setHostname" . }} 
spec:
  rules:
  - host: {{ include "ingress.setHostname" . }}
    http:
      paths: 
      - path: /
        pathType: Prefix
        backend:
          service:
            name: {{ .Values.Env }}-{{ .Release.Name }}
            port:
              number: 443
{{- end -}}