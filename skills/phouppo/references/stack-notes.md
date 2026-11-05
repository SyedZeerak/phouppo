# Stack-Specific Notes

Load only the sections that match the detected stack. These are starting points for targeted searches, not complete checklists.

## Next.js (App Router or Pages) & React Server Components
- **Server Actions (`"use server"`) are public HTTP POST endpoints:** Every exported Server Action and route handler (`app/**/route.ts`, `pages/api/**`) must independently verify authentication, tenant/resource ownership, and input schema (`zod`). Middleware path checks alone are insufficient and have historically been bypassed via header or rewrite quirks.
- **Client bundle secret & PII leakage:** Variables prefixed `NEXT_PUBLIC_` are inlined into browser bundles. Also check Server Components passing entire ORM user/tenant objects as props into `"use client"` components (which serializes every field into the HTML/RSC payload sent to the browser).
- **Cross-user caching hazards:** Module-level variables, `unstable_cache`, `"use cache"`, or `fetch` caching without user/tenant cache keys returning User A's personalized data to User B.
- **Performance & CWV traps:** Sequential `await` waterfalls in Server Components without `Promise.all` or `<Suspense>` streaming; oversized client subtrees marked `"use client"` at the page root; `next/image` missing `sizes` or `priority` on hero images.
- `next.config` security headers, `images.remotePatterns` wildcard abuse (SSRF/DoS via image optimizer), and exposed production source maps.

## Supabase (Postgres, Auth, Storage, Edge Functions)
- **RLS completeness:** Row-Level Security enabled on every table in exposed schemas (`public`); policies never `USING (true)` on private tables; separate policies for `SELECT`, `INSERT`, `UPDATE`, `DELETE` with `WITH CHECK` on writes; RLS policies wrap `auth.uid()` in `(select auth.uid())` and index referenced policy columns for query performance.
- **Privilege escalation via metadata:** RLS policies or backend code trusting `auth.jwt() -> 'user_metadata'` (which any authenticated user can self-update via `supabase.auth.updateUser()`) instead of `app_metadata` or a protected roles table!
- **Key isolation:** `service_role` key and direct Postgres connection string never in client code or `NEXT_PUBLIC_` / `VITE_` variables.
- **Database bypasses:** Functions marked `SECURITY DEFINER` without `SET search_path = ''`; database views created without `WITH (security_invoker = true)` bypassing underlying table RLS.
- **Storage & Edge Functions:** Storage buckets private by default with path-scoped RLS policies; Edge Functions verifying the `Authorization` JWT rather than instantiating a global `service_role` client blindly.

## Firebase (Firestore, Auth, Storage, Cloud Functions)
- Firestore and Storage rules never open (`allow read, write: if true` or `if request.auth != null` without tenant/owner check); rules validate `request.auth.uid == resource.data.ownerId` and restrict writable fields on `request.resource.data` (preventing role/balance tampering).
- Cloud Functions (`onCall` / `onRequest`) verify `context.auth` and enforce App Check / rate limits; Admin SDK service account keys never committed or shipped to clients.

## Prisma / Drizzle / TypeORM (Node & TypeScript ORMs)
- **Unbounded queries & N+1:** `findMany()` without `take` limit; nested loops calling `findUnique` instead of `include` / `inArray` batching.
- **Missing interactive transactions:** Multi-step read-then-write workflows executed as separate `await prisma.x.update()` calls instead of `await prisma.$transaction(async (tx) => ...)` or atomic `increment`/`decrement` with `where` guards.
- **Over-fetching & mass assignment:** Passing unvalidated `req.body` directly into `data:` or returning models without `select:` / DTO serialization (leaking `passwordHash`, `twoFactorSecret`, or internal flags).
- **Raw query injection:** `$queryRawUnsafe`, `$executeRawUnsafe`, or `sql.raw()` constructed via string interpolation.

## FastAPI / Python (SQLAlchemy, Pydantic)
- **Router-level Complete Mediation:** `Depends(get_current_user)` and tenant/role dependencies attached to every router and endpoint; check that internal/admin routers are not mounted without auth.
- **Boundary parsing & response leakage:** Separate Pydantic `Create`/`Update` schemas (preventing mass assignment via `Model(**payload.dict())`) and explicit `response_model` schemas (preventing ORM relationship/secret leakage).
- **Event-loop starvation (Amdahl's Law):** Synchronous blocking calls (`requests.get`, synchronous SQLAlchemy IO, CPU-heavy `pandas`/PDF generation, `time.sleep`) inside `async def` handlers blocking the entire Uvicorn event loop for all concurrent users.
- SQLAlchemy connection pool sizing (`pool_size`, `max_overflow`, `pool_pre_ping=True`) and parameterized `text()` queries.
- `/docs`, `/redoc`, and `/openapi.json` disabled or auth-protected in production; CORS `allow_origins` explicit (never `["*"]` with `allow_credentials=True`).

## Django / Django REST Framework
- `DEBUG = False`, explicit `ALLOWED_HOSTS`, `SECRET_KEY` from env, `CSRF_COOKIE_SECURE`, `SESSION_COOKIE_SECURE`, `SECURE_HSTS_SECONDS`.
- **DRF authorization:** ViewSets define both `permission_classes` (including object-level `has_object_permission` called via `self.get_object()`) and tenant-scoped `get_queryset()`; ModelSerializers never use `fields = '__all__'` on models with role, tenant, or balance columns.
- **Query & transaction discipline:** `select_related` and `prefetch_related` used to prevent N+1 queries; `transaction.atomic()` and `select_for_update()` used on financial/inventory mutations; flag `.extra()`, `RawSQL`, and `mark_safe()`.

## Express / Fastify / Node.js
- Helmet security headers, rate limiting (`express-rate-limit` with Redis store), strict CORS allowlist, and explicit JSON/urlencoded body size limits (`limit: '100kb'`).
- **Middleware ordering:** Routes accidentally mounted *before* authentication or tenant-scoping middleware; async route errors in Express 4 not forwarded to `next(err)` without `express-async-errors` or wrapper.
- **Prototype pollution & NoSQL injection:** Mongoose/MongoDB queries accepting raw objects from `req.body`/`req.query` (`{ password: { $ne: null } }`); deep object merges without key sanitization.

## Laravel / PHP
- `APP_DEBUG=false`, strict `$fillable` (never `$guarded = []` paired with `$request->all()`), Policies/Gates enforced on every controller action, and route model binding scoped to parent/tenant (`->scopeBindings()`).
- Eager loading (`with()`) to prevent N+1 (`Model::preventLazyLoading()`); `DB::transaction()` with `lockForUpdate()` on balance/stock writes; flag `DB::raw()` interpolation and `{!! !!}` unescaped Blade rendering.

## Vite / SPA & Client State (TanStack Query, Zustand, Redux, PWA)
- **Client-side environment exposure:** Every `VITE_*` or `REACT_APP_*` variable is public in the compiled JS bundle.
- **Cross-user cache bleed on shared devices:** On logout, verify `queryClient.clear()`, Zustand/Redux stores, `localStorage`, `sessionStorage`, and IndexedDB are wiped so the next user on a shared computer/tablet cannot see cached screens.
- **Service Worker & offline sync:** PWAs must not cache authenticated API responses in shared Cache Storage without encryption/cleanup on logout; offline mutation queues require idempotency keys and conflict handling on reconnect.
