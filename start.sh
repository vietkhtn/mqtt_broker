#!/usr/bin/env bash
set -euo pipefail

DOMAIN="${1:-${HOST_DOMAIN:-}}"
if [[ -z "${DOMAIN}" ]]; then
  echo "Usage: $0 <domain>" >&2
  echo "Alternatively set HOST_DOMAIN before invoking this script." >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="${SCRIPT_DIR}"

python3 - "${ROOT_DIR}" "${DOMAIN}" <<'PY'
import pathlib
import sys

root = pathlib.Path(sys.argv[1])
domain = sys.argv[2]
template = root / "haproxy.cfg.template"
target = root / "haproxy.cfg"

if not template.exists():
  raise SystemExit(f"Template not found: {template}")

data = template.read_text()
target.write_text(data.replace("__HOST_DOMAIN__", domain))
PY

cat <<EOF
Rendered haproxy.cfg for HOST_DOMAIN=${DOMAIN}.
Run Docker Compose with the same domain, e.g.:
HOST_DOMAIN=${DOMAIN} docker compose up -d
EOF
