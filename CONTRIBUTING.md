# Contributing

Thank you for helping improve this skill. Contributions that make audits more accurate, more evidence-driven, or cheaper in tokens are especially welcome.

## Principles
- **Evidence over opinion.** A check should tell the agent what to look for and how to prove it, not just name a topic.
- **Progressive disclosure.** `SKILL.md` stays short and routes to `references/`. Keep each reference focused on one area.
- **Read-only and safe.** Nothing in the skill may instruct the agent to modify the audited repository, expose secrets, or test third-party systems.
- **Plain language in reports.** The skill must keep producing output that non-technical stakeholders can act on.

## Making a change
1. Fork the repository and create a branch (`feat/<topic>` or `fix/<topic>`).
2. Edit files under `skills/phouppo/`.
3. Keep `SKILL.md` under 500 lines. Add a table of contents to any reference longer than 300 lines.
4. Test the skill on at least two real or sample vibe-coded repositories and note any false positives.
5. Update `CHANGELOG.md` under an `Unreleased` heading.
6. Open a pull request describing the problem, the change, and how you tested it.

## Adding a stack
Add a section to `references/stack-notes.md` with: where authorization is enforced, which variables or settings are exposed to clients, common misconfigurations, and targeted search patterns.

## Reporting issues
Include the agent and version used, the invocation, the stack of the audited app (no proprietary code), and what the skill got wrong.
