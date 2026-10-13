<div align="center">

# 🧐 Phouppo

### *A read-only audit skill for vibe-coded apps. She notices everything.*

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=flat-square)](LICENSE)
[![Cursor Skill](https://img.shields.io/badge/Cursor-Skill%20Compatible-000000?style=flat-square&logo=cursor&logoColor=white)](https://cursor.com)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-Compatible-6B4FBB?style=flat-square&logo=anthropic&logoColor=white)](https://claude.ai/code)
[![Codex](https://img.shields.io/badge/Codex-Install%20Supported-10A37F?style=flat-square)](#option-5-codex)
[![Antigravity](https://img.shields.io/badge/Antigravity-Install%20Supported-4285F4?style=flat-square)](#option-6-antigravity)
[![Standard](https://img.shields.io/badge/Standard-SKILL.md-FF6B6B?style=flat-square)](https://agentskills.io)
[![Safety: Read-Only](https://img.shields.io/badge/Safety-100%25%20Read--Only-2EA44F?style=flat-square)](#-safety-model)
[![PRs Welcome](https://img.shields.io/badge/PRs-Welcome-brightgreen.svg?style=flat-square)](CONTRIBUTING.md)

<p align="center">
  <a href="#why-phouppo">Why Phouppo</a> •
  <a href="#what-it-covers">Coverage</a> •
  <a href="#how-it-works">How It Works</a> •
  <a href="#installation">Installation</a> •
  <a href="#usage">Usage</a> •
  <a href="#sample-report">Sample Report</a> •
  <a href="#safety-model">Safety</a>
</p>

---

</div>

> **Phouppo** *(n.)*: The paternal aunt in South Asian families who catches every imperfection before you even notice, and tells you straight up.
>
> *(The name is playful branding; Phouppo conducts audits with strict engineering objectivity and delivers professional, evidence-backed reports.)*

---

## <a id="why-phouppo"></a>💡 Why Phouppo?

Apps generated with AI coding assistants ("vibe-coded" apps) often demo flawlessly and sail through the happy path on day one. But behind the polished UI, they routinely harbor invisible landmines:

```
┌─────────────────────────────────┐      ┌──────────────────────────────────┐
│     The AI Demo (Day 1)         │      │     The Reality (Day 30)         │
├─────────────────────────────────┤      ├──────────────────────────────────┤
│  ✨ Slick shadcn/ui components   │  VS  │  🚨 IDOR: unauthenticated data   │
│  ✨ Responsive dashboards       │      │  🚨 Floats used for currency     │
│  ✨ Instant Supabase integration│      │  🚨 RLS disabled (USING true)    │
│  ✨ Seamless OAuth flow         │      │  🚨 Hardcoded test credentials   │
└─────────────────────────────────┘      └──────────────────────────────────┘
```

**Phouppo** steps in before real users do. Operating as an autonomous, read-only Agent Skill (supporting Cursor, Claude Code, Codex, Antigravity, and any agent implementing the `SKILL.md` specification), Phouppo evaluates your code like an ensemble of a **Principal Security Engineer**, **Systems Architect**, **Data Engineer**, and **Product Manager**.

---

## <a id="what-it-covers"></a>🎯 What It Covers

Phouppo inspects 10 critical domains, providing structured evaluation with zero generic fluff:

| Domain | Focus & Key Checkpoints |
|:---|:---|
| 🛡️ **Security** | Secret leakage (`sk-`, `AKIA`, JWTs), server-side authorization & IDOR, Supabase/Firebase RLS policies, SQL/XSS/Command injection, file upload guards, security headers, dependency poisoning. |
| 🏛️ **Architecture** | Component boundaries, DRY business logic, API consistency, rate limits, scale bottlenecks, graceful degradation, and multi-tenancy isolation. |
| 💻 **Code Quality** | Swallowed errors (`catch {}`), frontend boundary states (empty, loading, offline), async race conditions, accessibility, and phantom/mocked features disguised as real. |
| 🎨 **Visual Design & UI** | Consistency of tokens and typography, WCAG AA color contrast, responsive layout breaks, chart states, RTL & Urdu layout fidelity, and recognizable "AI UI tells". |
| 🗄️ **Data Engineering** | Migration history, relational integrity, missing foreign keys, floating-point math on currencies, backup & restore plans, and CSV/file import validation. |
| 🚀 **DevOps & Reliability** | Environment variable management, lockfile discipline, CI/CD pipeline health, edge/serverless timeouts, observability (logging/metrics), and bus-factor risk. |
| 🧪 **Testing** | Critical-path coverage, negative edge-case test suites, auth regression tests, and acceptance test validity. |
| 🤖 **LLM Risks** | Indirect prompt injection, system prompt leakage, unbounded agent tool permissions, and API budget runaway vulnerabilities. |
| 📋 **Product & Governance** | Problem-solution alignment, user workflow drop-offs, administrative ownership, and regulatory/privacy disclosures. |
| 📚 **Documentation** | Handover package completeness, incident runbooks, disaster recovery steps, and service access matrix. |

---

## <a id="how-it-works"></a>⚙️ How It Works

Phouppo utilizes **progressive disclosure** to stay ultra-fast and consume minimal LLM tokens. Instead of loading encyclopedic rule sets upfront, it operates in focused phases:

```mermaid
flowchart LR
    A[🔍 Phase 0<br/><b>Reconnaissance</b><br/><i>Detect stack & env</i>] --> B[⚡ Phase 1<br/><b>10-Point Triage</b><br/><i>Pass / Fail / Partial</i>]
    B --> C[🔬 Phase 2<br/><b>Targeted Deep Dive</b><br/><i>Load specific modules</i>]
    C --> D[📑 Phase 3<br/><b>Evidence Report</b><br/><i>path:line citations</i>]
```

1. **Reconnaissance:** Fast scan of runtime, framework, database, authentication provider, and third-party integrations (completed in under 10 tool calls).
2. **10-Point Triage:** Executes high-leverage grep/regex checks across top failure modes. Marks each as `Pass`, `Fail`, `Partial`, or `Not verified`.
3. **Targeted Deep Dive:** Dynamically loads reference modules (`references/*.md`) *only* for areas flagged during triage or explicitly requested.
4. **Actionable Report:** Outputs an executive summary for stakeholders alongside line-by-line developer remediation steps.

---

## <a id="installation"></a>📦 Installation

Choose your agent environment below.

### Option 1: Via the Skills CLI *(Recommended)*
Installs for one or several agents with a single command:
```bash
# One agent
npx skills add SyedZeerak/phouppo -a cursor

# Several agents at once
npx skills add SyedZeerak/phouppo -a cursor -a claude-code -a codex -a antigravity
```

### Option 2: Install script *(all agents, no extra tools)*
Clone the repo, then run the installer from the repository root:
```bash
git clone https://github.com/SyedZeerak/phouppo.git
cd phouppo

bash install.sh                          # global install for all four agents
bash install.sh --agents codex,antigravity
bash install.sh --project                # install into the current project instead
bash install.sh --link                   # symlink so repo updates apply automatically
bash install.sh --uninstall
```
Windows (PowerShell):
```powershell
.\install.ps1
.\install.ps1 -Scope project -Agents codex,antigravity
```

### Option 3: Cursor
<details open>
<summary><b>Project-level or Global installation</b></summary>

**Project Level (Current Repository):**
```bash
git clone https://github.com/SyedZeerak/phouppo.git
mkdir -p .cursor/skills
cp -r phouppo/skills/phouppo .cursor/skills/
rm -rf phouppo
```

**Global Level (Available Across All Projects):**
```bash
git clone https://github.com/SyedZeerak/phouppo.git
mkdir -p ~/.cursor/skills
cp -r phouppo/skills/phouppo ~/.cursor/skills/
rm -rf phouppo
```

> [!NOTE]
> Cursor also recognizes skills in `.agents/skills/` and `.claude/skills/`. If the skill does not appear immediately, restart Cursor and check **Settings > Rules / Skills**.
</details>

### Option 4: Claude Code
<details>
<summary><b>Claude Code installation</b></summary>

```bash
git clone https://github.com/SyedZeerak/phouppo.git
mkdir -p ~/.claude/skills
cp -r phouppo/skills/phouppo ~/.claude/skills/
rm -rf phouppo
```
</details>

### <a id="option-5-codex"></a>Option 5: Codex
<details>
<summary><b>Codex installation</b></summary>

Codex scans `.agents/skills` from your working directory up to the repository root, and `~/.agents/skills` for personal skills.

**Global:**
```bash
git clone https://github.com/SyedZeerak/phouppo.git
mkdir -p ~/.agents/skills
cp -r phouppo/skills/phouppo ~/.agents/skills/
rm -rf phouppo
```

**Project level:** copy the folder to `<your-project>/.agents/skills/phouppo` instead.

Run `/skills` in Codex to confirm it is listed, and invoke it with `$phouppo`.
</details>

### <a id="option-6-antigravity"></a>Option 6: Antigravity
<details>
<summary><b>Antigravity installation</b></summary>

**Global:**
```bash
git clone https://github.com/SyedZeerak/phouppo.git
mkdir -p ~/.gemini/antigravity/skills
cp -r phouppo/skills/phouppo ~/.gemini/antigravity/skills/
rm -rf phouppo
```

**Project level:** copy the folder to `<your-project>/.agent/skills/phouppo` instead.

> [!NOTE]
> These locations follow the skills CLI conventions. Confirm them against your Antigravity version, and restart the agent if the skill does not appear.
</details>

### Invocation by agent

| Agent | Command |
|:---|:---|
| Cursor | `/phouppo` |
| Claude Code | `/phouppo` |
| Codex | `$phouppo` |
| Antigravity | Mention `phouppo` in chat, or use its skill picker |

> [!NOTE]
> The `disable-model-invocation` line in `SKILL.md` is honored by Cursor and Claude Code. Other agents may ignore it and select the skill automatically when a request matches.

---

## <a id="usage"></a>🚀 Usage & Options

Invoke the skill directly within your agent chat window (use `$phouppo` instead of `/phouppo` in Codex):

```bash
# Standard audit on the entire repository (default)
/phouppo

# Quick triage check (Phase 0 & 1 only)
/phouppo . --depth quick

# Full comprehensive deep dive across all 10 areas
/phouppo . --depth deep

# Focused audit on targeted subsystem and domains
/phouppo src/server --focus security,data

# Audit frontend styling and UX exclusively
/phouppo apps/web --focus visual
```

### Parameter Reference

| Flag / Argument | Options | Description |
|:---|:---|:---|
| `[scope]` | `<path>` | Relative path to audit. Defaults to `.` (repo root). Narrow scope to save tokens. |
| `--depth` | `quick` | Runs Reconnaissance & 10-Point Triage only. |
| | `standard` *(default)* | Adds Phase 2 deep-dive modules for areas flagged during triage. |
| | `deep` | Executes thorough deep-dive reviews across all 10 domains. |
| `--focus` | `comma-separated` | Limits Phase 2 to specific areas: `security`, `architecture`, `code-quality`, `visual`, `data`, `devops`, `testing`, `llm`, `product`, `docs`. |

> [!TIP]
> Want the audit saved to disk? Simply append your instruction:
> *"Run `/phouppo --depth standard` and save the report to `audit-report.md`."*

### Automatic Triggering
The skill ships with `disable-model-invocation: true` to prevent accidental token usage. If you want your agent to automatically recommend Phouppo during code reviews or before pull requests, remove that line from [SKILL.md](skills/phouppo/SKILL.md).

---

## <a id="sample-report"></a>📋 Sample Report Preview

Here is an excerpt of what Phouppo produces when auditing an application. The application and findings below are a fictional, illustrative example.

```markdown
# Vibe Code Audit Report: Acme Logistics Portal
Date: 2026-10-13 | Scope: apps/portal | Depth: standard

## 1. Executive Summary
- Overall Readiness: **Not ready for production**
- Primary Risk: Any authenticated driver can access distributor payout spreadsheets via IDOR.
- Required Action: Patch 2 critical authorization checks and enable RLS policies prior to launch (~1 day effort).

## 2. Scorecard
| Area | Rating | Key Reason |
|:---|:---|:---|
| Security | 🔴 Critical | Unrestricted ID parameter in payout route |
| Data & Calculations | 🟠 High | Float arithmetic used for currency totals |
| Code Quality | 🟡 Medium | Swallowed promise rejections in queue consumer |
| Visual Design | 🟢 Good | Clean token usage; WCAG AA contrast maintained |

## 3. Findings

### [SEC-01] IDOR in Distributor Payout Route
- Severity: Critical | Exploitability: High
- Location: `apps/portal/api/payouts/[id].ts:42`
- Evidence:
  const payout = await db.payouts.findUnique({ where: { id: req.query.id } });
  return res.json(payout);
- Risk: Route verifies session token but does not check whether req.user.orgId owns payout.
- Remediation: Scope query to tenant: { id: req.query.id, orgId: req.user.orgId }.
```

---

## <a id="safety-model"></a>🛡️ Safety Model

Phouppo is designed from the ground up to be safe to run against sensitive and proprietary codebases:

- **🔒 100% Read-Only:** Phouppo inspects code, but never edits, commits, or mutates repository files.
- **🙈 Secret Masking:** Detected tokens or API keys are automatically redacted (first 4 characters visible, followed by `****`).
- **🛡️ Injection Resistant:** Treats all codebase strings, READMEs, and test fixtures as untrusted user input.
- **🚫 Zero Unapproved Side Effects:** Never runs arbitrary shell commands, executes migrations, or triggers external network requests without explicit approval.
- **🎯 Evidence or Silence:** If something cannot be verified conclusively from static code, it is marked `Not verified`. No hallucinated vulnerabilities.

---

## 🤝 Companion Skills

Phouppo works seamlessly alongside other agent skills:
- **Terse output skills** (e.g. *caveman*) can manage working notes and subsequent fix generation, while preserving full fidelity for findings and evidence.
- **Minimal code skills** (e.g. *ponytail*) can guide remediation to ensure fixes remain concise and free of speculative abstractions.

---

## 📂 Repository Layout

```
phouppo/
├── README.md                      # Documentation & Quickstart
├── LICENSE                        # MIT License
├── CHANGELOG.md                   # Release history
├── CONTRIBUTING.md                # Contribution guidelines
├── AGENTS.md                      # Fallback for agents without skill support
├── install.sh                     # Installer (macOS / Linux)
├── install.ps1                    # Installer (Windows PowerShell)
└── skills/
    └── phouppo/
        ├── SKILL.md               # Main agent skill definition
        └── references/            # Modular deep-dive checklists
            ├── security.md        # Auth, IDOR, RLS, injection
            ├── architecture.md    # Multi-tenancy, API & structure
            ├── code-quality.md    # Error handling, race conditions
            ├── visual-design.md   # Design tokens, contrast, layout
            ├── data-engineering.md# Schema, migrations, math accuracy
            ├── devops.md          # CI/CD, envs, observability
            ├── testing.md         # Critical coverage, test quality
            ├── llm-risks.md       # Prompt injection, token runaway
            ├── product-governance.md # Feature fit, ownership
            ├── documentation.md   # Handover package, runbooks
            ├── stack-notes.md     # Framework-specific cheat sheets
            └── report-template.md # Standardized report schema
```

---

## ⚠️ Limitations

Phouppo provides **static, agent-assisted code review**. It does not substitute for:
- Formal, manual penetration testing
- Real-time dynamic fuzzing or live network vulnerability scanning
- Legal, HIPAA, or SOC2 compliance certification

Findings labeled `Not verified` always warrant human review.

---

## 🤝 Contributing

Contributions are warmly welcome! Whether you are adding stack-specific patterns to `stack-notes.md` or expanding check coverage:
1. Review [CONTRIBUTING.md](CONTRIBUTING.md).
2. Open an issue or submit a pull request.

---

## 📄 License

Distributed under the **MIT License**. See [LICENSE](LICENSE) for details.

---

<div align="center">

Crafted with care by **Syed Wajdan Zeerak**  
[![GitHub](https://img.shields.io/badge/GitHub-SyedZeerak-181717?style=flat-square&logo=github)](https://github.com/SyedZeerak)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Syed--Wajdan--Zeerak-0A66C2?style=flat-square&logo=linkedin)](https://www.linkedin.com/in/Syed-Wajdan-Zeerak)

</div>