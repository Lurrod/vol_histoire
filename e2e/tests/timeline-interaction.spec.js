// e2e/tests/timeline-interaction.spec.js
// Parcours critique : frise « Le Journal de Bord »
// - Couverture : 3 compteurs (événements, appareils, conflits)
// - Chapitres par décennie : title card + récit + événements + conflits +
//   appareils marquants + piste année par année + lien vers le hangar
// - Règle des années : année courante, un bouton par décennie, filtres
// - Rendu serveur : le texte des chapitres existe sans JavaScript

const { test, expect } = require('../helpers/fixtures');

test.describe('Timeline — Journal de Bord', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/timeline');
    // Le serveur rend déjà les chapitres (.tl-chapter--ssr) : attendre la
    // version interactive qui les remplace.
    await page.waitForSelector('.tl-chapter:not(.tl-chapter--ssr)', { timeout: 15000 });
  });

  /* ------------------------- HERO / COUVERTURE -------------------------- */

  test('les 3 stats d\'intro s\'animent (événements + appareils > 0, conflits ≥ 0)', async ({ page }) => {
    const statEvents = page.locator('#tl-stat-events');
    const statAircraft = page.locator('#tl-stat-aircraft');
    const statWars = page.locator('#tl-stat-wars');

    await expect(statEvents).toBeAttached();
    await expect(statAircraft).toBeAttached();
    await expect(statWars).toBeAttached();

    // Compteurs « odomètre » : la valeur lisible est dans .sr-only, posée dès
    // le départ de l'animation (les colonnes de chiffres sont aria-hidden).
    const value = async (stat) => {
      await expect(stat.locator('.sr-only')).toHaveText(/^\d+$/, { timeout: 8000 });
      return Number(await stat.locator('.sr-only').textContent());
    };
    expect(await value(statEvents)).toBeGreaterThan(0);
    expect(await value(statAircraft)).toBeGreaterThan(0);
    expect(await value(statWars)).toBeGreaterThanOrEqual(0);
  });

  /* ------------------------------ CHAPITRES ----------------------------- */

  test('au moins un chapitre par décennie est rendu', async ({ page }) => {
    const chapters = page.locator('.tl-chapter');
    const count = await chapters.count();
    expect(count).toBeGreaterThanOrEqual(1);
  });

  test('chaque chapitre a une title card avec numéro de décennie', async ({ page }) => {
    const first = page.locator('.tl-chapter').first();
    await expect(first.locator('.tl-title-card')).toBeVisible();
    const decadeNum = await first.locator('.tl-title-decade-num').first().textContent();
    expect(decadeNum).toMatch(/^\d{4}$/); // ex: "1940"
  });

  test('chaque chapitre affiche un numéro de chapitre et un libellé d\'ère', async ({ page }) => {
    const first = page.locator('.tl-chapter').first();
    await expect(first.locator('.tl-title-chapter')).toContainText(/Chapitre/i);
    await expect(first.locator('.tl-title-label')).toBeVisible();
    await expect(first.locator('.tl-title-era')).toBeVisible();
  });

  /* ---------------------------- NARRATIF -------------------------------- */

  test('chaque chapitre affiche un paragraphe narratif', async ({ page }) => {
    const first = page.locator('.tl-chapter').first();
    const narrative = first.locator('.tl-narrative-text');
    await expect(narrative).toBeVisible();
    const text = await narrative.textContent();
    expect(text.trim().length).toBeGreaterThan(80); // paragraphe éditorial non vide
  });

  /* --------------------------- ÉVÉNEMENTS ------------------------------- */

  test('au moins un événement éditorial est rendu avec type + année', async ({ page }) => {
    // On attend d'avoir au moins un .tl-event quelque part dans la frise
    await page.waitForSelector('.tl-event', { timeout: 10000 });
    const ev = page.locator('.tl-event').first();
    await expect(ev).toBeAttached();

    // Pastille de type (jalon / guerre / techno / doctrine / rupture)
    const kind = ev.locator('.tl-event-kind');
    await expect(kind).toBeAttached();
    const kindText = (await kind.textContent()).trim();
    expect(kindText.length).toBeGreaterThan(0);

    // Année sur le rail
    const year = ev.locator('.tl-event-year');
    const yearText = (await year.textContent()).trim();
    expect(yearText).toMatch(/^\d{4}$/);

    // Titre + corps
    await expect(ev.locator('.tl-event-title')).toBeVisible();
    await expect(ev.locator('.tl-event-text')).toBeAttached();
  });

  test('les événements avec airplane_id exposent une carte vers /details/', async ({ page }) => {
    // Certains événements sont liés à un avion — on vérifie qu'au moins un lien existe
    const planeLinks = page.locator('.tl-event-plane');
    const count = await planeLinks.count();
    if (count === 0) test.skip(true, 'Aucun événement lié à un avion dans le jeu de données');

    const firstLink = planeLinks.first();
    const href = await firstLink.getAttribute('href');
    expect(href).toMatch(/^\/details\/[a-z0-9-]+-\d+$/);
  });

  /* ------------------------- GRILLE APPAREILS --------------------------- */

  test('la grille d\'appareils d\'une décennie contient des cartes', async ({ page }) => {
    const cards = page.locator('.tl-plane-card');
    const count = await cards.count();
    expect(count).toBeGreaterThanOrEqual(1);
  });

  test('clic sur une carte avion → navigation vers /details/<slug>-<id>', async ({ page }) => {
    const firstCard = page.locator('.tl-plane-card').first();
    // Scroll vers la carte pour garantir qu'elle est dans le viewport avant le clic
    await firstCard.scrollIntoViewIfNeeded();
    const href = await firstCard.getAttribute('href');
    expect(href).toMatch(/^\/details\/[a-z0-9-]+-\d+$/);

    await firstCard.click();
    await page.waitForURL(/\/details\//);
  });

  /* ------------------------------ HUD / NAV ----------------------------- */

  test('la règle des années colle sous l\'en-tête et affiche l\'année courante', async ({ page }) => {
    await page.evaluate(() => window.scrollTo({ top: document.getElementById('tl-chapters').offsetTop + 400, behavior: 'instant' }));
    await page.waitForTimeout(600);

    const bar = page.locator('#tl-bar');
    const box = await bar.boundingBox();
    expect(box.y).toBeLessThan(140); // collée sous l'en-tête, pas défilée hors écran
    // Odomètre : la valeur lisible est dans .sr-only.
    await expect(page.locator('#tl-bar-year .sr-only')).toHaveText(/^(19[4-9]\d|20[0-2]\d)$/);
    expect(await page.locator('#tl-ruler .tl-tick').count()).toBeGreaterThanOrEqual(1);
  });

  test('navigation clavier — ArrowDown scrolle vers le chapitre suivant', async ({ page }) => {
    const firstChapter = page.locator('.tl-chapter').first();
    const firstTop = await firstChapter.evaluate(el => el.getBoundingClientRect().top);

    await page.keyboard.press('ArrowDown');
    await page.waitForTimeout(700); // smooth scroll

    const newTop = await firstChapter.evaluate(el => el.getBoundingClientRect().top);
    expect(newTop).toBeLessThan(firstTop);
  });

  test('clic sur une décennie de la règle → décennie active + chapitre ciblé à l\'écran', async ({ page }) => {
    const ticks = page.locator('#tl-ruler .tl-tick');
    const count = await ticks.count();
    if (count < 2) test.skip(true, 'Moins de 2 décennies disponibles — impossible de tester le saut');

    const target = ticks.nth(count - 1);
    const targetId = await target.getAttribute('data-target');
    await target.click();
    await page.waitForTimeout(1200);

    await expect(target).toHaveAttribute('aria-current', 'true');
    expect(await page.locator('#tl-ruler .tl-tick.active').count()).toBe(1);
    const vh = await page.evaluate(() => window.innerHeight);
    const top = await page.locator('#' + targetId).evaluate(el => el.getBoundingClientRect().top);
    expect(top).toBeLessThan(vh);
  });

  test('filtre par nation : URL partageable, frise filtrée, retour à tout afficher', async ({ page }) => {
    const nations = await page.locator('#tl-lens-nation option').evaluateAll(opts => opts.map(o => o.value).filter(Boolean));
    if (nations.length < 2) test.skip(true, 'Une seule nation dans le jeu de données');
    const total = await page.locator('.tl-plane-card, .tl-chip').count();

    // Le <select> natif reste la source de vérité (masqué sous la liste personnalisée).
    await page.evaluate(v => {
      const sel = document.getElementById('tl-lens-nation');
      sel.value = v;
      sel.dispatchEvent(new Event('change', { bubbles: true }));
    }, nations[0]);
    await expect(page).toHaveURL(new RegExp('nation=' + encodeURIComponent(nations[0]).replace(/%20/g, '(\\+|%20)')));
    const filtered = await page.locator('.tl-plane-card, .tl-chip').count();
    expect(filtered).toBeLessThan(total);
    await expect(page.locator('#tl-lens-reset')).toBeVisible();

    await page.locator('#tl-lens-reset').click();
    await expect(page).not.toHaveURL(/nation=/);
    expect(await page.locator('.tl-plane-card, .tl-chip').count()).toBe(total);
  });

  test('lien « Voir ces appareils dans le hangar » → hangar filtré sur la décennie', async ({ page }) => {
    const link = page.locator('.tl-hangar-link').first();
    const href = await link.getAttribute('href');
    expect(href).toMatch(/^\/hangar\?decade=(19[4-9]0|20[0-2]0)$/);
    await link.scrollIntoViewIfNeeded();
    await link.click();
    await page.waitForURL(/\/hangar\?decade=/);
    await expect(page.locator('.active-filter')).toContainText(/Années|s$/);
  });

  /* ------------------------------ API ---------------------------------- */

  test('GET /api/timeline répond 200 + structure { decades: [...] }', async ({ request }) => {
    const res = await request.get('/api/timeline');
    expect(res.status()).toBe(200);
    const body = await res.json();
    expect(Array.isArray(body.decades)).toBe(true);
    expect(Array.isArray(body.wars)).toBe(true);
    expect(body.decades.length).toBe(9); // 1940 → 2020
    const withEvents = body.decades.filter(d => (d.events?.length || 0) > 0);
    expect(withEvents.length).toBeGreaterThan(0);
  });
});

test.describe('Timeline — rendu serveur', () => {
  test('sans JavaScript, la page contient le texte des chapitres', async ({ browser }) => {
    const ctx = await browser.newContext({ javaScriptEnabled: false });
    const page = await ctx.newPage();
    await page.goto('/timeline');
    const chapters = page.locator('.tl-chapter--ssr');
    expect(await chapters.count()).toBeGreaterThanOrEqual(1);
    await expect(chapters.first().locator('.tl-narrative-text')).not.toBeEmpty();
    expect(await page.locator('.tl-chapter--ssr a.tl-chip').count()).toBeGreaterThanOrEqual(1);
    await ctx.close();
  });
});
