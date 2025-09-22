# bastion 서버 셋팅
>설치 요건은 아래와 같다.

- ubuntu
------

- zsh
```
sudo apt -y install zsh
chsh -s $(which zsh)
```
- oh-my-zsh
```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

```


```
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k

# Powerlevel10k 테마 설치
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# .zshrc 파일에서 테마 설정
sed -i 's/ZSH_THEME=".*"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc

# 설정 적용
source ~/.zshrc

# Powerlevel10k 설정 마법사 실행
p10k configure
=======

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
```

```
cd ~/.oh-my-zsh/plugins
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
#echo "source ${(q-)PWD}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc

# ~/.zshrc에 아래처럼 적어주면 됨
#plugins=(git kubectl kube-ps1 zsh-syntax-highlighting zsh-autosuggestions)


git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions


```


---

- command-not-found
command-not-found는 터미널에서 명령어를 입력했을 때 </br>
해당 명령어를 찾을 수 없을 경우,</br>
해당 명령어를 제공하는 패키지를 제안해주는 유틸리티입니다.

```
sudo apt install command-not-found
echo "source /etc/zsh_command_not_found" >> ~/.zshrc
exec zsh
```



- node 
```
curl -fsSL https://deb.nodesource.com/setup_21.x | sudo -E bash -
sudo apt-get install -y nodejs

#nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
nvm install 16
nvm use 16
# 최신버전 latest
nvm install latest
nvm use latest
```

---
- vi / nvim
- AstroNvim
 참고 : https://github.com/kimutae1/neovim 
---

- fzf
```
   git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
   ~/.fzf/install
```

- zip
```
sudo apt install zip unzip p7zip-full
```

- net-tools
ifconfig , netstat등 network 관련 
```
sudo apt install net-tools telnet ncat
```


- docker 
```
sudo apt install docker.io
    sudo groupadd docker
    sudo usermod -aG docker $USER
    newgrp docker
    sudo systemctl restart docker

```

- kubectl
```
sudo apt-get install -y apt-transport-https ca-certificates curl
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl
```
---

- terraform 
```
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform
```

- mysql
```
 sudo apt install mysql-client

``` 

- gui 용 component
  - fix-missing 옵션은 설치 프로세스 중에 발생할 수 있는 누락된 종속성을 해결하는 데 사용됩니다.
```

sudo apt install gnome-text-editor -y
sudo apt install gimp -y
sudo apt install nautilus -y
sudo apt install vlc -y
sudo apt install x11-apps -y
```

- Linux용 Google Chrome

```
cd /tmp
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install --fix-missing ./google-chrome-stable_current_amd64.deb

시작하려면 google-chrome을(를) 입력합니다.
```

- AWSCLI

```
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

- EKSCTL
```
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl version
```

- k9s
```
K9S_VERSION=$(curl -s https://api.github.com/repos/derailed/k9s/releases/latest | jq -r '.tag_name')
curl -sL https://github.com/derailed/k9s/releases/download/${K9S_VERSION}/k9s_Linux_amd64.tar.gz | sudo tar xfz - -C /usr/local/bin k9s
```

- helm 
```
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
```


- argocdcli
```
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64
```

- kubernetes krew
```

   (
     set -x; cd "$(mktemp -d)" &&
     OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
     ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
     KREW="krew-${OS}_${ARCH}" &&
     curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
     tar zxvf "${KREW}.tar.gz" &&
     ./"${KREW}" install krew
   )

#PATH 환경 변수에 Krew 추가
   echo 'export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"' >> ~/.bashrc
   source ~/.bashrc

```
- k8s neat 

```
kubectl krew install neat
```


