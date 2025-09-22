# StorageClass, PV, PVC, Deployment 생성
cat << EOF > ${YAML_HOME}/${ENV}-mysql-ebs.yaml
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: mysql-storage-class
provisioner: ebs.csi.aws.com
parameters:
  type: gp3
  fsType: ext4
reclaimPolicy: Retain

---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: mysql-pv1-2a
spec:
  capacity:
    storage: 10Gi
  volumeMode: Filesystem
  accessModes:
    - ReadWriteOnce
  storageClassName: mysql-storage-class
  awsElasticBlockStore:
    volumeID: vol-00f35233255093e49
    fsType: ext4

---

apiVersion: v1
kind: PersistentVolume
metadata:
  name: mysql-pv2-2a
spec:
  capacity:
    storage: 10Gi
  volumeMode: Filesystem
  accessModes:
    - ReadWriteOnce
  storageClassName: mysql-storage-class
  awsElasticBlockStore:
    volumeID: vol-00f35233255093e49
    fsType: ext4

---

apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mysql-pvc
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: mysql-storage-class
  resources:
    requests:
      storage: 10Gi
  volumeName: mysql-pv2-2a
# 
---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysql-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mysql
  template:
    metadata:
      labels:
        app: mysql
    spec:
      containers:
        - name: mysql
          image: mysql:latest
          env:
          - name: MYSQL_ROOT_PASSWORD
            value: root
          ports:
            - containerPort: 3306
          volumeMounts:
            - name: mysql-volume
              mountPath: /volume/pv2
      volumes:
        - name: mysql-volume
          persistentVolumeClaim:
            claimName: mysql-pvc

---
apiVersion: v1
kind: Service
metadata:
  name: mysql-service
spec:
  selector:
    app: mysql
  ports:
    - protocol: TCP
      port: 3306
      targetPort: 3306
EOF

kubectl apply -f ${YAML_HOME}/${ENV}-mysql-ebs.yaml