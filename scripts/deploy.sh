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

# Load environment
source .env.prod

case $SERVICE in
  nuxt)
    docker compose -f compose.yml -f compose.prod.yml pull nuxt
    docker compose -f compose.yml -f compose.prod.yml up -d nuxt
    ;;
  strapi)
    docker compose -f compose.yml -f compose.prod.yml pull strapi
    docker compose -f compose.yml -f compose.prod.yml up -d strapi
    ;;
  all)
    docker compose -f compose.yml -f compose.prod.yml pull
    docker compose -f compose.yml -f compose.prod.yml up -d
    ;;
  *)
    echo "Unknown service: $SERVICE"
    usage
    ;;
esac

docker system prune -f
docker compose -f compose.yml -f compose.prod.yml ps