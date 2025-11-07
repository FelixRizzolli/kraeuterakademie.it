#!/bin/bash
set -e

echo "🚀 Setting up development environment..."

# Copy SSH keys
echo "🔑 Configuring SSH keys..."
mkdir -p /root/.ssh
cp -p /root/local-ssh/* /root/.ssh/

echo "🔒 Setting SSH key permissions..."
chmod 700 /root/.ssh
chmod 600 /root/.ssh/*
chmod 644 /root/.ssh/*.pub
chown -R root:root /root/.ssh

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