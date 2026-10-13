# DevOps and Reliability Review

Contents: environments and deployment, CI/CD, hosting limits, observability, cost control, continuity.

## Environments and deployment
- Separate development, staging, and production environments with separate credentials and data.
- Deployment is scripted and repeatable, not manual steps held in someone's memory.
- Rollback path exists and is documented.
- Infrastructure defined as code, or recorded configuration, rather than undocumented console changes.

## CI/CD
- Automated build, lint, type-check, test, and dependency or secret scanning on every change.
- Protected main branch; code review required for production changes.
- Build reproducibility: pinned runtime versions, lockfile used in CI.

## Hosting and capacity
- Hosting plan limits versus real usage: cold starts, request timeouts, database connection caps, storage and bandwidth quotas, free-tier pausing.
- Realistic load expectations (concurrent users at peak, such as month-end closing or incentive publication) and evidence of load testing, otherwise `Not verified`.
- Region and latency for users in the target geography; behavior on weak connectivity.

## Observability
- Structured, searchable logs without sensitive data.
- Error tracking, uptime checks, health endpoint, and alerts that reach a named person.
- Basic metrics: latency, error rate, job success, queue depth.

## Cost control
- Unbounded spend: LLM calls, SMS, email, maps, storage egress. Spending caps and alerts configured.
- Per-user and per-endpoint limits on paid operations.

## Continuity and ownership
- Disaster recovery: defined RTO and RPO, tested restore, secondary access.
- Bus factor: setup is documented; repository, hosting, domain, database, and third-party accounts are owned by the organization, not a personal account; at least two people hold admin access.
- Maintenance plan: who patches dependencies, who responds to an incident at 2 a.m., and what the long-term support cost is.
