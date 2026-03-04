# PRD Directory

This directory stores **Product Requirements Documents** (PRDs) created by the PAI Algorithm.

## Purpose

Every Algorithm run creates or continues a PRD file that serves as:
- **Persistent memory** across sessions
- **ISC tracking** (Ideal State Criteria)
- **Decision log** for technical choices
- **Progress tracking** for multi-session work

## File Naming Convention

```
PRD-{YYYYMMDD}-{slug}.md
```

Example: `PRD-20260225-install-algorithm.md`

## PRD Structure

Each PRD contains:

```markdown
---
id: PRD-{YYYYMMDD}-{slug}
status: PLANNED | IN_PROGRESS | COMPLETE | FAILED | BLOCKED
effort_level: Instant | Fast | Standard | Extended | Advanced | Deep | Comprehensive
created: {date}
---

# {Task Title}

## STATUS
| What | State |
|------|-------|
| Progress | X/N criteria |
| Phase | OBSERVE | THINK | PLAN | BUILD | EXECUTE | VERIFY | LEARN |

## CONTEXT
Problem space, key files, constraints

## PLAN
Execution approach, technical decisions, task breakdown

## IDEAL STATE CRITERIA
- [ ] ISC-C1: ... | Verify: ...
- [ ] ISC-C2: ... | Verify: ...
- [ ] ISC-A1: ... | Verify: ...

## DECISIONS
Non-obvious technical decisions

## LOG
Session entries with timestamps
```

## Status Progression

```
DRAFT → CRITERIA_DEFINED → PLANNED → IN_PROGRESS → VERIFYING → COMPLETE/FAILED/BLOCKED
```

## Usage

The Algorithm automatically:
1. Creates PRDs for Extended+ effort tasks
2. Updates existing PRDs when continuing work
3. Syncs ISC between working memory and PRD files
4. Logs decisions and mutations

## PRD Template (v2.0-auggie)

The canonical PRD template lives at `templates/PRD-TEMPLATE.md`. All new PRDs should be created from this template.

### YAML Frontmatter Fields

| Field | Description | Example |
|-------|-------------|---------|
| `task` | Human-readable task title | `"Install PAI Algorithm"` |
| `slug` | Unique identifier (timestamp + kebab) | `"20260227-143000_install-pai"` |
| `effort` | Effort tier from Algorithm v3.5.0 | `Standard`, `Extended`, `Advanced`, `Deep`, `Comprehensive` |
| `phase` | Current algorithm phase | `observe`, `think`, `plan`, `build`, `execute`, `verify`, `learn`, `complete` |
| `progress` | ISC completion counter | `"3/12"` |
| `mode` | Execution mode | `algorithm`, `native` |
| `started` | ISO 8601 timestamp of creation | `"2026-02-27T14:30:00Z"` |
| `updated` | ISO 8601 timestamp of last edit | `"2026-02-27T15:00:00Z"` |

### Key Differences from v1.0

- **YAML frontmatter** replaces the `id` / `status` header format
- **Phase tracking** uses lowercase algorithm phase names instead of `PLANNED | IN_PROGRESS | COMPLETE`
- **Sections** reduced to four: `Context`, `Criteria`, `Decisions`, `Verification` (no separate `PLAN` or `LOG` sections -- plan goes under Context, log is handled by git history)
- **ISC criteria** must pass the Splitting Test (atomic, 8-12 words, binary testable)
- **Anti-criteria** use `ISC-A` prefix to define what must NOT happen
- **Risks** captured as a subsection under Context during THINK phase

### Memory System Integration

PRDs are stored in `MEMORY/WORK/{slug}/PRD.md` and synced to `MEMORY/STATE/current-work.json` for active session tracking. Reflections from the LEARN phase are appended to `MEMORY/LEARNING/reflections.jsonl`.

## References

- **PRD Template:** `templates/PRD-TEMPLATE.md`
- **Algorithm v3.5.0:** `~/.claude/PAI/Algorithm/v3.5.0.md`
- **Algorithm:** `../rules/algorithm.md`
- **TheAlgorithm:** https://github.com/danielmiessler/TheAlgorithm
- **PAI System:** https://github.com/danielmiessler/PAI

