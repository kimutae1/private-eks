#!/bin/bash

# ConfigMap 생성을 위한 YAML 파일 작성
cat <<EOF > ${YAML_HOME}/${ENV}-configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles:  |
    - groups:
        - system:masters
        - system:bootstrappers
        - system:nodes
      rolearn: $sso_role
      username: system:node:{{SessionName}}
    - groups:
       - system:masters
       - system:bootstrappers
       - system:node-proxier
       - system:nodes
      rolearn: $devops_role
      username: system:node:{{SessionName}}
    - groups:
       - system:masters
       - system:bootstrappers
       - system:nodes
       - system:node-proxier
      rolearn: $eks_engine_role
      username: system:node:{{EC2PrivateDNSName}}
EOF

kubectl apply -f ${YAML_HOME}/${ENV}-configmap.yaml