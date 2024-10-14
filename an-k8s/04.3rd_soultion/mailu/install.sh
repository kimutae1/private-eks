helm repo add mailu https://mailu.github.io/helm-charts/
#helm show values mailu/mailu > my-values-file.yaml
#helm install mailu mailu/mailu -n mailu-mailserver --values my-values-file.yaml
#helm upgrade --install mailu mailu/mailu -n mailu-mailserver --values my-values-file.yaml
# helm template mailu -f my-values-file.yaml > start.yaml
#helm uninstall mail-d --namespace=mailu-mailserver
helm  install mailu ./mailu -n mailu-mailserver --values my-values-file.yaml

#uninstall
