// e2e/tests/i18n.spec.js
const { test, expect } = require('@playwright/test');

test.describe('Internationalisation fr/en', () => {
  test('la page index se charge en français par défaut', async ({ page }) => {
    await page.addInitScript(() => window.localStorage.clear());
    await page.goto('/');
    await page.waitForLoadState('networkidle');

    const bodyText = await page.textContent('body');
    const isFrench =
      bodyText.includes('Explorez') ||
      bodyText.includes('Découvrez') ||
      bodyText.includes('Collection') ||
      bodyText.includes('Aviation');
    expect(isFrench).toBe(true);
  });

  test('le sélecteur de langue change le texte en anglais', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');

    const beforeText = await page.textContent('body');

    // Ouvrir le sélecteur de langue et cliquer sur EN
    const langSwitch = page.locator('.lang-switch').first();
    await langSwitch.click();
    const enOption = page.locator('.lang-option[data-lang="en"]').first();
    await enOption.click();
    await page.waitForTimeout(500);

    const afterText = await page.textContent('body');
    expect(afterText).not.toBe(beforeText);

    const hasEnglish =
      afterText.includes('Explore') ||
      afterText.includes('Discover') ||
      afterText.includes('Collection') ||
      afterText.toLowerCase().includes('history');
    expect(hasEnglish).toBe(true);
  });

  test('le changement de langue est persisté dans localStorage', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');

    // Ouvrir le sélecteur et changer en anglais
    const langSwitch = page.locator('.lang-switch').first();
    await langSwitch.click();
    const enOption = page.locator('.lang-option[data-lang="en"]').first();
    await enOption.click();
    await page.waitForTimeout(500);

    // Vérifier localStorage (clé = 'vol-histoire-lang')
    const storedLang = await page.evaluate(() => window.localStorage.getItem('vol-histoire-lang'));
    expect(storedLang).toBe('en');
  });
});
