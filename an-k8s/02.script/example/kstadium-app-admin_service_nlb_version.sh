# app-admin deployment yaml 생성
cat <<EOF > ${YAML_HOME}/${ENV}-app-admin-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-deployment
spec:
  replicas: 2
  selector:
    matchLabels:
      app: app-deployment
  template:
    metadata:
      labels:
        app: app-deployment
    spec:
      containers:
      - name: app-deployment
        image: 911781391110.dkr.ecr.ap-northeast-2.amazonaws.com/develop/app-admin:latest
        ports:
        - containerPort: 3000
EOF

# admin-admin service 생성
cat <<EOF > ${YAML_HOME}/${ENV}-app-admin-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: app-service
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-type: external
    service.beta.kubernetes.io/aws-load-balancer-nlb-target-type: ip
spec:
  selector:
    app: app-deployment
  ports:
    - protocol: TCP
      port: 80
      targetPort: 3000
  type: LoadBalancer
EOF

kubectl apply -f ${YAML_HOME}/${ENV}-app-admin-deployment.yaml
kubectl apply -f ${YAML_HOME}/${ENV}-app-admin-service.yaml