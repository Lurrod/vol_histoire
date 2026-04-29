// e2e/tests/admin-crud.spec.js
// Tests CRUD avion pour les utilisateurs admin/éditeur
const { test, expect } = require('../helpers/fixtures');
const { loginViaApi } = require('../helpers/auth');

// Ces tests nécessitent un compte admin en BDD (id=1, role_id=1)
test.describe('Admin — CRUD Avions', () => {
  test.beforeEach(async ({ page }) => {
    await loginViaApi(page, 'test@gmail.com', 'test');
  });

  test('le bouton ajouter est visible pour un admin', async ({ page }) => {
    await page.goto('/hangar');
    await page.waitForSelector('.aircraft-card', { timeout: 10000 });

    const addBtn = page.locator('#add-airplane-btn');
    await expect(addBtn).toBeVisible({ timeout: 5000 });
  });

  test('créer un avion via le formulaire modal', async ({ page }) => {
    await page.goto('/hangar');
    await page.waitForSelector('.aircraft-card', { timeout: 10000 });

    // Ouvrir la modale
    await page.click('#add-airplane-btn');
    const modal = page.locator('#aircraft-modal');
    await expect(modal).toBeVisible({ timeout: 3000 });

    // Remplir TOUS les champs obligatoires (la validation HTML5 bloque sinon)
    await page.fill('#aircraft-name', 'E2E Test Aircraft');
    await page.fill('#aircraft-little-description', 'Avion créé par les tests E2E');
    await page.fill('#aircraft-image-url', 'https://vol-histoire.titouan-borde.com/assets/airplanes/a10-thunderbolt-2.jpg');

    // Attendre que les dropdowns soient peuplés par l'API référentiels
    await page.waitForFunction(
      () => document.querySelectorAll('#aircraft-country option').length > 1
    );

    // Sélectionner la première option non vide pour chaque select obligatoire
    for (const id of ['#aircraft-country', '#aircraft-manufacturer', '#aircraft-generation', '#aircraft-type']) {
      const sel = page.locator(id);
      const optCount = await sel.locator('option').count();
      if (optCount > 1) await sel.selectOption({ index: 1 });
    }

    // Soumettre
    await page.click('#aircraft-form button[type="submit"]');

    // Attendre la fermeture de la modale (signal de succès)
    await expect(modal).toBeHidden({ timeout: 5000 });

    // Vérifier qu'un avion a été ajouté (via API, limite 100 = tous les avions)
    const response = await page.request.get('http://localhost:3000/api/airplanes?search=E2E+Test+Aircraft&limit=100');
    const data = await response.json();
    const created = data.data?.find(a => a.name === 'E2E Test Aircraft');
    expect(created).toBeDefined();
  });

  test('la page détails affiche l\'avion créé', async ({ page }) => {
    // Chercher l'avion par son nom via l'API
    const response = await page.request.get('http://localhost:3000/api/airplanes?search=E2E+Test+Aircraft&limit=100');
    const data = await response.json();
    const aircraft = data.data?.find(a => a.name === 'E2E Test Aircraft');

    test.skip(!aircraft, 'Avion E2E non trouvé — test de création peut avoir échoué');

    await page.goto(`/details?id=${aircraft.id}`);
    await page.waitForLoadState('networkidle');

    const title = page.locator('h1').first();
    await expect(title).toContainText('E2E Test Aircraft', { timeout: 8000 });
  });

  test('supprimer l\'avion créé via l\'API', async ({ page }) => {
    // Naviguer pour avoir auth.js chargé en mémoire
    await page.goto('/hangar');
    await page.waitForLoadState('networkidle');

    // Chercher l'avion par nom (toutes pages, limit max)
    const listResponse = await page.request.get('http://localhost:3000/api/airplanes?search=E2E+Test+Aircraft&limit=100');
    const data = await listResponse.json();
    const aircraft = data.data?.find(a => a.name === 'E2E Test Aircraft');

    test.skip(!aircraft, 'Avion E2E non trouvé — rien à supprimer');

    // Le token est en mémoire dans auth.js (jamais persisté en localStorage),
    // accessible via le scope script global.
    const token = await page.evaluate(() => {
      try { return typeof auth !== 'undefined' ? auth.getToken() : null; }
      catch { return null; }
    });
    expect(token).toBeTruthy();

    const deleteResponse = await page.request.delete(
      `http://localhost:3000/api/airplanes/${aircraft.id}`,
      { headers: { Authorization: `Bearer ${token}` } }
    );
    expect(deleteResponse.status()).toBe(200);

    // Vérifier que l'avion n'existe plus
    const checkResponse = await page.request.get(`http://localhost:3000/api/airplanes/${aircraft.id}`);
    expect(checkResponse.status()).toBe(404);
  });
});
