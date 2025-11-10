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

# Use the current working directory (where the user ran the script) as the base. If it doesn't exist, use the current directory.
WORKDIR="$(pwd)"
if [ -d "$WORKDIR/infrastructure" ]; then
  COMPOSE_DIR="$WORKDIR/infrastructure"
else
  COMPOSE_DIR="$WORKDIR"
fi

# For clarity, show which directory will be used (helpful when script is in PATH)
echo "Using compose directory: $COMPOSE_DIR"

case "${ENVIRONMENT,,}" in
  prod)
    COMPOSE_ARGS=("-f" "$COMPOSE_DIR/compose.yml" "-f" "$COMPOSE_DIR/compose.prod.yml")
    ENV_FILE="$COMPOSE_DIR/.env.prod"
    ;;
  staging)
    # NOTE: using compose.staging.yml (not staging.prod.yml) — matches repo convention
    COMPOSE_ARGS=("-f" "$COMPOSE_DIR/compose.yml" "-f" "$COMPOSE_DIR/compose.staging.yml")
    ENV_FILE="$COMPOSE_DIR/.env.staging"
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
