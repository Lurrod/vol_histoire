// e2e/tests/contact-form.spec.js
// Parcours critique : formulaire de contact (soumission, validation, feedback)

const { test, expect } = require('../helpers/fixtures');

test.describe('Contact Form', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/contact');
  });

  test('la page contact charge avec le formulaire visible', async ({ page }) => {
    await expect(page.locator('#contact-form')).toBeVisible();
    await expect(page.locator('#contact-email')).toBeVisible();
    await expect(page.locator('#contact-message')).toBeVisible();
    await expect(page.locator('.btn-send')).toBeVisible();
  });

  test('les 3 cartes de contact sont affichées', async ({ page }) => {
    const cards = page.locator('.contact-card');
    await expect(cards).toHaveCount(3);
  });

  test('soumission avec email vide → toast erreur', async ({ page }) => {
    await page.fill('#contact-message', 'Test message');
    await page.click('.btn-send');

    const toast = page.locator('.toast-error');
    await expect(toast).toBeVisible({ timeout: 3000 });
  });

  test('soumission avec message vide → toast erreur', async ({ page }) => {
    await page.fill('#contact-email', 'test@example.com');
    await page.click('.btn-send');

    const toast = page.locator('.toast-error');
    await expect(toast).toBeVisible({ timeout: 3000 });
  });

  test('soumission avec email invalide → toast erreur', async ({ page }) => {
    await page.fill('#contact-email', 'pas-un-email');
    await page.fill('#contact-message', 'Un message de test');
    await page.click('.btn-send');

    const toast = page.locator('.toast-error');
    await expect(toast).toBeVisible({ timeout: 3000 });
  });

  test('soumission valide → toast succès + message de confirmation', async ({ page }) => {
    await page.fill('#contact-firstname', 'Jean');
    await page.fill('#contact-lastname', 'Dupont');
    await page.fill('#contact-email', 'jean@example.com');
    await page.selectOption('#contact-subject', 'general');
    await page.fill('#contact-message', 'Ceci est un message de test E2E.');

    await page.click('.btn-send');

    // Le bouton passe en loading
    await expect(page.locator('.btn-send')).toBeDisabled();

    // Succès : toast + message de confirmation visible
    const success = page.locator('#contact-success');
    await expect(success).toHaveClass(/visible/, { timeout: 5000 });
  });

  test('le sélecteur de sujet contient les options attendues', async ({ page }) => {
    const options = page.locator('#contact-subject option');
    await expect(options).toHaveCount(5); // general, bug, contrib, partner, other
  });

  test('les délais de réponse sont affichés', async ({ page }) => {
    const responseTimes = page.locator('.response-time-item, .info-card');
    const count = await responseTimes.count();
    expect(count).toBeGreaterThanOrEqual(3);
  });
});
