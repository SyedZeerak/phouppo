# LLM and AI Feature Risks

Apply only if the application calls a language model or other AI service.

## Data exposure
- What data is sent to the model provider (personal, financial, commercial)? Under what terms and retention? Is it appropriate for the organization's policy?
- Prompts and responses stored in logs or analytics.

## Prompt injection and untrusted content
- User text, uploaded documents, web pages, and database content placed into prompts without separation or delimiting.
- Model output treated as trusted instructions, SQL, shell commands, URLs, or HTML.
- Output rendered as raw HTML or executed (stored XSS and code execution risk).

## Agent and tool permissions
- Least privilege for tools: no unrestricted database, file system, shell, or network access.
- Destructive or financial actions require explicit human confirmation.
- Per-user scoping: the model cannot retrieve another user's data through a shared tool or index.

## Reliability
- Hallucination handling; human-in-the-loop on consequential outputs (approvals, payouts, customer communication).
- Deterministic logic (calculations, policy rules) is implemented in code, not delegated to the model.
- Structured output is validated against a schema; failures handled.
- Model and version pinned; behavior on provider outage or deprecation.

## Cost and abuse
- Token limits, request rate limits, per-user quotas, and spending alerts.
- Protection against prompt-based resource exhaustion (very long inputs, recursive tool loops).

## Evaluation
- A test set or review process for output quality; monitoring for drift and regressions after model or prompt changes.
