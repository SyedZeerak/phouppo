# Data Engineering Review

Contents: schema and integrity, migrations, data quality, calculations, pipelines and reporting, backup and recovery.

## Schema and integrity
- Primary keys, foreign keys, unique constraints, NOT NULL, and check constraints where the business rule demands them.
- Appropriate types: money as `DECIMAL`/`NUMERIC` or integer minor units, never float; dates as timestamps with timezone; enumerations constrained.
- Indexes on columns used in filters, joins, and sorts. No missing indexes on large tables.
- Deletion strategy: soft versus hard delete; cascades that could wipe related data unintentionally.
- Audit columns: `created_at`, `updated_at`, `created_by`, `updated_by`.

## Migrations and environments
- Schema changes are versioned migrations, reversible where practical, and tested. No manual schema edits in production.
- Seed and demo data are separated from production data.
- Non-production environments use masked or synthetic data.

## Data quality and ingestion
- Validation at the point of ingestion (forms, APIs, file imports).
- Duplicate detection and idempotent imports; re-running an import must not double-count.
- Handling of messy real inputs: Excel files with merged cells or inconsistent headers, mixed date formats, trailing spaces, mixed English and Urdu text, encoding problems, leading zeros in phone numbers or codes.
- Referential integrity between imported data and master data (distributors, SKUs, regions, customers).
- Reconciliation against the source system of record.

## Calculation correctness (high priority for financial and incentive logic)
- Locate every place a business metric or payout is computed. The same metric calculated differently in two places is a defect.
- Select at least three representative cases (normal, boundary, and edge such as zero, negative, or capped) and recompute by hand from the stated policy. Report any mismatch as Critical or High.
- Rounding rules (when, how, and at which stage), tiers and slabs boundary handling (inclusive or exclusive), proration, and period cut-offs.
- Policy rules are configurable or documented, not buried as magic numbers.
- Idempotency and versioning: can a past period be recomputed with the policy that applied then?

## Pipelines and reporting
- Scheduled jobs: monitoring, retries, failure alerts, and clear ownership.
- Dashboards querying the operational database directly can degrade it; consider replicas or summary tables.
- Data lineage: can a number on a report be traced back to source rows?

## Backup and recovery
- Backups exist, are automated, are encrypted, and retention is defined.
- A restore has actually been tested. Record the recovery time and recovery point objectives if stated, otherwise `Not verified`.
