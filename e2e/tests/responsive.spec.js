// e2e/tests/responsive.spec.js
// Tests responsive : mobile, tablette, navigation
const { test, expect } = require('../helpers/fixtures');

const MOBILE = { width: 390, height: 844 };   // iPhone 12
const TABLET = { width: 810, height: 1080 };  // iPad

test.describe('Responsive — Mobile', () => {
  test.beforeEach(async ({ page }) => {
    await page.setViewportSize(MOBILE);
  });

  test('le hamburger est visible sur mobile', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');

    const hamburger = page.locator('.hamburger');
    await expect(hamburger).toBeVisible();

    const navLinks = page.locator('.nav-links');
    await expect(navLinks).not.toBeVisible();
  });

  test('le hamburger ouvre et ferme le menu', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');

    const hamburger = page.locator('.hamburger');
    const navLinks = page.locator('.nav-links');

    await hamburger.click();
    await expect(navLinks).toBeVisible({ timeout: 2000 });

    await hamburger.click();
    await page.waitForTimeout(500);
    await expect(navLinks).not.toBeVisible();
  });

  test('ESC ferme le menu mobile', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');

    const hamburger = page.locator('.hamburger');
    const navLinks = page.locator('.nav-links');

    await hamburger.click();
    await expect(navLinks).toBeVisible({ timeout: 2000 });

    await page.keyboard.press('Escape');
    await page.waitForTimeout(500);
    await expect(navLinks).not.toBeVisible();
  });

  test('le hangar affiche les cartes en colonne sur mobile', async ({ page }) => {
    await page.goto('/hangar');
    await page.waitForSelector('.aircraft-card', { timeout: 10000 });

    const firstCard = page.locator('.aircraft-card').first();
    const box = await firstCard.boundingBox();

    expect(box.width).toBeGreaterThan(250);
  });

  test('la page login est utilisable sur mobile', async ({ page }) => {
    await page.goto('/login');
    await page.waitForLoadState('networkidle');

    const form = page.locator('#login-form');
    await expect(form).toBeVisible();

    const emailInput = page.locator('#login-email');
    await expect(emailInput).toBeVisible();
    await emailInput.fill('test@example.com');
    expect(await emailInput.inputValue()).toBe('test@example.com');
  });
});

test.describe('Responsive — Tablette', () => {
  test.beforeEach(async ({ page }) => {
    await page.setViewportSize(TABLET);
  });

  test('la page hangar affiche les cartes en grille', async ({ page }) => {
    await page.goto('/hangar');
    await page.waitForSelector('.aircraft-card', { timeout: 10000 });

    const cards = page.locator('.aircraft-card');
    const count = await cards.count();
    expect(count).toBeGreaterThan(0);

    const firstCard = cards.first();
    const box = await firstCard.boundingBox();
    const viewport = page.viewportSize();
    expect(box.width).toBeLessThan(viewport.width * 0.8);
  });
});

// Bureau (≥ 64em) : le bouton Menu ouvre le menu « underlay » — la page
// glisse et se resserre, le panneau des liens apparaît dessous.
test.describe('Responsive — Bureau : menu underlay', () => {
  const DESKTOP = { width: 1440, height: 900 };

  test.beforeEach(async ({ page }) => {
    await page.setViewportSize(DESKTOP);
  });

  test('les liens sont derrière le bouton Menu', async ({ page }) => {
    await page.goto('/hangar');
    await page.waitForLoadState('networkidle');
    await expect(page.locator('.hamburger')).toBeVisible();
    await expect(page.locator('.nav-links a[href="/timeline"]')).toBeHidden();
  });

  test('ouvre, garde l’en-tête à l’écran, puis Échap referme et rend le focus', async ({ page }) => {
    await page.goto('/hangar');
    await page.waitForSelector('.aircraft-card', { timeout: 10000 });
    await page.evaluate(() => window.scrollTo(0, 600));

    await page.locator('.hamburger').click();
    const panel = page.locator('#nav-panel');
    await expect(panel).toBeVisible();
    await expect(page.locator('html')).toHaveClass(/ul-open/);
    await expect(page.locator('.nav-close')).toBeFocused();
    await expect(page.locator('#nav-panel .nav-links a[href="/timeline"]')).toBeVisible();

    // Fin de l'animation : la page est une carte à gauche, l'en-tête reste en haut.
    await page.waitForTimeout(1000);
    const header = await page.locator('body > header').boundingBox();
    expect(header.y).toBeGreaterThan(0);
    expect(header.y).toBeLessThan(40);
    expect(await page.evaluate(() => window.scrollY)).toBe(600);

    await page.keyboard.press('Escape');
    await expect(page.locator('html')).not.toHaveClass(/ul-on/, { timeout: 3000 });
    await expect(panel).toBeHidden();
    await expect(page.locator('.hamburger')).toBeFocused();
    expect(await page.evaluate(() => window.scrollY)).toBe(600);
  });

  test('le bouton Fermer referme au clic', async ({ page }) => {
    await page.goto('/hangar');
    await page.waitForLoadState('networkidle');
    await page.locator('.hamburger').click();
    await expect(page.locator('html')).toHaveClass(/ul-open/);
    await page.waitForTimeout(1000);
    await page.locator('.nav-close').click();
    await expect(page.locator('html')).not.toHaveClass(/ul-on/, { timeout: 3000 });
    await expect(page.locator('#nav-panel')).toBeHidden();
  });

  test('plus d’icône compte : « Votre espace » propose Connexion', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    await expect(page.locator('#login-icon')).toHaveCount(0);
    await page.locator('.hamburger').click();
    await expect(page.locator('#nav-panel a[href="/login"]')).toBeVisible();
  });

  test('un lien du panneau mène à sa page', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    await page.locator('.hamburger').click();
    await page.locator('#nav-panel .nav-links a[href="/timeline"]').click();
    await expect(page).toHaveURL(/\/timeline/);
  });
});
