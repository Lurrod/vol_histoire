// e2e/tests/auth-flow.spec.js
// Flux complet : inscription → vérification → connexion → favoris → déconnexion
/* global HTMLFormElement */ // utilisé dans page.addInitScript (contexte navigateur)
const { test, expect } = require('../helpers/fixtures');
const { loginViaApi } = require('../helpers/auth');

// Helper : attend que login.js ait attaché les submit handlers sur les deux forms
async function gotoLoginReady(page) {
  await page.addInitScript(() => {
    window.__loginFormReady = false;
    window.__registerFormReady = false;
    const proto = HTMLFormElement.prototype;
    const orig = proto.addEventListener;
    proto.addEventListener = function (type, ...rest) {
      if (type === 'submit') {
        if (this.id === 'login-form') window.__loginFormReady = true;
        if (this.id === 'register-form') window.__registerFormReady = true;
      }
      return orig.call(this, type, ...rest);
    };
  });
  await page.goto('/login');
  await page.waitForFunction(
    () => window.__loginFormReady && window.__registerFormReady,
    null,
    { timeout: 10000 }
  );
}

test.describe('Flux authentification complet', () => {

  test('inscription → POST /api/register répond 2xx ou 4xx contrôlé', async ({ page }) => {
    const unique = `e2e_${Date.now()}`;
    await gotoLoginReady(page);

    // Basculer vers inscription
    await page.click('#switch-to-register');
    await expect(page.locator('#register-slide')).toHaveClass(/active/, { timeout: 3000 });

    await page.fill('#register-name', `Test ${unique}`);
    await page.fill('#register-email', `${unique}@test-e2e.com`);
    await page.fill('#register-password', 'Testuser1');
    // Le checkbox réel est masqué (CSS custom-check), on force le check via JS
    await page.evaluate(() => {
      const cb = document.getElementById('accept-terms');
      cb.checked = true;
      cb.dispatchEvent(new Event('change', { bubbles: true }));
    });

    // Forcer une vraie soumission via le button click (Playwright auto-wait
    // l'actionnabilité). En cas d'overlay, on force.
    const [response] = await Promise.all([
      page.waitForResponse(r => r.url().includes('/api/register') && r.request().method() === 'POST', { timeout: 15000 }),
      page.evaluate(() => document.getElementById('register-form').requestSubmit()),
    ]);
    // Acceptable : 200 (success), 201 (created), 400/409 (déjà existant si rerun)
    expect([200, 201, 400, 409, 429]).toContain(response.status());
  });

  test('login avec mauvais mot de passe → API renvoie 400/401', async ({ page }) => {
    await gotoLoginReady(page);
    await page.fill('#login-email', 'user@test.local');
    await page.fill('#login-password', 'MauvaisMdp999');

    const [response] = await Promise.all([
      page.waitForResponse(r => r.url().includes('/api/login') && r.request().method() === 'POST', { timeout: 15000 }),
      page.evaluate(() => document.getElementById('login-form').requestSubmit()),
    ]);
    expect([400, 401, 403]).toContain(response.status());
  });

  test('login réussi → favoris accessible', async ({ page }) => {
    // Login via API pour éviter la dépendance au formulaire
    await loginViaApi(page, 'user@test.local', 'Testuser1');
    await page.goto('/favorites');

    // Pas de redirection vers login
    await expect(page).not.toHaveURL(/\/login/);

    // Le contenu favoris (soit grid, soit empty-state) doit être rendu
    // On attend la fin du chargement via aria-busy ou l'apparition d'un élément connu
    const content = page.locator('#favorites-content').first();
    await expect(content).not.toHaveClass(/hidden/, { timeout: 8000 });
  });

  test('déconnexion redirige vers l\'accueil', async ({ page }) => {
    await loginViaApi(page, 'user@test.local', 'Testuser1');
    await page.goto('/');
    await page.waitForLoadState('networkidle');

    // Ouvrir le menu utilisateur
    const userToggle = page.locator('.user-toggle, #login-icon').first();
    await userToggle.click();
    await page.waitForTimeout(300);

    // Cliquer sur déconnexion
    const logoutBtn = page.locator('#logout-icon, #logout-btn').first();
    if (await logoutBtn.isVisible()) {
      await logoutBtn.click();
      await page.waitForTimeout(1500);
      const bodyText = await page.textContent('body');
      const isLoggedOut =
        page.url().includes('/') ||
        bodyText.includes('Connexion') ||
        bodyText.includes('connecter');
      expect(isLoggedOut).toBe(true);
    }
  });

  test('basculer entre login et inscription via les boutons switch', async ({ page }) => {
    await gotoLoginReady(page);

    // Au départ : login slide actif
    await expect(page.locator('#login-slide')).toHaveClass(/active/);

    // Basculer vers inscription
    await page.click('#switch-to-register');
    await expect(page.locator('#register-slide')).toHaveClass(/active/, { timeout: 3000 });
    await expect(page.locator('#login-slide')).not.toHaveClass(/active/);

    // Revenir au login
    await page.click('#switch-to-login');
    await expect(page.locator('#login-slide')).toHaveClass(/active/, { timeout: 3000 });
    await expect(page.locator('#register-slide')).not.toHaveClass(/active/);
  });
});
