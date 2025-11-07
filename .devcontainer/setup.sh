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
if [ ! -d "/workspace/nuxt" ]; then
    echo "📦 Cloning Nuxt project..."
    gh repo clone FelixRizzolli/kraeuterakademie.it_nuxt /workspace/nuxt
else
    echo "🔄 Updating Nuxt project..."
    cd /workspace/nuxt && git pull
fi

# Clone or pull strapi project
if [ ! -d "/workspace/strapi" ]; then
    echo "📦 Cloning Strapi project..."
    gh repo clone FelixRizzolli/kraeuterakademie.it_strapi /workspace/strapi
else
    echo "🔄 Updating Strapi project..."
    cd /workspace/strapi && git pull
fi

# Install dependencies
echo "📦 Installing Nuxt dependencies..."
cd /workspace/nuxt && pnpm install

echo "📦 Installing Strapi dependencies..."
cd /workspace/strapi && pnpm install

echo "✅ Development environment ready!"