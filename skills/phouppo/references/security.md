# Security Review

Contents: secrets and configuration, authentication, authorization, input and injection, file uploads, transport and headers, dependencies, data protection, infrastructure exposure, audit and detection.

Report only what you can evidence. Authorization failures are the most common serious defect in AI-generated apps, so spend the most effort there.

## 1. Secrets and configuration
- API keys, DB credentials, JWT secrets hardcoded in source, committed to git history, or exposed in frontend bundles (`NEXT_PUBLIC_*`, `VITE_*`, `REACT_APP_*`).
- `.env` files tracked; `.gitignore` gaps; secrets in logs, error messages, or CI output.
- Separate secrets per environment (dev, staging, production).
- Service-role or admin keys (for example Supabase `service_role`) used in client code.
- Rotation path: can each key be rotated without redeploying everything?

## 2. Authentication
- Password hashing uses bcrypt, scrypt, or argon2. Flag MD5, SHA1, SHA256 without salt and work factor, or plaintext.
- Sessions and tokens: expiry, refresh, revocation on logout and password change, storage (HttpOnly cookie preferred over localStorage), algorithm pinned for JWT (no `alg: none`, no HS/RS confusion).
- Rate limiting and lockout on login, signup, password reset, OTP verification.
- Password reset: token expiry, single use, no user enumeration through differing responses.
- MFA available for admin accounts.
- Default, seed, or test accounts present in production code paths.
- Custom-built auth where a managed provider or framework feature would be safer.

## 3. Authorization
- Every endpoint enforces authentication and authorization server-side. UI hiding is not a control.
- IDOR / BOLA: can user A read, update, or delete user B's resource by changing an ID? Check that queries filter by owner or tenant, not only by ID.
- Role checks (admin, manager, viewer) enforced in backend handlers or middleware.
- Row-Level Security: enabled on every table that holds user data; policies are not `USING (true)`; `WITH CHECK` present on inserts and updates.
- Mass assignment: can a client set `role`, `is_admin`, `owner_id`, `price`, or `status` through a body that is spread directly into a model or query?
- Admin routes and internal APIs unprotected or protected only by obscurity.
- Horizontal scope for multi-tenant or multi-region apps (for example region manager sees only their region): verify on the server.

## 4. Input handling and injection
- SQL built by string concatenation or template literals; raw queries without parameters.
- NoSQL operator injection (`$ne`, `$gt` passed from request bodies).
- XSS: `dangerouslySetInnerHTML`, `innerHTML`, unsanitized Markdown or rich text, user content in `href` (`javascript:`).
- CSRF protection where cookie-based sessions are used.
- Command injection (`exec`, `spawn`, `os.system`, `subprocess(shell=True)`), path traversal, SSRF in any feature that fetches a user-supplied URL, open redirects.
- Server-side validation of type, length, range, and format on every input. Client-side validation alone does not count.
- `eval`, `new Function`, unsafe deserialization (`pickle`, `yaml.load`).

## 5. File uploads
- Validate content type and magic bytes, not only the extension. Enforce size limits.
- Store outside the web root or in private buckets; serve through signed URLs.
- Sanitize filenames; prevent overwrite and path traversal; block executable types.
- Public bucket URLs exposing private documents.

## 6. Transport and headers
- HTTPS enforced; HSTS set.
- CORS not `*` together with credentials; origin allowlist is explicit.
- Security headers: Content-Security-Policy, X-Content-Type-Options, X-Frame-Options or `frame-ancestors`, Referrer-Policy.
- Cookie flags: `Secure`, `HttpOnly`, `SameSite`.

## 7. Dependencies and supply chain
- Lockfile committed; versions pinned or bounded.
- Audit output (`npm audit`, `pip-audit`, `osv-scanner`) if available; otherwise recommend running it.
- Unfamiliar package names: confirm they exist and are the intended library (typosquatting, hallucinated packages).
- Abandoned or unmaintained libraries; unnecessary packages that enlarge the attack surface.
- Install scripts and postinstall hooks in unfamiliar dependencies.

## 8. Data protection
- Identify personal and sensitive data (names, phone numbers, CNIC or national ID, addresses, financial data, employee data).
- Encryption in transit and at rest; field-level encryption where warranted.
- Sensitive data in logs, URLs, analytics, or error trackers.
- Retention and deletion capability; export controls.
- Backups encrypted and access controlled. Production data copied into non-production environments without masking.
- Applicable regulation and internal policy (confirm with the organization's legal or information security owner; do not assert legal conclusions).

## 9. Infrastructure exposure
- Debug mode on in production; stack traces returned to users.
- Exposed `/docs`, Swagger UI, GraphQL introspection, admin panels, `/.git`, `/.env`, source maps containing secrets.
- Public database ports, public storage buckets, permissive security groups.
- Default credentials on databases, Redis, admin tools.

## 10. Audit and detection
- Audit log for sensitive actions: login, role change, delete, export, approval, configuration change. Entries record who, what, when, and from where.
- Alerting on anomalies; a defined incident process and key-rotation procedure.
