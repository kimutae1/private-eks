# privateEKS custom Project

## Architecture Overview

이 프로젝트는 하이브리드 컨테이너 아키텍처를 구현합니다:

- **인증 서비스**: Keycloak을 AWS ECS에서 운영하여 중앙 집중식 인증 관리
- **워크로드**: 마이크로서비스를 AWS EKS에서 운영하여 확장성과 관리 효율성 확보

### Key Components

- **ECS (Keycloak)**: 인증/인가 처리, 사용자 관리, SSO 제공
- **EKS (Workloads)**: 비즈니스 로직, API 서비스, 데이터 처리

## diagrams

![1](diagrams/privateeks_custom_architecture.png)

## Install

[install](./install.md)

## Tools

[bitbucekt 관리](scripts/bitbucket.md)
