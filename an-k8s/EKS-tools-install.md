리눅스에서 curl을 사용하여 kubectl 바이너리 설치
다음 명령으로 최신 릴리스를 다운로드한다.

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
참고:
특정 버전을 다운로드하려면, $(curl -L -s https://dl.k8s.io/release/stable.txt) 명령 부분을 특정 버전으로 바꾼다.

예를 들어, 리눅스에서 버전 v1.26.0을 다운로드하려면, 다음을 입력한다.

curl -LO https://dl.k8s.io/release/v1.26.0/bin/linux/amd64/kubectl

kubectl: OK

kubectl 설치

sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
참고:
대상 시스템에 root 접근 권한을 가지고 있지 않더라도, ~/.local/bin 디렉터리에 kubectl을 설치할 수 있다.

chmod +x kubectl
mkdir -p ~/.local/bin
mv ./kubectl ~/.local/bin/kubectl
# 그리고 ~/.local/bin 을 $PATH의 앞부분 또는 뒷부분에 추가

kubectl version --client


jq 설치하기
jq는 JSON 형식의 데이터를 다루는 커맨드라인 유틸리티입니다. 아래의 명령어를 통해, jq를 설치합니다.

sudo yum install -y jq

bash-completion 설치하기
Bash 쉘에서 kubectl completion script는 kubectl completion bash 명령어를 통해 생성할 수 있습니다. 쉘에 completion script를 소싱하면 kubectl 명령어의 자동 완성을 가능하게 만들 수 있습니다. 하지만 이런 completion script는 bash-completion에 의존하기 때문에 아래의 명령어를 통해, bash-completion 을 설치해야 합니다.

sudo yum install -y bash-completion

Install Git
Git Downloader  링크를 클릭하여 깃을 설치한다.

Python 설치하기
CDK for Python을 이용하기 떄문에 python 을 설치한다. Cloud9 환경에는 기본적으로 Python이 설치되어 있다. Python Installer  링크에서 적절한 패키지를 선택하여 다운로드 및 설치를 진행한다.

python --version
python3 --version

PIP 확인
Python의 패키지들을 설치하고 관리하는 매니저인 PIP설치 여부를 확인한다. 일정 버전 이상의 Python에 기본적으로 설치되어 있다.

pip
pip3

CodeCommit을 이용하기 위해 9.0.3 버전 이상의 pip가 필요하기 떄문에 아래의 명령을 수행하여 pip를 업데이트 진행한다.

curl -O https://bootstrap.pypa.io/get-pip.py
python3 get-pip.py --user

만약 설치되어 있지 않다면 pip install page  의 가이드 대로 인스톨을 진행하거나 최신 버전의 Python으로 설치를 권장한다.

## eks ctl
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp

sudo mv /tmp/eksctl /usr/local/bin


mkdir -p ~/.zsh/completion/
eksctl completion zsh > ~/.zsh/completion/_eksctl


## k9s
K9S_VERSION=$(curl -s https://api.github.com/repos/derailed/k9s/releases/latest | jq -r '.tag_name')
curl -sL https://github.com/derailed/k9s/releases/download/${K9S_VERSION}/k9s_Linux_amd64.tar.gz | sudo tar xfz - -C /usr/local/bin k9s

