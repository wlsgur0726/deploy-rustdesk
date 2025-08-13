#!/bin/bash

set -e

# 배포 대상 서버 정보 (CI인자)
#TARGET_USER="user"
#TARGET_HOST="localhost"  # 또는 실제 서버 IP/호스트명

TEMP_DIR="/tmp/rustdesk-deploy"

# 기존 임시 파일 정리
echo "기존 임시 파일 정리..."
ssh ${TARGET_USER}@${TARGET_HOST} "rm -rf ${TEMP_DIR}"

# SSH를 통해 파일들을 user 계정으로 전송
echo "${TARGET_USER}@${TARGET_HOST}로 파일 전송..."
ssh ${TARGET_USER}@${TARGET_HOST} "mkdir -p ${TEMP_DIR}"
scp ./hbbs.container ./hbbr.container ./setup-rustdesk.sh ${TARGET_USER}@${TARGET_HOST}:${TEMP_DIR}/

# 루트리스 서비스 설정 스크립트 실행
echo "루트리스 서비스 설정 스크립트 실행..."
ssh ${TARGET_USER}@${TARGET_HOST} "chmod +x ${TEMP_DIR}/setup-rustdesk.sh && ${TEMP_DIR}/setup-rustdesk.sh ${TEMP_DIR}"

echo "배포 완료!"