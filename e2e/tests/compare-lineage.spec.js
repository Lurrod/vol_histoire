// e2e/tests/compare-lineage.spec.js
//
// Comparateur partagé hangar ↔ fiche, et chaîne de filiation.
// Les deux dépendent des données : on interroge l'API pour trouver des
// appareils qui conviennent plutôt que de coder des ids en dur, qui divergent
// entre la base de test et la production.
const { test, expect } = require('../helpers/fixtures');
const { URL } = require('url');

/** Deux ids d'appareils quelconques, pris sur la première page du hangar. */
async function twoAircraftIds(request) {
  const res = await request.get('/api/airplanes?limit=6');
  const { data } = await res.json();
  expect(data.length).toBeGreaterThanOrEqual(2);
  return [data[0].id, data[1].id];
}

/** Les écouteurs de la fiche et du hangar ne sont posés qu'après `auth.init()`,
 *  donc parfois après networkidle. La barre du comparateur est créée par ce
 *  même init : sa présence dans le DOM est le signal que le module est prêt. */
async function waitForCompareReady(page) {
  await expect(page.locator('#compare-bar')).toBeAttached({ timeout: 10000 });
}

/** Premier appareil du catalogue dont la filiation compte au moins 2 maillons.
 *  Sondé sur un petit échantillon et mémorisé : chaque appel coûte une requête,
 *  et le limiteur de débit de l'API n'est neutralisé qu'en NODE_ENV=test. */
const PROBE_SIZE = 10;
let lineageProbe;

async function aircraftWithLineage(request) {
  if (lineageProbe !== undefined) return lineageProbe;
  const res = await request.get(`/api/airplanes?limit=${PROBE_SIZE}`);
  const { data } = await res.json();
  lineageProbe = null;
  for (const plane of data) {
    const lineage = await request.get(`/api/airplanes/${plane.id}/lineage`);
    if (!lineage.ok()) continue;
    const { chain } = await lineage.json();
    if (chain && chain.length >= 2) { lineageProbe = { id: plane.id, chain }; break; }
  }
  return lineageProbe;
}

test.describe('Comparateur', () => {
  test('ajouter depuis une fiche fait apparaître la barre et ouvre la modale', async ({ page, request }) => {
    const [first, second] = await twoAircraftIds(request);

    await page.goto(`/details?id=${first}`);
    await waitForCompareReady(page);
    await page.click('#compare-btn');
    await expect(page.locator('#compare-bar')).toBeVisible();
    await expect(page.locator('#compare-btn')).toHaveAttribute('aria-pressed', 'true');

    // La sélection survit à la navigation vers une autre fiche
    await page.goto(`/details?id=${second}`);
    await waitForCompareReady(page);
    await expect(page.locator('#compare-bar')).toBeVisible();
    await page.click('#compare-btn');

    await page.click('#compare-view');
    await expect(page.locator('#compare-modal')).toBeVisible();
    await expect(page.locator('.cmp-col-head')).toHaveCount(2, { timeout: 10000 });
  });

  test('l\'URL de la fiche n\'est pas polluée par la sélection', async ({ page, request }) => {
    const [first] = await twoAircraftIds(request);
    await page.goto(`/details?id=${first}`);
    await waitForCompareReady(page);
    await page.click('#compare-btn');
    expect(new URL(page.url()).searchParams.get('compare')).toBeNull();
  });

  test('le hangar reflète la sélection dans son URL', async ({ page, request }) => {
    const [first] = await twoAircraftIds(request);
    await page.goto('/hangar');
    await waitForCompareReady(page);
    await page.locator(`.aircraft-card[data-id="${first}"] input[data-compare-id]`).first().check();
    await expect(async () => {
      expect(new URL(page.url()).searchParams.get('compare')).toContain(String(first));
    }).toPass({ timeout: 5000 });
  });

  test('un lien de comparaison partagé ouvre directement la modale', async ({ page, request }) => {
    const [first, second] = await twoAircraftIds(request);
    await page.goto(`/hangar?compare=${first},${second}`);
    await expect(page.locator('#compare-modal')).toBeVisible({ timeout: 10000 });
    await expect(page.locator('.cmp-col-head')).toHaveCount(2, { timeout: 10000 });
  });

  test('un id inexistant dans le lien est purgé sans casser la comparaison', async ({ page, request }) => {
    const [first] = await twoAircraftIds(request);
    await page.goto(`/hangar?compare=${first},999999`);
    await expect(page.locator('#compare-modal')).toBeVisible({ timeout: 10000 });
    await expect(page.locator('.cmp-col-head')).toHaveCount(1, { timeout: 10000 });
  });
});

test.describe('Filiation', () => {
  test('la chaîne s\'affiche et l\'appareil courant y est marqué', async ({ page, request }) => {
    const found = await aircraftWithLineage(request);
    test.skip(!found, 'Aucune filiation de deux maillons dans cette base');

    await page.goto(`/details?id=${found.id}`);
    await page.waitForLoadState('networkidle');

    const section = page.locator('#lineage-section');
    await expect(section).toBeVisible({ timeout: 10000 });
    await expect(page.locator('#lineage-chain .lineage-node')).toHaveCount(found.chain.length);
    await expect(page.locator('.lineage-node.is-current')).toHaveCount(1);
  });

  test('un maillon mène à la fiche correspondante', async ({ page, request }) => {
    const found = await aircraftWithLineage(request);
    test.skip(!found, 'Aucune filiation de deux maillons dans cette base');

    await page.goto(`/details?id=${found.id}`);
    await page.waitForLoadState('networkidle');
    await page.locator('#lineage-chain .lineage-node a').first().click();
    await page.waitForURL('**/details/**', { timeout: 8000 });
    await expect(page.locator('#aircraft-name')).toBeVisible();
  });
});
