// e2e/tests/cookie-consent.spec.js
// Parcours critique : cookie consent (RGPD)

const base = require('@playwright/test');
const { expect } = base;

// PAS de fixture ici — on veut tester le banner SANS le consent pré-injecté
const test = base.test;

test.describe('Cookie Consent', () => {
  test.beforeEach(async ({ page }) => {
    // Nettoyer le localStorage pour que le banner apparaisse
    await page.addInitScript(() => {
      try {
        window.localStorage.removeItem('voldhistoire_cookie_consent');
        // Forcer FR
        window.localStorage.setItem('vol-histoire-lang', 'fr');
      } catch (_) {}
    });
  });

  test('le banner cookies s\'affiche si pas de consentement', async ({ page }) => {
    await page.goto('/');
    const banner = page.locator('#cookie-banner');
    await expect(banner).toBeVisible({ timeout: 5000 });
  });

  test('accepter tout → banner disparaît + consent enregistré', async ({ page }) => {
    await page.goto('/');
    const banner = page.locator('#cookie-banner');
    await expect(banner).toBeVisible({ timeout: 5000 });

    await page.click('#cookie-accept-btn');

    // Banner disparaît
    await expect(banner).not.toBeVisible({ timeout: 3000 });

    // Consent enregistré dans localStorage
    const consent = await page.evaluate(() =>
      JSON.parse(localStorage.getItem('voldhistoire_cookie_consent'))
    );
    expect(consent.preferences.analytics).toBe(true);
    expect(consent.preferences.essential).toBe(true);
  });

  test('refuser tout → seuls les essentiels activés', async ({ page }) => {
    await page.goto('/');
    await page.waitForSelector('#cookie-banner', { state: 'visible', timeout: 5000 });

    await page.click('#cookie-reject-btn');

    const consent = await page.evaluate(() =>
      JSON.parse(localStorage.getItem('voldhistoire_cookie_consent'))
    );
    expect(consent.preferences.essential).toBe(true);
    expect(consent.preferences.analytics).toBe(false);
    expect(consent.preferences.preference).toBe(false);
  });

  test('ouvrir les paramètres → modal visible avec toggles', async ({ page }) => {
    await page.goto('/');
    await page.waitForSelector('#cookie-banner', { state: 'visible', timeout: 5000 });

    await page.click('#cookie-settings-btn');

    const modal = page.locator('#cookie-modal');
    await expect(modal).toBeVisible({ timeout: 3000 });

    // Les toggles sont visibles
    await expect(page.locator('#cookie-analytics')).toBeVisible();
    await expect(page.locator('#cookie-preference')).toBeVisible();
  });

  test('sauvegarder les préférences personnalisées', async ({ page }) => {
    await page.goto('/');
    await page.waitForSelector('#cookie-banner', { state: 'visible', timeout: 5000 });

    await page.click('#cookie-settings-btn');
    await page.waitForSelector('#cookie-modal.show', { timeout: 3000 });

    // Activer analytics, laisser preference off
    await page.check('#cookie-analytics');
    await page.click('#cookie-save-preferences-btn');

    const consent = await page.evaluate(() =>
      JSON.parse(localStorage.getItem('voldhistoire_cookie_consent'))
    );
    expect(consent.preferences.analytics).toBe(true);
    expect(consent.preferences.preference).toBe(false);
  });

  test('ESC ferme la modal cookies', async ({ page }) => {
    await page.goto('/');
    await page.waitForSelector('#cookie-banner', { state: 'visible', timeout: 5000 });

    await page.click('#cookie-settings-btn');
    await page.waitForSelector('#cookie-modal.show', { timeout: 3000 });

    await page.keyboard.press('Escape');

    const modal = page.locator('#cookie-modal');
    await expect(modal).not.toHaveClass(/show/, { timeout: 2000 });
  });

  test('le banner ne réapparaît pas après consentement', async ({ page }) => {
    await page.goto('/');
    await page.waitForSelector('#cookie-banner', { state: 'visible', timeout: 5000 });
    await page.click('#cookie-accept-btn');

    // Recharger la page
    await page.reload();
    await page.waitForTimeout(2000);

    const banner = page.locator('#cookie-banner');
    await expect(banner).not.toBeVisible();
  });
});
