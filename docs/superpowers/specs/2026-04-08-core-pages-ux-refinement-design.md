# Core content pages UX refinement — Design spec

**Date:** 2026-04-08
**Project:** vol_histoire
**Scope:** Loading states · Details page hierarchy · Hangar exploration · Timeline wow-moment · Global polish

## 1. Goals

Refine the UX of the three core content pages (`hangar`, `details`, `timeline`) and the site-wide loading experience, **within the existing minimalist charcoal + champagne identity**. This is a refinement pass — no new art direction, no new tokens beyond one focus-ring variable, no frontend dependencies. Vanilla JS remains; backend stays CommonJS.

### Pain points being addressed

1. **Loading feels broken.** Hangar hero shows `0 / 0 / 0` until data lands; details page shows `Chargement...` and `-`. No skeletons.
2. **Details page is a stack of 9 identical cards** with no visual hierarchy — the crown-jewel per-aircraft page doesn't earn its scroll.
3. **Hangar browsing is transactional.** No URL state, no facet counts, no comparison, no view toggle, awkward mobile filters.
4. **Timeline is a flat vertical list** on a site literally named "Vol d'Histoire". Missed wow moment.

### Non-goals

- No framework migration (stays vanilla JS).
- No new visual identity / art direction.
- No ORM, no bundler.
- No overhaul of auth, admin tooling, i18n, or other pages (index, favorites layout, settings, login flows).
- No full CSS rewrite — targeted dedupe only.

## 2. Architecture constraints

- All frontend changes live in `frontend/`, reuse tokens in `css/tokens.css`.
- Backend adds exactly one new endpoint (`GET /api/airplanes/facets`). Route file pattern follows `backend/routes/monitoring.js`.
- No new npm dependencies on either side.
- Every new feature degrades gracefully without JS (progressive enhancement): timeline falls back to a vertical list; hangar renders a plain grid; details renders all sections linearly.
- `prefers-reduced-motion` respected for all animations (skeletons, count-ups, smooth scroll, timeline scroll-snap behavior).

## 3. Section 1 — Loading states system

### New files

- `frontend/css/skeleton.css` (~120 LOC)
- `frontend/js/loading.js` (~80 LOC)

### `skeleton.css`

Reusable classes using shimmer gradient on `var(--night-mid)` → `var(--night-soft)`:

- `.skel` — base shimmer element
- `.skel-text` — single text line (height `1em`)
- `.skel-title` — display heading block
- `.skel-card` — hangar card placeholder (image + two text lines)
- `.skel-hero` — details hero (title + meta row + image block)
- `.skel-stat` — quick-stat card placeholder

Shimmer = `linear-gradient(90deg, var(--night-mid) 0%, var(--night-soft) 50%, var(--night-mid) 100%)` animated via `background-position` at 1.4s infinite linear. Under `@media (prefers-reduced-motion: reduce)`, animation disabled and shimmer collapses to a flat `var(--night-mid)` block.

### `loading.js`

Exports three helpers on `window.Loading`:

- `mountSkeleton(target, template, count)` — injects `count` copies of `template` (one of the skel classes) into `target` element.
- `unmountSkeleton(target)` — clears `target` contents (caller then renders real content).
- `countUp(el, to, duration = 800)` — `requestAnimationFrame` driven; parses `el.textContent` as start value (default 0), interpolates to `to` over `duration` ms with `easeOutCubic`. Respects `prefers-reduced-motion` (snaps instantly).

### Integration points

- `hangar.js` — mounts 6 `.skel-card` into `#airplanes-container` before fetch; `countUp` on `#total-aircraft`, `#total-countries`, `#total-generations` after response.
- `details.js` — mounts `.skel-hero`, `.skel-stat` × 4, `.skel-text` × 3 (description) on `DOMContentLoaded`; `countUp` on each stat value after data arrives.
- `favorites.js` — same skeleton cards as hangar.

## 4. Section 2 — Details page hierarchy

**Touched:** `frontend/details.html`, `frontend/css/details.css`, `frontend/js/details.js`.

The 9 existing sections stay; their visual weight becomes unequal.

### Hero (promote)

- Image bleeds full-bleed on the right half: breaks out of `.container` via CSS `position: relative; right: calc(50% - 50vw);` on the right column at ≥ 1024px.
- Max-heights: 540px desktop / 360px tablet / auto stacked on mobile (< 768px, image on top, text below).
- Left column (title/meta/actions) remains inside the container.

### Sticky mini-bar (new)

- Appears when the user scrolls past the hero. Implementation: `IntersectionObserver` observing the hero bottom; toggles `.mini-bar-visible` on `<body>`.
- Contents: aircraft name (truncate at 40 chars), three quick-stat values (speed / range / weight), favorite button.
- Position: `position: sticky; top: var(--header-h);` with a `transform: translateY(-100%)` → `0` transition on the visibility toggle.
- Hidden on mobile (< 768px) to preserve scroll real estate.

### Quick stats

- Layout unchanged.
- Values use `Loading.countUp` when first revealed.

### Description (promote)

- Max-width `65ch`, centered in its column.
- First paragraph: CSS `p:first-of-type::first-letter` drop-cap, 3 lines tall, `font-family: var(--font-display)`, `color: var(--hud-cyan)`.
- No layout change to the section wrapper.

### Armament / Tech / Missions / Wars (demote to chip grids)

- Replace `.feature-grid`, `.mission-grid`, `.wars-timeline` rendering in `details.js` with a unified `renderChipGrid(items, iconKey)` helper.
- Chip markup:
  ```html
  <button class="chip" data-tooltip="...">
    <i class="fas fa-..."></i>
    <span class="chip-label">Name</span>
  </button>
  ```
- Chip CSS: small pill, `border: 1px solid var(--border-cyan)`, `padding: var(--sp-2) var(--sp-3)`, hover reveals a tooltip bubble positioned above the chip (CSS-only `:hover` + `::after`, no JS tooltip lib).
- Grid: `display: grid; grid-template-columns: repeat(auto-fill, minmax(180px, 1fr)); gap: var(--sp-2);`.
- Each chip is focusable (`<button>`), tooltip also revealed on `:focus-visible`.

### Right-rail TOC (new, desktop only)

- Appears at viewport width ≥ 1100px.
- Fixed column on the right (outside main content), `position: sticky; top: calc(var(--header-h) + var(--sp-8));`.
- Lists six section anchors: Description, Dates clés, Armement, Technologies, Missions, Engagements.
- Active item highlighted via `IntersectionObserver` on each section (`rootMargin: -30% 0px -60% 0px`).
- Click = smooth scroll to the target section (uses `element.scrollIntoView({ behavior: 'smooth', block: 'start' })`, respects `prefers-reduced-motion`).

### Scroll progress bar (new)

- Fixed at `top: 0; left: 0; right: 0; height: 2px; z-index: calc(var(--z-header) + 1);`
- Background `var(--hud-cyan)`, width bound to `scrollY / (scrollHeight - innerHeight)` via a `scroll` listener (passive, throttled via `requestAnimationFrame`).
- Present only on details page.

## 5. Section 3 — Hangar exploration

**Touched:** `hangar.html`, `hangar.css`, `hangar.js` (heavy refactor), `backend/app.js` (+ new route file).

### 5.1 URL state sync

Refactor `hangar.js` around a single `state` object:

```js
const state = {
  q: '',              // search text
  country: null,      // ISO code
  gen: null,          // generation id
  type: null,         // type id
  sort: 'default',    // sort key
  view: 'grid',       // 'grid' | 'list'
  page: 1,
  compareIds: [],     // transient, not in URL
};
```

- `readStateFromUrl()` runs on page load and on every `popstate`. Uses `URLSearchParams`.
- `writeStateToUrl()` called after every user interaction that changes state. Uses `history.pushState` when it's a user intent (filter change), `history.replaceState` when it's incidental (pagination from the same filter set — debatable, document as `pushState` everywhere for simplicity: every state change is back-button-recoverable).
- `render()` is the single entry point that reads `state` and updates DOM.
- Shareable URLs: any bookmarked URL reproduces the exact view.

### 5.2 Facet counts

**New backend endpoint:** `GET /api/airplanes/facets?q=&country=&gen=&type=`

Returns:
```json
{
  "countries":   { "fr": 12, "us": 8, "ru": 6, ... },
  "generations": { "3": 4, "4": 18, "5": 6, ... },
  "types":       { "1": 10, "2": 8, ... }
}
```

**Faceted search rule:** each facet's counts are computed with all current filters **except** that facet itself (so opening "Country" still shows every country count that would survive the other active filters).

**Implementation:** one SQL query per facet group (three queries total). Each query reuses the existing filter-building logic from the main `/api/airplanes` route, with one exclusion. Prefer factoring filter-building into a shared helper in `app.js` (or new `backend/lib/airplane-filters.js`) to avoid duplication.

**Route file:** `backend/routes/facets.js` exporting an Express router, mounted in `app.js` as `app.use('/api/airplanes/facets', facetsRouter)`.

**Cache:** none for now (data is small, 44 rows). Add later if needed.

**Frontend:** `hangar.js` fetches `/api/airplanes/facets` alongside `/api/airplanes` on every filter change; renders counts inside each filter dropdown as `name (count)`; greys out (not hides) options with count 0.

### 5.3 Active filter chips row

- DOM: existing `#active-filters` element (already in markup).
- Visible when `state.country || state.gen || state.type || state.q` is truthy.
- Renders one chip per active filter: `[France ×]`, `[4e génération ×]`, `[Type: Multirôle ×]`, `[Recherche: "f16" ×]`.
- Trailing `[Tout effacer]` button.
- Clicking `×` removes that facet from state; clicking "Tout effacer" resets all filters except `view` and `sort`.

### 5.4 Compare mode

- **Card checkbox:** top-right corner of each aircraft card, `<input type="checkbox">` with a custom-styled label. Max 3 selected; attempting a 4th is blocked with a toast `"Maximum 3 avions en comparaison"`.
- **State:** `state.compareIds` array, synced to `localStorage` key `vh_compare_ids` (persists across pages). Not synced to URL.
- **Floating bar:** fixed bottom bar appears when `compareIds.length >= 1`. Contents: `Comparer (N)  [Effacer]  [Voir la comparaison →]`. Slide-up transition.
- **Compare modal:** `<dialog>` element with a table:
  - Rows: Image, Nom, Pays, Constructeur, Génération, Type, Entrée en service, Vitesse max, Portée max, Poids, Statut.
  - Columns: one per selected aircraft (max 3).
  - Mobile (< 768px): table reflows to stacked sections (one per aircraft) with row labels repeated.
- **Data fetch:** reuses existing `/api/airplanes/:id` endpoint, one call per selected id, `Promise.all`.

### 5.5 View toggle

- Two buttons in the toolbar right area: grid (current) / list.
- List view: one row per aircraft with thumbnail (80×60), name, country flag, gen badge, speed, range. `display: grid; grid-template-columns: 80px 1fr auto auto auto auto; gap: var(--sp-4);`.
- Persists in `localStorage` key `vh_hangar_view` AND URL (`?view=list`). URL wins on load.

### 5.6 Mobile filter sheet

- Breakpoint: `< 768px`.
- Replaces dropdowns with a single full-height bottom sheet using native `<dialog>`.
- Sheet contents: three tabs (Pays / Génération / Type), scrollable options list per tab, sticky bottom `[Appliquer]` button.
- Open via any filter button; close via backdrop tap, swipe-down, or X button.
- Transitions: `@starting-style` + `transform: translateY(100%)` → `0`. Fallback: instant open for older browsers.

## 6. Section 4 — Timeline (ambitious)

**Touched:** `timeline.html`, `timeline.css`, `timeline.js` (rewrite).

### Layout

- **Era bands header:** sticky top strip, horizontally laid out: `1960s · 1970s · 1980s · 1990s · 2000s · 2010s · 2020s`. Fixed below the main header (`top: var(--header-h)`). Active decade underlined in `var(--hud-cyan)`.
- **Main rail:** horizontally scrollable flex container (`overflow-x: auto; scroll-snap-type: x mandatory;`), one section per decade.
- **Decade sections:** each `width: 100vw; scroll-snap-align: start;` — exactly one decade fills the viewport.
- **Center time axis:** horizontal line at 50% vertical, year markers every 2 years (ticks + labels).
- **Aircraft cards:** docked along the axis at their `date_operational` year. Anti-overlap: sort by year, alternate above/below the axis (even index above, odd below). Card = thumbnail (120×80) + name + year. Small vertical connector from card to its year tick.

### Interactions

- Click decade in header → smooth horizontal scroll to that decade section.
- Current decade tracked via `IntersectionObserver` on each section; updates header highlight.
- Keyboard nav: `ArrowLeft` / `ArrowRight` jump one decade; `Home` / `End` jump to first / last. Focus trap not needed — decades are regular sections.
- Aircraft card click → navigates to `/details?id=X` (same behavior as hangar).
- `prefers-reduced-motion`: disables smooth scroll (instant jump).

### Mobile (< 768px)

- Same horizontal scroll, one decade per swipe.
- Inside a decade, cards stack vertically (no center-line anti-overlap math — complexity not worth it on small screens).
- Era bands header becomes a horizontally scrollable chip strip.

### Progressive enhancement fallback

- `timeline.html` renders all decade sections as plain HTML `<section>`s containing an `<ol>` of aircraft by year (SEO-readable).
- `timeline.js` applies the `.js-enhanced` class on `<body>` which unlocks the horizontal layout via CSS `.js-enhanced .timeline-rail { display: flex; overflow-x: auto; }`.
- Without JS: page reads as a linear vertical archive, still usable.

## 7. Section 5 — Global polish

- **Footer dead links:** remove `À propos`, `FAQ`, `Support` from the footer on all pages. Keep `Contact`. Point `Cookies` link to `#cookie-settings-btn` so it opens the existing consent modal.
- **Accessibility:**
  - `aria-expanded` on all filter buttons and hamburger, toggled on open/close.
  - New token `--focus-ring: 0 0 0 2px var(--hud-cyan)` in `tokens.css`.
  - Global `:focus-visible { box-shadow: var(--focus-ring); outline: none; }` rule in `base.css`.
  - All icon-only buttons audit: ensure `aria-label` is set.
- **`components.css` extraction:**
  - Diff `style.css` (1427 LOC) and `shared.css` (1282 LOC); move exact-duplicate or near-duplicate rules (buttons, cards, modal, toast, form controls) into new `frontend/css/components.css`.
  - Update every HTML file to load `components.css` after `shared.css` and before the page-specific CSS.
  - Target reduction: 300–500 LOC net across the two original files.
  - This is a targeted dedupe, not a rewrite — behavior identical, verified by eyeballing each touched page.
- **Image performance:** `loading="lazy"` on all `<img>` below the fold (hangar card images, timeline card images). Explicit `width` and `height` attributes everywhere to prevent CLS.

## 8. Testing

### Backend

- **New test file:** `backend/__tests__/facets.test.js`
  - GET with no filters → returns three groups, counts sum to total aircraft count
  - GET with `country=fr` → `countries` group still returns all countries (not just fr), `generations` and `types` reflect only French aircraft
  - GET with unknown country code → all counts are 0

### Frontend QA checklist (manual, documented in the spec)

- [ ] Hangar: deep-link `?country=fr&gen=4&sort=date&page=2` loads that exact view
- [ ] Hangar: back button restores previous filter state
- [ ] Hangar: compare 1 / 2 / 3 aircraft; attempt 4th shows toast; remove compare persists via localStorage
- [ ] Hangar: grid ↔ list toggle persists across reload
- [ ] Hangar: mobile filter sheet opens, applies, closes
- [ ] Details: skeleton → content transition is smooth, no layout shift
- [ ] Details: sticky mini-bar appears after hero, disappears on scroll up
- [ ] Details: right-rail TOC highlights the current section on desktop
- [ ] Details: scroll progress bar tracks accurately
- [ ] Timeline: horizontal scroll + scroll-snap works, era header highlights current decade
- [ ] Timeline: keyboard `←/→` jumps decades
- [ ] Timeline: without JS, still renders a readable vertical list
- [ ] Global: `prefers-reduced-motion` disables all animations (skeletons flat, count-ups instant, smooth scroll instant)
- [ ] Global: `:focus-visible` ring visible on every interactive element

### E2E

- Existing Playwright smoke tests remain as-is. Not expanded in this spec — add coverage later if any of these pages become gating.

## 9. File inventory

### New files (5)

- `frontend/js/loading.js`
- `frontend/css/skeleton.css`
- `frontend/css/components.css`
- `backend/routes/facets.js`
- `backend/__tests__/facets.test.js`

### Heavily modified (10)

- `frontend/hangar.html`, `frontend/css/hangar.css`, `frontend/js/hangar.js`
- `frontend/details.html`, `frontend/css/details.css`, `frontend/js/details.js`
- `frontend/timeline.html`, `frontend/css/timeline.css`, `frontend/js/timeline.js`
- `frontend/js/favorites.js` (skeleton integration only)
- `backend/app.js` (mount facets route, extract filter helper)

### Lightly touched

- `frontend/css/tokens.css` — add `--focus-ring`
- `frontend/css/base.css` — add global `:focus-visible` rule
- All `frontend/*.html` files — load `components.css`, remove dead footer links

## 10. Effort split (relative)

- Loading states: 10%
- Details page: 20%
- Hangar exploration: 35%
- Timeline: 25%
- Polish + tests + CSS dedupe: 10%

## 11. Out of scope (deferred to later sub-projects)

- Content & SEO (sub-project #1 from original brainstorm)
- Performance & PWA / service worker / image optimization beyond `loading=lazy`
- Features: user profiles, comments, ratings, collections, quiz mode
- Admin tooling
- Backend hardening beyond the one new endpoint
- Full CSS rewrite
- E2E test expansion
