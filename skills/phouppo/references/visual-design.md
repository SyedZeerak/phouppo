# Visual Design, HCI, Human Psychology, and User Behavior Review

Contents: how to review, foundational HCI and cognitive laws, design system and tokens, typography and psychophysics, color and contrast, spatial layout and motor ergonomics (Fitts/Gestalt), cognitive load and decision architecture (Hick/Miller/Sweller/Tesler), interaction models and error proofing (Norman/Poka-Yoke/Doherty), temporal psychology and behavioral patterns (Kahneman/Peak-End/Zeigarnik/Jakob), data visualization (Tufte), imagery, motion, language and RTL, brand and ethical UX, print and export, AI-generated UI tells.

Accessibility mechanics (DOM semantics, ARIA, keyboard traps) live in `code-quality.md`. This module evaluates visual craft, Human-Computer Interaction (HCI), human perception, cognitive load, and behavioral ergonomics.

## How to review
- **Static first.** Inspect stylesheets, Tailwind/CSS config, theme tokens, component libraries, forms, navigation, assets, and templates. Do not start the app without user approval.
- **With screenshots.** If the user supplies screenshots or approves running the app, check the rendered result at three widths (about 360, 768, 1280 px) and in each supported theme. State which screens were reviewed.
- **Without either.** Mark rendered-only checks as `Not verified` and list which screens need a human look.
- Findings cite the file and line of the offending style or component, or the screenshot name.

## Foundational HCI, psychology & design laws
Anchor visual and UX findings in established scientific principles when evidencing defects:
- **Fitts's Law & Accot-Zhai Steering Law (Motor Ergonomics):** Target acquisition time scales with $\log_2(2D/W)$. Frequently used actions must be large and close to the user's focus/thumb zone; destructive actions must have spatial separation; hover menus must not require narrow "tunnel steering".
- **Hick-Hyman Law (Decision Latency):** Decision time increases logarithmically with the number and complexity of choices ($RT = a + b \log_2(n+1)$). Avoid choice overload in navigation, toolbars, and action menus.
- **Sweller's Cognitive Load Theory & Miller's Law ($7 \pm 2$ / Chunking):** Working memory is strictly limited. Minimize *extraneous cognitive load* (visual noise, redundant borders, inconsistent layouts) and group information into scannable chunks of 3–5 items.
- **Tesler's Law (Conservation of Complexity):** Every workflow has irreducible complexity. Engineer the system to absorb that complexity (smart defaults, auto-formatting, inline lookup) rather than shifting it onto the user.
- **Don Norman's Interaction Model (*The Design of Everyday Things*):** Bridge the *Gulf of Execution* (clear **Affordances** and **Signifiers** showing what is interactive and how) and the *Gulf of Evaluation* (immediate, unambiguous **Feedback** and system status).
- **Gestalt Principles of Visual Perception (Wertheimer, Koffka):** *Proximity* (related items closer together than unrelated ones), *Similarity*, *Common Region* (cards/containers), *Figure-Ground*, and *Continuity*.
- **Von Restorff (Isolation) Effect:** When multiple stimuli are present, the visually distinct one is remembered and acted upon. Each screen should have *one* unmistakable primary CTA; if everything is emphasized, nothing is.
- **Weber-Fechner Law (Just Noticeable Difference / JND):** Perceptual differences are proportional to stimulus magnitude. Typographic scale steps, spacing increments, and state changes must exceed the JND to look intentional rather than like an alignment bug.
- **Doherty Threshold ($<400\text{ms}$):** Human-computer flow requires system response under 400ms (and visual acknowledgment of input within 100ms). Operations exceeding 400ms require optimistic updates, skeleton screens, or determinate progress indicators.
- **Poka-Yoke (Shigeo Shingo — Mistake-Proofing):** Design interfaces so human slips and mistakes are prevented before submission (constrained inputs, confirmation on irreversible actions, forgiving parsers, easy undo).
- **Jakob's Law (Jakob Nielsen):** Users spend most of their time in other apps. Follow standard platform conventions for navigation, search, Escape/Back behavior, and URL state.
- **Kahneman's System 1 / System 2, Peak-End Rule & Zeigarnik Effect:** Design routine scans for fast, intuitive System 1 perception; engage deliberate System 2 friction only on high-risk confirmations. Polish workflow completion states (Peak-End) and preserve progress across multi-step tasks (Zeigarnik).
- **Edward Tufte's Quantitative Display Principles:** Maximize the *data-ink ratio*, eliminate *chartjunk*, and maintain a *Lie Factor* of 1.0.

## 1. Design system and token consistency
- A single source of truth for color, type scale, spacing, radius, elevation/shadow, and z-index (CSS custom properties, theme file, Tailwind config). Flag arbitrary magic values scattered across files (`#3b82f6`, `text-[13px]`, `p-[17px]`, `z-[9999]`).
- Component unity: the same element (button, input, select, card, modal, badge, table) looks and behaves identically across screens. Count competing implementations of the same widget.
- Mixed UI kits or icon packs in one app (for example mixing Material, Lucide, Heroicons, and raw emoji).

## 2. Typography and psychophysical hierarchy (Weber-Fechner Law)
- Deliberate, modular type scale (typically 5–7 distinct sizes) and at most two font families (plus monospace for codes/IDs). Ensure adjacent heading levels exceed the Just Noticeable Difference.
- Readable body copy: $\ge 16\text{px}$ (`1rem`) on mobile (which also prevents iOS Safari auto-zoom on `<input>` focus), comfortable line height (`1.5`–`1.6` for body, `1.15`–`1.3` for headings), and constrained measure (`60ch`–`75ch` for prose; no full-width 1920px text lines).
- **Numeric discipline:** Financial tables, quantities, timestamps, and KPI counters use `font-variant-numeric: tabular-nums` (`tabular-nums`) so digits align vertically without jitter; consistent decimal precision and currency/unit formatting (e.g., `PKR` / `Rs.` with thousands separators).
- Font loading: `font-display: swap` or `optional`, metric-compatible fallbacks, and self-hosted or reliable font delivery that will not fail on restricted corporate networks.

## 3. Color, contrast, and perceptual semantics
- Contrast meets **WCAG 2.2 AA** minimum ($\ge 4.5:1$ normal text, $\ge 3:1$ large text and interactive UI boundaries/icons; $\ge 7:1$ AAA preferred for field/sunlight use). Compute directly from hex/HSL/OKLCH token values.
- **Redundant encoding (Colorblind safety):** Never rely on color alone to convey status, trend, or validation error—pair color with an icon, badge text, or pattern so deuteranopia/protanopia users can distinguish states.
- Semantic discipline: `success`, `warning`, `danger`/`error`, and `info` colors used strictly for their semantic meaning, never as decorative accent colors on neutral cards.
- **Dark mode & theme parity:** If dark mode exists, verify semantic surface tokens (elevation via subtle luminance steps rather than heavy black shadows), border visibility, chart legibility, and absence of hardcoded `bg-white` / `text-black` overrides that break in dark theme.

## 4. Spatial layout, Gestalt grouping, and Fitts's Law ergonomics
- **Gestalt Proximity:** Form labels and helper/error messages sit closer to their own input than to the preceding or following field; related controls are grouped in clear common regions with consistent spacing tokens (`4px`/`8px` grid).
- **Von Restorff & visual hierarchy:** One clear primary action per screen or modal. Secondary and tertiary actions are visually subordinate (outline/ghost) so the eye lands immediately on the primary path.
- **Fitts's Law & thumb-zone ergonomics:**
  - Touch targets are at least $44\times 44\text{ CSS px}$ ($48\times 48\text{ dp}$) on mobile/tablet with $\ge 8\text{px}$ separation between adjacent targets.
  - Destructive actions (`Delete`, `Reject`, `Revoke`) are spatially separated and visually distinct from primary positive actions (`Save`, `Approve`).
- **Overflow and boundary resilience:** Long user names, organization titles, SKUs, and localized strings wrap or truncate gracefully (`truncate`, `line-clamp`, `min-w-0` inside flex/grid children) without pushing action buttons off-screen or overlapping fixed headers/bottom nav bars.

## 5. Cognitive load, Hick's Law, and Tesler's Law
- **Hick's Law (Choice restraint):** Top-level navigation, table row actions, and modal options are capped at scannable counts (typically $\le 5\text{–}7$ visible items), placing secondary actions inside an overflow menu (`...`) or progressive disclosure drawer.
- **Miller's Law (Chunking):** Long forms and onboarding flows are broken into logical fieldsets or steps; long identifiers (phone numbers, CNIC `35202-1234567-1`, IBANs, credit cards, OTPs) are visually chunked rather than displayed as unbroken digit strings.
- **Tesler's Law (Absorbing complexity):**
  - Does the UI force the user to type exact punctuation, calculate totals manually, or remember internal codes? The app should accept flexible input (spaces, dashes, leading `+92` or `03`), normalize on the backend, auto-fill known context, and provide searchable comboboxes instead of raw ID fields.

## 6. Interaction models, Poka-Yoke error-proofing, and Doherty Threshold
- **Norman's Affordances & Signifiers:** Interactive elements have clear visual signifiers (hover, focus-visible ring, active press state, cursor pointer); static badges and cards do not look like buttons.
- **Doherty Threshold ($<400\text{ms}$) & Gulf of Evaluation:**
  - Every click, tap, or submit gives immediate visual feedback ($<100\text{ms}$ active/disabled/spinner state).
  - Data fetches $>400\text{ms}$ render geometry-matched skeleton screens or progress indicators rather than blank white screens or layout-shifting spinners.
  - Every data view implements all four boundary states: **Loading**, **Empty** (explaining *why* it is empty + CTA to create/clear filters), **Error** (human-readable reason + retry action), and **Success**.
- **Poka-Yoke (Mistake-proofing forms & workflows):**
  - Constrain invalid inputs upfront (`min`/`max` dates, numeric `inputMode="decimal"`, disabling unavailable options with a tooltip explaining why).
  - Preserve all user-entered form data on validation or network error—never wipe a form on failed submit.
  - Double-submit lock (`disabled={isSubmitting}`) on every mutation trigger.
  - High-consequence or irreversible actions (bulk delete, payout disbursement, period close, role revocation) require explicit confirmation stating the exact impact (or provide an immediate Undo toast).

## 7. User behavior, Jakob's Law, Peak-End Rule, and ethical UX
- **Jakob's Law & URL state:** Filters, search queries, pagination page, sort order, and active tabs are reflected in URL query parameters (`?status=pending&page=2`) so browser Back/Forward, refresh, and shared links work as users expect. Modals close on `Escape` and backdrop click (unless dirty-form guard applies).
- **Zeigarnik Effect & interruption resilience:** Multi-step wizards or long field-entry forms show clear step progress (`Step 2 of 4`) and persist draft state (or warn via `beforeunload` on unsaved changes) so interrupted field workers do not lose 10 minutes of work.
- **Peak-End Rule:** Workflow completion states (order submitted, payout approved, import finished) provide a reassuring summary, reference/receipt ID, timestamp, and clear next action instead of dumping the user back onto a blank or un-updated table.
- **Anti-dark patterns (Ethical UX):** Flag deceptive patterns such as confirmshaming, hidden fees, pre-checked consent boxes, or making cancellation/export artificially harder than signup.

## 8. Responsive behavior and field-device reality
- Viewport meta tag present (`width=device-width, initial-scale=1`, without disabling pinch-to-zoom `user-scalable=no`).
- Zero horizontal page scroll at `360px` width; wide data tables either scroll horizontally inside an isolated shadow-cued container with sticky first column or adapt to structured summary cards on mobile.
- Modals, popovers, and date pickers fit within small mobile viewports with virtual keyboard open (`100dvh` instead of `100vh`); safe-area insets (`env(safe-area-inset-*)`) respected.

## 9. Data visualization and tables (Tufte's Principles)
- **Chart integrity (Tufte's Lie Factor):** Bar charts always start at a zero baseline; dual-axis charts avoided or clearly separated; chart type matches the analytical question (line for time series, bar for categorical comparison, stacked bar/treemap for part-to-whole—avoid 3D charts or multi-slice pie charts).
- **Data-ink ratio:** Axes labeled with units and currency; direct data labels or clear tooltips; empty, partial, and single-point states handled without NaN/Infinity rendering bugs.
- **Table ergonomics:** Sticky header on scroll, right-aligned numeric/currency columns, left-aligned text columns, sort indicators, clear pagination count (`Showing 1–25 of 342`), and row density matched to the task.

## 10. Imagery, iconography, and motion
- Single consistent icon family and stroke weight; icon-only buttons always have a tooltip and `aria-label`.
- No un-licensed stock photos, broken image URLs, or emoji used in place of professional status/navigation icons in enterprise portals.
- **Purposeful motion:** Transitions are brisk ($150\text{–}250\text{ms}$ ease-out), animate compositor-friendly properties (`transform`, `opacity`), and respect `@media (prefers-reduced-motion: reduce)`.

## 11. Language, locale, and RTL (Urdu / Arabic) fidelity
- Strings externalized if multilingual; no broken string concatenation that fails in SOV word order (Urdu).
- **RTL layout mechanics:** Logical CSS properties (`ms-*`, `me-*`, `ps-*`, `pe-*`, `text-start`, `text-end`) used instead of physical `left`/`right`; `dir="rtl"` mirrors navigation, chevrons, and progress bars while keeping phone numbers, codes, and equations `dir="ltr"` (`unicode-bidi: isolate`).
- Urdu typography uses an appropriate Nastaliq or Naskh font stack (`Noto Nastaliq Urdu`, `Jameel Noori Nastaleeq`) with increased `line-height` ($\ge 1.8\text{–}2.2$) so ascenders and diacritics never clip.
- No leftover `"Lorem ipsum"`, `"John Doe"`, `"Test 123"`, or `"TODO"` strings in UI templates.

## 12. Brand, trust signals, and print/export
- Meaningful `<title>` per route, correct favicon and brand logo, and custom 403/404/500 screens written in plain human language (never raw JSON or stack traces).
- **Print & export fidelity:** Invoices, ledgers, and reports include `@media print` rules (hiding navbars/buttons, forcing high-contrast ink-friendly colors, controlling `break-inside: avoid` on rows/signatures), and CSV/Excel/PDF exports preserve headers, UTF-8/BOM encoding (for Urdu/Excel compatibility), and exact numeric types.

## 13. Signs of unreviewed AI-generated UI ("Vibe-Coded UI Tells")
- **The AI SaaS template clone:** Purple-to-indigo gradients, glowing glassmorphism cards, generic 3-column "feature grid" marketing heroes on internal enterprise portals, and decorative sparklines wired to hardcoded arrays (`[12, 19, 3, 5, 2, 3]`).
- **Look-alike non-functional chrome:** Notification bells, search bars, "Export" buttons, filter pills, or settings gears rendered in the header with `onClick={() => {}}` or no handler at all.
- **Prompt-session schizophrenia:** Three different modal implementations, two toast libraries, and conflicting button radii (`rounded-md` vs `rounded-full`) across adjacent routes.
- **Desktop-demo blindness:** Dashboards designed for a 27-inch MacBook screen that collapse into unreadable 4-column squished grids on the $100 Android phones actually used by field sales or warehouse staff.
