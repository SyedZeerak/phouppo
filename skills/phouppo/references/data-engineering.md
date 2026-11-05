# Database Theory, Data Engineering, and Query Optimization Review

Contents: foundational database laws, relational schema and Codd integrity, ACID transactions and MVCC concurrency anomalies, B+Tree indexing and query execution speed, zero-downtime migrations, data ingestion quality, financial and ledger calculation correctness, analytical pipelines, backup and recovery.

## Foundational database principles
- **Codd's Relational Model & Normal Forms (1970 — 3NF/BCNF):** Every non-key attribute must depend on the key, the whole key, and nothing but the key. Uncontrolled denormalization or storing relational entities inside untyped JSON blobs without constraints breeds update anomalies and silent data corruption.
- **Jim Gray's ACID Guarantees & Transaction Processing:** *Atomicity* (all-or-nothing), *Consistency* (invariants preserved across commits), *Isolation* (concurrent transactions do not corrupt each other), and *Durability* (committed writes survive crashes).
- **Berenson, Gray & Kleppmann Concurrency Anomalies (MVCC & Snapshot Isolation):** Default database isolation (`READ COMMITTED` in Postgres/Oracle, `REPEATABLE READ` in MySQL) does **not** prevent *Lost Updates* or *Write Skew*. Concurrent check-then-act logic requires explicit locking, atomic SQL expressions, or `SERIALIZABLE` isolation.
- **Stonebraker's Workload Fit & Mechanical Indexing:** B+Tree indexes follow the leftmost-prefix rule; queries must be *sargable* (Search Argument Able) so the optimizer can seek rather than scan.
- **Double-Entry Bookkeeping (Pacioli / Financial Engineering):** Financial balances, payouts, and inventory adjustments should be backed by an immutable, append-only ledger of debit/credit or delta entries rather than destructive in-place overwrites (`SET balance = 500`) that erase audit history.

## 1. Relational schema and declarative integrity (Codd's Rules)
- Primary keys, `FOREIGN KEY` constraints, `UNIQUE` constraints, `NOT NULL`, and `CHECK` constraints (for example `CHECK (quantity >= 0)`, `CHECK (amount_cents >= 0)`) enforced in the database schema—not only in application code.
- **Data type fidelity:**
  - Money, prices, tax rates, and incentives stored as `NUMERIC(p, s)` / `DECIMAL` or `BIGINT` minor units (paisas/cents), **never** `FLOAT` / `REAL` / `DOUBLE PRECISION`.
  - Timestamps stored as `TIMESTAMPTZ` (UTC); dates stored as `DATE` rather than unvalidated `VARCHAR` strings.
  - Enums or lookup tables constrained rather than free-text status strings (`'pending'`, `'Pending'`, `'PENDING'`).
- **JSONB discipline:** Flag "database-in-a-column" anti-patterns where core relational entities, foreign keys, or frequently filtered attributes are buried inside untyped `JSON`/`JSONB` arrays.
- **Deletion & cascade safety:** Explicit choice between soft delete (`deleted_at`) and hard delete; verify `ON DELETE CASCADE` cannot accidentally wipe historical invoices, ledger entries, or audit logs when a user or SKU is removed. Partial unique indexes (`WHERE deleted_at IS NULL`) used when combining `UNIQUE` constraints with soft deletes.
- Audit columns present (`created_at`, `updated_at`, `created_by`, `updated_by`).

## 2. ACID transactions and MVCC concurrency anomalies
- **Multi-step atomicity:** Any handler that performs two or more dependent writes (create order + decrement inventory + record payment; approve request + write audit log) must execute inside a single database transaction.
- **Lost Update prevention:** Flag read-modify-write sequences where code reads a row (`const row = await db.find(...)`), computes `row.balance -= amount` in JS/Python, and saves `db.update({ balance: row.balance })`. Require atomic SQL (`SET balance = balance - $1 WHERE id = $2 AND balance >= $1`), optimistic concurrency (`WHERE version = $expected`), or `SELECT ... FOR UPDATE`.
- **Write Skew & Phantom prevention:** Flag business invariants checked via a `SELECT COUNT(*)` or `SUM(...)` before an `INSERT` (e.g., "at most 1 active payout run per month", "booking a slot if free", "redeeming a limit-N voucher") without a unique constraint, exclusion constraint, or row/advisory lock.
- **Long-held transactions:** Never hold an open DB transaction across external network calls (Stripe, LLMs, SMTP, webhooks), which locks rows and exhausts connection pools.

## 3. Indexing, sargability, and query speed optimization
- **Foreign key indexing:** Verify every `FOREIGN KEY` column and `tenant_id` / `organization_id` column has an index (Postgres does **not** auto-index foreign keys, causing full-table scans on joins and parent deletes).
- **Composite index leftmost-prefix rule:** Multi-column B+Tree indexes order equality columns first (`tenant_id, status`) followed by range or sort columns (`created_at DESC`).
- **Sargability (Search Argument Able):** Flag queries that wrap indexed columns in functions (`WHERE LOWER(email) = $1`, `WHERE DATE(created_at) = $1`, `WHERE YEAR(order_date) = 2026`) or leading wildcards (`LIKE '%foo'`) without a matching functional/expression index or trigram (`pg_trgm`) / full-text index.
- **Keyset (cursor) vs. `OFFSET` pagination:** Flag deep `OFFSET` pagination (`LIMIT 50 OFFSET 10000`) on large or rapidly growing tables, which forces the DB to scan and discard $N$ rows and skips/duplicates records when rows are inserted concurrently; recommend cursor/keyset pagination (`WHERE (created_at, id) < ($cursor_time, $cursor_id)`).
- **Projection discipline:** Select only needed columns rather than `SELECT *` on tables containing large text/JSON blobs.

## 4. Zero-downtime migrations and environments
- Schema changes managed through versioned, deterministic migration files committed to git—never manual production console edits or `db push --accept-data-loss` in production scripts.
- **Expand-and-contract safety:** Flag migrations that take prolonged `ACCESS EXCLUSIVE` locks on large tables (e.g., `CREATE INDEX` without `CONCURRENTLY` in Postgres, renaming or dropping columns still referenced by running application instances, or rewriting whole tables during peak hours).
- Seed and demo data strictly isolated from production migrations; non-production environments use synthetic or deterministically masked data.

## 5. Data quality, ingestion, and idempotent imports
- Strict schema validation at ingestion boundaries (forms, webhooks, bulk CSV/Excel uploads).
- **Idempotent ingestion:** Re-running a file import, webhook delivery, or sync job must not create duplicate rows or double-count totals (use natural idempotency keys and `ON CONFLICT DO NOTHING / DO UPDATE`).
- **Real-world messy input resilience:** Bulk Excel/CSV importers handle BOM markers, trailing/leading whitespace, merged or reordered headers, mixed date formats (`DD/MM/YYYY` vs `MM/DD/YYYY`), mixed English/Urdu UTF-8 text, and preserve leading zeros on phone numbers (`0300...`), CNICs, and SKU codes (never parse identifiers as integers).
- **Batch ingestion:** Bulk uploads use batched `INSERT` / `COPY` and transactional staging tables rather than executing 10,000 individual row queries in a loop.

## 6. Financial, ledger, and calculation correctness (Critical priority)
- **Single canonical implementation:** Locate every place a business metric, invoice total, tax, commission, or incentive payout is computed. Computing the same metric with two different formulas across dashboard, export, and payout routes is a High/Critical defect.
- **Hand-verification of boundary cases:** Select at least three cases—normal, slab/tier boundary (inclusive `<=` vs exclusive `<`), and edge (zero, negative/return, credit note, cap/ceiling, proration)—and recompute by hand against the domain policy.
- **Rounding & precision discipline:** Explicit rounding mode (`HALF_UP` vs Banker's `HALF_EVEN`) applied at the defined policy stage (line-item vs invoice total), avoiding cumulative rounding drift; verify sum-of-parts equals the stated total.
- **Immutable ledger & policy versioning:** Historical periods store the applied policy version/rates or immutable ledger rows so changing next month's slab or tax rate does not retroactively alter last month's closed statements.

## 7. Analytical pipelines and reporting isolation
- Heavy analytical queries, full-period exports, and executive dashboards use pre-aggregated summary tables, materialized views, or read replicas rather than running expensive multi-join `GROUP BY` scans on hot OLTP tables on every page load.
- **Data lineage:** Every figure on a management dashboard or exported statement can be traced back to exact underlying source transactions.

## 8. Backup, PITR, and recovery verification
- Automated, encrypted backups and Point-in-Time Recovery (PITR / WAL archiving) configured with defined retention.
- Evidence of a tested restore runbook and stated Recovery Time Objective (RTO) and Recovery Point Objective (RPO); otherwise mark `Not verified`.
