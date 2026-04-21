// e2e/tests/contact-form.spec.js
// Parcours critique : formulaire de contact (soumission, validation, feedback)

const { test, expect } = require('../helpers/fixtures');

test.describe('Contact Form', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/contact');
    // Attendre que contact.min.js ait attaché son handler sur le formulaire
    await page.waitForFunction(
      () => typeof isValidEmail === 'function' && typeof showToast === 'function',
      null,
      { timeout: 10000 }
    );
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

  test('soumission avec email vide → erreur inline sur le champ email', async ({ page }) => {
    await page.fill('#contact-message', 'Test message');
    await page.click('.btn-send');

    await expect(page.locator('#contact-email')).toHaveAttribute('aria-invalid', 'true', { timeout: 5000 });
    await expect(page.locator('#contact-email-error')).toBeVisible();
  });

  test('soumission avec message vide → erreur inline sur le champ message', async ({ page }) => {
    await page.fill('#contact-email', 'test@example.com');
    await page.click('.btn-send');

    await expect(page.locator('#contact-message')).toHaveAttribute('aria-invalid', 'true', { timeout: 5000 });
    await expect(page.locator('#contact-message-error')).toBeVisible();
  });

  test('soumission avec email invalide → erreur inline sur le champ email', async ({ page }) => {
    await page.fill('#contact-email', 'pas-un-email');
    await page.fill('#contact-message', 'Un message de test');
    await page.click('.btn-send');

    await expect(page.locator('#contact-email')).toHaveAttribute('aria-invalid', 'true', { timeout: 5000 });
    await expect(page.locator('#contact-email-error')).toBeVisible();
  });

  test('soumission valide → message de confirmation visible', async ({ page }) => {
    // Mock l'API contact pour ne pas dépendre du mailer
    await page.route('**/api/contact', route =>
      route.fulfill({ status: 200, contentType: 'application/json', body: '{"message":"ok"}' })
    );

    await page.fill('#contact-firstname', 'Jean');
    await page.fill('#contact-lastname', 'Dupont');
    await page.fill('#contact-email', 'jean@example.com');
    await page.selectOption('#contact-subject', 'general');
    await page.fill('#contact-message', 'Ceci est un message de test E2E.');

    await page.click('.btn-send');

    // Succès : message de confirmation visible
    const success = page.locator('#contact-success');
    await expect(success).toHaveClass(/visible/, { timeout: 10000 });
  });

  test('le sélecteur de sujet contient les options attendues', async ({ page }) => {
    const options = page.locator('#contact-subject option');
    await expect(options).toHaveCount(5); // general, bug, contrib, partner, other
  });

  test('les délais de réponse sont affichés', async ({ page }) => {
    // Les délais sont dans une liste <ul> dans .legal-section
    const delayItems = page.locator('.legal-section ul li');
    const count = await delayItems.count();
    expect(count).toBeGreaterThanOrEqual(3);
  });
});
