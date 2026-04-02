// e2e/tests/settings-profile.spec.js
// Tests Settings : profil, changement de mot de passe, sécurité
const { test, expect } = require('@playwright/test');
const { loginViaApi } = require('../helpers/auth');

test.describe('Settings — Profil & Sécurité', () => {
  test.beforeEach(async ({ page }) => {
    await loginViaApi(page, 'titouan.borde.47@gmail.com', 'Titouan1.');
  });

  test('la page settings affiche le nom et l\'email pré-remplis', async ({ page }) => {
    await page.goto('/settings');
    await page.waitForLoadState('networkidle');

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

    // Naviguer vers la section sécurité via le sidebar
    const securityLink = page.locator('[data-section="security"]');
    if (await securityLink.isVisible()) {
      await securityLink.click();
      await page.waitForTimeout(300);

      // Le formulaire de changement de mot de passe doit être visible
      const passwordSection = page.locator('#security');
      await expect(passwordSection).toBeVisible({ timeout: 3000 });
    }
  });

  test('changement de mot de passe — validation champs vides', async ({ page }) => {
    await page.goto('/settings');
    await page.waitForLoadState('networkidle');

    // Naviguer vers sécurité
    const securityLink = page.locator('[data-section="security"]');
    if (await securityLink.isVisible()) {
      await securityLink.click();
      await page.waitForTimeout(300);
    }

    // Chercher le bouton de soumission du formulaire sécurité
    const securitySubmit = page.locator('#security-form button[type="submit"], #change-password-btn').first();
    if (await securitySubmit.isVisible()) {
      await securitySubmit.click();

      // Un toast d'erreur ou un message de validation doit apparaître
      await page.waitForTimeout(1000);
      const toast = page.locator('.toast').first();
      const hasValidation = await toast.isVisible();
      // Le formulaire ne doit pas accepter des champs vides
      expect(hasValidation).toBe(true);
    }
  });

  test('la zone de danger affiche le bouton supprimer le compte', async ({ page }) => {
    await page.goto('/settings');
    await page.waitForLoadState('networkidle');

    // Naviguer vers la section danger
    const dangerLink = page.locator('[data-section="danger"]');
    if (await dangerLink.isVisible()) {
      await dangerLink.click();
      await page.waitForTimeout(300);

      const deleteBtn = page.locator('#delete-account-btn');
      await expect(deleteBtn).toBeVisible({ timeout: 3000 });
    }
  });
});
