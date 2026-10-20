// e2e/tests/home-landing.spec.js
//
// Accueil v4.10.0 : la page montre le catalogue au lieu de décrire le site.
// On vérifie ce que le visiteur fait réellement — chercher un appareil par
// les premières lettres de son nom, entrer par une génération ou une mission —
// sans dépendre du nombre de fiches (la CI n'en sème que cinq, la prod 383).
const { test, expect } = require('../helpers/fixtures');

test.describe('Accueil — recherche du hero', () => {
  test('les premières lettres suffisent, la flèche puis Entrée ouvrent la fiche', async ({ page }) => {
    await page.goto('/');
    const input = page.locator('#hero-search-input');
    await input.fill('raf');

    const option = page.locator('#hero-suggest [role="option"]').first();
    await expect(option).toContainText('Rafale', { timeout: 10000 });
    await expect(input).toHaveAttribute('aria-expanded', 'true');

    await input.press('ArrowDown');
    await expect(input).toHaveAttribute('aria-activedescendant', 'hero-suggest-opt-0');
    await input.press('Enter');
    await page.waitForURL(/\/details\/rafale-\d+/, { timeout: 10000 });
  });

  test('Entrée sans suggestion choisie ouvre le hangar filtré', async ({ page }) => {
    await page.goto('/');
    const input = page.locator('#hero-search-input');
    await input.fill('Rafale');
    await input.press('Enter');
    await page.waitForURL(/\/hangar\?q=Rafale/, { timeout: 10000 });
  });

  test('Échap ferme la liste de suggestions', async ({ page }) => {
    await page.goto('/');
    const input = page.locator('#hero-search-input');
    await input.fill('mig');
    await expect(page.locator('#hero-suggest')).toBeVisible({ timeout: 10000 });
    await input.press('Escape');
    await expect(page.locator('#hero-suggest')).toBeHidden();
  });
});

test.describe('Accueil — entrées par génération et par mission', () => {
  test('cinq tuiles de génération, chacune vers le hangar filtré', async ({ page }) => {
    await page.goto('/');
    const tiles = page.locator('.gen-tile');
    await expect(tiles).toHaveCount(5);
    for (let n = 1; n <= 5; n++) {
      await expect(tiles.nth(n - 1)).toHaveAttribute('href', `/hangar?gen=${n}`);
    }
    // La 4e génération est semée en CI (Rafale, Su-27, Mirage 2000) : son
    // compteur vient de l'API, pas du HTML.
    await expect(page.locator('[data-gen-count="4"]')).toHaveText(/^\d+ fiches?$/, { timeout: 10000 });
  });

  test('les types de mission sont rangés en familles et mènent au hangar', async ({ page }) => {
    await page.goto('/');
    const family = page.locator('.mission-family').first();
    await expect(family).toBeVisible({ timeout: 10000 });
    const link = family.locator('.mission-type').first();
    await expect(link).toHaveAttribute('href', /^\/hangar\?type=/);
    await link.click();
    await page.waitForURL(/\/hangar\?type=/, { timeout: 10000 });
  });
});

test.describe('Accueil — fin de page et langue', () => {
  test('un visiteur anonyme est invité à créer un compte', async ({ page }) => {
    await page.goto('/');
    const actions = page.locator('#home-end-actions');
    await expect(actions.locator('a[href="/login"]')).toBeVisible();
    await expect(page.locator('#home-end-favs')).toBeHidden();
  });

  test('la page est traduite en anglais, sections dynamiques comprises', async ({ page }) => {
    await page.addInitScript(() => window.localStorage.setItem('vol-histoire-lang', 'en'));
    await page.goto('/');
    await expect(page.locator('#gen-title')).toHaveText('Eighty years in five steps');
    await expect(page.locator('#missions-title')).toHaveText('Not just fighters');
    await expect(page.locator('[data-gen-count="4"]')).toHaveText(/^\d+ aircraft$/, { timeout: 10000 });
    await expect(page.locator('.mission-family-title').first()).toContainText('Combat');
  });
});
