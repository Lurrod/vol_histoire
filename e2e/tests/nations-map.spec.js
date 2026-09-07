// e2e/tests/nations-map.spec.js
//
// Carte des nations de conception, sur l'accueil. Le SVG n'est chargé qu'à
// l'approche de la section : chaque test doit y faire défiler la page.
const { test, expect } = require('../helpers/fixtures');
const { URL } = require('url');

async function revealMap(page) {
  await page.goto('/');
  await page.locator('#nations-map-section').scrollIntoViewIfNeeded();
  await expect(page.locator('#nations-map-canvas svg')).toBeVisible({ timeout: 15000 });
  await expect(page.locator('.wm-nation-active').first()).toBeAttached({ timeout: 15000 });
}

test.describe('Carte des nations', () => {
  test('le planisphère se charge et colore les nations du catalogue', async ({ page, request }) => {
    await revealMap(page);

    const nations = await (await request.get('/api/nations')).json();
    await expect(page.locator('.wm-nation-active')).toHaveCount(nations.length);

    // Chaque nation colorée est atteignable au clavier et se décrit
    const first = page.locator('.wm-nation-active').first();
    await expect(first).toHaveAttribute('tabindex', '0');
    await expect(first).toHaveAttribute('role', 'link');
    expect(await first.getAttribute('aria-label')).toBeTruthy();
  });

  test('la synthèse annonce le nombre de nations', async ({ page, request }) => {
    await revealMap(page);
    const nations = await (await request.get('/api/nations')).json();
    await expect(page.locator('#nations-map-summary')).toContainText(String(nations.length));
    await expect(page.locator('#nations-map-summary .nm-chip')).toHaveCount(3);
  });

  test('cliquer sur une nation ouvre le hangar filtré sur elle', async ({ page }) => {
    await revealMap(page);

    const target = page.locator('.wm-nation-active').first();
    const expected = await target.getAttribute('data-name-fr');
    await target.focus();
    await page.keyboard.press('Enter');

    await page.waitForURL('**/hangar**', { timeout: 10000 });
    expect(new URL(page.url()).searchParams.get('country')).toBe(expected);
    await expect(page.locator('.aircraft-card').first()).toBeVisible({ timeout: 10000 });
  });

  test('les pays sans fiche restent du décor', async ({ page }) => {
    await revealMap(page);
    const inert = page.locator('.wm-nation-empty');
    if (await inert.count() > 0) {
      await expect(inert.first()).not.toHaveAttribute('tabindex', '0');
    }
  });
});

test.describe('Carte des nations — filtre du hangar', () => {
  // Les écouteurs du hangar sont posés après `auth.init()` : #compare-bar,
  // créée par le même init, signale que la page est prête.
  async function openPanel(page) {
    await page.goto('/hangar');
    await expect(page.locator('#compare-bar')).toBeAttached({ timeout: 10000 });
    await page.click('#map-filter-btn');
    await expect(page.locator('#nations-map-panel .wm-nation-active').first())
      .toBeAttached({ timeout: 15000 });
  }

  test('le planisphère n\'est chargé qu\'à la première ouverture', async ({ page }) => {
    const requests = [];
    page.on('request', r => { if (r.url().includes('world-nations.svg')) requests.push(r.url()); });

    await page.goto('/hangar');
    await expect(page.locator('#compare-bar')).toBeAttached({ timeout: 10000 });
    await expect(page.locator('#nations-map-panel')).toBeHidden();
    expect(requests).toHaveLength(0);

    await page.click('#map-filter-btn');
    await expect(page.locator('#nations-map-panel .wm-nation-active').first())
      .toBeAttached({ timeout: 15000 });
    await expect(page.locator('#map-filter-btn')).toHaveAttribute('aria-expanded', 'true');
    expect(requests).toHaveLength(1);
  });

  test('cliquer un pays filtre sur place et referme le panneau', async ({ page }) => {
    await openPanel(page);

    const target = page.locator('#nations-map-panel .wm-nation-active').first();
    const expected = await target.getAttribute('data-name-fr');
    await target.focus();
    await page.keyboard.press('Enter');

    // On reste sur le hangar : c'est toute la différence avec la carte d'accueil
    await expect(page).toHaveURL(/\/hangar/);
    await expect(async () => {
      expect(new URL(page.url()).searchParams.get('country')).toBe(expected);
    }).toPass({ timeout: 8000 });
    await expect(page.locator('#nations-map-panel')).toBeHidden();
    await expect(page.locator('#active-filters')).toContainText(/\S/);
  });

  test('le pays filtré est marqué à la réouverture, et un second clic le retire', async ({ page }) => {
    await openPanel(page);
    await page.locator('#nations-map-panel .wm-nation-active').first().focus();
    await page.keyboard.press('Enter');
    await expect(page.locator('#nations-map-panel')).toBeHidden();

    await page.click('#map-filter-btn');
    const selected = page.locator('#nations-map-panel .wm-nation-active.is-selected');
    await expect(selected).toHaveCount(1);

    await selected.focus();
    await page.keyboard.press('Enter');
    await expect(async () => {
      expect(new URL(page.url()).searchParams.get('country')).toBeNull();
    }).toPass({ timeout: 8000 });
  });

  test('le bouton Carte disparaît sous 768 px', async ({ page }) => {
    await page.setViewportSize({ width: 390, height: 844 });
    await page.goto('/hangar');
    await expect(page.locator('#compare-bar')).toBeAttached({ timeout: 10000 });
    await expect(page.locator('#map-filter-btn')).toBeHidden();
  });
});
