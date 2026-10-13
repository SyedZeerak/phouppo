# Architecture Review

Contents: structure, business logic placement, API design, scalability, resilience, tenancy, build versus buy.

## Structure and consistency
- Clear separation of UI, business logic, and data access, or logic scattered across components and route handlers.
- Business rules duplicated in frontend and backend, or living only in the frontend.
- Consistent patterns across the codebase. Multiple ways of doing the same thing (data fetching, state, validation, error handling) indicate separate prompting sessions with no shared design.
- Dead code, unused files and dependencies, leftover scaffolding, commented-out blocks.
- Configuration separated from code; environment handling is explicit.
- Circular dependencies and tight coupling that make changes risky.

## State and data flow
- Global state misuse; stale caches; client state treated as the source of truth.
- Derived values (totals, balances, statuses) computed in more than one place with different logic.

## API design
- Consistent conventions (REST or GraphQL), error format, status codes, and naming.
- Server-side pagination, filtering, and sorting. Unbounded list endpoints.
- Idempotency for writes that may be retried (payments, submissions, approvals).
- Versioning strategy where external consumers exist.

## Scalability assumptions
- N+1 queries; missing indexes on queried columns; loading entire tables into memory.
- Heavy or slow work performed inside the request cycle (report generation, bulk imports, external API calls).
- Connection pooling and database connection limits, especially on serverless or free tiers.
- Behavior at expected peak: concurrent users, record counts, and import sizes realistic for the business.

## Background work
- Jobs, queues, and schedulers: retries with backoff, idempotency, dead-letter handling, failure alerting.
- Scheduled tasks that run on every instance and duplicate work.

## Resilience
- What happens when a third-party service (payments, SMS, email, maps, LLM, identity provider) is slow or down? Timeouts, retries, circuit breaking, graceful degradation.
- Single points of failure; single-region or single-instance assumptions.

## Multi-tenancy and scope
- Tenant, region, or department isolation enforced at the data layer, not only in the UI.
- Shared resources (caches, storage paths, job queues) that could leak across tenants.

## Build versus buy
- Custom implementations of solved problems (authentication, authorization, file storage, scheduling, search) where a proven service or library fits.
- Vendor lock-in and cost exposure introduced silently by the generated code.
