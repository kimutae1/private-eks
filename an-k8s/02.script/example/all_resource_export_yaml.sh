for resource in $(kubectl api-resources --verbs=list --namespaced -o name); do
  for item in $(kubectl get --show-kind --ignore-not-found $resource -o name|kubectl neat ); do
    mkdir -p $(dirname $item)
    kubectl get $item -o yaml > $item.yaml
  done
done
