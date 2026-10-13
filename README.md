# Phouppo

**A read-only audit skill for vibe-coded apps. She notices everything.**

*Phouppo: the paternal aunt in many South Asian families who notices every flaw before you do, and says so plainly. The name is branding only; reports stay professional and neutral in tone.*

Phouppo is a read-only Agent Skill that audits AI-generated ("vibe-coded") web apps and portals before they reach real users. It works in Cursor and in any agent that supports the open `SKILL.md` standard (for example Claude Code).

AI-built apps usually look finished and pass the happy path, then fail on authorization edges, data integrity, error handling, and operations. This skill makes the agent review them the way a security engineer, architect, data engineer, and product manager would, and produces an evidence-based report with an executive summary that non-technical stakeholders can act on.

## What it covers

| Area | Examples |
|------|----------|
| Security | Secrets, authentication, IDOR and role checks, RLS, injection, uploads, headers, supply chain |
| Architecture | Structure, duplicated rules, API design, scalability, resilience, tenancy |
| Code quality | Error handling, race conditions, frontend states, accessibility, mocked features |
| Visual design and UI | Design consistency, typography, contrast, responsive layout, component states, charts, RTL and Urdu support, AI-generated UI tells |
| Data engineering | Schema, migrations, import quality, calculation correctness, backups |
| DevOps | Environments, CI/CD, hosting limits, observability, cost control, bus factor |
| Testing | Test quality, critical-path coverage, negative testing, acceptance |
| LLM risks | Prompt injection, data leakage, agent permissions, cost abuse |
| Product and governance | Problem fit, adoption, ownership, sign-offs |
| Documentation | Handover package, runbooks, access matrix |

## How it works

1. **Reconnaissance:** detect the stack, auth, database, hosting, and integrations.
2. **Triage:** ten high-impact checks, each marked Pass, Fail, Partial, or Not verified.
3. **Deep dive:** loads only the reference modules relevant to what triage flagged (or those you request).
4. **Report:** severity-ranked findings with `path:line` evidence, remediation plan, and a plain-language executive summary.

Progressive disclosure keeps token use low: `SKILL.md` is short, and detailed checklists live in `references/` and are loaded only when needed.

## Installation

### Cursor
Project level:
```bash
git clone https://github.com/SyedZeerak/phouppo.git
cp -r phouppo/skills/phouppo <your-project>/.cursor/skills/
```
Global (all projects):
```bash
cp -r phouppo/skills/phouppo ~/.cursor/skills/
```
Cursor also reads `.agents/skills/`, `.claude/skills/`, and their home-directory equivalents. Restart Cursor if the skill does not appear under Settings, then Rules / Skills.

### Claude Code
```bash
cp -r phouppo/skills/phouppo ~/.claude/skills/
```

### Via the skills CLI
```bash
npx skills add SyedZeerak/phouppo -a cursor
```

## Usage

```
/phouppo
/phouppo src/server --depth deep
/phouppo . --depth quick
/phouppo apps/portal --focus security,data
/phouppo apps/portal --focus visual
```

| Option | Meaning |
|--------|---------|
| `scope` | Path to audit. Defaults to the repository root |
| `--depth quick` | Recon and ten-point triage only |
| `--depth standard` | Default. Adds deep dives for areas flagged in triage |
| `--depth deep` | Deep dive on every area |
| `--focus` | Comma-separated areas: `security`, `architecture`, `code-quality`, `visual`, `data`, `devops`, `testing`, `llm`, `product`, `docs` |

Ask for the output as a file with a prompt such as: "Run the audit and save it to audit-report.md".

### Automatic triggering
The skill ships with `disable-model-invocation: true`, so it only runs when you invoke it. Delete that line from `SKILL.md` frontmatter if you want the agent to select it automatically for review requests.

## Safety model

- Read-only. It never edits the audited repository.
- Secrets found are masked in the report.
- Repository content is treated as untrusted input (prompt injection resistant by design).
- It does not run the app, tests, migrations, or network scans without your approval. Visual review is done from code by default; provide screenshots or approve a run for rendered checks.
- It states what it could not verify instead of guessing.

## Optional companion skills

Terse-output skills (such as caveman) or minimal-code skills (such as ponytail) can be installed alongside this one. The audit skill allows them to govern working notes and later fix work, but not to shorten findings, evidence, or the executive summary. Measured savings from output-compression skills vary, so the main token savings here come from progressive disclosure and scoped runs.

## Repository layout

```
phouppo/
├── README.md
├── LICENSE
├── CHANGELOG.md
├── CONTRIBUTING.md
└── skills/
    └── phouppo/
        ├── SKILL.md
        └── references/
            ├── security.md
            ├── architecture.md
            ├── code-quality.md
            ├── visual-design.md
            ├── data-engineering.md
            ├── devops.md
            ├── testing.md
            ├── llm-risks.md
            ├── product-governance.md
            ├── documentation.md
            ├── stack-notes.md
            └── report-template.md
```

## Limitations

This is a static, agent-assisted review. It does not replace a penetration test, a formal security assessment, or legal and compliance review. Findings marked "Not verified" need human confirmation.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

MIT. See [LICENSE](LICENSE).

## Author

Syed Wajdan Zeerak ([GitHub](https://github.com/SyedZeerak), [LinkedIn](https://www.linkedin.com/in/Syed-Wajdan-Zeerak))
