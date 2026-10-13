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
1. **Authorization:** create two test users (and one per role). As user A, request user B's resources by changing IDs, and call admin endpoints as a normal user. Record request and response status.
2. **Calculations:** run user-supplied golden cases (inputs with expected outputs from the written policy). Report every mismatch.
3. **Input handling:** a small set of malformed and oversized inputs on forms and APIs. No heavy fuzzing or load.
4. **Sessions:** expired or tampered tokens, logout invalidation.
5. **Headers and cookies:** read from real responses (CSP, HSTS, cookie flags, CORS).
6. **Errors:** confirm no stack traces or SQL errors reach the client.
7. **Visual:** if a browser tool exists, screenshots at about 360, 768, and 1280 px, in each theme, plus a contrast and accessibility scan.

## Stop conditions
Stop and report immediately if: a production system is detected, real personal data, or any breach of the consent plan. Return to static mode and explain what happened.
