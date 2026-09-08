// e2e/tests/hero-daily.spec.js
//
// Widgets « du jour » de l'accueil. Leur promesse — le même contenu pour tout
// le monde aujourd'hui — ne se vérifie qu'en comparant deux chargements : c'est
// l'objet principal de cette spec.
const { test, expect } = require('../helpers/fixtures');

async function heroReady(page) {
  await page.goto('/');
  // Le corps du widget porte un texte d'attente tant que /api/hero/discoveries
  // n'a pas répondu : c'est notre signal de rendu.
  await expect(page.locator('#hero-fact-body')).not.toHaveText(/Tirage en cours/, { timeout: 15000 });
  await expect(page.locator('.hero-quiz-option').first()).not.toHaveText('—', { timeout: 15000 });
}

async function quizState(page) {
  return page.evaluate(() => ({
    image: document.getElementById('hero-quiz-image').getAttribute('src'),
    options: [...document.querySelectorAll('.hero-quiz-option')].map(b => b.textContent),
  }));
}

test.describe('Hero — widgets du jour', () => {
  test('le widget « Ce jour-là » annonce un événement daté et lie sa fiche', async ({ page }) => {
    await heroReady(page);

    // Trois libellés possibles : anniversaire du jour, de la semaine, ou repli
    // sur un fait éditorial les rares jours sans anniversaire.
    await expect(page.locator('#hero-fact-label'))
      .toHaveText(/Ce jour-là|Cette semaine-là|Saviez-vous/);

    const badge = page.locator('#hero-fact-body .hero-fact-year');
    await expect(badge).toBeVisible();
    await expect(badge).toHaveText(/\d{4}/);

    // Le lien mène à une fiche précise, jamais au « # » du HTML servi.
    const href = await page.locator('#hero-fact-link').getAttribute('href');
    expect(href).toMatch(/^\/(details\?id=\d+|hangar\?search=)/);
  });

  test("l'appareil du jour est le même d'un chargement à l'autre", async ({ page }) => {
    await heroReady(page);
    const premier = await quizState(page);
    await expect(page.locator('#hero-quiz-daily-tag')).toBeVisible();

    await heroReady(page);
    const second = await quizState(page);

    expect(second.image).toBe(premier.image);
    // Même ordre des propositions : sans ça, deux visiteurs ne verraient pas
    // tout à fait la même question.
    expect(second.options).toEqual(premier.options);
  });

  test('le bouton de tirage quitte l\'appareil du jour', async ({ page }) => {
    await heroReady(page);
    await page.click('#hero-quiz-reroll');
    await expect(page.locator('#hero-quiz-daily-tag')).toBeHidden();
    await expect(page.locator('.hero-quiz-option').first()).not.toHaveText('—');
  });

  test('répondre révèle la bonne proposition et ouvre la fiche', async ({ page }) => {
    await heroReady(page);
    await page.locator('.hero-quiz-option').first().click();

    await expect(page.locator('#hero-quiz-card')).toHaveClass(/is-revealed/);
    await expect(page.locator('.hero-quiz-option.is-correct')).toHaveCount(1);
    const lien = page.locator('#hero-quiz-link');
    await expect(lien).toBeVisible();
    expect(await lien.getAttribute('href')).toMatch(/^\/(details\?id=\d+|hangar\?search=)/);
  });

  test('la baseline a disparu du hero', async ({ page }) => {
    await page.goto('/');
    await expect(page.locator('.hero-split-baseline')).toHaveCount(0);
  });
});
