## helm repo 추가 
#Stable한 저장소를 다운로드하여 아래와 같이 구성합니다.
helm repo add stable https://charts.helm.sh/stable
helm repo update

helm search repo stable

helm search repo nginx

#간단한 웹서비스 배포를 위해 nginx를 추가해서 구동해 봅니다. 배포도구로 인기 있는 bitnami repo를 추가해서 nginx를 설치해 봅니다.
helm repo add bitnami https://charts.bitnami.com/bitnami
helm search repo bitnami/nginx

kubectl create namespace helm-test
helm install helm-nginx bitnami/nginx --namespace helm-test

kubectl -n helm-test get service

export SERVICE_IP=$(kubectl get svc --namespace helm-test helm-nginx --template "{{ range (index .status.loadBalancer.ingress 0) }}{{.}}{{ end }}")
echo "NGINX URL: http://$SERVICE_IP/"

#delete
#helm uninstall helm-nginx -n helm-test

#확인
helm list -n helm-test
kubectl -n helm-test get service 

