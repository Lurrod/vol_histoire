// e2e/tests/responsive.spec.js
// Tests responsive : mobile, tablette, navigation
const { test, expect } = require('@playwright/test');

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
