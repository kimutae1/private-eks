helm repo add docker-postfix https://bokysan.github.io/docker-postfix/
#helm install my-mail docker-postfix/mail --version 4.1.0

#helm upgrade --install --set persistence.enabled=false --set config.general.ALLOW_EMPTY_SENDER_DOMAINS=yes mail bokysan/mail


helm upgrade --install --set persistence.enabled=false --set config.general.ALLOWED_SENDER_DOMAINS=mail.dev.kstadium.io mail bokysan/mail

#Postfix service installed. Send email by using the following address and port:
#export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=mail,app.kubernetes.io/instance=mail" -o jsonpath= "{.items[0].metadata.name}") 
#echo "Visit http://127.0.0.1:8080 to use your application"
#kubectl --namespace default port-forward $POD_NAME 587:587

#admin
#helm repo add volker.raschek https://charts.cryptic.systems/volker.raschek
#helm install postfixadmin volker.raschek/postfixadmin
