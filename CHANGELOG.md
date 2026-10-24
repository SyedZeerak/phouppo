# Changelog

All notable changes to this project are documented here. The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and the project uses [Semantic Versioning](https://semver.org/).

## [Unreleased]

## [1.4.0] - 2026-10-24

### Added
- Interactive visual Markdown (`.md`) artifact report structure in `skills/phouppo/references/report-template.md` featuring Mermaid diagrams (severity breakdown and remediation roadmap), high-contrast status pills, and production readiness alert banners (`> [!CAUTION]`, `> [!WARNING]`, `> [!NOTE]`).
- Interactive collapsible finding accordions (`<details open>` for Critical and High findings, `<details>` for Medium, Low, and Info) with structured property tables, impact callouts, and syntax-highlighted code snippets.
- Interactive remediation punch-list task checklists (`- [ ]`) organized by priority (Before Go-Live, Within 30 Days, Backlog).
- Collapsible secondary diagnostic traces for the 10-point triage results and dynamic probe logs.
- High-resolution hero banner asset (`assets/phouppo-hero.png`) and animated interactive terminal simulation SVG (`assets/phouppo-demo.svg`) embedded in documentation.

### Changed
- Updated skill operating rules (`SKILL.md` and `AGENTS.md`) and Phase 3 workflow to deliver audits as dedicated interactive visual `.md` artifacts (written to the agent artifact panel or `audit-report.md`) accompanied by a concise executive summary in chat.
- Streamlined `README.md` header badges to standard compact shields for Cursor, Claude Code, Codex, and Antigravity.

## [1.3.0] - 2026-10-13

### Added
- Comprehensive secret and PII masking operating rule (`Mask secrets everywhere`) covering tokens, passwords (`[REDACTED]`), prefixes (`sk-****`, `AKIA****`), emails, and phone numbers across all report sections and snippets.
- Pre-output redaction pass rule verifying draft against leaked secrets, connection strings, personal emails, cloud project IDs, internal hostnames/URLs, and local system paths.
- Repository-relative path and unique finding ID operating guidelines.
- Severity calibration rule: down-rate finding when exploitability depends on unverified deployment facts, noting escalation conditions.
- Explicit readiness rubric definitions for "Not ready", "Ready with conditions", and "Ready".

## [1.2.0] - 2026-10-13

### Added
- Installation support for Codex and Antigravity (global and per-project).
- `AGENTS.md`, `install.sh`, and `install.ps1` for flexible installation.
- Cross-agent command mapping (`/phouppo` vs `$phouppo`).
- Explicit mention of Codex and Antigravity in the README.

### Changed
- Installation instructions now list 6 options instead of 3.

## [1.1.0] - 2026-10-13

### Added
- `visual-design.md` reference: design system consistency, typography, contrast, layout, responsive behavior, component states, data visualization, imagery, motion, RTL and Urdu support, branding, print and export, and signs of unreviewed AI-generated UI.
- `visual` focus option, scorecard row, and `VIS-` finding prefix.
- Visual review runs statically from code by default and uses screenshots or a user-approved run for rendered checks.
- `--mode static|tools|dynamic` option.
- `references/dynamic-testing.md`: preflight, consent plan, scanner commands, runtime probes, stop conditions.
- `Verified: Static | Test` field on findings and a "Tests performed" report section.

### Changed
- Operating rule on side effects is now mode-aware.

## [1.0.0] - 2026-10-13

### Added
- Initial release of the `vibe-code-audit` Agent Skill.
- Four-phase workflow: reconnaissance, ten-point triage, deep dive by area, structured report.
- Reference modules: security, architecture, code quality, data engineering, DevOps, testing, LLM risks, product and governance, documentation.
- Stack notes for Next.js, Supabase, Firebase, FastAPI, Django, Express, Laravel, and PWAs.
- Severity rubric, finding format, and report template with an executive summary for non-technical readers.
