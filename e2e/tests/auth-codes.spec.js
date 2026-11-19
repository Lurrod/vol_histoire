// e2e/tests/auth-codes.spec.js
// Inscription et mot de passe oublié par code reçu par email, entièrement
// sur /login : code faux (rouge, secousse) puis juste (contours verts),
// choix du mot de passe, connexion. Chaque spec crée son propre compte :
// aucune autre spec ne doit voir son mot de passe changer.
const { test, expect } = require('../helpers/fixtures');
const { setKnownCode, createVerifiedUser, deleteUser } = require('../helpers/email-code');

const NEW_PASSWORD = 'Codepilote1';

async function typeCode(page, code) {
  await page.locator('#code-otp .otp-row').click();
  await page.keyboard.type(code);
}

async function loginWith(page, email, password) {
  await page.fill('#login-email', email);
  await page.fill('#login-password', password);
  await page.click('#login-form button[type="submit"]');
  await page.waitForURL((url) => url.pathname === '/', { timeout: 8000 });
}

test.describe('Codes reçus par email', () => {
  test('inscription : code faux puis juste, mot de passe choisi, connexion', async ({ page }) => {
    const email = `e2e-inscription-${Date.now()}@test.local`;
    try {
      await page.goto('/login');
      await page.click('#tab-register');
      await page.fill('#register-name', 'Pilote E2E');
      await page.fill('#register-email', email);
      await expect(page.locator('#register-password')).toHaveCount(0); // plus de mot de passe ici
      // Case réelle masquée (case dessinée en CSS) : cochée via le DOM.
      await page.evaluate(() => { document.getElementById('accept-terms').checked = true; });
      await page.click('#register-form button[type="submit"]');

      await expect(page.locator('#code-slide')).toHaveClass(/active/);
      await expect(page.locator('#code-email')).toHaveText(email);
      await expect(page).toHaveURL(/#code$/);
      await setKnownCode(email, 'verify');

      await typeCode(page, '000000');
      await expect(page.locator('#code-otp')).toHaveClass(/is-error/);
      await expect(page.locator('#code-status')).not.toBeEmpty();

      await page.keyboard.press('Backspace');
      await expect(page.locator('#code-otp')).not.toHaveClass(/is-error/);
      for (let i = 0; i < 5; i++) await page.keyboard.press('Backspace');
      await page.keyboard.type('123456');
      await expect(page.locator('#code-otp')).toHaveClass(/is-success/);

      await expect(page.locator('#password-slide')).toHaveClass(/active/, { timeout: 5000 });
      await page.fill('#new-password', NEW_PASSWORD);
      await page.fill('#confirm-password', NEW_PASSWORD);
      await page.click('#password-form button[type="submit"]');

      await expect(page.locator('#login-slide')).toHaveClass(/active/);
      await expect(page.locator('#login-email')).toHaveValue(email);
      await loginWith(page, email, NEW_PASSWORD);
    } finally {
      await deleteUser(email);
    }
  });

  test('mot de passe oublié : lien de la connexion, code, nouveau mot de passe', async ({ page }) => {
    const email = `e2e-oubli-${Date.now()}@test.local`;
    await createVerifiedUser(email, 'Ancienpass1');
    try {
      await page.goto('/login');
      await page.fill('#login-email', email);
      await page.click('#open-forgot');
      await expect(page.locator('#forgot-slide')).toHaveClass(/active/);
      await expect(page.locator('.form-tabs')).toBeHidden();
      await expect(page.locator('#forgot-email')).toHaveValue(email);
      await page.click('#forgot-form button[type="submit"]');

      await expect(page.locator('#code-slide')).toHaveClass(/active/);
      await setKnownCode(email, 'reset');
      await typeCode(page, '123456');
      await expect(page.locator('#password-slide')).toHaveClass(/active/, { timeout: 5000 });
      await page.fill('#new-password', NEW_PASSWORD);
      await page.fill('#confirm-password', NEW_PASSWORD);
      await page.click('#password-form button[type="submit"]');

      await expect(page.locator('#login-slide')).toHaveClass(/active/);
      await loginWith(page, email, NEW_PASSWORD);
    } finally {
      await deleteUser(email);
    }
  });

  test('anciennes adresses des liens : redirigées vers la connexion', async ({ page }) => {
    await page.goto('/reset-password?token=abc');
    await expect(page).toHaveURL(/\/login#mot-de-passe-oublie$/);
    await expect(page.locator('#forgot-slide')).toHaveClass(/active/);
    await page.goto('/verify-email?token=abc');
    await expect(page).toHaveURL(/\/login$/);
    await expect(page.locator('#login-slide')).toHaveClass(/active/);
  });
});
