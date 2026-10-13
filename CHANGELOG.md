# Changelog

All notable changes to this project are documented here. The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and the project uses [Semantic Versioning](https://semver.org/).

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
