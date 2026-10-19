#!/usr/bin/env bash
set -euo pipefail
bash app-source/scripts/prepare.sh
DOCKER_LAB_DIR="$PWD/app-source"; export DOCKER_LAB_DIR
LABEL="org.opencontainers.image.source=https://github.com/${GITHUB_REPOSITORY}"
docker build --label "$LABEL" -f app-source/images/api-alpine/Dockerfile -t docker-lab-api-alpine:local app-source
docker build --label "$LABEL" -f trace-source/instrumentation/Dockerfile.alpine -t docker-lab-api-alpine-otel:local trace-source/instrumentation
python3 app-source/tests/api_alpine.py
python3 trace-source/tests/alpine_otlp.py
python3 scan-source/scripts/prepare.py
mkdir -p .local/api-alpine
for VARIANT in basic traced; do
  IMAGE=docker-lab-api-alpine:local
  if [ "$VARIANT" = traced ]; then IMAGE=docker-lab-api-alpine-otel:local; fi
  scan-source/.local/bin/trivy image --cache-dir scan-source/.local/cache --scanners vuln --no-progress --image-src docker --list-all-pkgs --ignore-unfixed=false --ignorefile scan-source/config/empty.ignore --severity UNKNOWN,LOW,MEDIUM,HIGH,CRITICAL --format json --output ".local/api-alpine/$VARIANT-scan.json" "$IMAGE"
  python3 scan-source/scripts/gate.py ".local/api-alpine/$VARIANT-scan.json" --output ".local/api-alpine/$VARIANT-gate.json"
  docker image inspect "$IMAGE" --format '{{.Id}}' > ".local/api-alpine/$VARIANT-image-id.txt"
done
