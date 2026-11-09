// e2e/tests/conflicts.spec.js
//
// Exploration par conflit et par mission : page /conflits, page d'un conflit,
// filtres « Conflit » et « Mission » du hangar, liens depuis la fiche, et
// recherche par début de mot. Les attentes se lisent dans l'API plutôt que
// d'être codées en dur : la base locale porte le vrai catalogue, la CI un jeu
// de cinq appareils.
const { test, expect } = require('../helpers/fixtures');

async function firstWar(request) {
  const wars = await (await request.get('/api/wars')).json();
  expect(wars.length).toBeGreaterThan(0);
  return { wars, war: wars[0] };
}

test.describe('Conflits', () => {
  test('la liste affiche une carte par conflit rattaché', async ({ page, request }) => {
    const { wars } = await firstWar(request);
    await page.goto('/conflits');
    await expect(page.locator('.conflict-card')).toHaveCount(wars.length, { timeout: 10000 });
    await expect(page.locator('#stat-a')).toHaveText(String(wars.length));
  });

  test('une carte ouvre la page du conflit et ses appareils', async ({ page, request }) => {
    const { war } = await firstWar(request);
    await page.goto('/conflits');
    await page.locator(`.conflict-card[href="/conflits/${war.slug}"]`).click();
    // i18n peut ajouter ?lang=… à l'URL : on n'exige que la fin du chemin.
    await expect(page).toHaveURL((url) => url.pathname === `/conflits/${war.slug}`);
    await expect(page.locator('h1')).toHaveText(war.name);
    await expect(page.locator('#conflict-aircraft .aircraft-card')).toHaveCount(war.count, { timeout: 10000 });
  });

  test('« Filtrer dans le hangar » applique le filtre conflit', async ({ page, request }) => {
    const { war } = await firstWar(request);
    await page.goto(`/conflits/${war.slug}`);
    await page.locator('#conflict-hangar-link').click();
    await expect(page).toHaveURL(/\/hangar\?.*war=/);
    await expect(page.locator('#results-count')).toContainText(String(war.count), { timeout: 10000 });
  });

  test('un conflit inconnu répond 404', async ({ request }) => {
    const res = await request.get('/conflits/guerre-qui-n-existe-pas');
    expect(res.status()).toBe(404);
  });
});

test.describe('Hangar — filtres conflit et mission', () => {
  test('le menu « Conflit » liste les conflits et filtre au clic', async ({ page, request }) => {
    const { wars, war } = await firstWar(request);
    await page.goto('/hangar');
    await page.waitForSelector('.aircraft-card', { timeout: 10000 });
    await page.click('#war-filter-btn');
    const options = page.locator('#war-options .filter-option');
    await expect(options).toHaveCount(wars.length);
    await options.first().click();
    await expect(page).toHaveURL(new RegExp('war='));
    await expect(page.locator('#results-count')).toContainText(String(war.count), { timeout: 10000 });
  });
});

test.describe('Fiche — liens vers les conflits et les missions', () => {
  test('la carte d\'un conflit mène à sa page, une mission au hangar filtré', async ({ page, request }) => {
    const { war } = await firstWar(request);
    const detail = await (await request.get(`/api/wars/${war.slug}`)).json();
    await page.goto(`/details?id=${detail.airplanes[0].id}`);
    await expect(page.locator(`#wars-list a.war-link[href="/conflits/${war.slug}"]`)).toBeAttached({ timeout: 10000 });
    const mission = page.locator('#missions-list a.capability-link').first();
    if (await mission.count()) {
      expect(await mission.getAttribute('href')).toMatch(/^\/hangar\?mission=/);
    }
  });
});

test.describe('Recherche par début de mot', () => {
  test('« mira » trouve les Mirage', async ({ request }) => {
    const body = await (await request.get('/api/airplanes?search=mira')).json();
    expect(body.data.length).toBeGreaterThan(0);
    expect(body.data.some(a => /^Mirage/.test(a.name))).toBe(true);
  });
});
