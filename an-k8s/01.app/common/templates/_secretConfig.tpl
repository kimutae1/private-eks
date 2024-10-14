{{- define "secretconfig.setData" -}}
{{- if empty .Values.CommonSecretSelect -}}
  {{/* nil이 리턴될 경우 건너뛰기 */}}
{{- else -}}
  {{- if kindIs "slice" .Values.CommonSecretSelect -}}
  {{- range $select := index $.Values.CommonSecretSelect }}
  {{- $keyName := index $.Values.CommonSecret $select -}}
  {{- range $key := splitList " " $keyName }}
  - secretKey: {{ $key }}
    remoteRef:
      key: "common-secret"
      property: {{ lower $select }}.{{ $key }}
  {{- end -}}
  {{- end -}}
  {{- else -}}
    {{- fail "Error! Please, Define to 'slice' type for Secret key name at CommonSecretSelect of values.yaml" -}}  
  {{- end -}}
{{- end -}}    
{{- end -}}

{{- define "secretconfig.setOptionalSecretManagerData" -}}
{{- if empty .Values.OptionalSecretManagerSelect -}}
  {{/* nil이 리턴될 경우 건너뛰기 */}}
{{- else -}}
  {{- if kindIs "slice" .Values.OptionalSecretManagerSelect -}}
  {{- range $select := index $.Values.OptionalSecretManagerSelect }}
  {{- $keyName := index $.Values.OptionalSecretManager $select -}}
  {{- range $key := splitList " " $keyName }}
  - secretKey: {{ $key }}
    remoteRef:
      key: {{ lower $select | quote }}
      property: {{ $key }}
  {{- end -}}
  {{- end -}}
  {{- else -}}
    {{- fail "Error! Please, Define to 'slice' type for Secret key name at OptionalSecretManagerSelect of values.yaml" -}}  
  {{- end -}}
{{- end -}}    
{{- end -}}

##########################
# ExternalSecret template
{{- define "externalsecret.template" -}}
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: {{ .Values.Env }}-{{ .Release.Name }}-externalsecret
  namespace: default
spec:
  refreshInterval: 1m
  secretStoreRef:
    name: {{ .Values.Env }}-secretstore
    kind: SecretStore
  target:
    name: {{ .Release.Name }}-secret
    creationPolicy: Owner
  data:
  {{- include "secretconfig.setData" . }}
  {{- include "secretconfig.setOptionalSecretManagerData" . }} 
{{- end }}