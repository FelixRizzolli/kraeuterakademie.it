#!/bin/bash
set -euo pipefail

# ---------------------------------------------------------------------------
# deploy.sh  –  Pull a new image and redeploy a service via Docker Compose.
#
# Usage: deploy.sh <service> [version]
#
#   service  – one of: all | payload | nuxt | storybook
#   version  – Docker image tag to deploy (default: latest)
#
# Examples:
#   ./deploy.sh payload
#   ./deploy.sh payload sha-abc1234
#   ./deploy.sh all
# ---------------------------------------------------------------------------

usage() {
  echo "Usage: $0 <service> [version]"
  echo ""
  echo "  service  - One of: all, payload, nuxt, storybook"
  echo "  version  - Docker image tag to deploy (default: latest)"
  echo ""
  echo "Examples:"
  echo "  $0 payload"
  echo "  $0 payload sha-abc1234"
  echo "  $0 all"
  exit 1
}

SERVICE="${1:-}"
VERSION="${2:-latest}"

if [[ "$SERVICE" == "-h" || "$SERVICE" == "--help" || -z "$SERVICE" ]]; then
  usage
fi

echo "====================================================================="
echo "  Deploying [$SERVICE] – version: $VERSION"
echo "====================================================================="

# ---------------------------------------------------------------------------
# 1. Update infrastructure config from the repository
# ---------------------------------------------------------------------------
REPO_DIR="/var/www/kraeuterakademie.it"
cd "$REPO_DIR"

echo "==> Syncing infrastructure files..."
git fetch origin main
git reset --hard origin/main

cd "$REPO_DIR/infrastructure"

ENV_FILE=".env.prod"
if [ ! -f "$ENV_FILE" ]; then
  echo "Error: Env file not found: $ENV_FILE" >&2
  exit 3
fi

COMPOSE_BASE=(
  # -p pins every docker compose call to the "kraeuterakademie" project name.
  # Without this, Docker Compose falls back to the directory name
  # ("infrastructure"), which is identical for every project on the server.
  # That collision would make Docker Compose treat containers from other
  # projects (e.g. felixrizzolli-com, the proxy) as orphans of THIS project
  # and remove them.  The explicit name here, together with `name:
  # kraeuterakademie` in compose.yml, guarantees full isolation.
  "-p" "kraeuterakademie"
  # Note: compose.proxy.yml (Traefik) is intentionally excluded here.
  # The reverse proxy is a standalone service managed by init-server.sh
  # and shared with other projects on this server.
  "-f" "compose.yml"
  "-f" "compose.payload.yml"
  "-f" "compose.nuxt.yml"
  "-f" "compose.storybook.yml"
  "--env-file" "$ENV_FILE"
)

# ---------------------------------------------------------------------------
# 2. Helper: deploy a single service with rollback on failure
#
#   deploy_service <compose-service-name> <version-env-var>
#
#   The version env var (e.g. PAYLOAD_VERSION) is the variable referenced
#   in the compose file image tag, e.g.:
#     image: ghcr.io/.../payload:${PAYLOAD_VERSION:-latest}
# ---------------------------------------------------------------------------
deploy_service() {
  local service="$1"
  local version_var="$2"

  # Snapshot the current running image for potential rollback
  local container_id="" running_image=""
  container_id=$(docker compose "${COMPOSE_BASE[@]}" ps -q "$service" 2>/dev/null | head -1 || true)
  if [ -n "$container_id" ]; then
    running_image=$(docker inspect --format='{{.Config.Image}}' "$container_id" 2>/dev/null || true)
  fi

  echo ""
  echo "--> Pulling $service ($VERSION)..."
  (export "${version_var}=${VERSION}"; docker compose "${COMPOSE_BASE[@]}" pull "$service")

  echo "--> Starting $service..."
  if (export "${version_var}=${VERSION}"; \
      docker compose "${COMPOSE_BASE[@]}" up -d --wait --wait-timeout 120 "$service"); then
    echo "✓  $service is healthy"
  else
    echo "✗  $service failed to become healthy" >&2

    if [ -n "$running_image" ]; then
      echo "==> Rolling back $service to: $running_image" >&2
      # Re-deploy with the previous image reference (uses the digest directly)
      (export "${version_var}=${running_image}"; \
       docker compose "${COMPOSE_BASE[@]}" up -d "$service") || true
      echo "==> Rollback complete. Please investigate the failed image." >&2
    fi

    exit 1
  fi
}

# ---------------------------------------------------------------------------
# 3. Deploy the requested service(s)
# ---------------------------------------------------------------------------
case $SERVICE in
  payload)
    deploy_service "payload" "PAYLOAD_VERSION"
    ;;
  nuxt)
    deploy_service "nuxt" "NUXT_VERSION"
    ;;
  storybook)
    deploy_service "storybook" "STORYBOOK_VERSION"
    ;;
  all)
    echo ""
    echo "--> Pulling all images ($VERSION)..."
    (
      export PAYLOAD_VERSION=$VERSION
      export NUXT_VERSION=$VERSION
      export STORYBOOK_VERSION=$VERSION
      docker compose "${COMPOSE_BASE[@]}" pull
      echo "--> Starting all services..."

      # No --remove-orphans: not needed and not desirable.
      # Cross-project isolation is guaranteed by -p kraeuterakademie in
      # COMPOSE_BASE; Docker Compose will never see containers from other
      # projects as orphans of this project.
      docker compose "${COMPOSE_BASE[@]}" up -d --wait --wait-timeout 300
    )
    echo "✓  All services are healthy"
    ;;
  *)
    echo "Error: Unknown service '$SERVICE'" >&2
    usage
    ;;
esac

# ---------------------------------------------------------------------------
# 4. Post-deploy cleanup
#    Only remove dangling (superseded) images that belong to this project.
#    Global `docker image prune` is intentionally avoided to prevent
#    accidentally cleaning up images from the proxy or other projects.
# ---------------------------------------------------------------------------
echo ""
echo "==> Cleaning up old project images..."
for repo in \
  "ghcr.io/felixrizzolli/kraeuterakademie-it-payload" \
  "ghcr.io/felixrizzolli/kraeuterakademie-it-nuxt" \
  "ghcr.io/felixrizzolli/kraeuterakademie-it-storybook"; do

  # Collect image IDs for this repo that are no longer tagged (dangling).
  # After a pull the old image loses its tag and shows as <none> for that repo.
  mapfile -t old_ids < <(docker images "$repo" --filter "dangling=true" -q 2>/dev/null || true)
  for id in "${old_ids[@]}"; do
    echo "   Removing old image: $repo ($id)"
    docker rmi "$id" 2>/dev/null || true
  done
done

echo ""
echo "==> Deployment complete. Current status:"
docker compose "${COMPOSE_BASE[@]}" ps

