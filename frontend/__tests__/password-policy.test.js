/**
 * Politique de mot de passe : une seule règle, celle du serveur.
 *
 * La règle était recopiée à la main dans quatre pages (inscription,
 * réinitialisation, activation, paramètres) et trois copies avaient perdu la
 * borne haute de 128 caractères ; les aides affichées disaient « 8 min » ici,
 * « 8 à 128 » là. isValidPassword() de utils.js est désormais l'unique copie
 * côté client, comparée ici à celle de backend/validators.js.
 */
const utils = require('../js/utils');
const backend = require('../../backend/validators');
const fr = require('../locales/fr.json');
const en = require('../locales/en.json');
const fs = require('fs');
const path = require('path');

const CASES = [
  '', 'Abc1', 'Abcdef1', 'Abcdefg1', 'abcdefg1', 'ABCDEFG1', 'Abcdefgh',
  'Motdepasse1', 'Mot de passe 1', 'Éléphant1', 'ÉLÉPHANT1a',
  'Aa1' + 'x'.repeat(125), // 128 caractères : accepté
  'Aa1' + 'x'.repeat(126), // 129 caractères : refusé
  'Aa1' + 'x'.repeat(500),
  null, undefined, 12345678, ['Abcdefg1'],
];

describe('isValidPassword : même verdict que le serveur', () => {
  test.each(CASES.map((c) => [typeof c === 'string' && c.length > 20 ? `${c.length} caractères` : String(c), c]))(
    '%s', (_label, value) => {
      expect(utils.isValidPassword(value)).toBe(backend.isValidPassword(value));
    },
  );

  test('bornes exportées : 8 et 128', () => {
    expect(utils.PASSWORD_MIN_LENGTH).toBe(8);
    expect(utils.PASSWORD_MAX_LENGTH).toBe(128);
  });
});

describe('Aides affichées : la même règle partout, borne haute comprise', () => {
  const KEYS = [
    ['login', 'password_requirements'],
    ['settings', 'req_length'],
    ['settings', 'toast_password_min'],
  ];

  test.each(KEYS)('%s.%s mentionne 8 et 128 dans les deux langues', (section, key) => {
    [fr, en].forEach((locale) => {
      expect(locale[section][key]).toMatch(/\b8\b/);
      expect(locale[section][key]).toMatch(/\b128\b/);
    });
  });

  test('plus d’espaces de noms des anciennes pages à lien (tout passe par /login)', () => {
    ['reset_password', 'verify_email', 'forgot_password', 'check_email'].forEach((ns) => {
      expect(fr[ns]).toBeUndefined();
      expect(en[ns]).toBeUndefined();
    });
  });

  test.each([
    ['login.html', 'login.password_requirements'],
  ])('%s : le texte de repli (sans JS) donne aussi la borne de 128', (file, key) => {
    const html = fs.readFileSync(path.join(__dirname, '..', file), 'utf8');
    const match = html.match(new RegExp(`data-i18n="${key.replace('.', '\\.')}">([^<]*)<`));
    expect(match).not.toBeNull();
    expect(match[1]).toMatch(/\b128\b/);
  });
});
