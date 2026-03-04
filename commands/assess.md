---
description: Run a security assessment (recon, web, threat-model, prompt-injection)
argument-hint: "<type> <target>"
---

Run the specified security assessment on the given target.

Available assessment types:
- **recon**: Infrastructure reconnaissance (passive/active)
- **web**: Web application security assessment (OWASP Top 10)
- **threat-model**: STRIDE threat modeling
- **prompt-injection**: LLM prompt injection testing

Read the matching skill file at `~/.augment/skills/{type}/SKILL.md` and apply its methodology.

IMPORTANT: All security testing requires explicit authorization. Confirm authorization before active testing.

$ARGUMENTS
