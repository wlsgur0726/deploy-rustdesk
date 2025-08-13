#!/bin/bash
# 원격 서버에서 실행될 RustDesk 서비스 설정 스크립트

set -e

# 첫 번째 인자로 TEMP_DIR 받기 (기본값: /tmp/rustdesk-deploy)
TEMP_DIR="${1:-/tmp/rustdesk-deploy}"

# RustDesk 데이터 디렉토리 생성
DATA_DIR="$HOME/rustdesk-server-data"
mkdir -p "$DATA_DIR"

# 현재 디렉토리의 Quadlet 파일들을 사용자 홈의 Quadlet 디렉토리로 복사
QUADLET_DIR="$HOME/.config/containers/systemd"
mkdir -p "$QUADLET_DIR"
cp ${TEMP_DIR}/hbbs.container "$QUADLET_DIR/hbbs.container"
cp ${TEMP_DIR}/hbbr.container "$QUADLET_DIR/hbbr.container"

# systemd user 데몬 리로드
systemctl --user daemon-reload

# 서비스 재시작 (이미 실행 중이면 재시작, 아니면 시작)
systemctl --user restart hbbs.service || systemctl --user start hbbs.service
systemctl --user restart hbbr.service || systemctl --user start hbbr.service

# 서비스 상태 확인
echo "=== 서비스 상태 확인 ==="
systemctl --user status hbbs.service --no-pager
systemctl --user status hbbr.service --no-pager

echo "RustDesk 서버(hbbs, hbbr)가 Podman Quadlet으로 사용자(systemd user) 서비스로 실행되었습니다."
