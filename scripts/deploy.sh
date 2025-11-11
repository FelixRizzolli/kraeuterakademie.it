#!/bin/bash
set -e

cd /var/www/kraeuterakademie.it
git pull origin main
cd infrastructure

# Load environment
source .env.prod

# Deploy based on trigger
SERVICE="$1"
case $SERVICE in
  nuxt-updated)
    docker compose -f compose.yml -f compose.prod.yml pull nuxt
    docker compose -f compose.yml -f compose.prod.yml up -d nuxt
    ;;
  strapi-updated)
    docker compose -f compose.yml -f compose.prod.yml pull strapi
    docker compose -f compose.yml -f compose.prod.yml up -d strapi
    ;;
  all)
    docker compose -f compose.yml -f compose.prod.yml pull
    docker compose -f compose.yml -f compose.prod.yml up -d
    ;;
esac

docker system prune -f
docker compose -f compose.yml -f compose.prod.yml ps
