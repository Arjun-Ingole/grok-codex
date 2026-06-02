#!/usr/bin/env bash
# grok-codex installer
# Usage: curl -fsSL https://raw.githubusercontent.com/Arjun-Ingole/grok-codex/main/install.sh | bash

set -euo pipefail

REPO="Arjun-Ingole/grok-codex"
INSTALL_DIR="${HOME}/.local/bin"
SCRIPT_NAME="grok-codex"

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
BOLD='\033[1m'
RESET='\033[0m'

info()  { printf "${BLUE}info${RESET}  %s\n" "$1"; }
ok()    { printf "${GREEN}ok${RESET}    %s\n" "$1"; }
error() { printf "${RED}error${RESET} %s\n" "$1" >&2; exit 1; }

printf "${BOLD}Installing grok-codex...${RESET}\n\n"

# Create install dir
mkdir -p "$INSTALL_DIR"

# Download the script
info "Downloading grok-codex..."
if command -v curl &>/dev/null; then
    curl -fsSL "https://raw.githubusercontent.com/$REPO/main/grok-codex" -o "$INSTALL_DIR/$SCRIPT_NAME"
elif command -v wget &>/dev/null; then
    wget -qO "$INSTALL_DIR/$SCRIPT_NAME" "https://raw.githubusercontent.com/$REPO/main/grok-codex"
else
    error "Neither curl nor wget found. Install one and try again."
fi

chmod +x "$INSTALL_DIR/$SCRIPT_NAME"
ok "Installed to $INSTALL_DIR/$SCRIPT_NAME"

# Check if install dir is in PATH
if ! echo "$PATH" | tr ':' '\n' | grep -qx "$INSTALL_DIR"; then
    printf "\n${BLUE}Note:${RESET} Add %s to your PATH if it's not already:\n" "$INSTALL_DIR"
    printf "  export PATH=\"%s:\$PATH\"\n" "$INSTALL_DIR"
fi

# Run setup
printf "\n"
info "Running setup..."
printf "\n"
"$INSTALL_DIR/$SCRIPT_NAME" setup
