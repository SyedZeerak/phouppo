# DevOps, SRE, and Operational Reliability Review

Contents: foundational SRE and systems laws, environments and Twelve-Factor config, CI/CD and release safety, hosting limits and capacity (Little's Law), observability (Gregg USE & Wilkie RED methods), graceful lifecycle, cost and quota controls, continuity and bus factor.

## Foundational SRE & operational principles
- **The Twelve-Factor App (Adam Wiggins):** Strict separation of config from code, stateless processes, disposable instances with fast startup and graceful shutdown, dev/prod parity, and logs treated as event streams.
- **Google SRE Principles (Treynor Sloss):** Define Service Level Indicators (SLIs) and Objectives (SLOs) for availability and tail latency ($p95$/$p99$); automate toil; practice blameless postmortems and reproducible rollbacks.
- **Brendan Gregg's USE Method (Infrastructure):** For every hardware/runtime resource (CPU, memory, DB connections, disk, event loop), monitor **U**tilization, **S**aturation (queue length / wait time), and **E**rrors.
- **Tom Wilkie's RED Method (Request Services):** For every API service and route, track **R**ate (requests/sec), **E**rrors (failed responses), and **D**uration (latency histogram, especially $p95$/$p99$).

## 1. Environments, Twelve-Factor configuration, and deployment
- Separate development, staging, and production environments with completely isolated credentials, databases, storage buckets, and webhook endpoints.
- **Startup env validation:** Environment variables validated at application boot (for example via `zod` / `@t3-oss/env` / `pydantic-settings`) so missing or malformed config fails fast at deploy time rather than crashing mid-request.
- **Repeatable deployments & rollbacks:** Scripted, deterministic deployments with a documented, one-command rollback path; infrastructure defined as code (Terraform, Pulumi, Docker/Compose, platform manifests) rather than undocumented console clicks.
- **Container & runtime hardening:** If a `Dockerfile` is present, verify multi-stage builds, pinned base image tags/digests, `.dockerignore` excluding `.env`/`.git`/`node_modules`, and execution as a non-root user (`USER node` / `USER appuser`).

## 2. CI/CD and supply-chain gates
- Automated pipeline running on every pull request: lockfile-enforced install (`npm ci` / `--frozen-lockfile`), linter, static type-check, test suite, build verification, and dependency/secret scanning.
- Protected production branch requiring passing status checks and review; no direct force-pushes or manual `scp`/FTP uploads to production servers.

## 3. Hosting limits, capacity, and Little's Law
- **Platform quota alignment:** Compare architecture against hosting tier constraints—serverless execution timeouts (10s–60s), payload body limits (4.5MB on Vercel), ephemeral filesystem loss on restart, cold starts, database connection caps, and free-tier auto-pausing.
- **Peak load readiness:** Evaluate behavior under realistic business peaks (month-end financial close, payroll/incentive publication, morning field-sales sync). Look for connection poolers (PgBouncer/Supavisor), HTTP keep-alive reuse, and CDN/edge caching.
- **Graceful shutdown (`SIGTERM`):** Server processes listen for `SIGTERM`/`SIGINT`, stop accepting new requests, drain in-flight requests/jobs, and close DB connections cleanly before exiting.

## 4. Observability (USE & RED methods)
- **Structured logging:** JSON-structured logs with severity levels, timestamps, and propagated request correlation IDs (`X-Request-ID` / W3C `traceparent`)—never raw `console.log(userObject)` leaking PII or tokens.
- **Health & readiness probes:** Liveness probe (`/healthz`) separated from deep dependency readiness (`/readyz`) so temporary downstream slowdowns do not trigger cascading container restarts.
- **Error tracking & alerting:** Unhandled exceptions, failed background jobs, and dead-letter queues routed to an active tracker (Sentry, Datadog, OpenTelemetry) with alerts reaching a named owner.

## 5. Cost control and runaway protection
- **Unbounded spend circuit breakers:** Hard budgets, rate limits, and per-user/per-tenant quotas on paid external APIs (LLM tokens, SMS/OTP gateways, WhatsApp APIs, Google Maps/Places, egress bandwidth).
- Protection against recursive webhook loops, infinite background job retries, or unthrottled public endpoints that can rack up cloud bills.

## 6. Continuity, disaster recovery, and bus factor
- **Disaster recovery:** Defined RTO and RPO, automated offsite backups, and tested restoration runbook.
- **Institutional ownership (Bus factor $\ge 2$):** Git repository, cloud hosting, DNS domain registrar, database, payment gateway, and Apple/Google developer accounts owned by organization accounts (with MFA and $\ge 2$ admins), never bound to an individual contractor's or developer's personal email/credit card.
