#helm repo add argo https://argoproj.github.io/argo-helm
helm install argorollout argo/argo-rollouts -n default
