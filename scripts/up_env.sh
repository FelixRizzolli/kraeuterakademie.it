#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<EOF
Usage: $0 <prod|staging>

Examples:
  $0 prod
  $0 staging
EOF
  exit 2
}

if [ "$#" -ne 1 ]; then
  usage
fi

ENVIRONMENT="$1"
# Resolve script directory so compose files are referenced relative to this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

case "${ENVIRONMENT,,}" in
  prod)
    COMPOSE_ARGS=("-f" "$SCRIPT_DIR/compose.yml" "-f" "$SCRIPT_DIR/compose.prod.yml")
    ENV_FILE="$SCRIPT_DIR/.env.prod"
    ;;
  staging)
    # NOTE: using compose.staging.yml (not staging.prod.yml) — matches repo convention
    COMPOSE_ARGS=("-f" "$SCRIPT_DIR/compose.yml" "-f" "$SCRIPT_DIR/compose.staging.yml")
    ENV_FILE="$SCRIPT_DIR/.env.staging"
    ;;
  *)
    echo "Unknown environment: $ENVIRONMENT" >&2
    usage
    ;;
esac

if [ ! -f "$ENV_FILE" ]; then
  echo "Env file not found: $ENV_FILE" >&2
  exit 3
fi

echo "Running: docker compose ${COMPOSE_ARGS[*]} --env-file $ENV_FILE up -d"

docker compose "${COMPOSE_ARGS[@]}" --env-file "$ENV_FILE" up -d
