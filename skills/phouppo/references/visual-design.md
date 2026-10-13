# Visual Design and UI Review

Contents: how to review, design system and consistency, typography, color and contrast, layout and spacing, responsive behavior, component states, data visualization, imagery and iconography, motion, language and direction, branding, print and export, AI-generated UI tells.

Accessibility mechanics (keyboard, ARIA, screen readers) live in `code-quality.md`. This module covers what users see and how consistent, readable, and trustworthy it looks.

## How to review
- **Static first.** Inspect stylesheets, Tailwind config, theme files, design tokens, component libraries, assets, and templates. Do not start the app without user approval.
- **With screenshots.** If the user supplies screenshots or approves running the app, check the rendered result at three widths (about 360, 768, 1280 px) and in each theme the app supports. State which screens were reviewed.
- **Without either.** Mark rendered-only checks as `Not verified` and list which screens need a human look.
- Findings cite the file and line of the offending style or component, or the screenshot name.

## 1. Design system and consistency
- A single source of truth for color, type scale, spacing, radius, and shadow (CSS variables, theme file, Tailwind config). Flag values hardcoded across many files (`#3b82f6`, `13px`, arbitrary `p-[17px]`).
- The same element (primary button, input, card, modal, table) looks and behaves the same on every screen. Count competing implementations of one component.
- Mixed UI libraries or icon sets in one app (for example two component kits plus hand-rolled styles).
- Naming and variants are predictable (`primary`, `secondary`, `danger`), not one-off classes per page.

## 2. Typography
- Limited, deliberate type scale (typically 5 to 7 sizes) and no more than two font families.
- Body text at readable size (16 px or equivalent on mobile), line height and line length comfortable, no walls of small gray text.
- Clear hierarchy: headings, subheadings, labels, and data are distinguishable.
- Fonts load reliably: fallbacks defined, no flash of invisible text, licenses acceptable, no dependence on blocked third-party hosts for a corporate network.
- Numbers in tables use tabular figures and consistent decimals and units (currency symbol, thousands separators, Pakistani rupee formatting if applicable).

## 3. Color and contrast
- Text and interactive element contrast meets WCAG AA (4.5:1 normal text, 3:1 large text and UI components). Compute from token values where possible.
- Color is not the only carrier of meaning (status shown by color alone, red versus green indicators).
- Semantic colors are consistent: success, warning, error, info, disabled.
- Palette is restrained and matches the organization's brand guidelines where they exist.
- Dark mode, if offered: tokens redefined for both themes, no unreadable text or invisible borders, images and charts adapt.

## 4. Layout and spacing
- Consistent spacing scale and alignment grid; no random margins.
- Visual hierarchy guides the primary action on each screen; one clear primary button.
- Information density suits the user: dense tables for analysts, spacious touch targets for field staff.
- Touch targets at least 44 by 44 px (or 48 dp) on mobile; adequate gaps between tappable items.
- No content clipped, overlapping, or hidden behind fixed headers, keyboards, or bottom navigation.
- Long text, long names, and large numbers do not break layouts (truncation, wrapping, tooltips).

## 5. Responsive behavior
- Viewport meta tag present; layouts use fluid units, flex or grid, and breakpoints rather than fixed pixel widths.
- No horizontal page scroll at 360 px; wide tables scroll within their own container or transform into cards.
- Navigation, forms, and modals usable on small phones; dialogs not larger than the screen.
- Safe areas respected on notched devices; orientation changes handled.
- Images and media scale; no layout shift while loading (reserved dimensions).

## 6. Component states and feedback
- Every interactive element has hover, focus (visible focus ring), active, disabled, and loading states.
- Every data screen has loading (skeleton or spinner), empty (helpful message and next action), error (what happened and what to do), and success states.
- Forms show inline validation near the field, preserve entered data on error, and confirm submission.
- Destructive actions use confirmation and distinct styling.
- Toasts, banners, and modals are consistent in placement, duration, and wording.

## 7. Data visualization and tables
- Chart type fits the question (comparison, trend, composition); no 3D or decorative effects that distort values.
- Axes labeled with units, zero baseline for bar charts, consistent scales across comparable charts.
- Colorblind-safe palette and direct labels or patterns, not color alone.
- Legends, tooltips, and empty or partial data states handled.
- Tables: sticky headers for long data, sortable and filterable where useful, aligned numerics, readable on mobile.
- Numbers and dates formatted consistently across the app; dashboard figures match the underlying records (see `data-engineering.md`).

## 8. Imagery and iconography
- One icon style and set; icons paired with labels where meaning is not obvious.
- Emoji used as functional icons, stock placeholders, or generic illustrations left in production.
- Images optimized (modern formats, sensible dimensions, lazy loading) with meaningful alt text.
- Logos and brand assets are correct versions, crisp at all sizes, and licensed for use.
- No broken image links or leftover placeholder URLs.

## 9. Motion
- Animations are purposeful, short, and do not block tasks.
- `prefers-reduced-motion` respected.
- No autoplay media with sound; no large animated backgrounds on low-end devices.

## 10. Language, locale, and direction
- Text externalized for translation if multiple languages are required; no concatenated sentence fragments.
- Right-to-left support for Urdu or Arabic: `dir` attribute, mirrored layout, correct alignment of numbers and mixed-direction text, suitable Nastaliq or Naskh font with adequate line height.
- Dates, numbers, and currency follow the locale expected by users.
- Placeholder text ("Lorem ipsum", "Test", "TODO", "Untitled") removed.

## 11. Brand and trust signals
- Consistent product name, logo, and favicon; page titles meaningful.
- Professional tone and copy: no leftover developer jargon, raw error codes, or debug text shown to users.
- Error and permission screens look intentional (403, 404, 500), not framework defaults.
- Login and payment-like screens look and behave in a way users can trust (clear domain, no confusing redirects).

## 12. Print and export
- Reports, invoices, and statements print cleanly (print stylesheet, page breaks, no cut-off tables).
- Exported PDF or Excel files keep formatting, headers, units, and correct number formats.

## 13. Visual performance
- Large images, unoptimized fonts, heavy icon packs, and unused CSS inflate load time on mobile networks.
- Layout shift and flicker on load; render-blocking resources.

## Signs of unreviewed AI-generated UI
- Generic template look: default gradient hero, purple-blue gradients, glassmorphism cards, centered everything, repeated "feature card" grids unrelated to the real workflow.
- Screens that look polished but show fake data, placeholder charts, or buttons that do nothing.
- Inconsistent components from separate prompts: three button styles, two modal designs, different date formats.
- Excess decoration (shadows, gradients, animations) competing with the task.
- Interfaces designed for desktop demos rather than the real users' devices, connectivity, and language.
- Dashboards copied from SaaS conventions that do not reflect how plant, sales, or distribution teams read information.
