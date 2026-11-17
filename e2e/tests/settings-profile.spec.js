// e2e/tests/settings-profile.spec.js
// Tests Settings : profil, changement de mot de passe, sécurité
const { test, expect } = require('../helpers/fixtures');
const { loginViaApi } = require('../helpers/auth');

// Les onglets ne sont câblés qu'après `await auth.init()` (settings.js) : sous
// la charge de la suite complète, un clic trop précoce est perdu et la section
// reste cachée. On reclique jusqu'à la voir, au lieu d'espérer un délai fixe.
async function openSection(page, name) {
  await expect(async () => {
    await page.click(`[data-section="${name}"]`);
    await expect(page.locator(`#${name}`)).toBeVisible({ timeout: 1000 });
  }).toPass({ timeout: 15000 });
}

// Le profil (nom, email) arrive après l'API : lire le champ avant serait lire
// un champ vide.
async function profileLoaded(page) {
  await openSection(page, 'profile');
  await expect(page.locator('#name')).not.toHaveValue('', { timeout: 15000 });
}

test.describe('Settings — Profil & Sécurité', () => {
  test.beforeEach(async ({ page }) => {
    await loginViaApi(page, 'user@test.local', 'Testuser1');
  });

  test('la page settings affiche le nom et l\'email pré-remplis', async ({ page }) => {
    await page.goto('/settings');
    await page.waitForLoadState('networkidle');
    // Section dashboard est active par défaut → switch vers profil
    await profileLoaded(page);

    const nameInput = page.locator('#name');
    await expect(nameInput).toBeVisible({ timeout: 8000 });

    const name = await nameInput.inputValue();
    expect(name.length).toBeGreaterThan(0);

    const emailInput = page.locator('#email');
    const email = await emailInput.inputValue();
    expect(email).toContain('@');
  });

  test('modifier le nom et sauvegarder affiche un toast de succès', async ({ page }) => {
    await page.goto('/settings');
    await page.waitForLoadState('networkidle');
    await profileLoaded(page);

    const nameInput = page.locator('#name');
    await expect(nameInput).toBeVisible({ timeout: 8000 });

    // Sauvegarder le nom original
    const originalName = await nameInput.inputValue();

    // Modifier le nom
    await nameInput.clear();
    await nameInput.fill('E2E Temp Name');

    // Soumettre le formulaire profil
    const submitBtn = page.locator('#profile-form button[type="submit"]');
    await submitBtn.click();

    // Attendre le toast de succès
    const toast = page.locator('.toast').first();
    await expect(toast).toBeVisible({ timeout: 5000 });

    // Restaurer le nom original
    await nameInput.clear();
    await nameInput.fill(originalName);
    await submitBtn.click();
    await page.waitForTimeout(1000);
  });

  test('le bouton réinitialiser restaure les valeurs du profil', async ({ page }) => {
    await page.goto('/settings');
    await page.waitForLoadState('networkidle');
    await profileLoaded(page);

    const nameInput = page.locator('#name');
    await expect(nameInput).toBeVisible({ timeout: 8000 });
    const originalName = await nameInput.inputValue();

    // Modifier le nom sans sauvegarder
    await nameInput.clear();
    await nameInput.fill('Temporaire');

    // Cliquer sur réinitialiser
    const resetBtn = page.locator('#reset-profile-btn');
    if (await resetBtn.isVisible()) {
      await resetBtn.click();
      await page.waitForTimeout(500);

      // Le nom devrait être restauré
      const restoredName = await nameInput.inputValue();
      expect(restoredName).toBe(originalName);
    }
  });

  test('la section sécurité est visible', async ({ page }) => {
    await page.goto('/settings');
    await page.waitForLoadState('networkidle');

    // Le panneau sécurité doit devenir visible (hidden retiré par activateTab)
    await openSection(page, 'security');
  });

  test('changement de mot de passe — validation champs vides', async ({ page }) => {
    await page.goto('/settings');
    await page.waitForLoadState('networkidle');

    // Naviguer vers sécurité
    await openSection(page, 'security');

    // Chercher le bouton de soumission du formulaire sécurité
    const securitySubmit = page.locator('#security-form button[type="submit"], #change-password-btn').first();
    if (await securitySubmit.isVisible()) {
      await securitySubmit.click();

      // Validation inline (setFieldError) ou toast — les deux sont acceptables
      await page.waitForTimeout(1000);
      const hasInlineError = await page.locator('[aria-invalid="true"], .form-error').first().isVisible().catch(() => false);
      const hasToast = await page.locator('.toast').first().isVisible().catch(() => false);
      // Le formulaire ne doit pas accepter des champs vides
      expect(hasInlineError || hasToast).toBe(true);
    }
  });

  test('la zone de danger affiche le bouton supprimer le compte', async ({ page }) => {
    await page.goto('/settings');
    await page.waitForLoadState('networkidle');

    // Naviguer vers la section danger
    await openSection(page, 'danger');
    await expect(page.locator('#delete-account-btn')).toBeVisible();
  });
});
