/**
 * utils/details-hero-ssr.js (PERF-004) : faits du héros et chiffres clés
 * écrits par le serveur, mêmes valeurs que frontend/js/details/render.js.
 */
const { applyHeroFacts, heroFacts } = require('../utils/details-hero-ssr');

const TEMPLATE = [
  '<span id="breadcrumb-name">Chargement...</span>',
  '<p class="aircraft-subtitle" id="aircraft-complete-name"></p>',
  '<div class="meta-item"><i class="fas fa-globe"></i><span id="hero-country">-</span></div>',
  '<div class="meta-item"><i class="fas fa-industry"></i><span id="hero-manufacturer">-</span></div>',
  '<div class="meta-item"><i class="fas fa-calendar"></i><span id="hero-year">-</span></div>',
  '<div class="meta-item" id="hero-generation-item" hidden><i class="fas fa-layer-group"></i><span id="hero-generation"></span></div>',
  '<div class="stat-value" id="stat-speed">-</div><div class="stat-value" id="stat-range">-</div>',
  '<div class="stat-value" id="stat-weight">-</div><div class="stat-value" id="stat-status">-</div>',
].join('\n');

const RAFALE = {
  name: 'Rafale', complete_name: 'Dassault Rafale', country_name: 'France', country_name_en: 'France',
  manufacturer_name: 'Dassault <Aviation>', date_operationel: '2001-05-18', generation: 4,
  max_speed: 1912, max_range: 3700, empty_weight: 10300, status: 'En service', status_en: 'In service',
};

test('écrit fil d\'Ariane, sous-titre, ligne de faits, génération et chiffres clés (fr)', () => {
  const html = applyHeroFacts(TEMPLATE, RAFALE, 'fr');
  expect(html).toContain('<span id="breadcrumb-name">Rafale</span>');
  expect(html).toContain('<p class="aircraft-subtitle" id="aircraft-complete-name">Dassault Rafale</p>');
  expect(html).toContain('<span id="hero-manufacturer">Dassault &lt;Aviation&gt;</span>');
  expect(html).toContain('<span id="hero-year">2001</span>');
  expect(html).toContain('<div class="meta-item" id="hero-generation-item"><i');
  expect(html).toContain('<span id="hero-generation">4e génération</span>');
  expect(html).toMatch(/id="stat-speed">1\s912 km\/h</);
  expect(html).toContain('id="stat-status">En service<');
});

test('anglais : séparateur de milliers et statut traduits, génération « 4th »', () => {
  const f = heroFacts(RAFALE, 'en');
  expect(f).toMatchObject({ speed: '1,912 km/h', status: 'In service', generation: '4th generation' });
});

test('sans mise en service : année du premier vol ; sans aucune date : élément masqué', () => {
  expect(heroFacts({ ...RAFALE, date_operationel: null, date_first_fly: '1986-07-04' }, 'fr').year).toBe('1er vol en 1986');
  const html = applyHeroFacts(TEMPLATE, { ...RAFALE, date_operationel: null, date_first_fly: null }, 'fr');
  expect(html).toContain('<div class="meta-item" hidden><i class="fas fa-calendar"></i><span id="hero-year">-</span>');
});

test('valeurs absentes : « N/A » et « Non spécifié » comme le client ; génération inconnue masquée', () => {
  const f = heroFacts({ name: 'X' }, 'fr');
  expect(f).toMatchObject({ speed: 'N/A', range: 'N/A', weight: 'N/A', status: 'Non spécifié', country: 'Non spécifié', generation: null });
  expect(applyHeroFacts(TEMPLATE, { name: 'X' }, 'fr')).toContain('id="hero-generation-item" hidden');
});
