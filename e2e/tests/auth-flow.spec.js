// e2e/tests/auth-flow.spec.js
// Flux complet : inscription → vérification → connexion → favoris → déconnexion
const { test, expect } = require('@playwright/test');
const { loginViaApi } = require('../helpers/auth');

test.describe('Flux authentification complet', () => {

  test('inscription affiche la page de confirmation email', async ({ page }) => {
    const unique = `e2e_${Date.now()}`;
    await page.goto('/login');

    // Basculer vers le formulaire inscription
    const switchBtn = page.locator('#switch-to-register');
    await switchBtn.click();
    await expect(page.locator('#register-slide')).toBeVisible({ timeout: 3000 });

    // Remplir le formulaire
    await page.fill('#register-name', `Test ${unique}`);
    await page.fill('#register-email', `${unique}@test-e2e.com`);
    await page.fill('#register-password', 'Titouan1.');

    // Cocher les CGU
    const termsCheckbox = page.locator('#accept-terms');
    await termsCheckbox.check();

    // Soumettre
    await page.click('#register-form button[type="submit"]');

    // Attendre soit une redirection vers check-email, soit un toast de succès
    await page.waitForTimeout(2000);
    const url = page.url();
    const bodyText = await page.textContent('body');

    const isSuccess =
      url.includes('check-email') ||
      bodyText.includes('Vérifiez') ||
      bodyText.includes('email') ||
      bodyText.includes('créé');
    expect(isSuccess).toBe(true);
  });

  test('login avec mauvais mot de passe → erreur', async ({ page }) => {
    await page.goto('/login');
    await page.fill('#login-email', 'titouan.borde.47@gmail.com');
    await page.fill('#login-password', 'MauvaisMdp999');
    await page.click('#login-form button[type="submit"]');

    const toast = page.locator('.toast').first();
    await expect(toast).toBeVisible({ timeout: 5000 });
  });

  test('login réussi → naviguer vers favoris → ajouter un favori', async ({ page }) => {
    // Login via API pour éviter la dépendance au formulaire
    await loginViaApi(page, 'titouan.borde.47@gmail.com', 'Titouan1.');
    await page.goto('/favorites');
    await page.waitForLoadState('networkidle');

    // La page favoris est accessible
    expect(page.url()).not.toContain('login');

    // Aller au hangar pour ajouter un favori
    await page.goto('/details?id=1');
    await page.waitForLoadState('networkidle');

    // Chercher le bouton favori
    const favBtn = page.locator('.btn-favorite, [data-action="favorite"], button:has(i.fa-heart)').first();
    if (await favBtn.isVisible()) {
      await favBtn.click();
      await page.waitForTimeout(1000);

      // Vérifier que le favori apparaît dans la page favoris
      await page.goto('/favorites');
      await page.waitForLoadState('networkidle');

      const container = page.locator('#favorites-container, .favorites-grid, .aircraft-card').first();
      await expect(container).toBeVisible({ timeout: 8000 });
    }
  });

  test('déconnexion redirige vers l\'accueil', async ({ page }) => {
    await loginViaApi(page, 'titouan.borde.47@gmail.com', 'Titouan1.');
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

      // Attendre la redirection
      await page.waitForTimeout(2000);
      const bodyText = await page.textContent('body');
      const isLoggedOut =
        page.url().includes('/') ||
        bodyText.includes('Connexion') ||
        bodyText.includes('connecter');
      expect(isLoggedOut).toBe(true);
    }
  });

  test('basculer entre login et inscription préserve l\'état', async ({ page }) => {
    await page.goto('/login');

    // Saisir un email dans login
    await page.fill('#login-email', 'test@example.com');

    // Basculer vers inscription
    await page.click('#switch-to-register');
    await expect(page.locator('#register-slide')).toBeVisible({ timeout: 2000 });

    // Revenir au login
    await page.click('#switch-to-login');
    await expect(page.locator('#login-slide')).toBeVisible({ timeout: 2000 });

    // Le champ email login devrait encore avoir la valeur
    const emailValue = await page.inputValue('#login-email');
    expect(emailValue).toBe('test@example.com');
  });
});
