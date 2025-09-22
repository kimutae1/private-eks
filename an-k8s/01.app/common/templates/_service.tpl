{{- define "service.setPort" -}}
  {{ $targetPort := include "deployment.setPort" . }}
  {{- range $key, $value := .Values.LbConfig.ListenPorts -}}
    {{- if ne (int $value.port) 80 -}}
    {{ $port := (int $value.port) }}
    - name: listen-{{ $port }}
      protocol: TCP
      port: {{ $port }}
      targetPort: {{ $targetPort }}
    {{- end -}}
  {{- end -}}
{{- end -}}


######################
# service template
{{- define "service.template" -}}
apiVersion: v1
kind: Service
metadata:
  name: {{ .Values.Env }}-{{ .Release.Name }}
  namespace: {{ .Release.Namespace }}
spec:
  selector:
    app: {{ .Values.Env }}-{{ .Release.Name }}
  ports:
    {{- include "service.setPort" . }}
  type: ClusterIP
  {{- end -}}