#!/bin/bash
https_BITBUCKET_SERVER="https://code.bespinglobal.com"
BITBUCKET_SERVER="code.bespinglobal.com"

# ~/.bashrc or ~/.zshrc 에 환경 bitbucket 정보를 넣어주세요 
#export BITBUCKET_USERNAME=kim@bespinglobal.com
#export BITBUCKET_PASSWORD='xxxyxyyxyxy'





# 프로젝트 목록 가져오기
echo "프로젝트 목록을 가져오는 중..."
project_list=$(curl -s -u "${BITBUCKET_USERNAME}:${BITBUCKET_PASSWORD}" "${https_BITBUCKET_SERVER}/rest/api/1.0/projects" | jq -r '.values[] | .name + "|" + .key')

# 프로젝트 목록 출력
echo "사용 가능한 프로젝트:"
IFS=$'\n'  # 내부 필드 구분자를 개행 문자로 설정
select project_choice in $project_list; do
    project_name=$(echo "$project_choice" | cut -d '|' -f 1)
    project_key=$(echo "$project_choice" | cut -d '|' -f 2)
    echo "선택된 프로젝트: $project_name ($project_key)"
    break
done
unset IFS  # IFS 설정을 원래대로 복구

# 선택된 프로젝트의 리포지토리 목록 가져오기
echo "리포지토리 목록을 가져오는 중..."
repo_list=$(curl -s -u "${BITBUCKET_USERNAME}:${BITBUCKET_PASSWORD}" "${https_BITBUCKET_SERVER}/rest/api/1.0/projects/${project_key}/repos" | jq -r '.values[] | .slug')

# 리포지토리 목록 출력
echo "사용 가능한 리포지토리:"
select repo_slug in $repo_list "모든 리포지토리 클론"; do
    if [[ $repo_slug == "모든 리포지토리 클론" ]]; then
        echo "모든 리포지토리를 클론하는 중..."
        for repo in $repo_list; do
            #git clone "${https_BITBUCKET_SERVER}/scm/${project_key}/${repo}.git"
            git clone "ssh://git@${BITBUCKET_SERVER}/${project_key}/${repo}.git"
        done
        break
    else
        echo "선택된 리포지토리: $repo_slug"
        break
    fi
done

# 작업 선택
echo "수행할 작업을 선택하세요 (clone, save, pull, all_clone):"
read action

case $action in
    clone)
        echo "저장소를 클론하는 중..."
  #      git clone "${https_BITBUCKET_SERVER}/scm/${project_key}/${repo_slug}.git"
        git clone "ssh://git@${BITBUCKET_SERVER}/${project_key}/${repo_slug}.git"
  #      git clone ssh://git@code.bespinglobal.com/ankbds/docs.git
        ;;
    save)
        echo "프로젝트 정보를 저장하는 중..."
        echo "$project_key $project_name $repo_slug" > "${project_key}_${repo_slug}_info.txt"
        ;;
    pull)
        echo "최신 변경사항을 가져오는 중..."
        if [ -d "$repo_slug" ]; then
            cd "$repo_slug" && git pull
        else
            echo "디렉토리 '$repo_slug'가 존재하지 않습니다."
        fi
        ;;
    all_clone)
        echo "모든 리포지토리를 클론하는 중..."
        for repo in $repo_list; do
            #git clone "${https_BITBUCKET_SERVER}/scm/${project_key}/${repo}.git"
            git clone "ssh://git@${BITBUCKET_SERVER}/${project_key}/${repo}.git"
        done
        ;;
    *)
        echo "알 수 없는 작업: $action"
        ;;
esac
