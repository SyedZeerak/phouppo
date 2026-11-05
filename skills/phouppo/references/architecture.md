# Architecture, Systems, and Scalability Review

Contents: foundational systems laws, modular boundaries and conceptual integrity, state and distributed consistency, API design, performance and queueing laws, background work, resilience, multi-tenancy, build versus buy.

## Foundational software & systems laws
Ground architectural findings in these proven engineering principles:
- **Parnas's Information Hiding (1972) & Constantine's Coupling/Cohesion:** Modules should hide internal data representations and volatile design decisions behind stable interfaces; high cohesion inside modules, low coupling between them.
- **Ousterhout's Deep vs. Shallow Modules (*A Philosophy of Software Design*):** Favor *deep modules* (simple interface hiding substantial implementation complexity) over *shallow modules* (pass-through methods, boilerplate wrappers, and over-abstracted layers that add cognitive load without hiding complexity).
- **Brooks's Conceptual Integrity & Accidental Complexity (*The Mythical Man-Month*):** A system should reflect a single cohesive design. In AI-generated apps, multiple prompting sessions often produce three competing patterns for state, fetching, validation, and error handling.
- **Butler Lampson's Hints for System Design:** *Separate mechanism from policy*; *Do one thing well*; *Keep secrets*; *End-to-End Principle* (Saltzer, Reed & Clark: correctness and idempotency must be guaranteed at the endpoints, not assumed from intermediate layers).
- **Amdahl's Law:** Overall speedup is bounded by the serial fraction of a workflow. Sequential `await` waterfalls or main-thread/event-loop blocking calls bottleneck throughput regardless of hardware scaling.
- **Little's Law ($L = \lambda W$):** Concurrent requests in flight ($L$) equal arrival rate ($\lambda$) times average latency ($W$). When downstream latency $W$ spikes, $L$ explodes—exhausting database connection pools, worker threads, and memory unless bounded by timeouts and backpressure.

## 1. Modularity, deep modules, and conceptual integrity
- **Separation of concerns:** Clear boundary between UI presentation, domain/business logic, and data access (`db`/ORM), versus raw SQL/ORM calls and pricing rules scattered inside UI components and route handlers.
- **Single source of domain truth (DRY business rules):** Business rules, permissions, and validation schemas defined once and enforced on the server, not duplicated (with subtle drift) between frontend and backend.
- **Conceptual integrity across files:** Flag competing implementations of the same concern (for example mixing Redux, Zustand, and raw Context; mixing `fetch`, `axios`, and Server Actions; inconsistent error shapes) introduced by separate AI prompting sessions.
- **Shallow-module bloat & dead code:** Pass-through service/repository layers that only forward arguments, speculative abstractions for hypothetical requirements (YAGNI violations), unused dependencies, dead files, and leftover template scaffolding.
- **Dependency direction:** Domain logic should not depend on UI or transport frameworks; check for circular imports that break bundling or testing.

## 2. State, caching, and distributed consistency
- **Source of truth:** Server/database state treated as authoritative; client state never trusted for prices, roles, quotas, or workflow status.
- **Derived state invariants:** Totals, balances, and aggregate statuses computed via a single canonical function or database view rather than re-derived inconsistently across screens.
- **Cache invalidation & isolation:**
  - Server-side caches (`unstable_cache`, Redis, in-memory `Map`, CDN `Cache-Control`) keyed by tenant/user ID where data is private; flag shared cache keys that leak User A's response to User B.
  - Protection against **cache stampede (thundering herd)** on expensive queries when a hot key expires.
- **Dual-write anti-pattern (Kleppmann DDIA):** Updating the database and publishing an event/email/webhook or calling a payment API without a transactional outbox, idempotency key, or compensating saga—leaving the system in a split-brain state on partial failure.

## 3. API design and contract discipline
- Consistent conventions (REST resource naming, HTTP verbs/status codes, or typed RPC/GraphQL), predictable error envelope (`{ code, message, details }`), and explicit boundary schemas.
- **Bounded queries:** Server-side pagination, filtering, and sorting on every collection endpoint. Flag unbounded `SELECT *` / `findMany()` endpoints that work with 20 demo rows and crash at 20,000 rows.
- **Idempotency (End-to-End Principle):** State-mutating writes that may be retried over unreliable networks (payments, order creation, payouts, approvals, webhook consumers) require an `Idempotency-Key` or natural unique constraint.
- Versioning or backward-compatible evolution where mobile apps, webhooks, or external consumers exist.

## 4. Scalability, Amdahl's waterfalls, and Little's Law capacity
- **N+1 query loops:** Database or API queries executed inside `for`/`map` loops or per-row component renders instead of batched `WHERE id IN (...)`, `JOIN`, or dataloader patterns.
- **Serial request waterfalls (Amdahl's Law):** Independent async calls awaited sequentially (`await a(); await b(); await c();`) instead of concurrently (`Promise.all` / `asyncio.gather`), multiplying tail latency.
- **Request-cycle blocking:** Heavy work performed synchronously inside an HTTP request handler (PDF/Excel generation, bulk CSV imports, multi-recipient emails, LLM chains, image resizing) that will exceed serverless or proxy timeouts.
- **Connection pool & memory bounds (Little's Law):**
  - Serverless functions instantiating a new DB client per invocation or exhausting Postgres connection limits without a pooler (PgBouncer / Supavisor).
  - Loading entire tables or multi-megabyte files into process RAM to filter/aggregate in JavaScript/Python instead of streaming or pushing predicates to SQL.

## 5. Background work and asynchronous pipelines
- Jobs, queues, and cron tasks: bounded concurrency, exponential backoff with jitter, dead-letter queues (DLQ), and failure alerting.
- **Idempotent job execution:** At-least-once queue delivery means jobs *will* run more than once; verify handlers are safe to re-run without double-charging or sending duplicate notifications.
- **Distributed cron lock:** Scheduled tasks running on multi-instance deployments without a distributed lock or single scheduler, duplicating runs across replicas.

## 6. Resilience and fault isolation (Nygard's *Release It!*)
- **Fallacies of Distributed Computing:** What happens when a third-party service (Stripe, Twilio, SendGrid, Maps, LLM provider, OAuth IDP) is slow, rate-limiting (`429`), or down (`5xx`)?
- **Explicit timeouts:** Every outbound HTTP, RPC, and DB call must configure a connect and read timeout (unbound `fetch()` or `requests.get()` without `timeout=` hangs workers indefinitely under Little's Law).
- **Circuit breaking, retries & bulkheads:** Retries limited to transient/idempotent errors with backoff + jitter (preventing retry storms); non-critical failures (analytics, secondary notifications) degrade gracefully without failing the core user transaction.

## 7. Multi-tenancy and blast-radius isolation
- Tenant, organization, region, or branch isolation enforced at the data access layer and storage paths (`s3://bucket/<tenant_id>/...`), not only in UI filters.
- Shared infrastructure (Redis namespaces, background job payloads, search indexes, vector stores) explicitly partitioned by tenant ID.

## 8. Build versus buy and mechanical sympathy
- Custom, fragile re-implementations of solved infrastructure (homegrown auth/crypto, custom job queues in DB tables without `FOR UPDATE SKIP LOCKED`, regex-based HTML sanitizers, custom date/timezone math) where standard platform features or vetted libraries belong.
- **Mechanical sympathy (Martin Thompson):** Respecting how the underlying runtime works—avoiding synchronous CPU blocks (`fs.readFileSync`, `crypto.pbkdf2Sync`, giant `JSON.parse`, heavy regex) on a single-threaded Node.js/Python async event loop.
