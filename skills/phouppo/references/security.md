# Security Review

Contents: foundational security laws, secrets and cryptography, authentication, authorization and complete mediation, LangSec input recognition and injection, file uploads, transport and browser defenses, supply chain, data protection, infrastructure exposure, audit and detection.

Report only what you can evidence. Authorization failures and check-then-act race conditions are the most common serious defects in AI-generated apps, so spend the most effort there.

## Foundational security axioms
Use these axioms to guide code inspection and explain *why* a pattern is dangerous:
- **Saltzer & Schroeder's 8 Design Principles (1975):** *Economy of Mechanism* (keep security logic small and auditable), *Fail-Safe Defaults* (deny by default unless explicitly permitted), *Complete Mediation* (check every access to every object on the server, never rely on UI state or cached permission assumptions), *Open Design* (never rely on obscurity of routes or IDs), *Separation of Privilege*, *Least Privilege*, *Least Common Mechanism* (isolate tenant state), and *Psychological Acceptability* (security flows must match user mental models).
- **Kerckhoffs's Principle & Shannon's Maxim:** The system must remain secure even if all source code, schemas, and route structures are public; security rests solely on protected, rotatable keys.
- **The Cryptographic Doom Principle (Moxie Marlinspike):** Never perform any cryptographic operation or parsing on untrusted ciphertext before authenticating it (use AEAD such as `AES-GCM` or `ChaCha20-Poly1305`).
- **LangSec (Language-Theoretic Security):** Treat untrusted input as a formal grammar. Parse and validate inputs into strict typed domain structures at the boundary *before* any downstream processing ("Parse, don't validate"); prevent parser differentials between middleware and handlers.

## 1. Secrets, cryptography, and configuration
- API keys, DB credentials, webhook signing secrets, and JWT secrets hardcoded in source, committed to git history, or exposed in frontend bundles (`NEXT_PUBLIC_*`, `VITE_*`, `REACT_APP_*`, `PUBLIC_*`).
- `.env` files tracked; `.gitignore` gaps; secrets echoed in logs, error payloads, or CI output.
- Service-role or admin keys (for example Supabase `service_role`, Firebase Admin SDK private key, Stripe `sk_live_`) imported or reachable from client code.
- **Cryptographic hygiene:**
  - Non-cryptographic PRNGs (`Math.random()`, `random.random()`) used for OTPs, reset tokens, session IDs, nonces, or salts instead of CSPRNG (`crypto.randomBytes`, `crypto.getRandomValues`, `secrets.token_urlsafe`).
  - Unauthenticated encryption (`AES-CBC`, `AES-ECB`) without encrypt-then-MAC, hardcoded IVs/nonces, or custom "home-rolled" obfuscation.
  - Webhook signatures (Stripe, GitHub, Twilio, Slack) not verified against the raw request body, or compared using standard `===`/`==` instead of constant-time comparison (`crypto.timingSafeEqual`, `hmac.compare_digest`).
- Rotation path: separate secrets per environment (dev, staging, prod) and ability to rotate without code changes.

## 2. Authentication and session mechanics
- Password hashing uses `Argon2id`, `bcrypt` (cost $\ge 10$), or `scrypt`. Flag `MD5`, `SHA1`, unsalted `SHA256`, or plaintext.
- Sessions and tokens:
  - Explicit expiration (`exp`), audience (`aud`), and issuer (`iss`) verified on JWTs; algorithm pinned on verification (no `alg: none`, no RS256/HS256 public-key confusion, no unverified `jwt.decode()` used as `jwt.verify()`).
  - Storage in `HttpOnly`, `Secure`, `SameSite` cookies preferred over `localStorage`/`sessionStorage` (which any XSS payload can exfiltrate).
  - **Session fixation & revocation:** Session ID rotated upon login and privilege elevation; server-side revocation or token versioning enforced on logout and password change.
- **OAuth / OIDC & SSO flows:**
  - Missing `state` parameter verification (CSRF on login/account linking) or missing PKCE (`code_verifier`) on public clients.
  - Open redirect in `redirect_uri` / `callbackUrl` / `next` parameter allowing token theft.
  - Automatic account linking by unverified email address across OAuth providers (pre-account takeover).
- Rate limiting and progressive lockout on login, signup, password reset, MFA, and OTP verification.
- Password reset: cryptographically random single-use token, short TTL ($\le 1\text{ hr}$), invalidated after use, no user enumeration via status codes, response strings, or timing discrepancies.
- Default, seed, backdoor, or bypass accounts (`if (email === 'admin@test.com')`) left in production code paths.

## 3. Authorization and Complete Mediation
- **Complete Mediation:** Every route handler, Server Action, GraphQL resolver, RPC endpoint, and WebSocket event enforces authentication and authorization server-side. Middleware path-matching alone is brittle and often bypassed by rewrites, trailing slashes, or direct action calls.
- **IDOR / BOLA (Broken Object Level Authorization):** Can user A read, update, or delete user B's resource by changing an ID in params, query, or body? Verify queries filter by authenticated owner or tenant (`WHERE id = $1 AND org_id = $2`), not by primary key alone.
- **BFLA (Broken Function Level Authorization):** Admin, approval, export, or impersonation endpoints accessible to standard authenticated users due to missing role/permission checks.
- **BOPLA (Broken Object Property Level Authorization):**
  - *Mass assignment:* Request body spread directly into ORM `create`/`update` (`prisma.user.update({ data: req.body })`, `Model(**data)`), allowing a user to overwrite `role`, `is_admin`, `organization_id`, `balance`, `status`, or `verified`.
  - *Excessive data exposure:* API returning full database rows (password hashes, internal notes, tokens, other users' PII) and relying on the frontend to hide fields.
- **TOCTOU (Time-of-Check to Time-of-Use) race conditions:**
  - Authorization, quota, coupon redemption, or balance check performed in a `SELECT` query followed by a separate `INSERT`/`UPDATE` without a transaction + row lock (`SELECT ... FOR UPDATE`) or atomic conditional update (`UPDATE ... WHERE balance >= $amount`).
- **Row-Level Security (RLS):** Enabled on every table holding user or tenant data; policies are not `USING (true)`; `WITH CHECK` present on `INSERT` and `UPDATE`; database views and `SECURITY DEFINER` functions do not inadvertently bypass RLS.

## 4. LangSec input recognition and injection
- **Boundary parsing ("Parse, don't validate"):** Every external input (body, query, params, headers, webhooks) parsed at the entry boundary through a strict schema (`zod`, `pydantic`, `valibot`, `joi`) that strips or rejects unknown fields.
- **SQL & NoSQL injection:** String concatenation or template literals in SQL (`query(\`SELECT ... \${input}\`)`), `prisma.$queryRawUnsafe`, `sequelize.literal`, Django `.extra()` / `RawSQL`, or NoSQL operator injection (`$ne`, `$gt`, `$where` passed from unparsed JSON).
- **Cross-Site Scripting (XSS):** `dangerouslySetInnerHTML`, `v-html`, `{!! !!}`, `innerHTML`, `outerHTML`, unsanitized Markdown/HTML renderers, or user-controlled URLs in `href`/`src` without protocol allowlisting (`http:`/`https:`, blocking `javascript:` and `data:`).
- **Command & code execution:** `eval`, `new Function`, `child_process.exec`, `os.system`, `subprocess.Popen(..., shell=True)`, Server-Side Template Injection (SSTI), or unsafe deserialization (`pickle`, `yaml.load` without `SafeLoader`, `unserialize`).
- **SSRF (Server-Side Request Forgery):** Any endpoint that fetches a user-supplied URL (webhooks, avatar URL import, PDF generator, link preview) without blocking private/loopback IP ranges (`127.0.0.0/8`, `10.0.0.0/8`, `172.16.0.0/12`, `192.168.0.0/16`, cloud metadata `169.254.169.254`) and DNS rebinding.
- **Prototype pollution & ReDoS:** Recursive object merges (`_.merge`, custom deep-assign) without guarding `__proto__`/`constructor`/`prototype`; catastrophic backtracking regular expressions applied to untrusted strings.

## 5. File uploads and storage isolation
- Validate content type and magic bytes, not only the file extension or client-supplied `Content-Type` header. Enforce strict byte-size limits before buffering into memory.
- Store outside the web root or in private object storage buckets; serve downloads via short-lived signed URLs scoped to the authorized user.
- Sanitize and randomize stored keys/filenames; prevent path traversal (`../`) and zip-slip archive extraction vulnerabilities.
- **SVG & active content:** Block or sanitize uploaded `.svg`, `.html`, and `.xml` files, or serve them with `Content-Disposition: attachment` and `Content-Security-Policy: sandbox` so embedded scripts cannot execute on the app's origin.

## 6. Transport, browser defenses, and headers
- HTTPS enforced everywhere; `Strict-Transport-Security` (HSTS) configured with long `max-age`.
- **CORS:** Never reflect arbitrary `Origin` headers with `Access-Control-Allow-Credentials: true`, and never use wildcard `*` on authenticated routes; maintain an explicit origin allowlist.
- **CSRF:** State-changing cookie-authenticated requests protected via CSRF tokens, `SameSite=Lax`/`Strict`, and `Origin`/`Sec-Fetch-Site` header verification.Ensure `GET` routes never mutate state.
- **Security headers:** `Content-Security-Policy` (avoiding `unsafe-inline`/`unsafe-eval` where practical), `X-Content-Type-Options: nosniff`, `X-Frame-Options: DENY` or `frame-ancestors 'none'`, `Referrer-Policy: strict-origin-when-cross-origin`, and `Permissions-Policy`.

## 7. Dependencies and supply chain (Thompson's Trust / SLSA)
- Lockfile (`package-lock.json`, `pnpm-lock.yaml`, `yarn.lock`, `poetry.lock`, `uv.lock`) committed and enforced in CI (`npm ci`, `--frozen-lockfile`).
- Audit output (`npm audit`, `pip-audit`, `osv-scanner`) clean or triaged.
- **Slopsquatting & typosquatting:** Confirm unfamiliar package names actually exist in the official registry and are the intended library—AI coding assistants occasionally hallucinate package names that attackers register.
- Inspect `postinstall` scripts and unpinned third-party GitHub Actions or CDN `<script>` tags lacking Subresource Integrity (`integrity="sha384-..."`).

## 8. Data protection and privacy
- Identify personal, financial, and regulated data (names, phone numbers, CNIC/SSN/national IDs, addresses, bank accounts, health or employee records).
- Encryption in transit (TLS 1.2+) and at rest; application-level envelope encryption for high-sensitivity secrets (OAuth tokens, tax IDs, payout keys) stored in DB columns.
- Ensure PII and tokens never leak into URL query parameters (logged by proxies/browsers), client analytics, Sentry breadcrumbs, or application logs.
- Retention, deletion, and tenant-scoped export controls; production data never copied to staging/dev without deterministic masking.

## 9. Infrastructure exposure
- Debug mode disabled in production (`DEBUG=False`, `NODE_ENV=production`); raw stack traces, Prisma/SQL error codes, and file paths masked before returning to clients.
- Exposed `/docs`, Swagger/OpenAPI UI, GraphQL introspection/playground, `/metrics`, admin panels, `/.git`, `/.env`, or production client source maps (`.map`) containing proprietary logic or keys.
- Publicly reachable database ports, Redis instances without auth, or storage buckets with public-list/public-read permissions.

## 10. Audit trail and anomaly detection
- Immutable audit log for security-critical and financial actions: login, failed auth, role/permission change, record deletion, bulk export, payout approval, and policy change. Entries record actor ID, tenant ID, action, target ID, before/after state (redacted of secrets), timestamp (UTC), and source IP/user-agent.
- Defined incident response and key-rotation runbook.
