# Verification Modes: Tools and Dynamic Testing

Contents: preflight, consent plan, tools mode, dynamic mode, stop conditions, evidence.

## Preflight (required before any command)
Confirm all of the following. If any fails, stay in static mode and say why.
- Target is localhost, a container, or a staging copy. Check `.env*`, config, and connection strings for production hostnames or managed production databases.
- Data is synthetic or masked. No real employee, distributor, or customer records.
- External integrations (payments, SMS, email, LLM, identity) are mocked, sandboxed, or disabled.
- No real credentials or production API keys are loaded.
- A container or throwaway environment is preferred, because running the app executes its code and install scripts.

## Consent plan
Before running anything, print: mode, exact commands, what each touches, expected side effects, and files that may be created. Wait for an explicit yes. Run only what was approved.

## Tools mode (--mode tools)
Run only read-only tools that exist on the machine. If one is missing, mark the check "Not verified" and recommend installing it.
| Check | Command examples |
|-------|------------------|
| Secrets, including git history | `gitleaks detect --redact` |
| Vulnerable dependencies | `npm audit --omit=dev`, `pip-audit`, `osv-scanner` |
| Insecure code patterns | `semgrep --config auto` |
| Existing tests | The project's own test command, only after confirming tests do not hit real services |

## Dynamic mode (--mode dynamic)
Includes tools mode. Start the app locally with approved commands, then probe.
1. **Authorization & Complete Mediation:** create two test users (and one per role/tenant). As user A, request user B's resources by changing IDs (BOLA/IDOR), send extra privileged fields in body payloads (BOPLA/mass assignment), and call admin endpoints as a normal user (BFLA). Record request and response status.
2. **Concurrency & TOCTOU probes:** fire 2–5 parallel requests against state-transition, coupon, or balance-deduction endpoints in the local sandbox to verify atomic locking and idempotency.
3. **Calculations:** run user-supplied golden cases (inputs with expected outputs from the written policy, including zero, negative, and slab boundaries). Report every mismatch.
4. **Boundary parsing & input handling:** a small set of malformed, unexpected-type, and oversized inputs on forms and APIs. No heavy fuzzing or load.
5. **Sessions:** expired or tampered tokens, logout invalidation, and session fixation check.
6. **Headers and cookies:** read from real responses (CSP, HSTS, cookie flags, CORS reflection).
7. **Errors:** confirm no stack traces, raw Prisma/SQL errors, or internal paths reach the client.
8. **Visual, CWV & HCI:** if a browser tool exists, inspect at about 360, 768, and 1280 px in each theme, measure LCP/CLS/INP and response latency against the 400ms Doherty Threshold, verify touch target sizes ($\ge 44\text{px}$), and run an accessibility/contrast scan.

## Stop conditions
Stop and report immediately if: a production system is detected, real personal data, or any breach of the consent plan. Return to static mode and explain what happened.
