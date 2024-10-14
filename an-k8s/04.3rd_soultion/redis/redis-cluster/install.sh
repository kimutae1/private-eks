#helm repo add bitnami https://charts.bitnami.com/bitnami
# helm show values bitnami/redis-cluster > cluster-values.yaml
# helm install redis-cluster bitnami/redis-cluster -n default -f cluster-values.yaml
# helm uninstall redis-cluster


 helm uninstall redis-cluster
 sleep 5
  helm install redis-cluster bitnami/redis-cluster -n default -f lio-values.yaml
