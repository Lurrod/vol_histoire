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

  test('colonne d’appoint : adresse, délais, lien depuis les fiches', async ({ page }) => {
    await expect(page.locator('.contact-card')).toHaveCount(3);
    await expect(page.locator('.contact-address a[href="mailto:vdh@titouan-borde.com"]')).toBeVisible();
    await expect(page.locator('#contact-copy')).toBeVisible();
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

    await page.fill('#contact-name', 'Jean Dupont');
    await page.fill('#contact-email', 'jean@example.com');
    await page.getByRole('radio', { name: /contribution/i }).check();
    await page.fill('#contact-message', 'Ceci est un message de test E2E.');

    const sent = page.waitForRequest('**/api/contact');
    await page.click('.btn-send');
    const body = JSON.parse((await sent).postData());
    expect(body).toMatchObject({ name: 'Jean Dupont', email: 'jean@example.com', subject: 'contrib' });

    // Succès : message de confirmation visible
    const success = page.locator('#contact-success');
    await expect(success).toHaveClass(/visible/, { timeout: 10000 });
  });

  test('cinq sujets en pastilles ; le délai du sujet choisi est mis en avant', async ({ page }) => {
    await expect(page.locator('input[name="subject"]')).toHaveCount(5); // general, bug, contrib, partner, other
    await expect(page.locator('.contact-delays > div')).toHaveCount(3);
    await expect(page.locator('.contact-delays .is-active')).toHaveAttribute('data-topic', 'general');
    await page.getByRole('radio', { name: /signaler une erreur/i }).check();
    await expect(page.locator('.contact-delays .is-active')).toHaveAttribute('data-topic', 'bug');
  });

  test('depuis une fiche : sujet « erreur » et fiche concernée envoyée', async ({ page }) => {
    // Une fiche réelle du jeu de test, trouvée par l'API.
    const list = await (await page.request.get('/api/airplanes?limit=1')).json();
    const aircraft = (list.data || list)[0];
    await page.goto(`/contact?sujet=bug&fiche=${aircraft.id}`);
    await expect(page.locator('#contact-aircraft')).toBeVisible();
    await expect(page.locator('#contact-aircraft-link')).toHaveText(aircraft.name);
    await expect(page.getByRole('radio', { name: /signaler une erreur/i })).toBeChecked();

    await page.route('**/api/contact', route =>
      route.fulfill({ status: 200, contentType: 'application/json', body: '{"message":"ok"}' })
    );
    await page.fill('#contact-email', 'jean@example.com');
    await page.fill('#contact-message', 'La vitesse maximale semble fausse.');
    const sent = page.waitForRequest('**/api/contact');
    await page.click('.btn-send');
    expect(JSON.parse((await sent).postData()).aircraft_id).toBe(aircraft.id);
  });
});
