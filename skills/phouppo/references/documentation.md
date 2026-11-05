# Documentation, ADR, and Handover Review

## Foundational documentation principles
- **Literate & Self-Documenting Systems (Knuth / Parnas):** Code shows *how*; documentation must explain *why*—domain invariants, architectural trade-offs, and operational recovery procedures that cannot be inferred from syntax alone.
- **Architecture Decision Records (ADRs — Michael Nygard) & Diátaxis Framework:** Separate quickstart tutorials, operational how-to runbooks, technical reference (API/schema), and architectural explanation.

## Minimum handover package
- **README & Quickstart:** Purpose, prerequisites, reproducible local setup from a clean clone, `.env.example` documenting every variable's purpose and format (never real secrets), test execution, and build/deploy commands.
- **System Architecture & Data Flow:** High-level component boundary diagram, authentication/authorization flow, multi-tenant isolation model, and external service dependencies.
- **API & Contract Reference:** OpenAPI/Swagger spec, typed RPC schemas, or webhook payload contracts (including idempotency and signature verification requirements).
- **Data Dictionary & Domain Rules Ledger:** Entity-relationship overview, explicit financial/incentive calculation formulas, rounding rules, tier boundary definitions, and policy versioning rules.
- **Operational Runbooks (Day-2 Operations):** Step-by-step commands for deployment, instant rollback, database migration and restore-from-backup verification, secret/key rotation, dead-letter queue replay, and user/tenant onboarding and offboarding.
- **Architecture Decision Log (ADRs):** Brief record of why key stack choices, third-party services, and security/tenancy models were chosen.
- **Institutional Access Matrix:** Inventory of who holds organization-level admin access for source control, cloud hosting, database, DNS domain, payment/SMS gateways, and error monitoring (confirming bus factor $\ge 2$).

## Assessment
- For each item mark `Present`, `Partial`, or `Missing` with file evidence (and flag AI-generated boilerplate READMEs that still say `"Welcome to Vite + React"` or list commands/routes that do not exist in the codebase).
- State clearly whether a new engineer who never saw the original AI prompts could run, debug, and safely deploy the application from the repository documentation alone.
