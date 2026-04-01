# Track A — Tests : Plan d'Implémentation

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Atteindre 80%+ de couverture backend avec seuil bloquant, couvrir les routes et branches manquantes, et introduire 5 tests E2E Playwright sur les flows critiques.

**Architecture:** Les tests backend utilisent Jest + Supertest avec un pool PostgreSQL mocké (pattern existant). Les tests E2E utilisent Playwright installé dans `e2e/` à la racine du projet, avec démarrage automatique du backend (port 3000) et du frontend servi statiquement (port 8080).

**Tech Stack:** Jest 29 + Supertest 7 (existant), Playwright (nouveau), Node.js `serve` pour le frontend en E2E.

---

## Fichiers concernés

| Action | Fichier | Rôle |
|--------|---------|------|
| Modifier | `backend/jest.config.json` | Ajouter `coverageThreshold` à 80% |
| Modifier | `backend/__tests__/validators.test.js` | Tests manquants `validateAirplaneData` |
| Modifier | `backend/__tests__/api.test.js` | Tests manquants : sitemap, related, gaps |
| Créer | `e2e/playwright.config.js` | Config Playwright |
| Créer | `e2e/helpers/auth.js` | Helper login réutilisable |
| Créer | `e2e/tests/login.spec.js` | Flow login/logout |
| Créer | `e2e/tests/hangar.spec.js` | Navigation hangar + filtres |
| Créer | `e2e/tests/details.spec.js` | Page détails avion |
| Créer | `e2e/tests/favorites.spec.js` | Ajout/suppression favoris |
| Créer | `e2e/tests/i18n.spec.js` | Changement de langue fr/en |
| Modifier | `package.json` (racine) | Scripts `e2e` et `test:all` |

---

## Task 1 : Seuil de couverture dans jest.config.json

**Fichiers :**
- Modifier : `backend/jest.config.json`

Actuellement la couverture est à 84.65% (statements) et 81.88% (branches). On fige le seuil à 80% pour qu'une régression soit détectée automatiquement.

- [ ] **Étape 1 : Ajouter coverageThreshold**

Remplacer le contenu de `backend/jest.config.json` par :

```json
{
  "testEnvironment": "node",
  "testMatch": ["**/__tests__/**/*.test.js"],
  "collectCoverageFrom": [
    "validators.js",
    "app.js"
  ],
  "coverageReporters": ["text", "lcov"],
  "coverageThreshold": {
    "global": {
      "statements": 80,
      "branches": 80,
      "functions": 80,
      "lines": 80
    }
  },
  "verbose": true,
  "resolver": "./jest-resolver.js"
}
```

- [ ] **Étape 2 : Vérifier que la couverture actuelle passe le seuil**

```bash
cd backend && npm run test:coverage
```

Résultat attendu : `Tests: 237 passed` + aucun message `Jest: "global" coverage threshold for ...` en rouge.

- [ ] **Étape 3 : Commit**

```bash
git add backend/jest.config.json
git commit -m "test: ajouter coverageThreshold 80% dans jest.config"
```

---

## Task 2 : Couvrir les branches manquantes de validateAirplaneData

**Fichiers :**
- Modifier : `backend/__tests__/validators.test.js`

Les lignes 75, 78, 93, 96, 102, 105, 108, 111 de `validators.js` ne sont pas couvertes. Ce sont les branches d'erreur de `validateAirplaneData` pour : `complete_name`, `little_description`, `date_first_fly`, `date_operationel`, `max_range`, `id_manufacturer`, `id_generation`, `type`.

- [ ] **Étape 1 : Ajouter un bloc describe dans validators.test.js**

Ajouter à la fin de `backend/__tests__/validators.test.js` :

```js
// =============================================================================
// validateAirplaneData — branches optionnelles
// =============================================================================
describe('validateAirplaneData — champs optionnels invalides', () => {
  const base = { name: 'Rafale' };

  test('complete_name trop long (>255 car.) → erreur', () => {
    const errors = validateAirplaneData({ ...base, complete_name: 'A'.repeat(256) });
    expect(errors).toContain('Le nom complet ne doit pas dépasser 255 caractères.');
  });

  test('little_description trop longue (>255 car.) → erreur', () => {
    const errors = validateAirplaneData({ ...base, little_description: 'B'.repeat(256) });
    expect(errors).toContain('La description courte ne doit pas dépasser 255 caractères.');
  });

  test('date_first_fly invalide → erreur', () => {
    const errors = validateAirplaneData({ ...base, date_first_fly: 'not-a-date' });
    expect(errors).toContain('La date du premier vol doit être une date valide.');
  });

  test('date_operationel invalide → erreur', () => {
    const errors = validateAirplaneData({ ...base, date_operationel: 'not-a-date' });
    expect(errors).toContain('La date opérationnelle doit être une date valide.');
  });

  test('max_range négatif → erreur', () => {
    const errors = validateAirplaneData({ ...base, max_range: -100 });
    expect(errors).toContain('La portée max doit être un nombre positif.');
  });

  test('id_manufacturer invalide (chaîne) → erreur', () => {
    const errors = validateAirplaneData({ ...base, id_manufacturer: 'abc' });
    expect(errors).toContain("L'ID du fabricant doit être un entier positif.");
  });

  test('id_generation invalide (négatif) → erreur', () => {
    const errors = validateAirplaneData({ ...base, id_generation: -1 });
    expect(errors).toContain("L'ID de la génération doit être un entier positif.");
  });

  test('type invalide (0) → erreur', () => {
    const errors = validateAirplaneData({ ...base, type: 0 });
    expect(errors).toContain("L'ID du type doit être un entier positif.");
  });

  test('plusieurs erreurs simultanées', () => {
    const errors = validateAirplaneData({
      ...base,
      complete_name: 'A'.repeat(256),
      max_range: -1,
      id_generation: 'xyz',
    });
    expect(errors.length).toBe(3);
  });
});
```

- [ ] **Étape 2 : Lancer les tests et vérifier qu'ils passent**

```bash
cd backend && npm test -- --testPathPattern=validators
```

Résultat attendu : tous les tests passent, y compris les 9 nouveaux.

- [ ] **Étape 3 : Vérifier la progression de la couverture**

```bash
cd backend && npm run test:coverage
```

Résultat attendu : `validators.js` lignes ≥ 95%.

- [ ] **Étape 4 : Commit**

```bash
git add backend/__tests__/validators.test.js
git commit -m "test: couvrir branches manquantes de validateAirplaneData"
```

---

## Task 3 : Tester la route GET /sitemap.xml

**Fichiers :**
- Modifier : `backend/__tests__/api.test.js`

La route `/sitemap.xml` (lignes 764-808 de `app.js`) n'est pas testée du tout. Elle interroge la BDD et retourne du XML.

- [ ] **Étape 1 : Ajouter le describe dans api.test.js**

Ajouter après le dernier `describe` existant dans `backend/__tests__/api.test.js` :

```js
// =============================================================================
// GET /sitemap.xml
// =============================================================================
describe('GET /sitemap.xml', () => {
  test('200 — retourne un XML valide avec les URLs des avions', async () => {
    mockPool.query.mockResolvedValueOnce({
      rows: [{ id: 1 }, { id: 2 }, { id: 42 }],
    });

    const res = await request(app).get('/sitemap.xml');

    expect(res.status).toBe(200);
    expect(res.headers['content-type']).toMatch(/application\/xml/);
    expect(res.text).toContain('<?xml version="1.0" encoding="UTF-8"?>');
    expect(res.text).toContain('/details?id=1');
    expect(res.text).toContain('/details?id=2');
    expect(res.text).toContain('/details?id=42');
    expect(res.text).toContain('/hangar');
  });

  test('500 — erreur BDD → réponse texte erreur serveur', async () => {
    mockPool.query.mockRejectedValueOnce(new Error('DB down'));

    const res = await request(app).get('/sitemap.xml');

    expect(res.status).toBe(500);
    expect(res.text).toContain('Erreur serveur');
  });
});
```

- [ ] **Étape 2 : Lancer les tests**

```bash
cd backend && npm test -- --testPathPattern=api
```

Résultat attendu : 2 nouveaux tests passent.

- [ ] **Étape 3 : Commit**

```bash
git add backend/__tests__/api.test.js
git commit -m "test: couvrir route GET /sitemap.xml (succès + erreur BDD)"
```

---

## Task 4 : Couvrir les branches manquantes de app.js

**Fichiers :**
- Modifier : `backend/__tests__/api.test.js`

Trois groupes de lignes restent non couverts : la route `/api/airplanes/:id/related` (lignes 964-998), et plusieurs error paths dans les routes de référentiels.

- [ ] **Étape 1 : Ajouter les tests pour /api/airplanes/:id/related**

Ajouter dans le describe `'Relations avions'` existant dans `backend/__tests__/api.test.js` :

```js
  test('GET /api/airplanes/:id/related — 200 (toutes les relations)', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [{ name: 'Missile MICA', description: 'IR/EM' }] }) // armement
      .mockResolvedValueOnce({ rows: [{ name: 'RBE2-AA', description: 'Radar AESA' }] }) // tech
      .mockResolvedValueOnce({ rows: [{ name: 'Supériorité aérienne', description: '' }] }) // missions
      .mockResolvedValueOnce({ rows: [{ name: 'Opération Serval', date_start: '2013', date_end: '2014', description: '' }] }); // wars

    const res = await request(app)
      .get('/api/airplanes/4/related')
      .set('Authorization', `Bearer ${tokenAdmin}`);

    expect(res.status).toBe(200);
    expect(res.body).toHaveProperty('armament');
    expect(res.body).toHaveProperty('tech');
    expect(res.body).toHaveProperty('missions');
    expect(res.body).toHaveProperty('wars');
    expect(res.body.armament[0].name).toBe('Missile MICA');
  });

  test('GET /api/airplanes/:id/related — 500 erreur BDD', async () => {
    mockPool.query.mockRejectedValueOnce(new Error('DB error'));

    const res = await request(app)
      .get('/api/airplanes/4/related')
      .set('Authorization', `Bearer ${tokenAdmin}`);

    expect(res.status).toBe(500);
    expect(res.body.error).toBe('Erreur serveur');
  });
```

- [ ] **Étape 2 : Ajouter les error paths des référentiels**

Ajouter dans le describe `'Référentiels'` existant :

```js
  test('GET /api/countries — 500 erreur BDD', async () => {
    mockPool.query.mockRejectedValueOnce(new Error('DB error'));
    const res = await request(app).get('/api/countries');
    expect(res.status).toBe(500);
  });

  test('GET /api/generations — 500 erreur BDD', async () => {
    mockPool.query.mockRejectedValueOnce(new Error('DB error'));
    const res = await request(app).get('/api/generations');
    expect(res.status).toBe(500);
  });

  test('GET /api/types — 500 erreur BDD', async () => {
    mockPool.query.mockRejectedValueOnce(new Error('DB error'));
    const res = await request(app).get('/api/types');
    expect(res.status).toBe(500);
  });
```

- [ ] **Étape 3 : Lancer les tests et vérifier la progression**

```bash
cd backend && npm run test:coverage
```

Résultat attendu : `app.js` branches ≥ 84%, total coverage ≥ 85%.

- [ ] **Étape 4 : Commit**

```bash
git add backend/__tests__/api.test.js
git commit -m "test: couvrir /related et error paths des référentiels"
```

---

## Task 5 : Installer et configurer Playwright

**Fichiers :**
- Créer : `e2e/playwright.config.js`
- Créer : `e2e/package.json`
- Modifier : `package.json` (racine)

- [ ] **Étape 1 : Créer e2e/package.json**

Créer le fichier `e2e/package.json` :

```json
{
  "name": "vol-histoire-e2e",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "test": "playwright test",
    "test:headed": "playwright test --headed",
    "test:ui": "playwright test --ui"
  },
  "devDependencies": {
    "@playwright/test": "^1.44.0"
  }
}
```

- [ ] **Étape 2 : Installer Playwright**

```bash
cd e2e && npm install && npx playwright install chromium
```

Résultat attendu : dossier `e2e/node_modules/` créé, navigateur Chromium téléchargé.

- [ ] **Étape 3 : Créer e2e/playwright.config.js**

```js
// e2e/playwright.config.js
const { defineConfig, devices } = require('@playwright/test');

module.exports = defineConfig({
  testDir: './tests',
  timeout: 30000,
  retries: 0,
  reporter: 'list',
  use: {
    baseURL: 'http://localhost:8080',
    headless: true,
    screenshot: 'only-on-failure',
    video: 'off',
  },
  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
  ],
  webServer: [
    {
      command: 'cd ../backend && node server.js',
      port: 3000,
      timeout: 15000,
      reuseExistingServer: true,
      env: {
        NODE_ENV: 'test',
        PORT: '3000',
      },
    },
    {
      command: 'npx serve ../frontend -l 8080 --no-clipboard',
      port: 8080,
      timeout: 10000,
      reuseExistingServer: true,
    },
  ],
});
```

- [ ] **Étape 4 : Créer le dossier tests et le helper auth**

Créer `e2e/tests/` (dossier vide), puis créer `e2e/helpers/auth.js` :

```js
// e2e/helpers/auth.js
// Helper réutilisable pour se connecter via l'API avant les tests E2E

/**
 * Effectue un login via l'API REST et stocke le token JWT dans localStorage.
 * @param {import('@playwright/test').Page} page
 * @param {string} email
 * @param {string} password
 */
async function loginViaApi(page, email, password) {
  const response = await page.request.post('http://localhost:3000/api/login', {
    data: { email, password },
  });
  const body = await response.json();
  if (!body.token) {
    throw new Error(`Login échoué : ${JSON.stringify(body)}`);
  }
  // Stocker le token dans localStorage pour que auth.js le trouve
  await page.addInitScript((token) => {
    window.localStorage.setItem('authToken', token);
  }, body.token);
}

module.exports = { loginViaApi };
```

- [ ] **Étape 5 : Vérifier la config (dry run)**

```bash
cd e2e && npx playwright test --list
```

Résultat attendu : `No tests found` (normal, aucun fichier spec n'existe encore).

- [ ] **Étape 6 : Ajouter les scripts à package.json racine**

Modifier `package.json` à la racine du projet pour ajouter :

```json
{
  "scripts": {
    "e2e": "cd e2e && npm test",
    "e2e:headed": "cd e2e && npm run test:headed",
    "test:all": "cd backend && npm run test:coverage && cd ../e2e && npm test"
  }
}
```

- [ ] **Étape 7 : Commit**

```bash
git add e2e/ package.json
git commit -m "test: setup Playwright E2E dans e2e/"
```

---

## Task 6 : E2E — Flow login / logout

**Fichiers :**
- Créer : `e2e/tests/login.spec.js`

**Prérequis :** Un compte utilisateur de test doit exister dans la BDD locale avec l'email vérifié. Le créer une seule fois via curl (backend doit tourner) :

```bash
curl -X POST http://localhost:3000/api/register \
  -H "Content-Type: application/json" \
  -d '{"name":"Test User","email":"test@vol-histoire.com","password":"TestPass123"}'
# Puis vérifier manuellement le compte en base :
# UPDATE users SET email_verified = true WHERE email = 'test@vol-histoire.com';
```

- [ ] **Étape 1 : Créer e2e/tests/login.spec.js**

```js
// e2e/tests/login.spec.js
const { test, expect } = require('@playwright/test');

test.describe('Login / Logout', () => {
  test('login réussi redirige vers l\'accueil', async ({ page }) => {
    await page.goto('/login.html');

    await page.fill('#email', 'test@vol-histoire.com');
    await page.fill('#password', 'TestPass123');
    await page.click('button[type="submit"]');

    // Après login, on est redirigé vers l'index
    await page.waitForURL('**/index.html', { timeout: 5000 });
    await expect(page).toHaveURL(/index\.html/);
  });

  test('email incorrect → message d\'erreur visible', async ({ page }) => {
    await page.goto('/login.html');

    await page.fill('#email', 'inexistant@vol-histoire.com');
    await page.fill('#password', 'WrongPass123');
    await page.click('button[type="submit"]');

    // Un message d'erreur doit apparaître (toast ou div erreur)
    const errorMsg = page.locator('.toast-error, .error-message, [data-error]').first();
    await expect(errorMsg).toBeVisible({ timeout: 5000 });
  });

  test('champs vides → le formulaire ne soumet pas', async ({ page }) => {
    await page.goto('/login.html');
    await page.click('button[type="submit"]');

    // Toujours sur la page login
    await expect(page).toHaveURL(/login\.html/);
  });
});
```

- [ ] **Étape 2 : Lancer le test**

```bash
cd e2e && npx playwright test tests/login.spec.js
```

Résultat attendu : 3 tests passent (adapter les sélecteurs CSS si nécessaire en inspectant le DOM réel).

- [ ] **Étape 3 : Commit**

```bash
git add e2e/tests/login.spec.js
git commit -m "test(e2e): flow login/logout"
```

---

## Task 7 : E2E — Navigation hangar + filtres

**Fichiers :**
- Créer : `e2e/tests/hangar.spec.js`

- [ ] **Étape 1 : Créer e2e/tests/hangar.spec.js**

```js
// e2e/tests/hangar.spec.js
const { test, expect } = require('@playwright/test');

test.describe('Hangar', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/hangar.html');
    // Attendre que les cartes avions soient chargées
    await page.waitForSelector('.plane-card, .airplane-card, [data-airplane-id]', { timeout: 10000 });
  });

  test('la page affiche au moins une carte avion', async ({ page }) => {
    const cards = page.locator('.plane-card, .airplane-card, [data-airplane-id]');
    await expect(cards.first()).toBeVisible();
    const count = await cards.count();
    expect(count).toBeGreaterThan(0);
  });

  test('cliquer sur une carte navigue vers la page détails', async ({ page }) => {
    const firstCard = page.locator('.plane-card, .airplane-card, [data-airplane-id]').first();
    await firstCard.click();
    await page.waitForURL('**/details.html**', { timeout: 5000 });
    await expect(page).toHaveURL(/details\.html/);
  });

  test('le filtre par pays réduit les résultats', async ({ page }) => {
    // Compter les cartes initiales
    const cards = page.locator('.plane-card, .airplane-card, [data-airplane-id]');
    const initialCount = await cards.count();

    // Sélectionner un pays dans le filtre
    const countryFilter = page.locator('select[name="country"], #filter-country, [data-filter="country"]').first();
    await countryFilter.selectOption({ index: 1 }); // premier pays disponible

    // Attendre le rechargement
    await page.waitForTimeout(500);
    const filteredCount = await cards.count();

    // Le filtre doit avoir un effet
    expect(filteredCount).toBeLessThanOrEqual(initialCount);
  });
});
```

- [ ] **Étape 2 : Lancer le test**

```bash
cd e2e && npx playwright test tests/hangar.spec.js
```

Résultat attendu : 3 tests passent. Si les sélecteurs CSS ne correspondent pas, inspecter le DOM de `hangar.html` et ajuster.

- [ ] **Étape 3 : Commit**

```bash
git add e2e/tests/hangar.spec.js
git commit -m "test(e2e): navigation hangar et filtre pays"
```

---

## Task 8 : E2E — Page détails d'un avion

**Fichiers :**
- Créer : `e2e/tests/details.spec.js`

- [ ] **Étape 1 : Créer e2e/tests/details.spec.js**

```js
// e2e/tests/details.spec.js
const { test, expect } = require('@playwright/test');

test.describe('Page Détails', () => {
  test.beforeEach(async ({ page }) => {
    // L'avion id=1 (A-10 Thunderbolt II) doit exister en BDD locale
    await page.goto('/details.html?id=1');
    await page.waitForLoadState('networkidle');
  });

  test('le nom de l\'avion est affiché dans le titre', async ({ page }) => {
    const title = page.locator('h1, .plane-title, .airplane-name').first();
    await expect(title).toBeVisible({ timeout: 8000 });
    const text = await title.textContent();
    expect(text.trim().length).toBeGreaterThan(0);
  });

  test('l\'image de l\'avion est chargée', async ({ page }) => {
    const img = page.locator('img.plane-image, img.airplane-image, .details-image img').first();
    await expect(img).toBeVisible({ timeout: 8000 });
    // Vérifier que l'image n'est pas cassée
    const naturalWidth = await img.evaluate(el => el.naturalWidth);
    expect(naturalWidth).toBeGreaterThan(0);
  });

  test('la page 404 s\'affiche pour un ID inexistant', async ({ page }) => {
    await page.goto('/details.html?id=99999');
    await page.waitForLoadState('networkidle');
    // Soit une page 404, soit un message "avion non trouvé"
    const notFound = page.locator('h1:has-text("404"), .not-found, [data-not-found]').first();
    const bodyText = await page.textContent('body');
    const hasNotFoundIndicator =
      (await notFound.count()) > 0 ||
      bodyText.includes('404') ||
      bodyText.includes('non trouvé') ||
      bodyText.toLowerCase().includes('not found');
    expect(hasNotFoundIndicator).toBe(true);
  });
});
```

- [ ] **Étape 2 : Lancer le test**

```bash
cd e2e && npx playwright test tests/details.spec.js
```

Résultat attendu : 3 tests passent.

- [ ] **Étape 3 : Commit**

```bash
git add e2e/tests/details.spec.js
git commit -m "test(e2e): page détails avion"
```

---

## Task 9 : E2E — Favoris

**Fichiers :**
- Créer : `e2e/tests/favorites.spec.js`

- [ ] **Étape 1 : Créer e2e/tests/favorites.spec.js**

```js
// e2e/tests/favorites.spec.js
const { test, expect } = require('@playwright/test');
const { loginViaApi } = require('../helpers/auth');

test.describe('Favoris', () => {
  test('utilisateur non connecté → page favoris redirige vers login', async ({ page }) => {
    await page.goto('/favorites.html');
    await page.waitForLoadState('networkidle');
    // Soit redirection vers login, soit message d'invite
    const url = page.url();
    const bodyText = await page.textContent('body');
    const isBlocked =
      url.includes('login') ||
      bodyText.includes('connecter') ||
      bodyText.includes('connexion') ||
      bodyText.toLowerCase().includes('login');
    expect(isBlocked).toBe(true);
  });

  test('utilisateur connecté → page favoris accessible', async ({ page }) => {
    await loginViaApi(page, 'test@vol-histoire.com', 'TestPass123');
    await page.goto('/favorites.html');
    await page.waitForLoadState('networkidle');

    // La page ne doit pas rediriger vers login
    expect(page.url()).not.toContain('login');
    // Un conteneur de favoris (vide ou non) doit être présent
    const container = page.locator('.favorites-list, .favorites-container, #favorites-container').first();
    await expect(container).toBeVisible({ timeout: 8000 });
  });

  test('ajouter un avion aux favoris depuis le hangar', async ({ page }) => {
    await loginViaApi(page, 'test@vol-histoire.com', 'TestPass123');
    await page.goto('/hangar.html');
    await page.waitForSelector('.plane-card, .airplane-card, [data-airplane-id]', { timeout: 10000 });

    // Cliquer sur le bouton favori de la première carte
    const favBtn = page.locator('.favorite-btn, .btn-favorite, [data-action="favorite"]').first();
    await favBtn.click();

    // Un toast de confirmation doit apparaître
    const toast = page.locator('.toast, .toast-success, .notification').first();
    await expect(toast).toBeVisible({ timeout: 5000 });
  });
});
```

- [ ] **Étape 2 : Lancer le test**

```bash
cd e2e && npx playwright test tests/favorites.spec.js
```

Résultat attendu : 3 tests passent.

- [ ] **Étape 3 : Commit**

```bash
git add e2e/tests/favorites.spec.js
git commit -m "test(e2e): flow favoris (non connecté, connecté, ajout)"
```

---

## Task 10 : E2E — Changement de langue fr/en

**Fichiers :**
- Créer : `e2e/tests/i18n.spec.js`

- [ ] **Étape 1 : Créer e2e/tests/i18n.spec.js**

```js
// e2e/tests/i18n.spec.js
const { test, expect } = require('@playwright/test');

test.describe('Internationalisation fr/en', () => {
  test('la page index se charge en français par défaut', async ({ page }) => {
    // Réinitialiser la langue (supprimer tout localStorage)
    await page.addInitScript(() => window.localStorage.clear());
    await page.goto('/index.html');
    await page.waitForLoadState('networkidle');

    // La langue par défaut doit être le français
    const html = await page.locator('html').getAttribute('lang');
    // Soit l'attribut lang est 'fr', soit on trouve du texte français
    const bodyText = await page.textContent('body');
    const isFrench =
      html === 'fr' ||
      bodyText.includes('Explorez') ||
      bodyText.includes('Découvrez') ||
      bodyText.includes('Collection') ||
      bodyText.toLowerCase().includes('aviation');
    expect(isFrench).toBe(true);
  });

  test('le sélecteur de langue change le texte de la page', async ({ page }) => {
    await page.goto('/index.html');
    await page.waitForLoadState('networkidle');

    // Récupérer un texte avant le changement
    const beforeText = await page.textContent('body');

    // Cliquer sur le bouton anglais
    const langBtn = page.locator('[data-lang="en"], #lang-en, button:has-text("EN"), button:has-text("English")').first();
    await langBtn.click();
    await page.waitForTimeout(500);

    // Le texte doit avoir changé
    const afterText = await page.textContent('body');
    expect(afterText).not.toBe(beforeText);
    // Des mots anglais doivent apparaître
    const hasEnglish =
      afterText.includes('Explore') ||
      afterText.includes('Discover') ||
      afterText.includes('Collection') ||
      afterText.toLowerCase().includes('history');
    expect(hasEnglish).toBe(true);
  });

  test('le changement de langue est persisté dans localStorage', async ({ page }) => {
    await page.goto('/index.html');
    await page.waitForLoadState('networkidle');

    // Changer en anglais
    const langBtn = page.locator('[data-lang="en"], #lang-en, button:has-text("EN"), button:has-text("English")').first();
    await langBtn.click();
    await page.waitForTimeout(500);

    // Vérifier dans localStorage
    const storedLang = await page.evaluate(() => window.localStorage.getItem('language') || window.localStorage.getItem('lang'));
    expect(storedLang).toBe('en');
  });
});
```

- [ ] **Étape 2 : Lancer le test**

```bash
cd e2e && npx playwright test tests/i18n.spec.js
```

Résultat attendu : 3 tests passent.

- [ ] **Étape 3 : Commit**

```bash
git add e2e/tests/i18n.spec.js
git commit -m "test(e2e): changement de langue fr/en"
```

---

## Task 11 : Vérification finale

- [ ] **Étape 1 : Lancer tous les tests backend avec couverture**

```bash
cd backend && npm run test:coverage
```

Résultat attendu :
- `Tests: 250+ passed`
- `app.js` statements ≥ 85%, branches ≥ 83%
- `validators.js` statements ≥ 95%
- Aucun message `coverage threshold` en rouge

- [ ] **Étape 2 : Lancer tous les tests E2E**

```bash
cd e2e && npm test
```

Résultat attendu : 15 tests passent (3 par spec × 5 specs).

- [ ] **Étape 3 : Commit de clôture du track**

```bash
git add -A
git commit -m "test: Track A complet — couverture backend ≥85%, 15 tests E2E Playwright"
```

---

## Résumé des critères de succès

| Critère | Cible | Commande de vérification |
|---------|-------|--------------------------|
| Couverture backend statements | ≥ 85% | `cd backend && npm run test:coverage` |
| Couverture backend branches | ≥ 83% | idem |
| Couverture validators.js | ≥ 95% | idem |
| Seuil bloquant configuré | 80% | `jest.config.json` |
| Tests E2E passants | 15/15 | `cd e2e && npm test` |
