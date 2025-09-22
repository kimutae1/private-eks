cat << EOF > configmap-$cluster_name.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-logging
  namespace: kube-system
data:
  output.conf: |
    [OUTPUT]
      Name cloudwatch_logs
      Match *
      region ap-northeast-2
      log_group_name $cluster_name-logging
      log_stream_prefix from-
      auto_create_group true
      log_key log
EOF

kubectl apply -f configmap-$cluster_name.yaml