// e2e/tests/onboarding.spec.js
// Visite guidée de la première connexion (frontend/js/onboarding.js) : elle
// s'ouvre sur l'accueil, le projecteur suit les étapes, et une fois fermée
// elle ne revient plus.
const { test, expect } = require('../helpers/fixtures');
const { loginViaApi } = require('../helpers/auth');

test.describe('Visite guidée', () => {
  test.beforeEach(async ({ page }) => {
    // Le fixture marque la visite comme vue ; on annule pour ce scénario.
    // Script enregistré après celui du fixture : il s'exécute après lui.
    await page.addInitScript(() => {
      if (!window.sessionStorage.getItem('ob-seen-once')) {
        window.localStorage.removeItem('vh-onboarding-done');
      }
    });
  });

  test('s’ouvre à la première connexion, se parcourt et ne revient pas', async ({ page }) => {
    await loginViaApi(page, 'user@test.local', 'Testuser1');
    await page.goto('/');

    const dialog = page.locator('.ob[role="dialog"]');
    await expect(dialog).toBeVisible({ timeout: 8000 });
    await expect(page.locator('.ob-title')).toContainText('Bienvenue à bord');

    // Étape « recherche » : le projecteur se pose sur le formulaire.
    await page.click('.ob-next');
    await expect(page.locator('.ob-title')).toHaveText('Cherchez un appareil');
    await expect(dialog).not.toHaveClass(/ob-centered/);

    // Échap ferme et mémorise.
    await page.keyboard.press('Escape');
    await expect(dialog).toHaveCount(0, { timeout: 3000 });
    expect(await page.evaluate(() => window.localStorage.getItem('vh-onboarding-done'))).toBe('1');

    // Rechargement : la visite ne revient pas.
    await page.evaluate(() => window.sessionStorage.setItem('ob-seen-once', '1'));
    await page.reload();
    await page.waitForTimeout(2500);
    await expect(page.locator('.ob')).toHaveCount(0);
  });
});
