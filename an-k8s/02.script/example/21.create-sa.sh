cat << EOF > ${YAML_HOME}/${ENV}-create-sa.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: eks-node-role
  namespace: kube-system
  annotations:
    eks.amazonaws.com/role-arn: $eks_node_role


apiVersion: v1
kind: ServiceAccount
metadata:
  name: eks-node-role-default
  namespace: default
  annotations:
    eks.amazonaws.com/role-arn: $eks_node_role

apiVersion: v1
kind: ServiceAccount
metadata:
  name: eks-sa-role
  namespace: default
  annotations:
    eks.amazonaws.com/role-arn: $eks_sa_role
EOF

kubectl apply -f ${YAML_HOME}/${ENV}-create-sa.yaml