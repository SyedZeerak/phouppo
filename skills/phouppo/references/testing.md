# Testing, Verification, and Invariant Review

Contents: foundational testing laws, existing test audit and AI tautology detection, critical-path and calculation coverage, boundary value and property testing, negative and adversarial testing, regression determinism.

## Foundational testing principles
- **Dijkstra's Maxim (1970):** *"Program testing can be a very effective way to show the presence of bugs, but is hopelessly inadequate for showing their absence."* High line coverage means nothing if assertions do not verify domain invariants and authorization boundaries.
- **Kent Beck's Test Desiderata:** Tests should be *behavior-sensitive* (fail when business behavior breaks), *structure-insensitive* (not break on internal refactors), *deterministic* (zero flakiness from wall-clock time or network), and *predictive* (passing tests mean production is safe).
- **Boundary Value Analysis (BVA) & Equivalence Partitioning:** Bugs cluster at slab edges ($0$, $-1$, $\text{threshold}-1$, $\text{threshold}$, $\text{threshold}+1$, `MAX_SAFE_INTEGER`, empty collections, leap years/month-ends).
- **Property-Based & Metamorphic Testing (Claessen & Hughes — QuickCheck):** Verify algebraic invariants across generated inputs (e.g., sum of allocated line items always equals invoice total; `decode(encode(x)) === x`; applying an idempotent import twice yields the exact same state as once).

## 1. Existing tests and AI tautology detection
- Do tests exist, and are they wired into CI? Do not execute them without user approval; inspect test files, mocks, and CI logs statically first.
- **Flag AI-generated tautological tests:**
  - Tests that mock the exact service or calculation function under test and then assert `expect(mockFn).toHaveBeenCalled()` or `expect(result).toEqual(mockedReturnValue)`.
  - Assertions that only check `expect(res).toBeDefined()` or `expect(200).toBe(200)` without verifying database state transitions or exact output values.
  - Snapshot tests committed blindly over broken or placeholder output.

## 2. Critical-path and financial calculation coverage
- **Priority paths:** Authentication, role/tenant authorization boundaries (IDOR/BOLA attempts), money/tax/incentive calculations, state-machine transitions (approvals, cancellations, refunds), bulk file imports, and external side-effect triggers.
- **Golden-case calculation matrices:** Core pricing, commission, tax, or incentive formulas must have table-driven tests (`test.each` / `@pytest.mark.parametrize`) using golden inputs and hand-verified expected outputs signed off by the domain owner—covering normal slabs, exact boundary thresholds, zero/negative/return cases, caps, and rounding modes.

## 3. Negative, boundary, and adversarial testing
- **Authorization matrix tests:** Automated tests proving User A (Tenant 1) receives `403`/`404` when requesting or mutating User B's (Tenant 2) resource ID, and standard roles cannot invoke admin endpoints.
- **Malformed & hostile inputs:** Empty payloads, missing required fields, negative quantities, SQL/XSS/prototype-pollution payloads, oversized strings, Unicode/Urdu RTL strings, and CSV files with missing headers or leading-zero codes.
- **Concurrency & idempotency:** Tests or verification scripts simulating duplicate webhook delivery, double form submission, or parallel balance deductions (TOCTOU).
- **Downstream fault injection:** Behavior when a third-party API returns `429`, `500`, malformed JSON, or times out.

## 4. Determinism, isolation, and regression safety
- **Flakiness sources:** Flag tests that depend on live wall-clock time (`new Date()` without frozen clock), `setTimeout` sleeps, shared mutable state across test files, unseeded random values, or live external network calls.
- **Data hygiene:** Test fixtures use synthetic data—never unmasked production PII or real API keys.

## 5. Acceptance and pre-launch verification
- User Acceptance Testing (UAT) completed with real operational users on realistic datasets (including mobile/field devices if applicable), with recorded sign-off.
- Recommend an OWASP Top 10 and role-bypass verification pass (via `--mode dynamic` on a local/staging sandbox with explicit user consent).
