# Agent Instructions

This repository contains the Phouppo audit skill. Agents that support the Agent Skills standard (Cursor, Claude Code, Codex, Antigravity, and others) should load it as a skill from `skills/phouppo/`.

If your agent does not support skills, read `skills/phouppo/SKILL.md` and follow it as the task instructions when the user asks for an audit of a vibe-coded or AI-generated web app. Load files from `skills/phouppo/references/` only when `SKILL.md` directs you to.

Rules that always apply:
- The audit is read-only. Do not modify the audited repository.
- Do not run the app, tests, or scanners without explicit user approval.
- Cite `path:line` evidence for every finding, or mark it "Not verified".
- Mask any secret found in output.
