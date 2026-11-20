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

    // Le rôle se change dans la liste, plus dans la modale.
    await expect(page.locator('#edit-user-role')).toHaveCount(0);

    // Fermer la modale
    const cancelBtn = page.locator('#edit-user-cancel');
    await cancelBtn.click();
    await page.waitForTimeout(500);
  });

  test('modifier le rôle d\'un utilisateur dans la liste', async ({ page }) => {
    await page.goto('/settings');
    await page.waitForLoadState('networkidle');

    const adminLink = page.locator('[data-section="admin"]');
    await expect(adminLink).toBeVisible({ timeout: 8000 });
    await adminLink.click();

    // Compte dédié, utilisé par aucune autre spec : changer un rôle révoque
    // les jetons du compte (token_version). Prendre « le premier non-admin »
    // visait user@test.local, connecté au même moment par settings-profile,
    // dont les requêtes tombaient alors en 401 (profil jamais chargé).
    const TARGET = 'zoe.bernard@test.local';
    await page.locator('#user-filter').fill(TARGET);
    const targetCard = page.locator('.user-card', { hasText: TARGET });
    await expect(targetCard).toBeVisible({ timeout: 8000 });

    // <select> natif, amélioré par VH.customSelect (le natif reste la source de vérité).
    const roleSelect = targetCard.locator('select.user-role-select');
    const currentRole = await roleSelect.inputValue();
    const newRole = currentRole === '3' ? '2' : '3';
    await roleSelect.selectOption(newRole, { force: true });
    await expect(page.locator('.toast').first()).toBeVisible({ timeout: 5000 });

    // Restaurer le rôle d'origine (la liste est rechargée après le changement).
    const again = page.locator('.user-card', { hasText: TARGET }).locator('select.user-role-select');
    await expect(again).toHaveValue(newRole, { timeout: 8000 });
    await again.selectOption(currentRole, { force: true });
    await expect(again).toHaveValue(currentRole, { timeout: 8000 });
  });

  test('pastilles de rôle : filtre et état pressé', async ({ page }) => {
    await page.goto('/settings');
    await page.waitForLoadState('networkidle');
    const adminLink = page.locator('[data-section="admin"]');
    await expect(adminLink).toBeVisible({ timeout: 8000 });
    await adminLink.click();
    await expect(page.locator('.user-card').first()).toBeVisible({ timeout: 8000 });

    const editors = page.locator('.role-chip[data-role="2"]');
    await editors.click();
    await expect(editors).toHaveAttribute('aria-pressed', 'true');
    await expect(page.locator('.role-chip[data-role=""]')).toHaveAttribute('aria-pressed', 'false');
    // Chaque ligne affichée est un éditeur. La liste est redessinée après la
    // réponse : on attend que toutes les lignes le soient (compter avant
    // donnait le nombre de l'ancienne liste).
    const selects = page.locator('.user-card select.user-role-select');
    await expect.poll(async () => {
      const values = await selects.evaluateAll((els) => els.map((el) => el.value));
      return values.length > 0 && values.every((v) => v === '2');
    }, { timeout: 8000 }).toBe(true);
  });

  test('son propre rôle n\'est pas modifiable', async ({ page }) => {
    await page.goto('/settings');
    await page.waitForLoadState('networkidle');
    const adminLink = page.locator('[data-section="admin"]');
    await expect(adminLink).toBeVisible({ timeout: 8000 });
    await adminLink.click();
    await page.locator('#user-filter').fill('test@gmail.com');
    const own = page.locator('.user-card.is-self');
    await expect(own).toBeVisible({ timeout: 8000 });
    await expect(own.locator('select.user-role-select')).toBeDisabled();
    await expect(own.locator('.btn-delete')).toHaveCount(0);
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
