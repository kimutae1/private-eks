docker run --rm -it -p 8080:8080 -e DEBUG=1 -e STORAGE=local -e STORAGE_LOCAL_ROOTDIR=/mychart -v $(pwd)/charts:/charts ghcr.io/helm/chartmuseum:v0.14.0


helm repo add chartmuseum http://localhost:8080
