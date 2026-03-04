#!/usr/bin/env bash
# ═══════════════════════════════════════════
# PAI for Augment CLI — Setup Script
# ═══════════════════════════════════════════
#
# Usage: ./setup.sh
#
# Creates required directories and copies template files
# for a fresh installation of PAI-auggie.

set -euo pipefail

AUGMENT_DIR="${HOME}/.augment"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "═══════════════════════════════════════════"
echo " PAI for Augment CLI — Setup"
echo "═══════════════════════════════════════════"
echo ""

# Ensure we're running from the right place
if [ "$SCRIPT_DIR" != "$AUGMENT_DIR" ]; then
  echo "⚠️  This script should be run from ~/.augment/"
  echo "   Current location: $SCRIPT_DIR"
  echo ""
  read -p "Continue anyway? (y/N) " -n 1 -r
  echo ""
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
  fi
fi

# Create required directories
echo "📁 Creating directories..."
mkdir -p "$AUGMENT_DIR/MEMORY/LEARNING"
mkdir -p "$AUGMENT_DIR/MEMORY/STATE"
mkdir -p "$AUGMENT_DIR/MEMORY/RESEARCH"
mkdir -p "$AUGMENT_DIR/.prd/templates"
mkdir -p "$AUGMENT_DIR/sessions"
mkdir -p "$AUGMENT_DIR/task-storage"
echo "   ✓ Directories created"

# Initialize memory state files
if [ ! -f "$AUGMENT_DIR/MEMORY/STATE/current-work.json" ]; then
  echo '{"active": false, "task": null, "prd_path": null, "started": null}' > "$AUGMENT_DIR/MEMORY/STATE/current-work.json"
  echo "   ✓ current-work.json initialized"
fi

if [ ! -f "$AUGMENT_DIR/MEMORY/LEARNING/reflections.jsonl" ]; then
  touch "$AUGMENT_DIR/MEMORY/LEARNING/reflections.jsonl"
  echo "   ✓ reflections.jsonl initialized"
fi

if [ ! -f "$AUGMENT_DIR/MEMORY/LEARNING/corrections.jsonl" ]; then
  touch "$AUGMENT_DIR/MEMORY/LEARNING/corrections.jsonl"
  echo "   ✓ corrections.jsonl initialized"
fi

# Copy settings template if no settings.json exists
if [ ! -f "$AUGMENT_DIR/settings.json" ]; then
  if [ -f "$AUGMENT_DIR/settings.json.example" ]; then
    cp "$AUGMENT_DIR/settings.json.example" "$AUGMENT_DIR/settings.json"
    echo "   ✓ settings.json created from template"
    echo "   ⚠️  Edit settings.json to add your credentials and paths"
  fi
else
  echo "   ℹ️  settings.json already exists — skipping"
fi

echo ""
echo "═══════════════════════════════════════════"
echo " Setup complete!"
echo "═══════════════════════════════════════════"
echo ""
echo "Next steps:"
echo "  1. Edit settings.json with your credentials and paths"
echo "  2. Edit USER/ABOUTME.md with your details"
echo "  3. Edit USER/WORK/AXONIUS.md with your company context"
echo "  4. Edit USER/WORK/PROJECTS.md with your active projects"
echo "  5. Start Augment CLI — the algorithm loads automatically"
echo ""
