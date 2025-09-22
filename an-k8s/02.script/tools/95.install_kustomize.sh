#!/bin/bash

# Download the latest release of Kustomize
curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash

# Move the kustomize binary to a directory in your system's PATH
sudo mv kustomize /usr/local/bin/

# Verify that Kustomize is installed correctly
kustomize version