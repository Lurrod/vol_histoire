// e2e/helpers/fixtures.js
// Test fixture qui injecte automatiquement le consentement cookies + la langue FR
// avant chaque navigation. Évite que le banner cookies recouvre les boutons en
// headless et que i18n.js fallback sur navigator.language ('en-US' sous Playwright).
//
// Usage : remplacer `require('@playwright/test')` par `require('../helpers/fixtures')`
//         dans les specs qui ont besoin d'un état initial déterministe.

const base = require('@playwright/test');

const test = base.test.extend({
  page: async ({ page }, use) => {
    await page.addInitScript(() => {
      try {
        // Cookie consent : toujours forcé (le banner n'est pas testé en tant que tel)
        window.localStorage.setItem(
          'voldhistoire_cookie_consent',
          JSON.stringify({
            essential: true,
            analytics: false,
            preference: false,
            marketing: false,
            timestamp: Date.now(),
            version: '1.0',
          })
        );
        // Lang : seulement si non définie. i18n.js fait window.location.reload()
        // sur un setLang(), donc le init script re-run après reload — il ne faut
        // PAS écraser ce que l'utilisateur du test vient de changer.
        if (!window.localStorage.getItem('vol-histoire-lang')) {
          window.localStorage.setItem('vol-histoire-lang', 'fr');
        }
      } catch (_) {}
    });
    await use(page);
  },
});

module.exports = { test, expect: base.expect };
