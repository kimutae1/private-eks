REGISTRY_NAME=registry-1.docker.io
REPOSITORY_NAME=bitnamicharts

 helm uninstall redis
 sleep 5
 
 helm install redis oci://$REGISTRY_NAME/$REPOSITORY_NAME/redis -f values.yaml
