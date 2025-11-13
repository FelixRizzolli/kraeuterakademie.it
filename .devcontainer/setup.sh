#!/bin/bash
set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Color output for better readability
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Clone repositories with error handling
clone_repo() {
    local repo=$1
    local target=$2
    
    if [ -d "$target" ]; then
        log_warn "⚠️ Directory $target already exists, skipping clone"
        return 0
    fi
    
    log_info "📦 Cloning $repo into $target..."
    if git clone "git@github.com:FelixRizzolli/$repo.git" "$target"; then
        log_info "✅ Successfully cloned $repo"
    else
        log_error "❌ Failed to clone $repo"
        return 1
    fi
}

clone_repo "kraeuterakademie.it_nuxt" "/workspace/apps/nuxt"
clone_repo "kraeuterakademie.it_strapi" "/workspace/apps/strapi"
clone_repo "kraeuterakademie.it_payload" "/workspace/apps/payload"

# Install dependencies
log_info "📦 Installing dependencies..."
cd /workspace/apps/nuxt && pnpm install
cd /workspace/apps/strapi && pnpm install
cd /workspace/apps/payload && pnpm install

log_info "✅ Setup completed successfully!"