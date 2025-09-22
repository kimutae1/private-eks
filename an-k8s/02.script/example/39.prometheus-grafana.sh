helm repo add prometheus-community https://prometheus-community.github.io/helm-charts 
helm repo add grafana https://grafana.github.io/helm-charts 
helm repo update

cat <<EOF > values-prometheus.yaml
server:
  enabled: true

  persistentVolume:
    enabled: true
    accessModes:
      - ReadWriteOnce
    mountPath: /data
    size: 100Gi
  replicaCount: 1

  ## Prometheus data retention period (default if not specified is 15 days)
  ##
  retention: "15d"
EOF

cat << EOF > values-grafana.yaml
replicas: 1

service:
  type: LoadBalancer #Local환경 이라면, NodePort로 설정한다.

persistence:
  type: pvc
  enabled: true
  # storageClassName: default
  accessModes:
    - ReadWriteOnce
  size: 10Gi
  # annotations: {}
  finalizers:
    - kubernetes.io/pvc-protection

# Administrator credentials when not using an existing secret (see below)
adminUser: admin
adminPassword: test1234
EOF

kubectl create ns prometheus
helm install prometheus prometheus-community/prometheus -f values-prometheus.yaml -n prometheus
helm install grafana grafana/grafana -f values-grafana.yaml -n prometheus