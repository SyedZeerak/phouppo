# Changelog

All notable changes to this project are documented here. The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and the project uses [Semantic Versioning](https://semver.org/).

## [Unreleased]

## [1.5.0] - 2026-11-05

### Added
- Grounded all 10 audit domains and `SKILL.md` triage/deep-dive workflows in 100+ years of foundational computer science, software engineering, database, speed optimization, cybersecurity, cognitive psychology, and Human-Computer Interaction (HCI) laws:
  - **Security (`references/security.md`):** Saltzer & Schroeder's 8 Design Principles (*Complete Mediation, Fail-Safe Defaults, Economy of Mechanism, Least Privilege*), Kerckhoffs's Principle, Moxie Marlinspike's Cryptographic Doom Principle (AEAD before parsing, CSPRNG, constant-time `timingSafeEqual`), LangSec boundary parsing (*Parse, don't validate*), BOLA/BFLA/BOPLA, TOCTOU check-then-act race conditions, OAuth PKCE/`state` verification, SSRF private-CIDR/metadata blocks, SVG/Zip-Slip upload guards, and AI package slopsquatting checks.
  - **Architecture & Systems (`references/architecture.md`):** Parnas's Information Hiding, Ousterhout's Deep vs. Shallow Modules, Brooks's Conceptual Integrity, Butler Lampson's Hints & End-to-End Principle, Amdahl's Law (serial async waterfalls), Little's Law ($L = \lambda W$ connection pool and queue saturation), Kleppmann's Dual-Write / Transactional Outbox patterns, cache stampede protection, and Martin Thompson's Mechanical Sympathy (event-loop blocking).
  - **Code Quality & Web Speed (`references/code-quality.md`):** Hoare Logic invariants & Null Safety, Harel Statecharts (replacing "boolean soup" with discriminated unions), Carmack's pragmatic simplicity, Google RAIL model & Core Web Vitals (`LCP < 2.5s`, `INP < 200ms`, `CLS < 0.1`), DOM list virtualization, layout thrashing, and `AbortController` / listener lifecycle leak checks.
  - **Visual Design, HCI & Behavioral Psychology (`references/visual-design.md`):** Fitts's Law & Steering Law motor ergonomics, Hick-Hyman decision latency, Sweller's Cognitive Load Theory & Miller's Law chunking, Tesler's Law of Conservation of Complexity, Don Norman's Affordances/Signifiers & Gulfs of Execution/Evaluation, Gestalt perceptual grouping, Von Restorff isolation effect, Weber-Fechner Just Noticeable Difference (JND), Doherty Threshold ($<400\text{ms}$), Shigeo Shingo's Poka-Yoke mistake-proofing, Jakob's Law (URL state & conventions), Kahneman's System 1/2, Peak-End Rule, Zeigarnik Effect, Edward Tufte's Data-Ink Ratio & Lie Factor, and ethical anti-dark-pattern checks.
  - **Database Theory & Speed (`references/data-engineering.md`):** Codd's Relational Integrity (3NF/BCNF), Jim Gray's ACID guarantees, Berenson & Kleppmann MVCC concurrency anomalies (*Lost Updates*, *Write Skew*, *Phantom Reads*), B+Tree leftmost-prefix & query sargability, unindexed foreign key detection, cursor/keyset vs. `OFFSET` pagination, expand-and-contract zero-downtime migrations (`CREATE INDEX CONCURRENTLY`), and Pacioli double-entry immutable ledger checks.
  - **DevOps & SRE (`references/devops.md`):** Twelve-Factor App config validation at boot, Google SRE SLIs/SLOs, Brendan Gregg's USE Method (Utilization, Saturation, Errors), Tom Wilkie's RED Method (Rate, Errors, Duration), `SIGTERM` graceful shutdown draining, and `/healthz` vs. `/readyz` probe separation.
  - **Testing (`references/testing.md`):** Dijkstra's Maxim, Kent Beck's Test Desiderata, Boundary Value Analysis (BVA), QuickCheck property/metamorphic invariants, and explicit detection of AI-generated tautological tests.
  - **LLM & Agent Risks (`references/llm-risks.md`):** Simon Willison's "Lethal Trifecta", OWASP Top 10 for LLMs (`LLM01`–`LLM10`), CaMeL privilege separation, Markdown image exfiltration guards, deterministic session binding on agent tools, and RAG vector pre-filtering by tenant.
  - **Product, Docs & Stack Notes (`product-governance.md`, `documentation.md`, `stack-notes.md`):** Christensen's Jobs-to-be-Done (JTBD), Suchman's Situated Action & cognitive ergonomics, Cavoukian's Privacy by Design, Nygard ADRs & Diátaxis documentation structure, plus expanded stack notes for Next.js Server Actions/RSC, Supabase `user_metadata` RLS pitfalls, Prisma/Drizzle interactive transactions, FastAPI event-loop starvation, and SPA shared-device cache bleed.

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
