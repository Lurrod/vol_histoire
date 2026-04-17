// e2e/tests/timeline-interaction.spec.js
// Parcours critique : timeline interactive (navigation, décennies, fiches avion)

const { test, expect } = require('../helpers/fixtures');

test.describe('Timeline', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/timeline');
    // Attendre que le loader disparaisse et que les chapitres se chargent
    await page.waitForSelector('.tl-chapter', { timeout: 15000 });
  });

  test('les chapitres par décennie sont rendus', async ({ page }) => {
    const chapters = page.locator('.tl-chapter');
    const count = await chapters.count();
    expect(count).toBeGreaterThanOrEqual(1);
  });

  test('chaque chapitre affiche le numéro de décennie', async ({ page }) => {
    const decadeNums = page.locator('.tl-decade-num');
    const first = await decadeNums.first().textContent();
    expect(first).toMatch(/^\d{4}$/); // ex: "1950"
  });

  test('les cartes avion sont présentes dans les chapitres', async ({ page }) => {
    const cards = page.locator('.tl-plane-card');
    const count = await cards.count();
    expect(count).toBeGreaterThanOrEqual(1);
  });

  test('clic sur une carte avion → navigation vers /details/', async ({ page }) => {
    const firstCard = page.locator('.tl-plane-card').first();
    const href = await firstCard.getAttribute('href');
    expect(href).toMatch(/^\/details\//);

    await firstCard.click();
    await page.waitForURL(/\/details\//);
  });

  test('les liens avion utilisent les URL slugs', async ({ page }) => {
    const firstCard = page.locator('.tl-plane-card').first();
    const href = await firstCard.getAttribute('href');
    // Format attendu : /details/<slug>-<id> (ex: /details/f-22-raptor-12)
    expect(href).toMatch(/^\/details\/[a-z0-9-]+-\d+$/);
  });

  test('la minimap est présente et contient des boutons', async ({ page }) => {
    // Scroller un peu pour que la minimap apparaisse
    await page.evaluate(() => window.scrollBy(0, 800));
    await page.waitForTimeout(500);

    const minimap = page.locator('#tl-minimap');
    await expect(minimap).toBeAttached();

    const buttons = minimap.locator('.tl-mm-btn');
    const count = await buttons.count();
    expect(count).toBeGreaterThanOrEqual(1);
  });

  test('la barre de progression scroll existe', async ({ page }) => {
    const progress = page.locator('#tl-progress');
    await expect(progress).toBeAttached();
  });

  test('navigation clavier — ArrowDown déplace vers le chapitre suivant', async ({ page }) => {
    const firstChapter = page.locator('.tl-chapter').first();
    const firstTop = await firstChapter.evaluate(el => el.getBoundingClientRect().top);

    await page.keyboard.press('ArrowDown');
    await page.waitForTimeout(600); // smooth scroll

    const newTop = await firstChapter.evaluate(el => el.getBoundingClientRect().top);
    expect(newTop).toBeLessThan(firstTop);
  });

  test('les stats d\'intro sont animées (aircraft count > 0)', async ({ page }) => {
    const statEl = page.locator('#tl-stat-aircraft');
    await expect(statEl).toBeAttached();
    // Attendre que l'animation termine
    await page.waitForTimeout(2000);
    const text = await statEl.textContent();
    expect(Number(text)).toBeGreaterThan(0);
  });

  test('clic sur un bouton de la minimap met à jour l\'état actif', async ({ page }) => {
    await page.evaluate(() => window.scrollBy(0, 800));
    await page.waitForTimeout(500);

    const buttons = page.locator('#tl-minimap .tl-mm-btn');
    const count = await buttons.count();
    if (count < 2) test.skip(true, 'Pas assez de chapitres pour tester le switch');

    // Clique sur le dernier bouton (garantit un changement)
    const targetBtn = buttons.nth(count - 1);
    await targetBtn.click();
    await page.waitForTimeout(800);

    // Feedback immédiat : le bouton cliqué doit porter la classe active
    await expect(targetBtn).toHaveClass(/active/);

    // Et il doit être le seul actif
    const activeCount = await page.locator('#tl-minimap .tl-mm-btn.active').count();
    expect(activeCount).toBe(1);
  });
});
