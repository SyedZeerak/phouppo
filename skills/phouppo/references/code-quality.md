# Code Quality, Correctness, and Web Speed Review

Contents: foundational programming laws, backend correctness and concurrency, frontend correctness and state machines, web performance and Core Web Vitals (RAIL/LCP/INP/CLS), resource lifecycle and memory leaks, tooling hygiene, feature verification.

## Foundational programming principles
- **Hoare Logic ($P \{C\} Q$) & Domain Invariants (Tony Hoare):** Functions should enforce clear preconditions, postconditions, and domain invariants (e.g., an account balance or stock quantity cannot silently go negative; a state transition from `PAID` to `DRAFT` is rejected).
- **Null Safety (Hoare's "Billion-Dollar Mistake"):** Guard nullable/optional values explicitly through strict type systems (`strictNullChecks`) rather than assuming nested properties exist (`user.org.settings.theme` crashing at runtime).
- **Parse, Don't Validate (Alexis King / LangSec):** Transform untrusted inputs into narrow domain types at the system edge rather than scattering ad-hoc string/boolean checks deep inside business functions.
- **Harel Statecharts & Making Impossible States Unrepresentable:** Represent UI and workflow states as explicit discriminated unions / finite state machines (`status: 'idle' | 'submitting' | 'success' | 'error'`) rather than independent booleans (`isLoading`, `isError`, `isSuccess`) that allow contradictory states.
- **Carmack's Pragmatic Simplicity & Knuth's Optimization Rule:** Prefer straight-line, inspectable control flow over speculative framework abstractions; eliminate obvious $O(N^2)$ algorithmic traps and N+1 loops immediately, and measure before adding complex caching layers.

## 1. Backend correctness and concurrency
- **No swallowed errors:** Every external call and async boundary handles failures explicitly. Flag empty `catch {}`, `catch (e) { console.log(e); return []; }`, or unhandled promise rejections that disguise outages as empty data.
- **Concurrency & race conditions:**
  - Double-submission and parallel-request races on state mutations, inventory decrements, coupon redemptions, or approvals.
  - Read-modify-write in application memory without optimistic locking (`version` column check), pessimistic locking (`SELECT ... FOR UPDATE`), or atomic database expressions (`SET count = count + 1`).
- **Transactional atomicity:** Multi-step writes (e.g., create order + deduct inventory + record ledger entry) wrapped in a single database transaction so partial failures roll back cleanly.
- **Temporal & monetary precision:**
  - Store all timestamps in UTC (`TIMESTAMPTZ` / ISO-8601 UTC); convert to local time (e.g., `Asia/Karachi`) only at presentation or explicit business-period boundaries (day/month close, DST transitions).
  - Never use IEEE 754 floating-point (`number` / `float` / `double`) for money, tax, or incentive calculations; use integer minor units (paisas/cents) or arbitrary-precision decimals (`Decimal`, `big.js`, `dinero.js`).
- **No phantom or stubbed production paths:** Identify mocked functions, hardcoded return values, `setTimeout` fake delays, or `TODO` branches still wired into production routes.

## 2. Frontend correctness and state machines
- **Complete boundary states:** Every data-driven view and component handles four states explicitly: `loading`, `empty` (with clear explanation and action), `error` (with retry/guidance), and `populated` (plus `offline`/`stale` where relevant).
- **Finite state discipline:** Flag "boolean soup" (`isLoading && !isError && data`) and unguarded mutation buttons that permit double-clicks / duplicate POST requests while a request is in flight.
- **SSR, hydration & routing integrity:**
  - Next.js / Nuxt hydration mismatches caused by rendering `Date.now()`, `Math.random()`, `window`, or `localStorage` during initial render.
  - Broken links, missing 404/error boundaries (`error.tsx`, `not-found.tsx`), or client-side transitions that lose scroll/filter state.
- **Accessibility mechanics (WCAG 2.2 / WAI-ARIA):**
  - Semantic HTML elements (`<button>`, `<nav>`, `<main>`, `<dialog>`) used instead of `<div onClick>` without keyboard handlers (`Enter`/`Space`) or `role`/`tabIndex`.
  - Every form input associated with a `<label>` or `aria-label`; focus trapped and restored properly in modals/drawers; live regions (`aria-live`) announcing async errors.

## 3. Web speed, RAIL model, and Core Web Vitals
Evaluate frontend and full-stack speed against Google's **RAIL Model** (Response $<50\text{ms}$, Animation $<16\text{ms/frame}$, Idle, Load) and **Core Web Vitals**:
- **LCP (Largest Contentful Paint — target $<2.5\text{s}$):**
  - Client-side fetch waterfalls (`useEffect(() => fetch(...))` inside nested components) delaying primary content render instead of parallel server/loader fetching.
  - Unoptimized hero images, missing `fetchpriority="high"` on LCP image, or lazy-loading (`loading="lazy"`) accidentally applied to above-the-fold hero elements.
  - Render-blocking third-party scripts or giant unsplit JavaScript bundles (`import _ from 'lodash'`, importing entire icon/chart libraries without tree-shaking).
- **INP (Interaction to Next Paint — target $<200\text{ms}$):**
  - Main-thread saturation from rendering thousands of DOM nodes without list virtualization (`@tanstack/react-virtual`, `content-visibility: auto`).
  - Unthrottled/undebounced `onChange`/`onScroll`/`onResize` handlers triggering expensive re-renders or network requests on every keystroke/pixel.
  - Missing memoization or unstable object/function references in hot render loops causing whole-page re-renders; layout thrashing (interleaving DOM geometry reads like `getBoundingClientRect()` with style writes).
- **CLS (Cumulative Layout Shift — target $<0.1$):**
  - Images, videos, iframes, or ad slots missing explicit `width` and `height` (or CSS `aspect-ratio`).
  - Async banners, toasts, or un-sized skeleton placeholders injected above existing content after initial paint; web fonts loading without `font-display: swap`/`optional` and metric-compatible fallbacks.

## 4. Resource lifecycle and memory leaks
- **Frontend leaks:** `useEffect` / component lifecycle hooks that register `window.addEventListener`, `setInterval`, `setTimeout`, `ResizeObserver`, or WebSocket/Supabase realtime subscriptions without returning a cleanup function, or async `fetch` calls lacking an `AbortController` on unmount/query change (causing stale-response race conditions).
- **Backend leaks:** Unbounded in-memory caches/arrays in module scope that grow forever across requests, unclosed file descriptors/streams, or database/Redis clients instantiated per request instead of shared at module/app scope.

## 5. Language and tooling hygiene
- TypeScript strictness (`"strict": true`); flag pervasive `: any`, `as unknown as`, `@ts-ignore` / `@ts-expect-error`, and disabled ESLint/Biome rules (`eslint-disable`).
- Linter, formatter, and type-check scripts configured and runnable in CI.

## 6. End-to-end feature verification
- Compare the feature list in README, prompts, or UI navigation against actual code. Trace each critical workflow from UI handler $\rightarrow$ API route $\rightarrow$ validation $\rightarrow$ database write $\rightarrow$ response to catch "Potemkin village" UI screens that look finished but do nothing or only mutate local React state.
