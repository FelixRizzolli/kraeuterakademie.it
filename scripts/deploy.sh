#!/bin/bash
set -e

usage() {
  echo "Usage: $0 [nuxt|strapi|payload|all]"
  echo "Deploys the specified service(s) via Docker Compose."
  echo ""
  echo "Examples:"
  echo "  $0 nuxt"
  echo "  $0 strapi"
  echo "  $0 payload"
  echo "  $0 all"
  exit 1
}

SERVICE="$1"

if [[ "$SERVICE" == "-h" || "$SERVICE" == "--help" || -z "$SERVICE" ]]; then
  usage
fi

cd /var/www/kraeuterakademie.it
git pull origin main
cd infrastructure

ENV_FILE=".env.prod"
if [ ! -f "$ENV_FILE" ]; then
  echo "Env file not found: $ENV_FILE" >&2
  exit 3
fi


COMPOSE_ARGS=("-f" "compose.yml" "-f" "compose.prod.yml" "--env-file" "$ENV_FILE")

case $SERVICE in
  nuxt)
    docker compose "${COMPOSE_ARGS[@]}" pull nuxt
    docker compose "${COMPOSE_ARGS[@]}" up -d nuxt
    docker compose "${COMPOSE_ARGS[@]}" pull storybook
    docker compose "${COMPOSE_ARGS[@]}" up -d storybook
    ;;
  strapi)
    docker compose "${COMPOSE_ARGS[@]}" pull strapi
    docker compose "${COMPOSE_ARGS[@]}" up -d strapi
    ;;
  payload)
    docker compose "${COMPOSE_ARGS[@]}" pull payload
    docker compose "${COMPOSE_ARGS[@]}" up -d payload
    ;;
  all)
    docker compose "${COMPOSE_ARGS[@]}" pull
    docker compose "${COMPOSE_ARGS[@]}" up -d
    ;;
  *)
    echo "Unknown service: $SERVICE"
    usage
    ;;
esac

docker system prune -f
docker compose "${COMPOSE_ARGS[@]}" ps