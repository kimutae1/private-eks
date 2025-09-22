# app-admin deployment yaml 생성
cat <<EOF > ${YAML_HOME}/${ENV}-app-admin-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-deployment
  namespace: kube-system
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
  namespace: kube-system
spec:
  selector:
    app: app-deployment
  ports:
    - protocol: TCP
      port: 80
      targetPort: 3000
  type: NodePort
EOF

# app-admin ingress 생성
cat <<EOF > ${YAML_HOME}/${ENV}-app-admin-ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: app-ingress
  namespace: kube-system
  annotations:
    # Ingress Core Settings
    kubernetes.io/ingress.class: alb
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/target-type: ip
    alb.ingress.kubernetes.io/target-group-attributes: stickiness.enabled=true,stickiness.lb_cookie.duration_seconds=60
    # SSL Settings
    alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 80}, {"HTTPS":443}]'
    alb.ingress.kubernetes.io/certificate-arn: arn:aws:acm:ap-northeast-2:911781391110:certificate/c4b1fa44-ad4b-404e-aa4d-6e6e2aa3f858
    alb.ingress.kubernetes.io/ssl-redirect: '443'
    external-dns.alpha.kubernetes.io/hostname: test-app-admin.dev.kstadium.io
spec:
  rules:
  - http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: app-service
            port:
              number: 80
EOF

kubectl apply -f ${YAML_HOME}/${ENV}-app-admin-ingress.yaml
kubectl apply -f ${YAML_HOME}/${ENV}-app-admin-service.yaml
kubectl apply -f ${YAML_HOME}/${ENV}-app-admin-deployment.yaml