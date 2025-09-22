# StorageClass, PV, PVC, Deployment 생성
cat << EOF > ${YAML_HOME}/${ENV}-nginx-volume.yaml
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: nginx-storage-class
provisioner: ebs.csi.aws.com
parameters:
  type: gp3
  fsType: ext4
reclaimPolicy: Retain

---

apiVersion: v1
kind: PersistentVolume
metadata:
  name: nginx-volume-ap-northeast-2a
spec:
  capacity:
    storage: 10Gi
  volumeMode: Filesystem
  accessModes:
    - ReadWriteOnce
  storageClassName: nginx-storage-class
  awsElasticBlockStore:
    volumeID: vol-00f35233255093e49
    fsType: ext4

---

apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: nginx-pvc-ap-northeast-2a
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: nginx-storage-class
  resources:
    requests:
      storage: 10Gi
  volumeName: nginx-volume-ap-northeast-2a

---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment-ap-northeast-2a
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
      zone: ap-northeast-2a
  template:
    metadata:
      labels:
        app: nginx
        zone: ap-northeast-2a
    spec:
      nodeSelector:
        topology.kubernetes.io/zone: ap-northeast-2a
      containers:
        - name: nginx
          image: nginx
          ports:
            - containerPort: 80
          volumeMounts:
            - name: nginx-volume
              mountPath: /usr/share/nginx/html
      volumes:
        - name: nginx-volume
          persistentVolumeClaim:
            claimName: nginx-pvc-ap-northeast-2a

---

apiVersion: v1
kind: PersistentVolume
metadata:
  name: nginx-volume-ap-northeast-2c
spec:
  capacity:
    storage: 10Gi
  volumeMode: Filesystem
  accessModes:
    - ReadWriteOnce
  storageClassName: nginx-storage-class
  awsElasticBlockStore:
    volumeID: vol-0983f8b11b46ef7ce
    fsType: ext4

---

apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: nginx-pvc-ap-northeast-2c
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: nginx-storage-class
  resources:
    requests:
      storage: 10Gi
  volumeName: nginx-volume-ap-northeast-2c

---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment-ap-northeast-2c
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
      zone: ap-northeast-2c
  template:
    metadata:
      labels:
        app: nginx
        zone: ap-northeast-2c
    spec:
      nodeSelector:
        topology.kubernetes.io/zone: ap-northeast-2c
      containers:
        - name: nginx
          image: nginx
          ports:
            - containerPort: 80
          volumeMounts:
            - name: nginx-volume
              mountPath: /usr/share/nginx/html
      volumes:
        - name: nginx-volume
          persistentVolumeClaim:
            claimName: nginx-pvc-ap-northeast-2c
EOF

kubectl apply -f ${YAML_HOME}/${ENV}-nginx-volume.yaml