#!/bin/bash
set -e

echo "🚀 Setting up development environment..."

# Clone or pull nuxt project
if [ ! -d "/workspace/apps/nuxt" ]; then
    echo "📦 Cloning Nuxt project..."
    gh repo clone FelixRizzolli/kraeuterakademie.it_nuxt /workspace/apps/nuxt
else
    echo "🔄 Updating Nuxt project..."
    cd /workspace/apps/nuxt && git pull
fi

# Clone or pull strapi project
if [ ! -d "/workspace/apps/strapi" ]; then
    echo "📦 Cloning Strapi project..."
    gh repo clone FelixRizzolli/kraeuterakademie.it_strapi /workspace/apps/strapi
else
    echo "🔄 Updating Strapi project..."
    cd /workspace/apps/strapi && git pull
fi

# Install dependencies
echo "📦 Installing Nuxt dependencies..."
cd /workspace/apps/nuxt && pnpm install

echo "📦 Installing Strapi dependencies..."
cd /workspace/apps/strapi && pnpm install

echo "✅ Development environment ready!"