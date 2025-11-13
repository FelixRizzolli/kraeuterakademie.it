#!/usr/bin/env bash
set -euo pipefail

# Automated setup helper to install `up_env.sh` as `upenv` for the current user.
# Actions performed:
#  - Verifies the script exists in the same directory as this setup script
#  - Makes it executable
#  - Creates ~/.local/bin and adds a symlink ~/.local/bin/upenv -> /path/to/up_env.sh
#  - Ensures ~/.local/bin is on PATH by adding export to ~/.profile if missing

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
UP_SCRIPT="$SCRIPT_DIR/up_env.sh"
DEST_DIR="$HOME/.local/bin"
LINK_PATH="$DEST_DIR/upenv"

# Optional deploy script and link
DEPLOY_SCRIPT="$SCRIPT_DIR/deploy.sh"
DEPLOY_LINK="$DEST_DIR/deploy"

die(){ echo "ERROR: $*" >&2; exit 1; }

if [ ! -f "$UP_SCRIPT" ]; then
  die "up_env.sh not found at $UP_SCRIPT. Make sure this setup script sits next to up_env.sh"
fi

echo "Making $UP_SCRIPT executable..."
chmod +x "$UP_SCRIPT"

if [ ! -f "$DEPLOY_SCRIPT" ]; then
  die "deploy.sh not found at $DEPLOY_SCRIPT. Make sure this setup script sits next to deploy.sh"
fi

echo "Making $DEPLOY_SCRIPT executable..."
chmod +x "$DEPLOY_SCRIPT"

echo "Creating $DEST_DIR (if needed)..."
mkdir -p "$DEST_DIR"

if [ -e "$LINK_PATH" ]; then
  # If it's a symlink pointing to the same file, nothing to do
  if [ -L "$LINK_PATH" ] && [ "$(readlink "$LINK_PATH")" = "$UP_SCRIPT" ]; then
    echo "Existing symlink $LINK_PATH already points to $UP_SCRIPT. Skipping symlink creation."
  else
    ts=$(date +%s)
    backup="$LINK_PATH.bak.$ts"
    echo "Backing up existing $LINK_PATH -> $backup"
    mv "$LINK_PATH" "$backup"
    ln -s "$UP_SCRIPT" "$LINK_PATH"
    echo "Created symlink: $LINK_PATH -> $UP_SCRIPT (previous moved to $backup)"
  fi
else
  ln -s "$UP_SCRIPT" "$LINK_PATH"
  echo "Created symlink: $LINK_PATH -> $UP_SCRIPT"
fi

# Install deploy symlink the same way
if [ -e "$DEPLOY_LINK" ]; then
  if [ -L "$DEPLOY_LINK" ] && [ "$(readlink "$DEPLOY_LINK")" = "$DEPLOY_SCRIPT" ]; then
    echo "Existing symlink $DEPLOY_LINK already points to $DEPLOY_SCRIPT. Skipping symlink creation."
  else
    ts=$(date +%s)
    backup="$DEPLOY_LINK.bak.$ts"
    echo "Backing up existing $DEPLOY_LINK -> $backup"
    mv "$DEPLOY_LINK" "$backup"
    ln -s "$DEPLOY_SCRIPT" "$DEPLOY_LINK"
    echo "Created symlink: $DEPLOY_LINK -> $DEPLOY_SCRIPT (previous moved to $backup)"
  fi
else
  ln -s "$DEPLOY_SCRIPT" "$DEPLOY_LINK"
  echo "Created symlink: $DEPLOY_LINK -> $DEPLOY_SCRIPT"
fi

# Ensure DEST_DIR is on PATH via ~/.profile (user-level)
PROFILE="$HOME/.profile"
EXPORT_LINE='export PATH="$HOME/.local/bin:$PATH"'

if ! grep -qxF "$EXPORT_LINE" "$PROFILE" 2>/dev/null; then
  echo "Adding $DEST_DIR to PATH in $PROFILE"
  printf "\n# Add user local bin to PATH for upenv\n%s\n" "$EXPORT_LINE" >> "$PROFILE"
  echo "Wrote PATH export to $PROFILE"
else
  echo "$DEST_DIR already on PATH in $PROFILE"
fi

echo
echo "Setup complete."
echo
echo "If your shell session doesn't see the new command yet, run:"
echo "  source $PROFILE"
echo "or open a new terminal session."

exit 0
