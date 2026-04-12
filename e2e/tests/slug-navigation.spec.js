// e2e/tests/slug-navigation.spec.js
// Parcours critique : URL slugs SEO-friendly pour les fiches avion

const { test, expect } = require('../helpers/fixtures');

test.describe('URL Slugs', () => {
  test('le hangar navigue vers une URL slug au clic sur une carte', async ({ page }) => {
    await page.goto('/hangar');
    await page.waitForSelector('.aircraft-card', { timeout: 10000 });

    const firstCard = page.locator('.aircraft-card').first();
    await firstCard.click();

    // L'URL doit être /details/<slug>-<id> et non /details?id=<id>
    await page.waitForURL(/\/details\/[a-z0-9-]+-\d+/);
    const url = page.url();
    expect(url).not.toContain('?id=');
  });

  test('une URL slug valide charge la fiche avion', async ({ page }) => {
    // D'abord on récupère un slug réel depuis le hangar
    await page.goto('/hangar');
    await page.waitForSelector('.aircraft-card', { timeout: 10000 });

    const firstCard = page.locator('.aircraft-card').first();
    const name = await firstCard.locator('h3').textContent();
    await firstCard.click();
    await page.waitForURL(/\/details\//);

    // Attendre que le JS charge les données et rende le nom
    await page.waitForFunction(
      () => document.getElementById('aircraft-name')?.textContent?.length > 0,
      null,
      { timeout: 10000 }
    );

    const h1 = await page.locator('#aircraft-name').textContent();
    expect(h1).toBe(name);
  });

  test('le breadcrumb s\'affiche correctement sur la page details', async ({ page }) => {
    await page.goto('/hangar');
    await page.waitForSelector('.aircraft-card', { timeout: 10000 });

    await page.locator('.aircraft-card').first().click();
    await page.waitForURL(/\/details\//);

    const breadcrumb = page.locator('.breadcrumb, nav[aria-label="Breadcrumb"]');
    await expect(breadcrumb).toBeVisible();
  });

  test('history.replaceState met à jour l\'URL en slug propre', async ({ page }) => {
    // Accès via l'ancien format ?id= doit être remplacé par le slug
    const apiRes = await page.request.get('/api/airplanes?page=1');
    const data = await apiRes.json();
    const airplane = data.data[0];

    await page.goto(`/details?id=${airplane.id}`);

    // Attendre que le JS charge et remplace l'URL
    await page.waitForFunction(
      () => /\/details\/[a-z0-9-]+-\d+$/.test(window.location.pathname),
      null,
      { timeout: 10000 }
    );

    const url = page.url();
    expect(url).toMatch(/\/details\/[a-z0-9-]+-\d+$/);
    expect(url).not.toContain('?id=');
  });

  test('le sitemap XML contient des URL slugs', async ({ page }) => {
    const res = await page.request.get('/sitemap.xml');
    expect(res.status()).toBe(200);
    const xml = await res.text();

    // Doit contenir /details/<slug>-<id> et non /details?id=
    expect(xml).toMatch(/\/details\/[a-z0-9-]+-\d+/);
    expect(xml).not.toContain('/details?id=');
  });

  test('la page favorites navigue en slug au clic', async ({ page }) => {
    // Login via API avec les credentials de test
    const { loginViaApi } = require('../helpers/auth');
    await loginViaApi(page, 'test@gmail.com', 'test');

    await page.goto('/favorites');
    await page.waitForTimeout(3000);

    // S'il y a des favoris, vérifier que le clic navigue en slug
    const cards = page.locator('.aircraft-card');
    const count = await cards.count();
    if (count > 0) {
      await cards.first().click();
      await page.waitForURL(/\/details\/[a-z0-9-]+-\d+/);
    }
  });
});
