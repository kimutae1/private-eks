#!/bin/bash

service=test-app-admin2
port=3000

# Service dir 생성
mkdir ${service}
cd ${service}

# base, ovelays dir 생성
mkdir base
mkdir overlays

# base 기초 yaml 생성
cd base
cat << EOF > deployment.yaml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: ${service}
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ${service}
  template:
    metadata:
      labels:
        app: ${service}
    spec:
      containers:
      - name: ${service}
        image: Set_Kustomize:latest
        ports:
        - containerPort: ${port}

EOF

cat << EOF > service.yaml

apiVersion: v1
kind: Service
metadata:
  name: ${service}-svc
spec:
  selector:
    app: ${service}
  ports:
    - protocol: TCP
      port: 80
      targetPort: ${port}
  type: NodePort

EOF

cat << EOF > kustomization.yaml

apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
- ./deployment.yaml
- ./service.yaml

EOF

cd ../overlays

# 환경별 dir 생성
environments=("develop" "release" "main")
for env in "${environments[@]}"
do

mkdir $env
cd $env
cat << EOF > kustomization.yaml

apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

namePrefix: $env-

resources:
- ../../base

patches:
- path: ./replica.yaml
EOF

cat << EOF > replica.yaml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: ${service}
spec:
  replicas: 1
EOF

cd ..
done
