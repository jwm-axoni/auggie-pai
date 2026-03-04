---
description: Show PAI system status and active work
---

Show the current PAI system status:

1. Read `~/.augment/MEMORY/STATE/current-work.json` — is there active work?
2. List recent PRDs in `~/.augment/.prd/` (exclude templates/ and README.md)
3. Count entries in `~/.augment/MEMORY/LEARNING/reflections.jsonl`
4. Count entries in `~/.augment/MEMORY/LEARNING/corrections.jsonl`
5. List available skills in `~/.augment/skills/` (show directory names)

Format as a concise status report.
