#!/bin/bash
set -e

usage() {
  echo "Usage: $0 [nuxt|strapi|all]"
  echo "Deploys the specified service(s) via Docker Compose."
  echo ""
  echo "Examples:"
  echo "  $0 nuxt"
  echo "  $0 strapi"
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

case $SERVICE in
  nuxt)
    docker compose -f compose.yml -f compose.prod.yml --env-file "$ENV_FILE" pull nuxt
    docker compose -f compose.yml -f compose.prod.yml --env-file "$ENV_FILE" up -d nuxt
    docker compose -f compose.yml -f compose.prod.yml --env-file "$ENV_FILE" pull storybook
    docker compose -f compose.yml -f compose.prod.yml --env-file "$ENV_FILE" up -d storybook
    ;;
  strapi)
    docker compose -f compose.yml -f compose.prod.yml --env-file "$ENV_FILE" pull strapi
    docker compose -f compose.yml -f compose.prod.yml --env-file "$ENV_FILE" up -d strapi
    ;;
  all)
    docker compose -f compose.yml -f compose.prod.yml --env-file "$ENV_FILE" pull
    docker compose -f compose.yml -f compose.prod.yml --env-file "$ENV_FILE" up -d
    ;;
  *)
    echo "Unknown service: $SERVICE"
    usage
    ;;
esac

docker system prune -f
docker compose -f compose.yml -f compose.prod.yml --env-file "$ENV_FILE" ps