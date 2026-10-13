# Stack-Specific Notes

Load only the sections that match the detected stack. These are starting points for targeted searches, not complete checklists.

## Next.js (App Router or Pages)
- Server actions and route handlers (`app/**/route.ts`, `pages/api/**`) each need their own auth and authorization check. Middleware alone is not sufficient.
- Variables prefixed `NEXT_PUBLIC_` are shipped to the browser. Check none are secrets.
- Server components passing full database rows to client components can leak fields.
- `dangerouslySetInnerHTML`, `unstable_cache` or `fetch` caching returning one user's data to another, missing `revalidate` assumptions.
- `next.config` headers, `images.remotePatterns`, and exposed source maps.

## Supabase (Postgres, Auth, Storage)
- RLS enabled on every table in exposed schemas; policies not `USING (true)`; separate policies for select, insert, update, delete; `WITH CHECK` present.
- `service_role` key never in client code or `NEXT_PUBLIC_` variables.
- Storage buckets private by default; policies scoped to the owner path.
- Database functions marked `SECURITY DEFINER` without a safe `search_path`.
- Views bypassing RLS (use `security_invoker` where appropriate).
- Auth settings: email confirmation, redirect URL allowlist, password policy.

## Firebase
- Firestore and Storage rules not open (`allow read, write: if true`); rules check `request.auth.uid` against the document owner.
- Admin SDK credentials not in client code.

## FastAPI
- Dependencies (`Depends`) enforce auth on every router, including admin and internal routers.
- Pydantic models used for request validation; response models prevent field leakage; no `**request_body` passed into ORM models.
- CORS middleware origins explicit; `/docs` and `/openapi.json` restricted in production.
- Synchronous or blocking work inside `async` handlers; background tasks used for long jobs.
- SQLAlchemy sessions closed correctly; raw `text()` queries parameterized.

## Django
- `DEBUG=False`, `ALLOWED_HOSTS`, `SECRET_KEY` from environment, `SECURE_*` and cookie settings.
- Views and DRF viewsets have `permission_classes` and queryset scoping by user; serializers do not expose `fields = '__all__'` carelessly.
- Raw SQL and `extra()` usage; `mark_safe` usage.

## Express / Node
- Helmet, rate limiting, CORS configuration, body size limits.
- Auth middleware order; routes registered before the auth middleware.
- Mongoose or Sequelize queries built from `req.body` directly; prototype pollution through object merges.
- Unhandled promise rejections and missing global error handler.

## Laravel
- `APP_DEBUG=false`, mass assignment (`$fillable` versus `$guarded = []`), policies and gates on controllers, route model binding scoped to the owner.
- Raw queries, `{!! !!}` unescaped Blade output, storage disk visibility.

## Progressive Web Apps and offline sync
- Service worker caching of authenticated responses; data persisted in IndexedDB or localStorage without encryption on shared devices.
- Conflict resolution and idempotent replay for offline writes; token expiry handling while offline.
