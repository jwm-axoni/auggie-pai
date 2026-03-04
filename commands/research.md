---
description: Run a research workflow (quick, standard, deep, extract)
argument-hint: "<mode> <topic>"
---

Run the specified research mode on the given topic.

Available research modes:
- **quick**: Single-pass web research (~2min)
- **standard**: Multi-source structured research (~5min) — DEFAULT if no mode specified
- **deep**: Progressive iterative investigation with persistent knowledge vault
- **extract**: Extract insights from provided content

If no mode is specified, use standard research.

Read the matching skill file at `~/.augment/skills/{mode}-research/SKILL.md` (or `extract-knowledge` for extract mode) and apply its methodology.

$ARGUMENTS
