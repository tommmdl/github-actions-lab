#!/usr/bin/env bash
set -euo pipefail
cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../app-source"
bash scripts/prepare.sh
python3 -m compileall -q app tests
bash -n scripts/*.sh
docker build --label "org.opencontainers.image.source=https://github.com/${GITHUB_REPOSITORY}" \
  --label "org.opencontainers.image.revision=${APP_REVISION}" \
  --label "org.opencontainers.image.url=https://github.com/tommmdl/docker-lab" \
  --label "io.github.pipeline.revision=${GITHUB_SHA}" \
  -t docker-lab-api:local .
docker build --label "org.opencontainers.image.source=https://github.com/${GITHUB_REPOSITORY}" \
  --label "org.opencontainers.image.revision=${APP_REVISION}" \
  -t docker-lab-postgres:local images/postgres
bash scripts/compose.sh up -d --no-build --wait --wait-timeout 180
python3 tests/integration.py
python3 - <<'CHECK'
import json
from pathlib import Path
result = json.loads(Path('.local/integration-results.json').read_text())
if result['passed'] != 23:
    raise SystemExit('Expected all 23 integration checks')
CHECK
mkdir -p ../.local
docker image inspect docker-lab-api:local --format '{{.Id}}' > ../.local/tested-image-id.txt
docker image inspect docker-lab-postgres:local --format '{{.Id}}' > ../.local/tested-postgres-id.txt
docker save docker-lab-api:local docker-lab-postgres:local -o ../.local/tested-image.tar
cd ../.local
sha256sum tested-image.tar > tested-image.tar.sha256
