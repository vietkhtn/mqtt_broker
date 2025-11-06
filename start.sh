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
TEMPLATE="${ROOT_DIR}/haproxy.cfg.template"
TARGET="${ROOT_DIR}/haproxy.cfg"

if [[ ! -f "${TEMPLATE}" ]]; then
  echo "Template not found: ${TEMPLATE}" >&2
  exit 1
fi

ESCAPED_DOMAIN="${DOMAIN//\\/\\\\}"
ESCAPED_DOMAIN="${ESCAPED_DOMAIN//&/\\&}"
ESCAPED_DOMAIN="${ESCAPED_DOMAIN//|/\\|}"

sed "s|__HOST_DOMAIN__|${ESCAPED_DOMAIN}|g" "${TEMPLATE}" > "${TARGET}"

cat <<EOF
Rendered haproxy.cfg for HOST_DOMAIN=${DOMAIN}.
Run Docker Compose with the same domain, e.g.:
HOST_DOMAIN=${DOMAIN} docker compose up -d
EOF
