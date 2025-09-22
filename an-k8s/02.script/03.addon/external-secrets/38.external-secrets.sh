#!/bin/bash
helm repo add external-secrets https://charts.external-secrets.io

helm install external-secrets \
    external-secrets/external-secrets \
    -n external-secrets \
    --create-namespace \
    --set installCRDs=true \
    --set webhook.port=9443

# kubectl apply -f external-secrets/dev-secretstore.yaml
# kubectl apply -f external-secrets/dev-externalsecret.yaml