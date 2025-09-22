#!/bin/bash

if [ $# -lt 1 ] ; then
    echo "Argo Apps Script 입니다."
    echo "env 를 입력해주세요."
    echo "input arguments ex) ./argo_apps_helm dev"
    exit 0
fi

env=$1
cluster=service

current_folder=$(pwd)
app=$(basename $current_folder)
echo $env-$app

cat << EOF > $env-argo-apps-values.yaml
applications: 
- name: $app
  namespace: managed
  additionalLabels: {}
  additionalAnnotations: {}
  finalizers:
  - resources-finalizer.argocd.argoproj.io
  project: default
  source:
    repoURL: git@github.com:kstadium/kstadium-k8s.git
    targetRevision: develop
    path: 01.app/common
    helm:
      valueFiles:
        - common-values.yaml
        - ../$app/$env-values.yaml
  destination:
    name: $env-kstadium-$cluster
    namespace: default
  syncPolicy:
    automated:
      prune: false
      selfHeal: false
    syncOptions:
    - CreateNamespace=true
  revisionHistoryLimit: null

EOF

helm upgrade --install $env-$app argo/argocd-apps -f $env-argo-apps-values.yaml
#helm upgrade --install -n default test-app-admin argo/argocd-apps -f argo-apps-values.yaml
