# Testing Review

Contents: existing tests, coverage of critical paths, negative testing, regression safety, acceptance testing.

## Existing tests
- Do tests exist, and do they run? Do not execute them without user approval; inspect configuration and recent results instead.
- Quality: assertions that verify behavior versus tests that assert nothing, mock the unit under test, or snapshot everything.
- AI-generated tests that pass by construction (testing the implementation against itself).

## Critical-path coverage
- Priority paths: authentication, authorization boundaries, money or incentive calculations, approvals and state changes, imports, exports, and anything that notifies external parties.
- Calculation logic has table-driven tests with known inputs and outputs taken from the written policy or domain owner, including boundaries.

## Negative and edge testing
- Invalid input, empty data, very large data, special characters, Unicode and RTL text.
- Expired or tampered sessions and tokens; missing permissions; cross-tenant access attempts.
- Concurrency: simultaneous updates and double submissions.
- Third-party failure: timeout, error response, partial response.

## Regression safety
- Changing one feature should fail a test if it breaks another. Identify untested high-change areas.
- Test data and fixtures are realistic and not copied from production without masking.

## Acceptance and security testing
- User acceptance testing with real users on real (or realistic) data before go-live. Record who signed off.
- Recommend an OWASP Top 10 pass and role-bypass attempts as manual or tool-assisted tests, to be run only against non-production environments with permission.
