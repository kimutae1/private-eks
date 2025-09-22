curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
chmod 700 get_helm.sh
./get_helm.sh

#compltion
#helm completion bash >> ~/.bash_completion
#. /etc/profile.d/bash_completion.sh
#. ~/.bash_completion
#source <(helm completion bash)

#helm compltion zsh
helm completion zsh > sudo  /usr/local/share/zsh/site-functions/_helm

#repo add
helm repo add stable https://kubernetes-charts.storage.googleapis.com/
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

#helm search
helm search repo "app name"
helm search repo bitnami/nginx




helm show values bitnami/mariadb

echo '{namespace: helm-test, mariadbUser: user0, mariadbDatabase: user0db}' > helm.yaml
helm install -f helm.yaml stable/mariadb --generate-name


