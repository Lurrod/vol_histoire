# Core content pages UX refinement — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Refine the UX of hangar, details, and timeline pages within the existing minimalist charcoal + champagne identity — add loading states, restructure details hierarchy, rebuild hangar as an exploration tool with URL state + facets + compare, and turn timeline into a horizontal era-scroll experience.

**Architecture:** Vanilla JS, no new npm deps. All CSS uses existing tokens. Backend gets one new endpoint (`/api/airplanes/facets`) via a new Express router file. Progressive enhancement: every new feature degrades to a usable fallback without JS. All animations respect `prefers-reduced-motion`.

**Tech Stack:** HTML5, CSS3 custom properties, Vanilla ES6+ JS, Express 4 / PostgreSQL (`pg`), Jest + Supertest.

**Spec reference:** `docs/superpowers/specs/2026-04-08-core-pages-ux-refinement-design.md`

---

## Task 1 — Tokens & global focus ring

**Files:**
- Modify: `frontend/css/tokens.css`
- Modify: `frontend/css/base.css`

- [ ] **Add `--focus-ring` token.** Append to `tokens.css` inside `:root { ... }` just after the shadow block:

```css
--focus-ring: 0 0 0 2px var(--hud-cyan);
```

- [ ] **Add global `:focus-visible` rule.** Append to `base.css`:

```css
*:focus-visible {
  box-shadow: var(--focus-ring);
  outline: none;
  border-radius: var(--r-sm);
}
```

- [ ] **Commit:**

```bash
git add frontend/css/tokens.css frontend/css/base.css
git commit -m "feat(ui): add --focus-ring token and global :focus-visible rule"
```

---

## Task 2 — Skeleton CSS

**Files:**
- Create: `frontend/css/skeleton.css`

- [ ] **Create `frontend/css/skeleton.css`** with the full content:

```css
/* ============================================================
   SKELETON LOADING STATES
   ============================================================ */

.skel {
  background: linear-gradient(
    90deg,
    var(--night-mid) 0%,
    var(--night-soft) 50%,
    var(--night-mid) 100%
  );
  background-size: 200% 100%;
  animation: skel-shimmer 1.4s infinite linear;
  border-radius: var(--r-md);
  display: block;
}

@keyframes skel-shimmer {
  0%   { background-position: 200% 0; }
  100% { background-position: -200% 0; }
}

.skel-text {
  height: 1em;
  margin-bottom: var(--sp-2);
  width: 100%;
}
.skel-text.short { width: 40%; }
.skel-text.mid   { width: 70%; }

.skel-title {
  height: 2.4em;
  width: 60%;
  margin-bottom: var(--sp-3);
}

.skel-card {
  border: 1px solid var(--border-subtle);
  border-radius: var(--r-lg);
  overflow: hidden;
  background: var(--night-mid);
}
.skel-card .skel-image {
  height: 180px;
  width: 100%;
  border-radius: 0;
}
.skel-card .skel-body {
  padding: var(--sp-4);
}

.skel-hero {
  display: grid;
  grid-template-columns: 1.2fr 1fr;
  gap: var(--sp-6);
  min-height: 360px;
  padding: var(--sp-8) 0;
}
.skel-hero .skel-left { padding: var(--sp-4); }
.skel-hero .skel-image {
  height: 340px;
  border-radius: var(--r-lg);
}
@media (max-width: 768px) {
  .skel-hero { grid-template-columns: 1fr; }
}

.skel-stat {
  height: 96px;
  border: 1px solid var(--border-subtle);
  border-radius: var(--r-lg);
}

@media (prefers-reduced-motion: reduce) {
  .skel,
  .skel-text,
  .skel-title,
  .skel-card .skel-image,
  .skel-hero .skel-image,
  .skel-stat {
    animation: none;
    background: var(--night-mid);
  }
}
```

- [ ] **Commit:**

```bash
git add frontend/css/skeleton.css
git commit -m "feat(ui): add reusable skeleton loading CSS"
```

---

## Task 3 — Loading JS helpers

**Files:**
- Create: `frontend/js/loading.js`

- [ ] **Create `frontend/js/loading.js`:**

```javascript
/* Loading helpers — skeletons + animated count-ups.
   Exposed on window.Loading. */
(function () {
  'use strict';

  const reduce =
    window.matchMedia &&
    window.matchMedia('(prefers-reduced-motion: reduce)').matches;

  /**
   * @param {HTMLElement} target
   * @param {string} templateHtml  Template HTML for one skeleton unit.
   * @param {number} count
   */
  function mountSkeleton(target, templateHtml, count = 1) {
    if (!target) return;
    target.setAttribute('aria-busy', 'true');
    target.innerHTML = Array.from({ length: count })
      .map(() => templateHtml)
      .join('');
  }

  /** @param {HTMLElement} target */
  function unmountSkeleton(target) {
    if (!target) return;
    target.removeAttribute('aria-busy');
    target.innerHTML = '';
  }

  /**
   * @param {HTMLElement} el
   * @param {number} to
   * @param {number} duration
   */
  function countUp(el, to, duration = 800) {
    if (!el) return;
    const target = Number(to) || 0;
    if (reduce || duration <= 0) {
      el.textContent = String(target);
      return;
    }
    const from = Number(el.textContent) || 0;
    const start = performance.now();
    function frame(now) {
      const t = Math.min(1, (now - start) / duration);
      const eased = 1 - Math.pow(1 - t, 3); // easeOutCubic
      const value = Math.round(from + (target - from) * eased);
      el.textContent = String(value);
      if (t < 1) requestAnimationFrame(frame);
    }
    requestAnimationFrame(frame);
  }

  window.Loading = { mountSkeleton, unmountSkeleton, countUp };
})();
```

- [ ] **Commit:**

```bash
git add frontend/js/loading.js
git commit -m "feat(ui): add Loading helpers (skeleton + countUp)"
```

---

## Task 4 — Wire loading on hangar page

**Files:**
- Modify: `frontend/hangar.html`
- Modify: `frontend/js/hangar.js`

- [ ] **Add skeleton.css + loading.js script to `hangar.html`.** In `<head>` after `hangar.css`:

```html
<link rel="stylesheet" href="css/skeleton.css">
```

And in the scripts block before `hangar.js`:

```html
<script defer src="js/loading.js"></script>
```

- [ ] **In `hangar.js`**, before the fetch call for `/api/airplanes`, mount skeletons into `#airplanes-container`:

```javascript
const SKEL_CARD = `
  <div class="skel-card">
    <div class="skel skel-image"></div>
    <div class="skel-body">
      <div class="skel skel-text mid"></div>
      <div class="skel skel-text short"></div>
    </div>
  </div>`;

window.Loading.mountSkeleton(
  document.getElementById('airplanes-container'),
  SKEL_CARD,
  6
);
```

Call `window.Loading.unmountSkeleton(container)` right before the existing render loop that injects real cards.

- [ ] **After hero stats arrive**, replace the direct `textContent = n` assignments for `#total-aircraft`, `#total-countries`, `#total-generations` with:

```javascript
window.Loading.countUp(document.getElementById('total-aircraft'), totalAircraft);
window.Loading.countUp(document.getElementById('total-countries'), totalCountries);
window.Loading.countUp(document.getElementById('total-generations'), totalGenerations);
```

- [ ] **Manual verify** on localhost: reload hangar page — skeletons visible briefly, then cards; hero numbers animate 0 → final.

- [ ] **Commit:**

```bash
git add frontend/hangar.html frontend/js/hangar.js
git commit -m "feat(hangar): wire skeleton cards + hero stat count-up"
```

---

## Task 5 — Wire loading on details page

**Files:**
- Modify: `frontend/details.html`
- Modify: `frontend/js/details.js`

- [ ] **Include skeleton.css and loading.js** in `details.html` the same way as hangar.

- [ ] **On DOMContentLoaded, before fetch**, mount skeletons. Replace the existing `innerHTML = 'Chargement...'` placeholders with skeleton markup:

```javascript
const heroName = document.getElementById('aircraft-name');
if (heroName) heroName.innerHTML = '<span class="skel skel-title"></span>';

const desc = document.getElementById('aircraft-description');
if (desc) desc.innerHTML =
  '<span class="skel skel-text"></span>' +
  '<span class="skel skel-text"></span>' +
  '<span class="skel skel-text mid"></span>';
```

- [ ] **After data loads**, call `countUp` on stat values that are numeric:

```javascript
const speedEl = document.getElementById('stat-speed');
if (speedEl && aircraft.max_speed) {
  speedEl.textContent = '0';
  window.Loading.countUp(speedEl, aircraft.max_speed);
}
// repeat for stat-range, stat-weight
```

- [ ] **Manual verify**: reload a details page — no more `Chargement...` or `-` visible as static text; stats animate.

- [ ] **Commit:**

```bash
git add frontend/details.html frontend/js/details.js
git commit -m "feat(details): wire skeleton loading + stat count-up"
```

---

## Task 6 — Backend: facets endpoint (TDD)

**Files:**
- Create: `backend/routes/facets.js`
- Create: `backend/__tests__/facets.test.js`
- Modify: `backend/app.js`

- [ ] **Write the failing test.** Create `backend/__tests__/facets.test.js`:

```javascript
const request = require('supertest');
const app = require('../app');

describe('GET /api/airplanes/facets', () => {
  beforeAll(() => {
    app.setPool(global.testPool || require('./helpers/testPool'));
  });

  test('returns three facet groups with counts', async () => {
    const res = await request(app).get('/api/airplanes/facets');
    expect(res.status).toBe(200);
    expect(res.body).toHaveProperty('countries');
    expect(res.body).toHaveProperty('generations');
    expect(res.body).toHaveProperty('types');
    const sum = Object.values(res.body.countries).reduce((a, b) => a + b, 0);
    expect(sum).toBeGreaterThan(0);
  });

  test('country filter narrows generations and types, not countries', async () => {
    const res = await request(app).get('/api/airplanes/facets?country=France');
    expect(res.status).toBe(200);
    // countries group still shows all countries (facet excludes itself)
    expect(Object.keys(res.body.countries).length).toBeGreaterThan(1);
  });
});
```

- [ ] **Run and verify it fails:**

```bash
cd backend && npx jest __tests__/facets.test.js
```

Expected: FAIL — 404 or missing route.

- [ ] **Create `backend/routes/facets.js`:**

```javascript
const express = require('express');

/**
 * @param {() => import('pg').Pool} getPool
 */
module.exports = function createFacetsRouter(getPool) {
  const router = express.Router();

  function buildConditions({ country, generation, type }, exclude) {
    const params = [];
    const conds = [];
    if (country && exclude !== 'country') {
      params.push(country);
      conds.push(`c.name = $${params.length}`);
    }
    if (generation && exclude !== 'generation') {
      params.push(Number(generation));
      conds.push(`g.generation = $${params.length}`);
    }
    if (type && exclude !== 'type') {
      params.push(type);
      conds.push(`t.name = $${params.length}`);
    }
    return { params, where: conds.length ? ' WHERE ' + conds.join(' AND ') : '' };
  }

  router.get('/airplanes/facets', async (req, res, next) => {
    try {
      const filters = {
        country: req.query.country || '',
        generation: req.query.generation || '',
        type: req.query.type || '',
      };
      const base = `
        FROM airplanes a
        LEFT JOIN countries c ON a.country_id = c.id
        LEFT JOIN generation g ON a.id_generation = g.id
        LEFT JOIN type t ON a.type = t.id`;

      const ctryQ = buildConditions(filters, 'country');
      const genQ  = buildConditions(filters, 'generation');
      const typQ  = buildConditions(filters, 'type');

      const pool = getPool();
      const [ctryRes, genRes, typRes] = await Promise.all([
        pool.query(
          `SELECT c.name AS k, COUNT(*)::int AS n ${base}${ctryQ.where}
           GROUP BY c.name ORDER BY c.name`,
          ctryQ.params
        ),
        pool.query(
          `SELECT g.generation AS k, COUNT(*)::int AS n ${base}${genQ.where}
           GROUP BY g.generation ORDER BY g.generation`,
          genQ.params
        ),
        pool.query(
          `SELECT t.name AS k, COUNT(*)::int AS n ${base}${typQ.where}
           GROUP BY t.name ORDER BY t.name`,
          typQ.params
        ),
      ]);

      const toMap = rows =>
        rows.reduce((acc, row) => {
          if (row.k != null) acc[row.k] = row.n;
          return acc;
        }, {});

      res.json({
        countries:   toMap(ctryRes.rows),
        generations: toMap(genRes.rows),
        types:       toMap(typRes.rows),
      });
    } catch (err) {
      next(err);
    }
  });

  return router;
};
```

- [ ] **Mount the router** in `backend/app.js`. Near the existing `airplanesRouter` mount (around line 334), add:

```javascript
const createFacetsRouter = require('./routes/facets');
const facetsRouter = createFacetsRouter(() => pool);
app.use('/api', facetsRouter);
```

- [ ] **Run the tests:**

```bash
cd backend && npx jest __tests__/facets.test.js
```

Expected: PASS.

- [ ] **Commit:**

```bash
git add backend/routes/facets.js backend/__tests__/facets.test.js backend/app.js
git commit -m "feat(api): add /api/airplanes/facets endpoint with faceted counts"
```

---

## Task 7 — Hangar: URL state sync

**Files:**
- Modify: `frontend/js/hangar.js`

- [ ] **Add `readStateFromUrl()` / `writeStateToUrl()` helpers** near the top of `hangar.js`:

```javascript
function readStateFromUrl() {
  const p = new URLSearchParams(location.search);
  state.filters.country    = p.get('country') || null;
  state.filters.generation = p.get('gen') ? Number(p.get('gen')) : null;
  state.filters.type       = p.get('type') || null;
  state.searchQuery        = p.get('q') || '';
  state.sort               = p.get('sort') || 'default';
  state.view               = p.get('view') === 'list' ? 'list' : 'grid';
  state.currentPage        = Math.max(1, Number(p.get('page')) || 1);
}

function writeStateToUrl() {
  const p = new URLSearchParams();
  if (state.filters.country)    p.set('country', state.filters.country);
  if (state.filters.generation) p.set('gen', String(state.filters.generation));
  if (state.filters.type)       p.set('type', state.filters.type);
  if (state.searchQuery)        p.set('q', state.searchQuery);
  if (state.sort && state.sort !== 'default') p.set('sort', state.sort);
  if (state.view === 'list')    p.set('view', 'list');
  if (state.currentPage > 1)    p.set('page', String(state.currentPage));
  const qs = p.toString();
  const url = qs ? `${location.pathname}?${qs}` : location.pathname;
  history.pushState(null, '', url);
}

window.addEventListener('popstate', () => {
  readStateFromUrl();
  renderAirplanes(); // existing render fn
});
```

- [ ] **Call `readStateFromUrl()` once at the start of the init function** (before the initial fetch).

- [ ] **Call `writeStateToUrl()` at the end of every handler** that changes a filter, search input, sort, view, or page (the existing `applyFilter`, `handleSearchInput`, `handleSortChange`, `goToPage` functions — find them and append the call).

- [ ] **Manual verify:** apply a country filter → URL updates → reload → same filter is active → back button removes it.

- [ ] **Commit:**

```bash
git add frontend/js/hangar.js
git commit -m "feat(hangar): sync filter state with URL query params"
```

---

## Task 8 — Hangar: facet counts integration

**Files:**
- Modify: `frontend/js/hangar.js`
- Modify: `frontend/css/hangar.css`

- [ ] **Add a `fetchFacets()` function** in `hangar.js`:

```javascript
async function fetchFacets() {
  const p = new URLSearchParams();
  if (state.filters.country)    p.set('country', state.filters.country);
  if (state.filters.generation) p.set('generation', String(state.filters.generation));
  if (state.filters.type)       p.set('type', state.filters.type);
  try {
    const res = await fetch(`/api/airplanes/facets?${p}`);
    if (!res.ok) return null;
    return await res.json();
  } catch (_) {
    return null;
  }
}
```

- [ ] **Call `fetchFacets()` in parallel with `fetchAirplanes()`** on every render cycle. Store result in `state.facets = { countries, generations, types }`.

- [ ] **Update the filter dropdown rendering** — find the code that builds `#country-options`, `#generation-options`, `#type-options` and append counts to each option label. For country options:

```javascript
const n = state.facets?.countries?.[country.name] ?? 0;
// inject as ` (${n})` after the name, add class `filter-option-empty` when n === 0
```

- [ ] **Add CSS for greyed-out zero-count options** in `hangar.css`:

```css
.filter-option-empty { opacity: .4; pointer-events: none; }
.filter-option .count {
  color: var(--text-muted);
  font-size: var(--text-xs);
  margin-left: var(--sp-2);
}
```

- [ ] **Manual verify:** open Country filter → counts visible next to each name → apply one filter → other dropdowns' counts update.

- [ ] **Commit:**

```bash
git add frontend/js/hangar.js frontend/css/hangar.css
git commit -m "feat(hangar): render facet counts on filter dropdowns"
```

---

## Task 9 — Hangar: active filter chips

**Files:**
- Modify: `frontend/js/hangar.js`
- Modify: `frontend/css/hangar.css`

- [ ] **Add `renderActiveFilters()` function** in `hangar.js`:

```javascript
function renderActiveFilters() {
  const container = document.getElementById('active-filters');
  if (!container) return;
  const chips = [];
  if (state.filters.country)
    chips.push({ key: 'country', label: `Pays: ${state.filters.country}` });
  if (state.filters.generation)
    chips.push({ key: 'generation', label: `Gén. ${state.filters.generation}` });
  if (state.filters.type)
    chips.push({ key: 'type', label: `Type: ${state.filters.type}` });
  if (state.searchQuery)
    chips.push({ key: 'q', label: `"${state.searchQuery}"` });

  if (chips.length === 0) {
    container.classList.add('hidden');
    container.innerHTML = '';
    return;
  }
  container.classList.remove('hidden');
  container.innerHTML =
    chips
      .map(
        c =>
          `<button class="active-chip" data-key="${c.key}">
            ${escapeHtml(c.label)} <i class="fas fa-times"></i>
          </button>`
      )
      .join('') +
    `<button class="active-chip active-chip-clear">Tout effacer</button>`;

  container.querySelectorAll('.active-chip[data-key]').forEach(btn => {
    btn.addEventListener('click', () => {
      const k = btn.dataset.key;
      if (k === 'q') state.searchQuery = '';
      else state.filters[k] = null;
      state.currentPage = 1;
      writeStateToUrl();
      renderAirplanes();
      renderActiveFilters();
    });
  });
  container.querySelector('.active-chip-clear')?.addEventListener('click', () => {
    state.filters = { country: null, generation: null, type: null };
    state.searchQuery = '';
    state.currentPage = 1;
    document.getElementById('search-input').value = '';
    writeStateToUrl();
    renderAirplanes();
    renderActiveFilters();
  });
}
```

- [ ] **Call `renderActiveFilters()` after every state change** (inside `renderAirplanes()` or alongside it).

- [ ] **Add CSS** to `hangar.css`:

```css
.active-filters {
  display: flex;
  flex-wrap: wrap;
  gap: var(--sp-2);
  margin: var(--sp-4) 0;
}
.active-chip {
  background: rgba(200, 169, 110, .08);
  border: 1px solid var(--border-cyan);
  color: var(--hud-cyan);
  padding: var(--sp-2) var(--sp-3);
  border-radius: var(--r-full);
  font-size: var(--text-sm);
  display: inline-flex;
  align-items: center;
  gap: var(--sp-2);
  cursor: pointer;
  transition: var(--transition-fast);
}
.active-chip:hover { background: rgba(200, 169, 110, .16); }
.active-chip-clear {
  background: transparent;
  color: var(--text-muted);
  border-color: var(--border-subtle);
}
```

- [ ] **Manual verify:** apply 2 filters → 2 chips + Clear visible → click × on a chip → chip disappears and grid updates.

- [ ] **Commit:**

```bash
git add frontend/js/hangar.js frontend/css/hangar.css
git commit -m "feat(hangar): active filter chips with individual and clear-all removal"
```

---

## Task 10 — Hangar: compare mode

**Files:**
- Modify: `frontend/hangar.html`
- Modify: `frontend/css/hangar.css`
- Modify: `frontend/js/hangar.js`

- [ ] **Add compare checkbox to the card template.** Find the aircraft card render function in `hangar.js` and add a checkbox in the top-right:

```javascript
// inside card HTML template string
`<label class="compare-check" onclick="event.stopPropagation()">
   <input type="checkbox" data-compare-id="${airplane.id}"
          ${state.compareIds.includes(airplane.id) ? 'checked' : ''}>
   <span>Comparer</span>
 </label>`
```

- [ ] **Initialize `state.compareIds`** from `localStorage` at init:

```javascript
state.compareIds = JSON.parse(localStorage.getItem('vh_compare_ids') || '[]');
```

- [ ] **Add event delegation** for compare checkboxes:

```javascript
document.getElementById('airplanes-container').addEventListener('change', e => {
  const cb = e.target.closest('[data-compare-id]');
  if (!cb) return;
  const id = Number(cb.dataset.compareId);
  if (cb.checked) {
    if (state.compareIds.length >= 3) {
      cb.checked = false;
      showToast('Maximum 3 avions en comparaison', 'warning');
      return;
    }
    state.compareIds.push(id);
  } else {
    state.compareIds = state.compareIds.filter(x => x !== id);
  }
  localStorage.setItem('vh_compare_ids', JSON.stringify(state.compareIds));
  renderCompareBar();
});
```

- [ ] **Add the floating compare bar** at the bottom of `hangar.html` before `</body>`:

```html
<div id="compare-bar" class="compare-bar hidden">
  <span id="compare-count">0 sélectionnés</span>
  <button id="compare-clear" class="btn btn-secondary btn-sm">Effacer</button>
  <button id="compare-view" class="btn btn-primary btn-sm">Voir la comparaison</button>
</div>

<dialog id="compare-modal" class="compare-modal">
  <button class="compare-modal-close" aria-label="Fermer"><i class="fas fa-times"></i></button>
  <div id="compare-modal-body"></div>
</dialog>
```

- [ ] **Add `renderCompareBar()` + `openCompareModal()`** in `hangar.js`:

```javascript
function renderCompareBar() {
  const bar = document.getElementById('compare-bar');
  const n = state.compareIds.length;
  bar.classList.toggle('hidden', n === 0);
  document.getElementById('compare-count').textContent = `${n} sélectionné${n > 1 ? 's' : ''}`;
}

async function openCompareModal() {
  if (state.compareIds.length === 0) return;
  const items = await Promise.all(
    state.compareIds.map(id => fetch(`/api/airplanes/${id}`).then(r => r.json()))
  );
  const fields = [
    ['Image', a => `<img src="${escapeHtml(a.image_url || '')}" alt="" style="width:100%;max-height:120px;object-fit:cover">`],
    ['Nom', a => escapeHtml(a.name)],
    ['Pays', a => escapeHtml(a.country_name || '-')],
    ['Constructeur', a => escapeHtml(a.manufacturer_name || '-')],
    ['Génération', a => a.generation ? `${a.generation}e` : '-'],
    ['Type', a => escapeHtml(a.type_name || '-')],
    ['Vitesse max', a => a.max_speed ? `${a.max_speed} km/h` : '-'],
    ['Portée max', a => a.max_range ? `${a.max_range} km` : '-'],
    ['Poids', a => a.weight ? `${a.weight} kg` : '-'],
    ['Statut', a => escapeHtml(a.status || '-')],
  ];
  const rows = fields
    .map(
      ([label, fn]) =>
        `<tr><th>${label}</th>${items.map(a => `<td>${fn(a)}</td>`).join('')}</tr>`
    )
    .join('');
  document.getElementById('compare-modal-body').innerHTML =
    `<table class="compare-table"><tbody>${rows}</tbody></table>`;
  document.getElementById('compare-modal').showModal();
}

document.getElementById('compare-clear').addEventListener('click', () => {
  state.compareIds = [];
  localStorage.setItem('vh_compare_ids', '[]');
  renderCompareBar();
  renderAirplanes();
});
document.getElementById('compare-view').addEventListener('click', openCompareModal);
document.querySelector('#compare-modal .compare-modal-close').addEventListener('click', () => {
  document.getElementById('compare-modal').close();
});

renderCompareBar();
```

- [ ] **Add CSS** to `hangar.css`:

```css
.compare-check {
  position: absolute;
  top: var(--sp-3);
  right: var(--sp-3);
  background: rgba(13,13,13,.85);
  backdrop-filter: blur(8px);
  padding: var(--sp-2) var(--sp-3);
  border-radius: var(--r-md);
  font-size: var(--text-xs);
  color: var(--text-primary);
  cursor: pointer;
  display: inline-flex;
  align-items: center;
  gap: var(--sp-2);
  z-index: 2;
}
.compare-bar {
  position: fixed;
  bottom: var(--sp-4);
  left: 50%;
  transform: translateX(-50%);
  background: var(--night-mid);
  border: 1px solid var(--border-cyan-md);
  box-shadow: var(--shadow-xl);
  border-radius: var(--r-xl);
  padding: var(--sp-3) var(--sp-4);
  display: flex;
  gap: var(--sp-3);
  align-items: center;
  z-index: var(--z-sticky);
  animation: compare-bar-up .25s var(--ease);
}
@keyframes compare-bar-up {
  from { transform: translate(-50%, 20px); opacity: 0; }
  to   { transform: translate(-50%, 0);    opacity: 1; }
}
.compare-modal {
  background: var(--night-mid);
  color: var(--text-primary);
  border: 1px solid var(--border-cyan-md);
  border-radius: var(--r-xl);
  padding: var(--sp-6);
  max-width: 900px;
  width: 90vw;
}
.compare-modal::backdrop { background: rgba(0,0,0,.75); }
.compare-modal-close {
  position: absolute;
  top: var(--sp-3);
  right: var(--sp-3);
  background: transparent;
  border: none;
  color: var(--text-muted);
  cursor: pointer;
  font-size: var(--text-lg);
}
.compare-table { width: 100%; border-collapse: collapse; }
.compare-table th,
.compare-table td {
  padding: var(--sp-3);
  border-bottom: 1px solid var(--border-subtle);
  text-align: left;
  vertical-align: top;
}
.compare-table th {
  color: var(--hud-cyan);
  font-weight: 600;
  font-size: var(--text-sm);
  width: 140px;
}
.aircraft-card { position: relative; }

@media (max-width: 768px) {
  .compare-table,
  .compare-table tbody,
  .compare-table tr,
  .compare-table th,
  .compare-table td { display: block; width: 100%; }
  .compare-table th { background: var(--night-soft); }
}
```

- [ ] **Manual verify:** tick 3 cards → bar visible → click "Voir la comparaison" → modal with spec table → attempt 4th → toast warning.

- [ ] **Commit:**

```bash
git add frontend/hangar.html frontend/css/hangar.css frontend/js/hangar.js
git commit -m "feat(hangar): compare mode with up to 3 aircraft and spec table modal"
```

---

## Task 11 — Hangar: grid/list view toggle

**Files:**
- Modify: `frontend/hangar.html`
- Modify: `frontend/css/hangar.css`
- Modify: `frontend/js/hangar.js`

- [ ] **Add toggle buttons** in the `.toolbar-right` in `hangar.html` before the sort-select:

```html
<div class="view-toggle" role="group" aria-label="Vue">
  <button id="view-grid" class="view-btn" aria-pressed="true"><i class="fas fa-th"></i></button>
  <button id="view-list" class="view-btn" aria-pressed="false"><i class="fas fa-list"></i></button>
</div>
```

- [ ] **In `hangar.js`**, persist and react to view state:

```javascript
state.view = localStorage.getItem('vh_hangar_view') || 'grid';

function setView(v) {
  state.view = v === 'list' ? 'list' : 'grid';
  localStorage.setItem('vh_hangar_view', state.view);
  document.getElementById('airplanes-container').classList.toggle('aircraft-list', state.view === 'list');
  document.getElementById('airplanes-container').classList.toggle('aircraft-grid', state.view === 'grid');
  document.getElementById('view-grid').setAttribute('aria-pressed', state.view === 'grid');
  document.getElementById('view-list').setAttribute('aria-pressed', state.view === 'list');
  writeStateToUrl();
  renderAirplanes();
}
document.getElementById('view-grid').addEventListener('click', () => setView('grid'));
document.getElementById('view-list').addEventListener('click', () => setView('list'));
setView(state.view);
```

- [ ] **Add CSS** for list view in `hangar.css`:

```css
.view-toggle { display: inline-flex; border: 1px solid var(--border-mid); border-radius: var(--r-md); }
.view-btn {
  background: transparent;
  color: var(--text-muted);
  border: none;
  padding: var(--sp-2) var(--sp-3);
  cursor: pointer;
}
.view-btn[aria-pressed="true"] { color: var(--hud-cyan); background: rgba(200,169,110,.08); }

.aircraft-list { display: flex; flex-direction: column; gap: var(--sp-2); }
.aircraft-list .aircraft-card {
  display: grid;
  grid-template-columns: 80px 1fr auto auto auto;
  gap: var(--sp-4);
  padding: var(--sp-3);
  align-items: center;
}
.aircraft-list .aircraft-card img { width: 80px; height: 60px; object-fit: cover; border-radius: var(--r-sm); }
.aircraft-list .aircraft-card .aircraft-desc { display: none; }
@media (max-width: 768px) {
  .aircraft-list .aircraft-card { grid-template-columns: 80px 1fr; }
  .aircraft-list .aircraft-card > :nth-child(n+3) { display: none; }
}
```

- [ ] **Manual verify:** click list icon → cards become rows → reload → list view persists.

- [ ] **Commit:**

```bash
git add frontend/hangar.html frontend/css/hangar.css frontend/js/hangar.js
git commit -m "feat(hangar): grid/list view toggle with persistence"
```

---

## Task 12 — Hangar: mobile filter sheet

**Files:**
- Modify: `frontend/hangar.html`
- Modify: `frontend/css/hangar.css`
- Modify: `frontend/js/hangar.js`

- [ ] **Add `<dialog id="filter-sheet">`** before `</body>` in `hangar.html`:

```html
<dialog id="filter-sheet" class="filter-sheet">
  <div class="filter-sheet-header">
    <h3>Filtres</h3>
    <button class="filter-sheet-close" aria-label="Fermer"><i class="fas fa-times"></i></button>
  </div>
  <div class="filter-sheet-tabs">
    <button class="fs-tab active" data-tab="country">Pays</button>
    <button class="fs-tab" data-tab="generation">Génération</button>
    <button class="fs-tab" data-tab="type">Type</button>
  </div>
  <div class="filter-sheet-body"></div>
  <div class="filter-sheet-footer">
    <button class="btn btn-primary" id="fs-apply">Appliquer</button>
  </div>
</dialog>
```

- [ ] **CSS** in `hangar.css`:

```css
.filter-sheet {
  border: none;
  padding: 0;
  width: 100%;
  max-width: 100vw;
  max-height: 85vh;
  margin: 0 0 0 auto;
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  background: var(--night-mid);
  color: var(--text-primary);
  border-top: 1px solid var(--border-cyan-md);
  border-radius: var(--r-xl) var(--r-xl) 0 0;
  display: flex;
  flex-direction: column;
}
.filter-sheet::backdrop { background: rgba(0,0,0,.7); }
.filter-sheet-header {
  display: flex; justify-content: space-between; align-items: center;
  padding: var(--sp-4); border-bottom: 1px solid var(--border-subtle);
}
.filter-sheet-tabs { display: flex; border-bottom: 1px solid var(--border-subtle); }
.fs-tab {
  flex: 1; background: transparent; border: none; color: var(--text-muted);
  padding: var(--sp-3); cursor: pointer;
}
.fs-tab.active { color: var(--hud-cyan); border-bottom: 2px solid var(--hud-cyan); }
.filter-sheet-body { flex: 1; overflow-y: auto; padding: var(--sp-4); }
.filter-sheet-footer { padding: var(--sp-4); border-top: 1px solid var(--border-subtle); }

@media (min-width: 768px) { .filter-sheet { display: none !important; } }
```

- [ ] **JS wiring in `hangar.js`** — on mobile, intercept filter button clicks:

```javascript
function isMobile() { return window.matchMedia('(max-width: 767px)').matches; }

function openFilterSheet(initialTab = 'country') {
  const sheet = document.getElementById('filter-sheet');
  const body = sheet.querySelector('.filter-sheet-body');
  let currentTab = initialTab;

  function renderTab() {
    sheet.querySelectorAll('.fs-tab').forEach(t =>
      t.classList.toggle('active', t.dataset.tab === currentTab)
    );
    let items = [];
    if (currentTab === 'country')    items = state.countries.map(c => ({ key: c.name, label: c.name }));
    if (currentTab === 'generation') items = state.generations.map(g => ({ key: g.generation, label: `${g.generation}e` }));
    if (currentTab === 'type')       items = state.types.map(t => ({ key: t.name, label: t.name }));
    body.innerHTML = items.map(it => {
      const active = state.filters[currentTab] == it.key;
      return `<button class="fs-item ${active ? 'active' : ''}" data-key="${escapeHtml(String(it.key))}">${escapeHtml(it.label)}</button>`;
    }).join('');
    body.querySelectorAll('.fs-item').forEach(btn => {
      btn.addEventListener('click', () => {
        const k = btn.dataset.key;
        state.filters[currentTab] = state.filters[currentTab] == k ? null : k;
        renderTab();
      });
    });
  }

  sheet.querySelectorAll('.fs-tab').forEach(t => {
    t.addEventListener('click', () => { currentTab = t.dataset.tab; renderTab(); });
  });
  sheet.querySelector('.filter-sheet-close').addEventListener('click', () => sheet.close());
  document.getElementById('fs-apply').addEventListener('click', () => {
    sheet.close();
    state.currentPage = 1;
    writeStateToUrl();
    renderAirplanes();
    renderActiveFilters();
  });
  renderTab();
  sheet.showModal();
}

// Intercept existing filter buttons on mobile
['country-filter-btn', 'generation-filter-btn', 'type-filter-btn'].forEach(id => {
  const btn = document.getElementById(id);
  if (!btn) return;
  btn.addEventListener('click', e => {
    if (isMobile()) {
      e.stopImmediatePropagation();
      openFilterSheet(id.split('-')[0]);
    }
  }, true); // capture so we run before the existing dropdown handler
});
```

Also add CSS for `.fs-item`:

```css
.fs-item {
  display: block; width: 100%; text-align: left;
  background: transparent; border: 1px solid var(--border-subtle);
  color: var(--text-primary); padding: var(--sp-3); margin-bottom: var(--sp-2);
  border-radius: var(--r-md); cursor: pointer;
}
.fs-item.active { border-color: var(--hud-cyan); color: var(--hud-cyan); }
```

- [ ] **Manual verify (mobile viewport 375px):** tap Country → bottom sheet opens → select → tap Appliquer → sheet closes, grid updates.

- [ ] **Commit:**

```bash
git add frontend/hangar.html frontend/css/hangar.css frontend/js/hangar.js
git commit -m "feat(hangar): mobile filter bottom sheet replacing dropdowns"
```

---

## Task 13 — Details: hero promotion + editorial description

**Files:**
- Modify: `frontend/css/details.css`

- [ ] **Promote hero (full-bleed right column at ≥1024px)** — append to `details.css`:

```css
@media (min-width: 1024px) {
  .hero-main {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: var(--sp-8);
    align-items: stretch;
  }
  .hero-right {
    position: relative;
    right: calc(50% - 50vw);
    width: 50vw;
    max-width: none;
  }
  .hero-right .aircraft-image-container,
  .hero-right img {
    height: 540px;
    width: 100%;
    object-fit: cover;
  }
}
@media (min-width: 768px) and (max-width: 1023px) {
  .hero-right img { max-height: 360px; }
}
```

- [ ] **Editorial description** — append:

```css
.description-section .section-content {
  max-width: 65ch;
}
.description-section .section-content p:first-of-type::first-letter {
  font-family: var(--font-display);
  font-size: 3.4em;
  float: left;
  line-height: .9;
  padding: 4px 8px 0 0;
  color: var(--hud-cyan);
}
```

- [ ] **Manual verify** on desktop, tablet, mobile. Drop cap visible on first paragraph.

- [ ] **Commit:**

```bash
git add frontend/css/details.css
git commit -m "feat(details): promote hero with bleed image and editorial description"
```

---

## Task 14 — Details: chip grids for armament/tech/missions/wars

**Files:**
- Modify: `frontend/js/details.js`
- Modify: `frontend/css/details.css`

- [ ] **Add `renderChipGrid(container, items, iconFn, descFn, nameFn)`** helper at the top of `details.js`:

```javascript
function renderChipGrid(container, items, iconClass, nameFn, descFn) {
  if (!container) return;
  if (!items || items.length === 0) {
    container.innerHTML = `<p class="section-empty">-</p>`;
    return;
  }
  container.className = 'chip-grid';
  container.innerHTML = items.map(it => {
    const name = escapeHtml(nameFn(it));
    const desc = escapeHtml(descFn(it) || '');
    return `
      <button class="chip" type="button" aria-describedby="tt-${it.id}">
        <i class="fas ${iconClass}"></i>
        <span class="chip-label">${name}</span>
        ${desc ? `<span class="chip-tooltip" role="tooltip" id="tt-${it.id}">${desc}</span>` : ''}
      </button>`;
  }).join('');
}
```

- [ ] **Replace the existing armament/tech/missions/wars render calls** in `details.js` with:

```javascript
renderChipGrid(
  document.getElementById('armament-list'),
  armamentData, 'fa-crosshairs',
  x => x.name, x => x.description || x.type
);
renderChipGrid(
  document.getElementById('tech-list'),
  techData, 'fa-microchip',
  x => x.name, x => x.description
);
renderChipGrid(
  document.getElementById('missions-list'),
  missionsData, 'fa-bullseye',
  x => x.name, x => x.description
);
renderChipGrid(
  document.getElementById('wars-list'),
  warsData, 'fa-burst',
  x => x.name, x => `${x.start_year || ''} – ${x.end_year || ''}`
);
```

(Remove or replace the existing calls — look for `armament-list`, `tech-list`, etc. in the current `details.js`.)

- [ ] **Add CSS** to `details.css`:

```css
.chip-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
  gap: var(--sp-2);
}
.chip {
  position: relative;
  background: var(--night-soft);
  border: 1px solid var(--border-subtle);
  color: var(--text-primary);
  padding: var(--sp-2) var(--sp-3);
  border-radius: var(--r-md);
  display: inline-flex;
  align-items: center;
  gap: var(--sp-2);
  cursor: default;
  font-size: var(--text-sm);
  transition: var(--transition-fast);
}
.chip:hover,
.chip:focus-visible {
  border-color: var(--border-cyan-md);
  color: var(--hud-cyan);
}
.chip i { color: var(--hud-cyan); }
.chip-tooltip {
  position: absolute;
  bottom: calc(100% + 6px);
  left: 50%;
  transform: translateX(-50%);
  background: var(--night);
  color: var(--text-primary);
  border: 1px solid var(--border-cyan-md);
  padding: var(--sp-2) var(--sp-3);
  border-radius: var(--r-md);
  font-size: var(--text-xs);
  white-space: normal;
  width: max-content;
  max-width: 280px;
  opacity: 0;
  pointer-events: none;
  transition: opacity .15s var(--ease);
  z-index: 10;
}
.chip:hover .chip-tooltip,
.chip:focus-visible .chip-tooltip { opacity: 1; }
```

- [ ] **Manual verify:** armament/tech/missions/wars now render as chips with tooltips on hover/focus.

- [ ] **Commit:**

```bash
git add frontend/js/details.js frontend/css/details.css
git commit -m "feat(details): render armament/tech/missions/wars as compact chip grids"
```

---

## Task 15 — Details: sticky mini-bar + scroll progress + TOC

**Files:**
- Modify: `frontend/details.html`
- Modify: `frontend/css/details.css`
- Modify: `frontend/js/details.js`

- [ ] **Add mini-bar + progress bar + TOC markup** in `details.html`, right after `<body>` opening:

```html
<div id="scroll-progress" class="scroll-progress"></div>
<div id="mini-bar" class="mini-bar" aria-hidden="true">
  <div class="container">
    <span id="mini-name"></span>
    <span class="mini-stats">
      <span id="mini-speed"></span>
      <span id="mini-range"></span>
      <span id="mini-weight"></span>
    </span>
    <button id="mini-favorite" class="btn btn-favorite btn-sm"><i class="far fa-heart"></i></button>
  </div>
</div>
```

Inside `<main class="container">`, wrap the existing `.content-layout` in:

```html
<div class="details-with-toc">
  <nav id="details-toc" class="details-toc" aria-label="Sections">
    <a href="#desc">Description</a>
    <a href="#dates">Dates clés</a>
    <a href="#armement">Armement</a>
    <a href="#tech">Technologies</a>
    <a href="#missions">Missions</a>
    <a href="#wars">Engagements</a>
  </nav>
  <div class="content-layout"><!-- existing sections --></div>
</div>
```

Add `id="desc"` / `id="dates"` / `id="armement"` / `id="tech"` / `id="missions"` / `id="wars"` to the corresponding `<section>` elements.

- [ ] **CSS** in `details.css`:

```css
.scroll-progress {
  position: fixed;
  top: 0; left: 0;
  height: 2px;
  width: 0;
  background: var(--hud-cyan);
  z-index: calc(var(--z-header) + 1);
  transition: width .08s linear;
}

.mini-bar {
  position: fixed;
  top: var(--header-h);
  left: 0; right: 0;
  background: rgba(13,13,13,.92);
  backdrop-filter: blur(10px);
  border-bottom: 1px solid var(--border-subtle);
  transform: translateY(-100%);
  transition: transform .25s var(--ease);
  z-index: calc(var(--z-header) - 1);
}
body.mini-bar-visible .mini-bar { transform: translateY(0); }
.mini-bar .container {
  display: flex; align-items: center; gap: var(--sp-4);
  padding: var(--sp-3) var(--container-pad);
}
.mini-bar #mini-name { font-family: var(--font-display); font-size: var(--text-lg); color: var(--text-primary); }
.mini-bar .mini-stats { margin-left: auto; display: flex; gap: var(--sp-4); color: var(--text-secondary); font-size: var(--text-sm); }
@media (max-width: 768px) { .mini-bar { display: none; } }

@media (min-width: 1100px) {
  .details-with-toc {
    display: grid;
    grid-template-columns: 180px 1fr;
    gap: var(--sp-8);
  }
  .details-toc {
    position: sticky;
    top: calc(var(--header-h) + var(--sp-8));
    align-self: start;
    display: flex;
    flex-direction: column;
    gap: var(--sp-2);
    border-left: 1px solid var(--border-subtle);
    padding-left: var(--sp-4);
  }
  .details-toc a {
    color: var(--text-muted);
    text-decoration: none;
    font-size: var(--text-sm);
    padding: var(--sp-1) 0;
    transition: var(--transition-fast);
  }
  .details-toc a:hover,
  .details-toc a.active {
    color: var(--hud-cyan);
    border-left: 2px solid var(--hud-cyan);
    margin-left: -18px;
    padding-left: 16px;
  }
}
@media (max-width: 1099px) {
  .details-toc { display: none; }
}
```

- [ ] **JS** at the bottom of the init in `details.js`:

```javascript
// Scroll progress
const progress = document.getElementById('scroll-progress');
function updateProgress() {
  const h = document.documentElement;
  const max = h.scrollHeight - h.clientHeight;
  const pct = max > 0 ? (h.scrollTop / max) * 100 : 0;
  progress.style.width = `${pct}%`;
}
let progressTicking = false;
window.addEventListener('scroll', () => {
  if (!progressTicking) {
    requestAnimationFrame(() => { updateProgress(); progressTicking = false; });
    progressTicking = true;
  }
}, { passive: true });
updateProgress();

// Mini-bar visibility via IntersectionObserver on hero
const heroEl = document.querySelector('.page-hero') || document.querySelector('.hero-main');
if (heroEl) {
  new IntersectionObserver(
    entries => {
      const visible = entries[0].isIntersecting;
      document.body.classList.toggle('mini-bar-visible', !visible);
    },
    { threshold: 0 }
  ).observe(heroEl);
}

// Populate mini-bar fields once details load
function syncMiniBar(a) {
  document.getElementById('mini-name').textContent = a.name || '';
  document.getElementById('mini-speed').textContent = a.max_speed ? `${a.max_speed} km/h` : '';
  document.getElementById('mini-range').textContent = a.max_range ? `${a.max_range} km` : '';
  document.getElementById('mini-weight').textContent = a.weight ? `${a.weight} kg` : '';
}
// call syncMiniBar(aircraft) where aircraft payload is received

// TOC active highlight
const tocLinks = Array.from(document.querySelectorAll('.details-toc a'));
if (tocLinks.length > 0) {
  const sections = tocLinks
    .map(a => document.querySelector(a.getAttribute('href')))
    .filter(Boolean);
  new IntersectionObserver(
    entries => {
      entries.forEach(e => {
        if (e.isIntersecting) {
          const id = e.target.id;
          tocLinks.forEach(l =>
            l.classList.toggle('active', l.getAttribute('href') === `#${id}`)
          );
        }
      });
    },
    { rootMargin: '-30% 0px -60% 0px' }
  ).observe(sections[0]);
  sections.forEach(s => {
    new IntersectionObserver(
      entries => {
        entries.forEach(e => {
          if (e.isIntersecting) {
            tocLinks.forEach(l =>
              l.classList.toggle('active', l.getAttribute('href') === `#${e.target.id}`)
            );
          }
        });
      },
      { rootMargin: '-30% 0px -60% 0px' }
    ).observe(s);
  });
}
```

- [ ] **Manual verify** on desktop ≥1100px: scroll past hero → mini-bar slides in → progress bar fills → TOC highlights current section.

- [ ] **Commit:**

```bash
git add frontend/details.html frontend/css/details.css frontend/js/details.js
git commit -m "feat(details): sticky mini-bar, scroll progress, right-rail TOC"
```

---

## Task 16 — Timeline: horizontal era-scroll rewrite

**Files:**
- Modify: `frontend/timeline.html`
- Modify: `frontend/css/timeline.css`
- Modify: `frontend/js/timeline.js`

- [ ] **Rewrite `timeline.html` body** (inside `<main>` or main section):

```html
<section class="timeline-page">
  <header class="timeline-era-bar" id="era-bar">
    <!-- decade buttons injected by JS -->
  </header>
  <div class="timeline-rail" id="timeline-rail">
    <p class="timeline-loading">Chargement…</p>
  </div>
</section>
```

- [ ] **CSS** in `timeline.css` (replace existing styles for those selectors):

```css
.timeline-page { padding-top: var(--header-h); }

.timeline-era-bar {
  position: sticky;
  top: var(--header-h);
  display: flex;
  gap: var(--sp-3);
  padding: var(--sp-3) var(--container-pad);
  background: rgba(13,13,13,.92);
  backdrop-filter: blur(10px);
  border-bottom: 1px solid var(--border-subtle);
  overflow-x: auto;
  z-index: var(--z-sticky);
}
.era-chip {
  background: transparent;
  border: 1px solid var(--border-subtle);
  color: var(--text-muted);
  padding: var(--sp-2) var(--sp-4);
  border-radius: var(--r-full);
  font-family: var(--font-display);
  letter-spacing: .05em;
  cursor: pointer;
  white-space: nowrap;
  transition: var(--transition-fast);
}
.era-chip.active { color: var(--hud-cyan); border-color: var(--hud-cyan); }

.timeline-rail {
  display: flex;
  overflow-x: auto;
  scroll-snap-type: x mandatory;
  scroll-behavior: smooth;
}
@media (prefers-reduced-motion: reduce) {
  .timeline-rail { scroll-behavior: auto; }
}

.era-section {
  flex: 0 0 100vw;
  scroll-snap-align: start;
  min-height: 70vh;
  position: relative;
  padding: var(--sp-8) var(--container-pad);
}
.era-title {
  font-family: var(--font-display);
  font-size: var(--text-4xl);
  color: var(--hud-cyan);
  letter-spacing: .05em;
  margin-bottom: var(--sp-6);
}

/* Desktop: horizontal axis layout */
@media (min-width: 768px) {
  .era-timeline {
    position: relative;
    height: 420px;
    border-top: 1px dashed var(--border-mid);
    margin-top: 160px;
  }
  .era-tick {
    position: absolute;
    top: -6px;
    width: 1px;
    height: 12px;
    background: var(--border-mid);
  }
  .era-tick span {
    position: absolute;
    top: 16px;
    left: 50%;
    transform: translateX(-50%);
    font-size: var(--text-xs);
    color: var(--text-muted);
    font-family: var(--font-display);
  }
  .era-card {
    position: absolute;
    width: 160px;
    background: var(--night-mid);
    border: 1px solid var(--border-subtle);
    border-radius: var(--r-md);
    padding: var(--sp-2);
    cursor: pointer;
    transition: var(--transition-fast);
  }
  .era-card:hover { border-color: var(--hud-cyan); transform: translateY(-2px); }
  .era-card img { width: 100%; height: 90px; object-fit: cover; border-radius: var(--r-sm); }
  .era-card h4 { font-size: var(--text-sm); margin: var(--sp-2) 0 0; color: var(--text-primary); }
  .era-card .year { font-size: var(--text-xs); color: var(--hud-cyan); font-family: var(--font-display); }
  .era-card::after {
    content: "";
    position: absolute;
    left: 50%;
    width: 1px;
    background: var(--border-cyan);
  }
  .era-card.above { bottom: 220px; }
  .era-card.above::after { top: 100%; height: 60px; }
  .era-card.below { top: 20px; }
  .era-card.below::after { bottom: 100%; height: 60px; }
}

/* Mobile fallback: stacked */
@media (max-width: 767px) {
  .era-timeline { display: flex; flex-direction: column; gap: var(--sp-3); }
  .era-card { display: flex; gap: var(--sp-3); background: var(--night-mid); border: 1px solid var(--border-subtle); padding: var(--sp-3); border-radius: var(--r-md); }
  .era-card img { width: 100px; height: 70px; object-fit: cover; }
  .era-tick { display: none; }
}
```

- [ ] **Rewrite `timeline.js`:**

```javascript
(async function () {
  'use strict';
  const DECADES = [
    { label: '1960s', start: 1960 },
    { label: '1970s', start: 1970 },
    { label: '1980s', start: 1980 },
    { label: '1990s', start: 1990 },
    { label: '2000s', start: 2000 },
    { label: '2010s', start: 2010 },
    { label: '2020s', start: 2020 },
  ];

  const rail = document.getElementById('timeline-rail');
  const bar  = document.getElementById('era-bar');

  // Fetch aircraft
  let airplanes = [];
  try {
    const res = await fetch('/api/airplanes?limit=100');
    const data = await res.json();
    airplanes = Array.isArray(data.data) ? data.data : (data.data || data || []);
  } catch (err) {
    rail.innerHTML = '<p class="timeline-loading">Erreur de chargement.</p>';
    return;
  }

  function yearOf(a) {
    const d = a.date_operationel || a.date_operational || a.date_first_fly;
    if (!d) return null;
    return Number(String(d).slice(0, 4));
  }

  // Group by decade
  const byDecade = DECADES.map(d => ({
    ...d,
    items: airplanes
      .filter(a => {
        const y = yearOf(a);
        return y && y >= d.start && y < d.start + 10;
      })
      .sort((a, b) => yearOf(a) - yearOf(b)),
  }));

  // Render era chips
  bar.innerHTML = byDecade
    .map(
      (d, i) =>
        `<button class="era-chip ${i === 0 ? 'active' : ''}" data-decade="${i}">${d.label}</button>`
    )
    .join('');

  // Render sections
  rail.innerHTML = byDecade.map((d, i) => {
    const ticks = Array.from({ length: 5 }, (_, k) => {
      const year = d.start + k * 2;
      const left = (k / 5) * 100;
      return `<div class="era-tick" style="left:${left}%"><span>${year}</span></div>`;
    }).join('');
    const cards = d.items
      .map((a, idx) => {
        const y = yearOf(a);
        const left = ((y - d.start) / 10) * 100;
        const placement = idx % 2 === 0 ? 'above' : 'below';
        return `
          <a class="era-card ${placement}" href="/details?id=${a.id}" style="left:calc(${left}% - 80px)">
            <img src="${escapeAttr(a.image_url || '')}" alt="${escapeAttr(a.name)}" loading="lazy" width="160" height="90">
            <h4>${escapeHtml(a.name)}</h4>
            <span class="year">${y || ''}</span>
          </a>`;
      })
      .join('');
    return `
      <section class="era-section" id="era-${i}" data-decade="${i}">
        <h2 class="era-title">${d.label}</h2>
        <div class="era-timeline">${ticks}${cards}</div>
      </section>`;
  }).join('');

  function escapeHtml(s) { return String(s || '').replace(/[&<>"']/g, c => ({ '&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;' }[c])); }
  function escapeAttr(s) { return escapeHtml(s); }

  // Chip click → scroll to section
  bar.addEventListener('click', e => {
    const chip = e.target.closest('.era-chip');
    if (!chip) return;
    const idx = Number(chip.dataset.decade);
    const target = document.getElementById(`era-${idx}`);
    target?.scrollIntoView({ behavior: 'smooth', inline: 'start', block: 'nearest' });
  });

  // Active chip tracking
  const sections = Array.from(document.querySelectorAll('.era-section'));
  const io = new IntersectionObserver(
    entries => {
      entries.forEach(e => {
        if (e.isIntersecting) {
          const idx = e.target.dataset.decade;
          document.querySelectorAll('.era-chip').forEach(c =>
            c.classList.toggle('active', c.dataset.decade === idx)
          );
        }
      });
    },
    { root: rail, threshold: 0.5 }
  );
  sections.forEach(s => io.observe(s));

  // Keyboard nav
  window.addEventListener('keydown', e => {
    if (!['ArrowLeft', 'ArrowRight', 'Home', 'End'].includes(e.key)) return;
    const active = document.querySelector('.era-chip.active');
    let idx = Number(active?.dataset.decade || 0);
    if (e.key === 'ArrowRight') idx = Math.min(DECADES.length - 1, idx + 1);
    if (e.key === 'ArrowLeft')  idx = Math.max(0, idx - 1);
    if (e.key === 'Home')       idx = 0;
    if (e.key === 'End')        idx = DECADES.length - 1;
    document.getElementById(`era-${idx}`)?.scrollIntoView({ behavior: 'smooth', inline: 'start' });
  });
})();
```

- [ ] **Manual verify** on desktop: horizontal scroll snaps between decades; cards visible above/below axis; chip highlights update; keyboard `←/→` navigates. Mobile: cards stack vertically, one decade per screen.

- [ ] **Commit:**

```bash
git add frontend/timeline.html frontend/css/timeline.css frontend/js/timeline.js
git commit -m "feat(timeline): horizontal era-scroll with axis layout and keyboard nav"
```

---

## Task 17 — Global polish

**Files:**
- Modify: `frontend/index.html` + every `frontend/*.html` footer
- Modify: `frontend/js/nav.js` (hamburger aria-expanded)
- Modify: `frontend/js/hangar.js` (filter button aria-expanded)

- [ ] **Remove dead footer links.** In every `*.html` that has the footer "Ressources" list, replace:

```html
<li><a href="#" data-i18n="footer.about">À propos (à venir)</a></li>
<li><a href="/contact" data-i18n="footer.contact">Contact</a></li>
<li><a href="#" data-i18n="footer.faq">FAQ (à venir)</a></li>
<li><a href="#" data-i18n="footer.support">Support (à venir)</a></li>
```

with just:

```html
<li><a href="/contact" data-i18n="footer.contact">Contact</a></li>
```

And the "Cookies" link in the legal section gets `id="footer-cookies-link"`:

```html
<li><a href="#" id="footer-cookies-link" data-i18n="footer.cookies">Cookies</a></li>
```

- [ ] **Wire footer cookies link** in `frontend/js/cookies.js` (or `script.js`):

```javascript
document.querySelectorAll('#footer-cookies-link').forEach(link => {
  link.addEventListener('click', e => {
    e.preventDefault();
    document.getElementById('cookie-settings-btn')?.click();
  });
});
```

- [ ] **Add `aria-expanded` toggling to hamburger** in `nav.js` — find the hamburger click handler and add:

```javascript
hamburger.addEventListener('click', () => {
  const open = document.body.classList.toggle('nav-open');
  hamburger.setAttribute('aria-expanded', String(open));
});
hamburger.setAttribute('aria-expanded', 'false');
```

- [ ] **Add `aria-expanded` to filter buttons** in `hangar.js`. In the dropdown toggle handler, toggle `aria-expanded` on the button.

- [ ] **Add `loading="lazy"`** to aircraft card images in `hangar.js` rendering (add `loading="lazy"` to the `<img>` template) and confirm `width`/`height` attributes are set.

- [ ] **Manual verify:** footer has no dead links; hamburger announces state; Lighthouse a11y improved.

- [ ] **Commit:**

```bash
git add frontend/*.html frontend/js/nav.js frontend/js/hangar.js frontend/js/cookies.js
git commit -m "chore(ui): remove dead footer links, add aria-expanded, lazy load grid images"
```

---

## Task 18 — CSS dedupe into components.css

**Files:**
- Create: `frontend/css/components.css`
- Modify: `frontend/css/style.css` (remove duplicates)
- Modify: `frontend/css/shared.css` (remove duplicates)
- Modify: every `frontend/*.html` to link `components.css`

- [ ] **Identify duplicates.** Run:

```bash
grep -n "^\.btn\|^\.modal\|^\.toast\|^\.card\|^\.form-group" frontend/css/style.css frontend/css/shared.css
```

Make a list of rules present in both files with identical or near-identical bodies.

- [ ] **Create `frontend/css/components.css`** and move the shared rules there. Focus on: `.btn`, `.btn-*`, `.modal`, `.modal-*`, `.toast`, `.form-group`, `.form-control`. Keep page-specific overrides in their original files.

- [ ] **Delete moved rules** from `style.css` and `shared.css`. Target ≥ 300 LOC net reduction.

- [ ] **Link `components.css`** in every HTML page right after `shared.css`:

```html
<link rel="stylesheet" href="css/shared.css">
<link rel="stylesheet" href="css/components.css">
```

- [ ] **Manual verify:** visit every page (index, hangar, details, timeline, favorites, login, settings, contact, legal pages) → visually identical to before.

- [ ] **Commit:**

```bash
git add frontend/css/components.css frontend/css/style.css frontend/css/shared.css frontend/*.html
git commit -m "refactor(css): extract shared component rules into components.css"
```

---

## Self-review

**Spec coverage:**
- Loading states → Tasks 2, 3, 4, 5 ✓
- Details hierarchy (hero, sticky mini-bar, description, chip grids, TOC, progress) → Tasks 13, 14, 15 ✓
- Hangar URL state → Task 7 ✓
- Hangar facet counts → Tasks 6, 8 ✓
- Hangar active chips → Task 9 ✓
- Hangar compare mode → Task 10 ✓
- Hangar view toggle → Task 11 ✓
- Hangar mobile sheet → Task 12 ✓
- Timeline rewrite → Task 16 ✓
- Global polish (footer, a11y, lazy) → Tasks 1, 17 ✓
- CSS dedupe → Task 18 ✓
- Backend facets endpoint + test → Task 6 ✓

**Scope check:** Focused on the four audit items; no drift into other pages or backend refactors.

**Notes for executor:**
- Tasks are not micro-steps because this is a UI refinement where most "tests" are manual viewport checks. Backend Task 6 uses strict TDD.
- If a manual verify step reveals a regression, fix inline before committing.
- Visit localhost after every committed task.
