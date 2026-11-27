// e2e/tests/favorites.spec.js
const { test, expect } = require('../helpers/fixtures');
const { loginViaApi } = require('../helpers/auth');

test.describe('Favoris', () => {
  test('utilisateur non connecté → auth gate affiché', async ({ page }) => {
    await page.goto('/favorites');
    await page.waitForLoadState('networkidle');

    // favorites.js montre #auth-gate et cache #favorites-content si pas de token
    const gate = page.locator('#auth-gate');
    await expect(gate).not.toHaveClass(/hidden/, { timeout: 5000 });
  });

  test('utilisateur connecté → contenu favoris accessible', async ({ page }) => {
    await loginViaApi(page, 'user@test.local', 'Testuser1');
    await page.goto('/favorites');

    // Pas de redirection vers login
    await expect(page).not.toHaveURL(/\/login/);

    // #favorites-content perd sa classe .hidden après init de favorites.js
    const content = page.locator('#favorites-content');
    await expect(content).not.toHaveClass(/hidden/, { timeout: 8000 });
  });

  test('retrait en deux temps : la poubelle demande confirmation, Échap annule, la coche retire', async ({ page }) => {
    // Compte dédié : aucune autre spec ne touche à ses favoris.
    await loginViaApi(page, 'bob.durand@test.local', 'Testuser1');
    await page.evaluate(() => auth.authFetch('/api/favorites/1', { method: 'POST' }));
    await page.goto('/favorites');

    const card = page.locator('.aircraft-card').first();
    await expect(card).toBeVisible({ timeout: 10000 });
    const control = card.locator('.fav-del');
    const bin = card.locator('.favorite-remove');

    // Poubelle : le panneau s'ouvre, rien n'est retiré
    await card.hover();
    await bin.click();
    await expect(control).toHaveAttribute('data-state', 'confirm');
    await expect(bin).toHaveAttribute('aria-expanded', 'true');
    // Focus sur « garder » : l'action la moins destructrice
    await expect(card.locator('.cfm-no')).toBeFocused();

    // Échap : on garde le favori, le focus revient à la poubelle
    await page.keyboard.press('Escape');
    await expect(control).toHaveAttribute('data-state', 'idle');
    await expect(bin).toBeFocused();
    await expect(card).not.toHaveClass(/is-removing/);
    await expect(page.locator('.toast-undo-btn')).toHaveCount(0);

    // Touche Suppr sur la carte (ici depuis la poubelle) : même confirmation
    await page.keyboard.press('Delete');
    await expect(control).toHaveAttribute('data-state', 'confirm');
    await expect(card.locator('.cfm-no')).toBeFocused();
    await page.keyboard.press('Escape');
    await expect(control).toHaveAttribute('data-state', 'idle');

    // Confirmer : la coche se trace, la carte part, « Annuler » est proposé
    await bin.click();
    await card.locator('.cfm-yes').click();
    await expect(control).toHaveAttribute('data-state', 'done');
    const undo = page.locator('.toast-undo-btn');
    await expect(undo).toBeVisible({ timeout: 5000 });

    // Annuler : le favori revient (la base n'est pas modifiée)
    await undo.click();
    await expect(page.locator('.aircraft-card .fav-del[data-state="idle"]').first()).toBeVisible();
  });
});
