#!/usr/bin/env bash
# ═══════════════════════════════════════════
# PAI for Augment CLI — Setup Script
# ═══════════════════════════════════════════
#
# Handles both fresh installs and existing Auggie users.
#
# Fresh install:  Creates everything from scratch
# Existing user:  Merges PAI into your existing config
#                 without touching settings.json, sessions,
#                 or any existing data
#
# Usage: ./setup.sh

set -euo pipefail

AUGMENT_DIR="${HOME}/.augment"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo ""
echo "═══════════════════════════════════════════"
echo " PAI for Augment CLI — Setup"
echo " v3.0-auggie"
echo "═══════════════════════════════════════════"
echo ""

# ─── Detect install type ───────────────────

EXISTING_INSTALL=false

if [ -f "$AUGMENT_DIR/settings.json" ] && [ ! -f "$AUGMENT_DIR/rules/algorithm.md" ]; then
  EXISTING_INSTALL=true
  echo "📋 Detected: Existing Augment CLI installation"
  echo "   Will merge PAI components without touching your existing config."
  echo ""
elif [ -f "$AUGMENT_DIR/rules/algorithm.md" ]; then
  echo "📋 Detected: PAI already installed — running update/repair"
  echo ""
else
  echo "📋 Detected: Fresh installation"
  echo ""
fi

# Ensure we're running from the right place
if [ "$SCRIPT_DIR" != "$AUGMENT_DIR" ]; then
  echo "⚠️  This script is running from: $SCRIPT_DIR"
  echo "   Expected location: $AUGMENT_DIR"
  echo ""
  read -p "Continue? (y/N) " -n 1 -r
  echo ""
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
  fi
fi

# ─── Create directories ───────────────────

echo "📁 Creating directories..."
mkdir -p "$AUGMENT_DIR/MEMORY/LEARNING"
mkdir -p "$AUGMENT_DIR/MEMORY/STATE"
mkdir -p "$AUGMENT_DIR/MEMORY/RESEARCH"
mkdir -p "$AUGMENT_DIR/.prd/templates"
mkdir -p "$AUGMENT_DIR/sessions"
mkdir -p "$AUGMENT_DIR/task-storage"
mkdir -p "$AUGMENT_DIR/USER/WORK"
mkdir -p "$AUGMENT_DIR/USER/SKILLCUSTOMIZATIONS"
echo "   ✓ Directories created"

# ─── Initialize memory state files ────────

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

if [ ! -f "$AUGMENT_DIR/MEMORY/LEARNING/patterns.md" ]; then
  cat > "$AUGMENT_DIR/MEMORY/LEARNING/patterns.md" << 'PATTERNS'
# Patterns & Learnings

Synthesized from reflections and corrections. Updated periodically during LEARN phase.

## Recurring Patterns
_None yet — patterns will emerge after multiple algorithm runs._

## Common Corrections
_None yet — corrections will be captured when user provides feedback._
PATTERNS
  echo "   ✓ patterns.md initialized"
fi

# ─── Handle settings.json ─────────────────

if [ "$EXISTING_INSTALL" = true ]; then
  # Existing user: inject PAI hooks into their settings.json
  echo ""
  echo "🔧 Checking settings.json for PAI hooks..."

  if grep -q "SessionStart" "$AUGMENT_DIR/settings.json" 2>/dev/null; then
    echo "   ℹ️  Hooks already present in settings.json — skipping"
  else
    echo ""
    echo "   Your settings.json needs PAI hooks added."
    echo "   Add this to your settings.json under a top-level \"hooks\" key:"
    echo ""
    echo '   "hooks": {'
    echo '     "SessionStart": [{'
    echo '       "hooks": [{'
    echo '         "type": "command",'
    echo '         "command": "cat $HOME/.augment/MEMORY/STATE/current-work.json"'
    echo '       }]'
    echo '     }],'
    echo '     "Stop": [{'
    echo '       "hooks": [{'
    echo '         "type": "command",'
    echo '         "command": "echo '"'"'{\"reminder\": \"check_reflection\"}'"'"' >> $HOME/.augment/MEMORY/STATE/stop-reminders.log 2>/dev/null || true"'
    echo '       }]'
    echo '     }]'
    echo '   }'
    echo ""
    echo "   ⚠️  If you already have hooks, merge these into your existing hooks object."
  fi
elif [ ! -f "$AUGMENT_DIR/settings.json" ]; then
  # Fresh install: copy templates
  if [ -f "$AUGMENT_DIR/settings.json.example" ]; then
    cp "$AUGMENT_DIR/settings.json.example" "$AUGMENT_DIR/settings.json"
    echo "   ✓ settings.json created from template"
    echo "   ⚠️  Edit settings.json to add your credentials and paths"
  fi
  if [ -f "$AUGMENT_DIR/CLAUDE.md.example" ] && [ ! -f "$AUGMENT_DIR/CLAUDE.md" ]; then
    cp "$AUGMENT_DIR/CLAUDE.md.example" "$AUGMENT_DIR/CLAUDE.md"
    echo "   ✓ CLAUDE.md created from template"
  fi
else
  echo "   ℹ️  settings.json already exists — skipping"
  if [ -f "$AUGMENT_DIR/CLAUDE.md.example" ] && [ ! -f "$AUGMENT_DIR/CLAUDE.md" ]; then
    cp "$AUGMENT_DIR/CLAUDE.md.example" "$AUGMENT_DIR/CLAUDE.md"
    echo "   ✓ CLAUDE.md created from template"
  fi
fi

# ─── Template files (only if missing) ─────

echo ""
echo "📄 Checking template files..."

for tmpl in USER/ABOUTME.md USER/AISTEERINGRULES.md USER/WORK/PROJECTS.md; do
  if [ ! -f "$AUGMENT_DIR/$tmpl" ]; then
    echo "   ⚠️  Missing: $tmpl (copy from repo or fill in manually)"
  else
    echo "   ✓ $tmpl exists"
  fi
done

# ─── Summary ──────────────────────────────

echo ""
echo "═══════════════════════════════════════════"
echo " Setup complete!"
echo "═══════════════════════════════════════════"
echo ""

if [ "$EXISTING_INSTALL" = true ]; then
  echo " You're an existing Auggie user. Here's what happened:"
  echo ""
  echo "   ✓ PAI directories created (rules/, skills/, commands/, MEMORY/, .prd/)"
  echo "   ✓ Memory system initialized"
  echo "   ✗ settings.json NOT modified (see hook instructions above)"
  echo ""
  echo " Next steps:"
  echo "   1. Add the PAI hooks to your settings.json (see above)"
  echo "   2. Edit USER/ABOUTME.md with your details"
  echo "   3. Edit USER/WORK/ files with your company and project context"
  echo "   4. Restart Augment CLI — the algorithm loads via rules/algorithm.md"
  echo ""
  echo " Your existing sessions, MCP servers, and credentials are untouched."
else
  echo " Next steps:"
  echo "   1. Edit settings.json with your credentials and paths"
  echo "   2. Edit USER/ABOUTME.md with your details"
  echo "   3. Edit USER/WORK/ files with your company and project context"
  echo "   4. Start Augment CLI — the algorithm loads automatically"
fi
echo ""
