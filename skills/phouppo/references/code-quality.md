# Code Quality and Full-Stack Correctness

Contents: backend, frontend, general verification.

## Backend
- Error handling on every external call. No swallowed exceptions (`catch {}` returning empty results). Failures surface to logs and to the user in a useful way.
- Race conditions: double submission, simultaneous updates, read-modify-write without locking or atomic operations.
- Transactions around multi-step writes (create order and decrement stock; approve and notify).
- Date, time, timezone, locale, and currency handling. Store timestamps in UTC; check conversions at boundaries (day, month, financial period end).
- Hardcoded values, magic numbers, test data, and placeholder logic left in code.
- Mocked or stubbed functions that "work" but return fixed or fake data in production paths.
- Functions that silently ignore invalid input instead of rejecting it.

## Frontend
- Loading, empty, error, and offline states exist for each screen and fetch.
- Form validation with clear messages; double-click and double-submit protection.
- Accessibility: keyboard navigation, labels, focus order, contrast, ARIA where needed.
- Responsive behavior on real devices, especially low-end Android phones and weak connectivity.
- Bundle size, unnecessary re-renders, memory leaks from effects and listeners.
- Broken routes, dead links, missing 404 handling, SSR or hydration mismatches (Next.js, Nuxt).
- Language and script support where users work in more than one (English and Urdu: right-to-left layout, fonts, text encoding).

## Language and tooling hygiene
- TypeScript strictness; widespread `any`; ignored compiler or lint errors; `@ts-ignore` density.
- Lint and formatter configuration present and enforced.
- Consistent naming, file layout, and module boundaries.

## Verify claims
- Compare the feature list in the README, prompts, or summaries against the code. Confirm each important feature works end to end by tracing the real path from UI to storage and back.
- Identify features that exist in the UI but are not implemented in the backend.

## Maintainability
- Could a developer who never saw the original prompts maintain this? Look for unexplained complexity, duplicated logic, and files with thousands of lines.
