// e2e/tests/admin-users.spec.js
// Tests Admin : gestion des utilisateurs (liste, modification rôle, recherche)
const { test, expect } = require('../helpers/fixtures');
const { loginViaApi } = require('../helpers/auth');

test.describe('Admin — Gestion des utilisateurs', () => {
  test.beforeEach(async ({ page }) => {
    // Nécessite un compte admin (role_id = 1) en BDD
    await loginViaApi(page, 'test@gmail.com', 'test');
  });

  test('la section admin est visible pour un admin', async ({ page }) => {
    await page.goto('/settings');
    await page.waitForLoadState('networkidle');

    // Le lien admin dans la sidebar doit être visible
    const adminLink = page.locator('[data-section="admin"]');
    await expect(adminLink).toBeVisible({ timeout: 8000 });
  });

  test('la liste des utilisateurs se charge', async ({ page }) => {
    await page.goto('/settings');
    await page.waitForLoadState('networkidle');

    // Naviguer vers la section admin
    const adminLink = page.locator('[data-section="admin"]');
    await expect(adminLink).toBeVisible({ timeout: 8000 });
    await adminLink.click();
    await page.waitForTimeout(1000);

    // Les cartes utilisateurs doivent être visibles
    const userCards = page.locator('.user-card');
    await expect(userCards.first()).toBeVisible({ timeout: 8000 });

    const count = await userCards.count();
    expect(count).toBeGreaterThan(0);
  });

  test('la recherche filtre les utilisateurs', async ({ page }) => {
    await page.goto('/settings');
    await page.waitForLoadState('networkidle');

    const adminLink = page.locator('[data-section="admin"]');
    await expect(adminLink).toBeVisible({ timeout: 8000 });
    await adminLink.click();
    await page.waitForTimeout(1000);

    // Compter les utilisateurs initiaux
    const userCards = page.locator('.user-card');
    await expect(userCards.first()).toBeVisible({ timeout: 8000 });
    const initialCount = await userCards.count();

    // Rechercher un terme spécifique
    const filterInput = page.locator('#user-filter');
    if (await filterInput.isVisible()) {
      await filterInput.fill('admin');
      await page.waitForTimeout(500);

      const filteredCount = await page.locator('.user-card').count();
      expect(filteredCount).toBeLessThanOrEqual(initialCount);
    }
  });

  test('ouvrir la modale d\'édition d\'un utilisateur', async ({ page }) => {
    await page.goto('/settings');
    await page.waitForLoadState('networkidle');

    const adminLink = page.locator('[data-section="admin"]');
    await expect(adminLink).toBeVisible({ timeout: 8000 });
    await adminLink.click();
    await page.waitForTimeout(1000);

    // Cliquer sur le bouton éditer du premier utilisateur
    const editBtn = page.locator('.btn-edit').first();
    await expect(editBtn).toBeVisible({ timeout: 8000 });
    await editBtn.click();

    // La modale d'édition doit s'ouvrir
    const modal = page.locator('#edit-user-modal');
    await expect(modal).toBeVisible({ timeout: 3000 });

    // Les champs doivent être pré-remplis
    const nameInput = page.locator('#edit-user-name');
    const name = await nameInput.inputValue();
    expect(name.length).toBeGreaterThan(0);

    const emailInput = page.locator('#edit-user-email');
    const email = await emailInput.inputValue();
    expect(email).toContain('@');

    // Le sélecteur de rôle doit être présent
    const roleSelect = page.locator('#edit-user-role');
    await expect(roleSelect).toBeVisible();

    // Fermer la modale
    const cancelBtn = page.locator('#edit-user-cancel');
    await cancelBtn.click();
    await page.waitForTimeout(500);
  });

  test('modifier le rôle d\'un utilisateur', async ({ page }) => {
    await page.goto('/settings');
    await page.waitForLoadState('networkidle');

    const adminLink = page.locator('[data-section="admin"]');
    await expect(adminLink).toBeVisible({ timeout: 8000 });
    await adminLink.click();
    await page.waitForTimeout(1000);

    // Trouver un utilisateur non-admin à modifier
    const userCards = page.locator('.user-card');
    await expect(userCards.first()).toBeVisible({ timeout: 8000 });

    // Chercher un utilisateur qui n'est pas admin (pas de badge-admin)
    const nonAdminEdit = page.locator('.user-card:not(:has(.badge-admin)) .btn-edit').first();

    if (await nonAdminEdit.isVisible()) {
      await nonAdminEdit.click();

      const modal = page.locator('#edit-user-modal');
      await expect(modal).toBeVisible({ timeout: 3000 });

      // Changer le rôle
      const roleSelect = page.locator('#edit-user-role');
      const currentRole = await roleSelect.inputValue();

      // Basculer entre membre (3) et éditeur (2)
      const newRole = currentRole === '3' ? '2' : '3';
      await roleSelect.selectOption(newRole);

      // Sauvegarder
      const saveBtn = page.locator('#edit-user-save');
      await saveBtn.click();

      // Attendre le toast de succès
      const toast = page.locator('.toast').first();
      await expect(toast).toBeVisible({ timeout: 5000 });

      // Restaurer le rôle original
      await page.waitForTimeout(1000);
      const editBtnAgain = page.locator('.user-card:not(:has(.badge-admin)) .btn-edit').first();
      if (await editBtnAgain.isVisible()) {
        await editBtnAgain.click();
        await expect(modal).toBeVisible({ timeout: 3000 });
        await roleSelect.selectOption(currentRole);
        await saveBtn.click();
        await page.waitForTimeout(1000);
      }
    }
  });
});

test.describe('Non-admin — Section admin masquée', () => {
  test('un membre ne voit pas la section admin', async ({ page }) => {
    await loginViaApi(page, 'user@test.local', 'Testuser1');
    await page.goto('/settings');
    await page.waitForLoadState('networkidle');

    // Le lien admin ne doit pas être visible
    const adminLink = page.locator('[data-section="admin"]');
    await expect(adminLink).not.toBeVisible({ timeout: 3000 });
  });
});
