# Report Template

Follow this structure. Keep the executive summary free of jargon. Do not pad sections: omit a section only if it has no content, and say so.

```markdown
# Vibe Code Audit Report: <application name>

Date: <YYYY-MM-DD>
Scope: <paths, branches, commit if known>
Depth: quick | standard | deep
Mode: static | tools | dynamic
Commands run: <list, or "none">
Stack: <language, framework, database, hosting, integrations>
Not examined: <what was out of scope or could not be verified>

## 1. Executive summary
Three to six sentences in plain language for non-technical readers.
- Overall readiness: Not ready | Ready with conditions | Ready
- The most important risks, in business terms (for example: "any logged-in user can view other distributors' payouts").
- What must be fixed before go-live, and a rough effort estimate.

## 2. Scorecard
| Area | Rating (Critical/High/Medium/Low/Good) | Key reason |
|------|----------------------------------------|------------|
| Security | | |
| Architecture | | |
| Code quality | | |
| Visual design and UI | | |
| Data and calculations | | |
| DevOps and reliability | | |
| Testing | | |
| LLM risks (if applicable) | | |
| Product fit and governance | | |
| Documentation and handover | | |

## 3. Triage results
| # | Check | Result (Pass/Fail/Partial/Not verified) | Evidence |
|---|-------|------------------------------------------|----------|

## 3b. Tests performed (tools and dynamic modes only)
| Test | Command or probe | Result | Findings affected |
|------|------------------|--------|-------------------|

## 4. Findings
Ordered by severity, then exploitability. Use the finding format from SKILL.md (including the `Verified: Static | Test` field).

## 5. Positive observations
Brief list of what is done well, with evidence.

## 6. Recommended remediation plan
| Priority | Action | Findings addressed | Effort | Suggested owner |
|----------|--------|--------------------|--------|-----------------|
| Before go-live | | | | |
| Within 30 days | | | | |
| Backlog | | | | |

## 7. Items requiring verification
Things that could not be confirmed from the repository, and what is needed (for example: "confirm restore test with the hosting administrator").

## 8. Limitations
Static review limits, sampling approach, and any assumptions.
```

## Writing rules
- Plain language first, technical detail second.
- Every finding must stand alone: someone reading only that finding can understand the risk and act.
- Use consistent IDs: SEC-01, ARC-01, COD-01, VIS-01, DAT-01, OPS-01, TST-01, LLM-01, PRD-01, DOC-01.
- Include the `Verified: Static | Test` field on every finding to distinguish static analysis from dynamic proof.
- Do not include full secrets, personal data, or large code excerpts.

