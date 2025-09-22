helm repo add docker-mailserver https://docker-mailserver.github.io/docker-mailserver-helm/
helm repo update

helm upgrade -i docker-mail-server docker-mailserver/docker-mailserver -f values.yaml



#uninstall
