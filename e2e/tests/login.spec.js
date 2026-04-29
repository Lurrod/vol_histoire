// e2e/tests/login.spec.js
/* global HTMLFormElement */ // utilisé dans page.addInitScript (contexte navigateur)
const { test, expect } = require('../helpers/fixtures');

test.describe('Login / Logout', () => {
  // Attend que login.js ait fini son init et attaché le submit handler.
  // Astuce : on intercepte le `addEventListener` du formulaire avant que le
  // handler ne soit attaché, en injectant un init script qui pose un flag.
  async function gotoLoginAndWaitReady(page) {
    await page.addInitScript(() => {
      window.__loginFormReady = false;
      const proto = HTMLFormElement.prototype;
      const orig = proto.addEventListener;
      proto.addEventListener = function (type, ...rest) {
        if (this.id === 'login-form' && type === 'submit') {
          window.__loginFormReady = true;
        }
        return orig.call(this, type, ...rest);
      };
    });
    await page.goto('/login');
    await page.waitForFunction(() => window.__loginFormReady === true, null, { timeout: 10000 });
  }

  test('login réussi → API renvoie 200 et redirige', async ({ page }) => {
    await gotoLoginAndWaitReady(page);

    await page.fill('#login-email', 'user@test.local');
    await page.fill('#login-password', 'Testuser1');

    const [response] = await Promise.all([
      page.waitForResponse(r => r.url().includes('/api/login') && r.request().method() === 'POST', { timeout: 15000 }),
      page.evaluate(() => document.getElementById('login-form').requestSubmit()),
    ]);
    expect(response.status()).toBe(200);

    await page.waitForURL((url) => !url.pathname.includes('login'), { timeout: 10000 });
    await expect(page).not.toHaveURL(/login/);
  });

  test('email incorrect → API renvoie 400/401', async ({ page }) => {
    await gotoLoginAndWaitReady(page);

    await page.fill('#login-email', 'inexistant-e2e@vol-histoire.test');
    await page.fill('#login-password', 'WrongPass123');

    const [response] = await Promise.all([
      page.waitForResponse(r => r.url().includes('/api/login') && r.request().method() === 'POST', { timeout: 15000 }),
      page.evaluate(() => document.getElementById('login-form').requestSubmit()),
    ]);
    expect([400, 401, 403]).toContain(response.status());

    await page.waitForTimeout(500);
    await expect(page).toHaveURL(/login/);
  });

  test('champs vides → le formulaire ne soumet pas', async ({ page }) => {
    await page.goto('/login');
    await page.click('#login-form button[type="submit"]');

    // Toujours sur la page login
    await expect(page).toHaveURL(/login/);
  });
});
