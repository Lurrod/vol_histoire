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
        window.localStorage.setItem('vol-histoire-lang', 'fr');
      } catch {}
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
    await expect(banner).not.toBeVisible({ timeout: 3000 });

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

  test('ouvrir les paramètres → modal visible', async ({ page }) => {
    await page.goto('/');
    await page.waitForSelector('#cookie-banner', { state: 'visible', timeout: 5000 });

    await page.click('#cookie-settings-btn');

    const modal = page.locator('#cookie-modal');
    await expect(modal).toBeVisible({ timeout: 3000 });

    // Le bouton sauvegarder est visible dans la modal
    await expect(page.locator('#cookie-save-preferences-btn')).toBeVisible();
  });

  test('sauvegarder les préférences personnalisées', async ({ page }) => {
    await page.goto('/');
    await page.waitForSelector('#cookie-banner', { state: 'visible', timeout: 5000 });

    await page.click('#cookie-settings-btn');
    await page.waitForSelector('#cookie-modal.show', { timeout: 3000 });

    // La checkbox est cachée par CSS (custom toggle) → cocher via evaluate
    await page.evaluate(() => {
      const cb = document.getElementById('cookie-analytics');
      if (cb && !cb.checked) {
        cb.checked = true;
        cb.dispatchEvent(new Event('change', { bubbles: true }));
      }
    });
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

  test('le banner ne réapparaît pas après consentement', async ({ context }) => {
    // Utiliser un contexte frais SANS le beforeEach initScript qui supprime le consent
    const page = await context.newPage();

    // Injecter un consent valide AVANT de naviguer
    await page.addInitScript(() => {
      try {
        window.localStorage.setItem('voldhistoire_cookie_consent', JSON.stringify({
          preferences: { essential: true, analytics: true, preference: false, marketing: false },
          timestamp: new Date().toISOString(),
          version: '1.0',
        }));
        window.localStorage.setItem('vol-histoire-lang', 'fr');
      } catch {}
    });

    await page.goto('/');
    await page.waitForTimeout(2000);

    const banner = page.locator('#cookie-banner');
    await expect(banner).not.toBeVisible();
  });
});
