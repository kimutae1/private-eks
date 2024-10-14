helm repo add bitnami https://charts.bitnami.com/bitnami  

helm install keycloak bitnami/keycloak -f values_hector.yaml --namespace default