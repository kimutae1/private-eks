{{- define "deployment.setImg" -}} 
  {{- $appname := .Release.Name -}}
  {{- $tagname := .Values.NewTag -}}
  {{- with index .Values.AWS  ( camelcase .Values.Env ) -}}
    {{- .AccountId -}}.dkr.ecr.{{- .Region -}}.amazonaws.com/{{- .Branch -}}/{{- $appname -}}:{{- $tagname }}
  {{- end -}}
{{- end -}}

{{- define "deployment.setEnv" -}}
{{- if empty .Values.CommonSecretSelect -}}
  {{- /* .Values.CommonSecretSelect가 빈 값이면 건너뛰기 */ -}}
{{- else -}}
  {{- if kindIs "slice" .Values.CommonSecretSelect -}}
    {{- $releaseName := .Release.Name }}
        env:
    {{- range $select := .Values.CommonSecretSelect }}
    {{- $keyName := index $.Values.CommonSecret $select -}}
    {{- range $key := splitList " " $keyName }} 
        - name: {{ $key }}
          valueFrom:
            secretKeyRef:
              name: {{ $releaseName }}-secret
              key: {{ $key }}
    {{- end -}}
    {{- end -}}
  {{- else -}}
    {{- fail "Error! Please, Define to 'slice' type for Secret key name at CommonSecretSelect of values.yaml" -}}  
  {{- end -}}
{{- end -}}  
{{- end -}}

{{- define "deployment.setOptionalSecretManagerEnv" -}}
{{- if empty .Values.OptionalSecretManagerSelect -}}
  {{- /* .Values.OptionalSecretManagerSelect가 빈 값이면 건너뛰기 */ -}}
{{- else -}}
  {{- if kindIs "slice" .Values.OptionalSecretManagerSelect -}}
    {{- $releaseName := .Release.Name -}}
    {{- if empty .Values.CommonSecretSelect }}
        env:
    {{- else -}}
      {{- /* CommonSecretSelect를 사용하는 경우 하위에 env: 가 또 안붙도록 패스시킴 */ -}}
    {{- end -}}
    {{- range $select := .Values.OptionalSecretManagerSelect -}}
    {{- $keyName := index $.Values.OptionalSecretManager $select -}}
    {{- range $key := splitList " " $keyName }} 
        - name: {{ $key }}
          valueFrom:
            secretKeyRef:
              name: {{ $releaseName }}-secret
              key: {{ $key }}
    {{- end -}}
    {{- end -}}
  {{- else -}}
    {{- fail "Error! Please, Define to 'slice' type for Secret key name at OptionalSecretManagerSelect of values.yaml" -}}  
  {{- end -}}
{{- end -}}  
{{- end -}}

{{- define "deployment.setPort" -}}
  {{- if empty .Values.AppType -}}
    {{- fail "Error! AppType is Empty for deployment.setPort" -}}  
  {{- else -}}
    {{- range $key, $value := ( index .Values.AppSet .Values.AppType ) -}}
      {{- if eq $key "ContainerPort" -}}
        {{- if empty $value -}}
          {{- fail "Error! ContainerPort is Empty in Values.AppSet" -}}
        {{- else -}}
          {{- $value -}}
        {{- end -}}    
      {{- end -}}  
    {{- end -}}  
  {{- end -}}
{{- end -}}

######################
# deployment template
{{- define "deployment.template" -}}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Values.Env }}-{{ .Release.Name }}
  namespace: {{ .Release.Namespace }}
spec:
  replicas: {{ .Values.Replicas }}
  revisionHistoryLimit: 2
  selector:
    matchLabels:
      app: {{ .Values.Env }}-{{ .Release.Name }}
  template:
    metadata:
      labels:
        app: {{ .Values.Env }}-{{ .Release.Name }}
    spec:
      containers:
      - name: {{ .Values.Env }}-{{ .Release.Name }}
        image: {{ include "deployment.setImg" . }}
        ports:
          - containerPort: {{ include "deployment.setPort" . }}
        {{- if empty (or (include "deployment.setEnv" .) (include "deployment.setOptionalSecretManagerEnv" .)) -}}
          {{- /* Secret관련 nil이 리턴될 경우 건너뛰기 */ -}}
        {{- else -}}
          {{- include "deployment.setEnv" . }}
          {{- include "deployment.setOptionalSecretManagerEnv" . }}
        {{- end -}}
{{- end -}}