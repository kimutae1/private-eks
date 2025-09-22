#!/bin/bash
folders=$(ls -d */)

for folder in $folders
do
    folder=${folder%?}  # 폴더 이름에서 슬래시(/) 제거
    cp -p "$folder/values.yaml" "$folder/dev-values.yaml"
    cp -p "$folder/values.yaml" "$folder/stg-values.yaml"
    ln -s ../../02.script/03.addon/argocd/2.argo_apps_helm.sh $folder/argo_apps_helm.sh
done

