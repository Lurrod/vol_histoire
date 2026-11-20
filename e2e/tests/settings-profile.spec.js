// e2e/tests/settings-profile.spec.js
// Tests Settings : onglets, profil (barre d'enregistrement), mot de passe,
// anciennes ancres, confidentialité, préférences.
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
  await openSection(page, 'account');
  await expect(page.locator('#name')).not.toHaveValue('', { timeout: 15000 });
}

test.describe('Settings — Compte, sécurité, confidentialité', () => {
  test.beforeEach(async ({ page }) => {
    await loginViaApi(page, 'user@test.local', 'Testuser1');
  });

  test('« Ma collection » est l’onglet par défaut, l’en-tête affiche le nom', async ({ page }) => {
    await page.goto('/settings');
    await page.waitForLoadState('networkidle');
    await expect(page.locator('#collection')).toBeVisible();
    await expect(page.locator('#tab-collection')).toHaveAttribute('aria-selected', 'true');
    await expect(page.locator('#id-name')).not.toHaveText('…', { timeout: 15000 });
    await expect(page.locator('h1')).toHaveCount(1);
  });

  test('la page settings affiche le nom et l\'email pré-remplis', async ({ page }) => {
    await page.goto('/settings');
    await page.waitForLoadState('networkidle');
    await profileLoaded(page);

    const name = await page.locator('#name').inputValue();
    expect(name.length).toBeGreaterThan(0);
    const email = await page.locator('#email').inputValue();
    expect(email).toContain('@');
  });

  test('modifier le nom fait apparaître la barre ; Enregistrer affiche un toast de succès', async ({ page }) => {
    await page.goto('/settings');
    await page.waitForLoadState('networkidle');
    await profileLoaded(page);

    const nameInput = page.locator('#name');
    const saveBar = page.locator('#save-bar');
    const originalName = await nameInput.inputValue();
    await expect(saveBar).toBeHidden();

    await nameInput.fill('E2E Temp Name');
    await expect(saveBar).toBeVisible();
    await page.locator('#save-bar-save').click();

    await expect(page.locator('.toast').first()).toBeVisible({ timeout: 5000 });
    await expect(saveBar).toBeHidden({ timeout: 5000 });

    // Restaurer le nom original (Entrée dans le champ enregistre aussi)
    await nameInput.fill(originalName);
    await nameInput.press('Enter');
    await expect(saveBar).toBeHidden({ timeout: 5000 });
  });

  test('Annuler dans la barre restaure les valeurs du profil', async ({ page }) => {
    await page.goto('/settings');
    await page.waitForLoadState('networkidle');
    await profileLoaded(page);

    const nameInput = page.locator('#name');
    const originalName = await nameInput.inputValue();
    await nameInput.fill('Temporaire');
    await page.locator('#save-bar-cancel').click();
    await expect(nameInput).toHaveValue(originalName);
    await expect(page.locator('#save-bar')).toBeHidden({ timeout: 3000 });
  });

  test('le bloc mot de passe est dans l’onglet Compte', async ({ page }) => {
    await page.goto('/settings');
    await page.waitForLoadState('networkidle');
    await openSection(page, 'account');
    await expect(page.locator('#security-form')).toBeVisible();
    await expect(page.locator('#logout-all-btn')).toBeVisible();
  });

  test('ancienne ancre #security (cible de change-password) : onglet Compte, bloc mot de passe', async ({ page }) => {
    await page.goto('/.well-known/change-password');
    await page.waitForLoadState('networkidle');
    await expect(page).toHaveURL(/\/settings#security$/);
    await expect(page.locator('#account')).toBeVisible({ timeout: 15000 });
    await expect(page.locator('#tab-account')).toHaveAttribute('aria-selected', 'true');
    await expect(page.locator('#password-block')).toBeFocused();
  });

  test('changement de mot de passe — validation champs vides', async ({ page }) => {
    await page.goto('/settings');
    await page.waitForLoadState('networkidle');
    await openSection(page, 'account');

    await page.locator('#security-form button[type="submit"]').click();
    await page.waitForTimeout(1000);
    const hasInlineError = await page.locator('[aria-invalid="true"], .form-error').first().isVisible().catch(() => false);
    const hasToast = await page.locator('.toast').first().isVisible().catch(() => false);
    expect(hasInlineError || hasToast).toBe(true);
  });

  test('la suppression du compte est en bas de « Confidentialité » (ancienne ancre #danger)', async ({ page }) => {
    await page.goto('/settings#danger');
    await page.waitForLoadState('networkidle');
    await expect(page.locator('#privacy')).toBeVisible({ timeout: 15000 });
    await expect(page.locator('#delete-account-btn')).toBeVisible();
    await expect(page.locator('#delete-block')).toBeFocused();
    await expect(page.locator('[data-section="danger"]')).toHaveCount(0);
  });

  test('préférences : langue, animations réduites, visite guidée', async ({ page }) => {
    await page.goto('/settings');
    await page.waitForLoadState('networkidle');
    await openSection(page, 'preferences');
    await expect(page.locator('input[name="pref-lang"][value="fr"]')).toBeChecked();
    // Clic réel (la case transparente couvre l'interrupteur) : un clic forcé
    // ne vérifie pas la cible et pouvait tomber sur l'en-tête collant.
    await page.locator('#pref-reduce-motion').click();
    await expect(page.locator('#pref-reduce-motion')).toBeChecked();
    await expect(page.locator('html')).toHaveClass(/vh-reduce-motion/);
    await page.reload();
    await expect(page.locator('html')).toHaveClass(/vh-reduce-motion/);
    await openSection(page, 'preferences');
    await page.locator('#pref-reduce-motion').click();
    await expect(page.locator('#pref-reduce-motion')).not.toBeChecked();
    await expect(page.locator('html')).not.toHaveClass(/vh-reduce-motion/);
    await expect(page.locator('#pref-tour-btn')).toBeVisible();
  });
});
