cat << EOF > argo-apps-values.yaml
applications: 
- name: dev-kstadium-service
  namespace: default
  additionalLabels: {}
  additionalAnnotations: {}
  finalizers:
  - resources-finalizer.argocd.argoproj.io
  project: default
  source:
    repoURL: git@github.com:the-medium/kstadium-k8s.git
    targetRevision: develop 
    path: manifest/test-app-admin/overlays/develop
  destination:
    name: dev-kstadium-service
    namespace: default
  syncPolicy:
    automated:
      prune: false
      selfHeal: false
    syncOptions:
    - CreateNamespace=true
  revisionHistoryLimit: null
  info:
  - name: url
    value: https://github.com/the-medium/test-app-admin

EOF

helm upgrade --install -n default test-app-admin argo/argocd-apps -f argo-apps-values.yaml
