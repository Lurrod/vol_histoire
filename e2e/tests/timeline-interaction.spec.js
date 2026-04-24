// e2e/tests/timeline-interaction.spec.js
// Parcours critique : timeline « Le Journal de Bord » (v4.3.0)
// - Hero couverture : stamp + 3 stats animés
// - Chapitres par décennie : title card + narratif + événements + grille avions
// - Navigation : minimap, clavier, HUD décennie, progress bar

const { test, expect } = require('../helpers/fixtures');

test.describe('Timeline — Journal de Bord', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/timeline');
    // Attendre que le loader disparaisse et que les chapitres soient injectés
    await page.waitForSelector('.tl-chapter', { timeout: 15000 });
  });

  /* ------------------------- HERO / COUVERTURE -------------------------- */

  test('la couverture affiche le tampon « Dossier · VH · 01 »', async ({ page }) => {
    const stamp = page.locator('.tl-intro-stamp');
    await expect(stamp).toBeVisible();
    await expect(stamp).toContainText(/VH/);
  });

  test('les 3 stats d\'intro s\'animent (événements + appareils + décennies > 0)', async ({ page }) => {
    const statEvents = page.locator('#tl-stat-events');
    const statAircraft = page.locator('#tl-stat-aircraft');
    const statDecades = page.locator('#tl-stat-decades');

    await expect(statEvents).toBeAttached();
    await expect(statAircraft).toBeAttached();
    await expect(statDecades).toBeAttached();

    await page.waitForTimeout(2000); // attend la fin de l'animation de compteurs

    expect(Number(await statEvents.textContent())).toBeGreaterThan(0);
    expect(Number(await statAircraft.textContent())).toBeGreaterThan(0);
    expect(Number(await statDecades.textContent())).toBeGreaterThan(0);
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

  test('la minimap apparaît après avoir quitté la couverture', async ({ page }) => {
    await page.evaluate(() => window.scrollBy(0, window.innerHeight + 200));
    await page.waitForTimeout(500);

    const minimap = page.locator('#tl-minimap');
    await expect(minimap).toBeAttached();
    const buttons = minimap.locator('.tl-mm-btn');
    expect(await buttons.count()).toBeGreaterThanOrEqual(1);
  });

  test('la barre de progression scroll existe et change de largeur au scroll', async ({ page }) => {
    const progress = page.locator('#tl-progress');
    await expect(progress).toBeAttached();

    await page.evaluate(() => window.scrollBy(0, 2000));
    await page.waitForTimeout(300);

    const width = await progress.evaluate(el => el.style.width);
    expect(width).toMatch(/\d+(\.\d+)?%/); // ex: "12.5%"
    expect(parseFloat(width)).toBeGreaterThan(0);
  });

  test('le HUD décennie fixe apparaît après la couverture', async ({ page }) => {
    const hud = page.locator('#tl-year-hud');
    await expect(hud).toBeAttached();

    await page.evaluate(() => window.scrollBy(0, window.innerHeight + 400));
    await page.waitForTimeout(600);

    await expect(hud).toHaveClass(/visible/);
    const num = await page.locator('#tl-year-hud-num').textContent();
    expect(num).toMatch(/^\d{4}s$/); // ex: "1940s"
  });

  test('navigation clavier — ArrowDown scrolle vers le chapitre suivant', async ({ page }) => {
    const firstChapter = page.locator('.tl-chapter').first();
    const firstTop = await firstChapter.evaluate(el => el.getBoundingClientRect().top);

    await page.keyboard.press('ArrowDown');
    await page.waitForTimeout(700); // smooth scroll

    const newTop = await firstChapter.evaluate(el => el.getBoundingClientRect().top);
    expect(newTop).toBeLessThan(firstTop);
  });

  test('clic minimap → bouton actif + scroll vers le chapitre ciblé', async ({ page }) => {
    await page.evaluate(() => window.scrollBy(0, window.innerHeight + 200));
    await page.waitForTimeout(500);

    const buttons = page.locator('#tl-minimap .tl-mm-btn');
    const count = await buttons.count();
    if (count < 2) test.skip(true, 'Moins de 2 décennies disponibles — impossible de tester le switch');

    // Bouton cible = dernier bouton (garantit un saut visible)
    const targetBtn = buttons.nth(count - 1);
    const targetId = await targetBtn.getAttribute('data-target');
    await targetBtn.click();
    await page.waitForTimeout(900);

    // Feedback immédiat : classe .active sur le bouton cliqué
    await expect(targetBtn).toHaveClass(/active/);
    const activeCount = await page.locator('#tl-minimap .tl-mm-btn.active').count();
    expect(activeCount).toBe(1);

    // Le chapitre ciblé est désormais proche du haut (ancre ≈ 35% viewport)
    const vh = await page.evaluate(() => window.innerHeight);
    const top = await page.locator('#' + targetId).evaluate(el => el.getBoundingClientRect().top);
    expect(top).toBeLessThan(vh);
  });

  /* ------------------------------ API ---------------------------------- */

  test('GET /api/timeline répond 200 + structure { decades: [...] }', async ({ request }) => {
    const res = await request.get('/api/timeline');
    expect(res.status()).toBe(200);
    const body = await res.json();
    expect(Array.isArray(body.decades)).toBe(true);
    expect(body.decades.length).toBe(9); // 1940 → 2020
    const withEvents = body.decades.filter(d => (d.events?.length || 0) > 0);
    expect(withEvents.length).toBeGreaterThan(0);
  });
});
