/**
 * Tests DOM — frontend/js/details/render.js : rendu complet de la fiche.
 *
 * Complète render.test.js (fonctions isolées) : ici on monte le VRAI corps de
 * details.html et les vrais modules voisins (data.js pour le slug et le SEO,
 * markdown.js, shared/picture.js, utils.js avec DOMPurify), comme en
 * production. Un identifiant renommé dans la page ferait échouer ces tests.
 */

const fs = require('fs');
const path = require('path');

const PAGE_HTML = fs.readFileSync(path.join(__dirname, '..', 'details.html'), 'utf8');

function mountPage() {
  const doc = new window.DOMParser().parseFromString(PAGE_HTML, 'text/html');
  doc.querySelectorAll('script').forEach((s) => s.remove());
  document.head.innerHTML = '';
  document.body.innerHTML = doc.body.innerHTML;
}

let render;

function boot(lang = 'fr', dict = {}) {
  jest.resetModules();
  mountPage();
  global.i18n = { t: (k) => (k in dict ? dict[k] : k), currentLang: lang };
  window.i18n = global.i18n;
  global.DOMPurify = require('dompurify');
  const utils = require('../js/utils');
  global.escapeHtml = utils.escapeHtml;
  global.safeSetHTML = utils.safeSetHTML;
  window.VH = {};
  require('../js/shared/picture');
  require('../js/shared/meta-description');
  require('../js/details/data');
  require('../js/details/markdown');
  require('../js/details/key-dates');
  render = require('../js/details/render');
}

afterEach(() => {
  delete global.DOMPurify;
  delete global.safeSetHTML;
});

const RAFALE = {
  name: 'Rafale',
  complete_name: 'Dassault Rafale',
  generation: 4,
  country_name: 'France',
  manufacturer_name: 'Dassault Aviation',
  date_concept: '1983-01-01T00:00:00Z',
  date_first_fly: '1986-07-04T00:00:00Z',
  date_operationel: '2001-05-18T00:00:00Z',
  image_url: '/assets/airplanes/rafale.jpg',
  max_speed: 1912,
  max_range: 3700,
  empty_weight: 10300,
  status: 'En service',
  description: 'Chasseur omnirôle français.',
};

const $ = (sel) => document.querySelector(sel);
const text = (id) => document.getElementById(id).textContent.trim();

describe('renderAircraftDetails — en-tête et statistiques', () => {
  test('titre, fil d\'Ariane, nom, sous-titre, pays, constructeur, année', () => {
    boot();
    render.renderAircraftDetails({ aircraftId: '30', aircraftData: { ...RAFALE } });
    expect(document.title).toBe('Rafale | Vol d\'Histoire');
    expect(text('breadcrumb-name')).toBe('Rafale');
    expect(text('aircraft-name')).toBe('Rafale');
    expect(text('aircraft-complete-name')).toBe('Dassault Rafale');
    expect(text('hero-country')).toBe('France');
    expect(text('hero-manufacturer')).toBe('Dassault Aviation');
    expect(text('hero-year')).toBe('2001');
  });

  test('URL réécrite en /details/<slug>-<id> et canonical absolue', () => {
    boot();
    render.renderAircraftDetails({ aircraftId: '30', aircraftData: { ...RAFALE, name: 'Mirage 2000-5' } });
    expect(window.location.pathname).toBe('/details/mirage-2000-5-30');
    expect(window.history.state).toEqual({ id: '30' });
    expect($('link[rel="canonical"]').href).toBe('https://vol-histoire.titouan-borde.com/details/mirage-2000-5-30');
  });

  test('SEO-001 — la réécriture d’URL garde ?lang=en et retire l’ancien ?id=', () => {
    window.history.replaceState(null, '', '/details?id=30&lang=en');
    boot();
    render.renderAircraftDetails({ aircraftId: '30', aircraftData: { ...RAFALE } });
    expect(window.location.pathname).toBe('/details/rafale-30');
    expect(window.location.search).toBe('?lang=en');
    window.history.replaceState(null, '', '/');
  });

  test('statistiques avec unités ; N/A et « non précisé » si absentes', () => {
    boot();
    render.renderAircraftDetails({ aircraftId: '30', aircraftData: { ...RAFALE } });
    // Nombres groupés dans la langue du site (espace fine insécable en français).
    expect(text('stat-speed')).toMatch(/^1\s912 km\/h$/);
    expect(text('stat-range')).toMatch(/^3\s700 km$/);
    expect(text('stat-weight')).toMatch(/^10\s300 kg$/);
    expect(text('stat-status')).toBe('En service');
    render.renderAircraftDetails({ aircraftId: '1', aircraftData: { name: 'X' } });
    expect(text('stat-speed')).toBe('N/A');
    expect(text('stat-range')).toBe('N/A');
    expect(text('stat-weight')).toBe('N/A');
    expect(text('stat-status')).toBe('details.not_specified');
    expect(text('hero-country')).toBe('details.not_specified');
    expect(text('hero-manufacturer')).toBe('details.not_specified');
    expect(text('aircraft-complete-name')).toBe('');
  });

  test('nom absent : « N/A » dans le titre principal', () => {
    boot();
    render.renderAircraftDetails({ aircraftId: '1', aircraftData: { name: '' } });
    expect(text('aircraft-name')).toBe('N/A');
  });

  test('le nom venu de l\'API est inséré comme texte (pas de HTML)', () => {
    boot();
    const evil = '<img src=x onerror=alert(1)>';
    render.renderAircraftDetails({ aircraftId: '1', aircraftData: { name: evil } });
    expect($('#aircraft-name img, #breadcrumb-name img')).toBeNull();
    expect(text('aircraft-name')).toBe(evil);
  });

  test('chiffres clés en anglais : séparateur de milliers anglais', () => {
    boot('en');
    render.renderAircraftDetails({ aircraftId: '30', aircraftData: { ...RAFALE } });
    expect(text('stat-speed')).toBe('1,912 km/h');
  });

  test('génération dans la ligne pays · constructeur · année : « 4e génération »', () => {
    boot('fr');
    render.renderAircraftDetails({ aircraftId: '30', aircraftData: { ...RAFALE } });
    expect(text('hero-generation')).toBe('4e génération');
    expect($('#hero-generation-item').hidden).toBe(false);
    expect($('#hero-badge')).toBeNull();
  });

  test.each([[1, '1st'], [2, '2nd'], [3, '3rd'], [5, '5th']])('génération en anglais : %i → %s', (gen, suffix) => {
    boot('en');
    render.renderAircraftDetails({ aircraftId: '30', aircraftData: { ...RAFALE, generation: gen } });
    expect(text('hero-generation')).toBe(`${suffix} generation`);
  });

  test('génération inconnue : élément masqué', () => {
    boot('fr');
    render.renderAircraftDetails({ aircraftId: '30', aircraftData: { ...RAFALE, generation: null } });
    expect($('#hero-generation-item').hidden).toBe(true);
  });

  test('image hero : alt composé, chargement immédiat ; crédit photo affiché', () => {
    boot();
    render.renderAircraftDetails({
      aircraftId: '30',
      aircraftData: { ...RAFALE, image_credit: 'Rob Schleiffert', image_licence: 'CC BY-SA 2.0' },
    });
    const img = document.getElementById('hero-image');
    expect(img.alt).toBe('Rafale — Dassault Aviation — France');
    expect(img.loading).toBe('eager');
    expect(document.getElementById('image-credit').hidden).toBe(false);
    expect(text('image-credit')).toBe('details.photo : Rob Schleiffert — CC BY-SA 2.0');
  });

  test('frise : dates localisées, « non précisé » si absentes', () => {
    boot('fr');
    render.renderAircraftDetails({ aircraftId: '30', aircraftData: { ...RAFALE, date_concept: null } });
    expect($('#date-first-fly .timeline-date').textContent).toBe('4 juillet 1986');
    expect($('#date-concept .timeline-date').textContent).toBe('details.not_specified');
    boot('en');
    render.renderAircraftDetails({ aircraftId: '30', aircraftData: { ...RAFALE } });
    expect($('#date-first-fly .timeline-date').textContent).toBe('4 July 1986');
  });

  test('sans mise en service : année du premier vol à la place du squelette', () => {
    boot();
    document.getElementById('hero-year').innerHTML = '<span class="skeleton-inline-meta"></span>';
    render.renderAircraftDetails({ aircraftId: '30', aircraftData: { ...RAFALE, date_operationel: null, date_first_fly: '1976-08-09' } });
    expect(text('hero-year')).toMatch(/1976/);
  });

  test('sans aucune date : l\'élément de l\'année est retiré', () => {
    boot();
    const year = document.getElementById('hero-year');
    year.textContent = '-';
    const item = document.createElement('div');
    item.className = 'meta-item';
    year.replaceWith(item);
    item.appendChild(year);
    render.renderAircraftDetails({ aircraftId: '30', aircraftData: { ...RAFALE, date_operationel: null, date_first_fly: null } });
    expect(item.hidden).toBe(true);
  });

  test('sans date opérationnelle : l\'année du hero n\'est pas écrasée', () => {
    boot();
    document.getElementById('hero-year').textContent = 'SSR';
    render.renderAircraftDetails({ aircraftId: '30', aircraftData: { ...RAFALE, date_operationel: null } });
    expect(text('hero-year')).toBe('SSR');
  });
});

describe('renderAircraftDetails — description', () => {
  test('texte simple : inséré tel quel, sans classe markdown-body', () => {
    boot();
    render.renderAircraftDetails({ aircraftId: '30', aircraftData: { ...RAFALE, description: 'Un <b>chasseur</b>' } });
    const desc = document.getElementById('aircraft-description');
    expect(desc.classList.contains('markdown-body')).toBe(false);
    expect(desc.querySelector('b')).toBeNull();
    expect(desc.textContent).toBe('Un <b>chasseur</b>');
  });

  test('sans description : message « aucune description »', () => {
    boot();
    render.renderAircraftDetails({ aircraftId: '30', aircraftData: { ...RAFALE, description: null } });
    expect(text('aircraft-description')).toBe('details.no_description');
  });

  test('Markdown détecté (##, liste) : rendu HTML assaini, classe markdown-body', () => {
    boot();
    const md = '## Origines\nLe **Rafale** vole en 1986.\n\n- Mach 1,8\n- RBE2';
    render.renderAircraftDetails({ aircraftId: '30', aircraftData: { ...RAFALE, description: md } });
    const desc = document.getElementById('aircraft-description');
    expect(desc.classList.contains('markdown-body')).toBe(true);
    expect(desc.querySelector('h3.md-section').textContent).toBe('Origines');
    expect(desc.querySelector('strong').textContent).toBe('Rafale');
    expect(desc.querySelectorAll('li')).toHaveLength(2);
  });

  test('Markdown hostile : aucun script ni gestionnaire on* dans la fiche', () => {
    boot();
    const md = '## T\n<img src=x onerror=alert(1)>\n- [x](javascript:alert(1))';
    render.renderAircraftDetails({ aircraftId: '30', aircraftData: { ...RAFALE, description: md } });
    const desc = document.getElementById('aircraft-description');
    expect(desc.querySelector('img, script')).toBeNull();
    const handlers = [...desc.querySelectorAll('*')]
      .flatMap((el) => [...el.attributes].map((a) => a.name))
      .filter((n) => n.startsWith('on'));
    expect(handlers).toEqual([]);
    expect(desc.querySelector('a[href^="javascript"]')).toBeNull();
  });

  test('repli sans safeSetHTML : le HTML Markdown est inséré directement', () => {
    boot();
    delete global.safeSetHTML;
    render.renderAircraftDetails({ aircraftId: '30', aircraftData: { ...RAFALE, description: '## Titre' } });
    expect($('#aircraft-description h3').textContent).toBe('Titre');
  });

  test('passage Markdown → texte simple : la classe markdown-body est retirée', () => {
    boot();
    render.renderAircraftDetails({ aircraftId: '30', aircraftData: { ...RAFALE, description: '## A' } });
    render.renderAircraftDetails({ aircraftId: '30', aircraftData: { ...RAFALE, description: 'plain' } });
    expect(document.getElementById('aircraft-description').classList.contains('markdown-body')).toBe(false);
  });

  // BUG (render.js:63 + utils.js:47) : safeSetHTML n'autorise ni `target` ni
  // `rel` (ALLOWED_ATTR). Les liens que markdown.js émet avec
  // target="_blank" rel="noopener noreferrer" perdent ces attributs : un lien
  // externe d'une description ouvre dans l'onglet de la fiche. Sans danger
  // (rel n'est utile qu'avec target), mais contraire à l'intention de
  // markdown.js. Correctif : ajouter 'target' et 'rel' à ALLOWED_ATTR (DOMPurify
  // ajoute alors lui-même la protection noopener).
  test.skip('BUG : un lien Markdown de la description garde target="_blank"', () => {
    boot();
    render.renderAircraftDetails({
      aircraftId: '30',
      aircraftData: { ...RAFALE, description: '## Sources\n- [Wiki](https://fr.wikipedia.org/wiki/Rafale)' },
    });
    const a = $('#aircraft-description a');
    expect(a.getAttribute('href')).toBe('https://fr.wikipedia.org/wiki/Rafale');
    expect(a.getAttribute('target')).toBe('_blank');
  });
});

describe('renderSpecs (strates 1-2)', () => {
  test('une ligne par valeur renseignée, rangée dans son groupe ; nombres localisés', () => {
    boot('fr', { 'details.spec_length': 'Longueur', 'details.spec_crew': 'Équipage' });
    render.renderAircraftDetails({
      aircraftId: '30',
      aircraftData: { ...RAFALE, length: 15.27, crew: 2, mtow: 24500, engine_name: 'Snecma M88-2', wingspan: null },
    });
    const section = document.getElementById('specs-section');
    expect(section.classList.contains('hidden')).toBe(false);
    const tiles = [...section.querySelectorAll('.spec-row')].map((t) => [
      t.querySelector('dt.spec-label').textContent, t.querySelector('dd.spec-value').textContent,
    ]);
    expect(tiles).toContainEqual(['Longueur', '15,27 m']);
    expect(tiles).toContainEqual(['Équipage', '2']);
    expect(tiles).toContainEqual(['details.spec_engine', 'Snecma M88-2']);
    // empty_weight (RAFALE) + mtow
    expect(tiles.find(([l]) => l === 'details.spec_mtow')[1]).toMatch(/^24\s500 kg$/);
    expect(tiles.map(([l]) => l)).not.toContain('details.spec_wingspan');
    // Trois groupes au plus, chacun titré ; la longueur est dans « cellule ».
    const groups = [...section.querySelectorAll('.spec-group')];
    expect(groups.map((g) => g.querySelector('.spec-group-title').textContent))
      .toEqual(['details.spec_group_airframe', 'details.spec_group_performance', 'details.spec_group_propulsion']);
    expect(groups[0].textContent).toContain('Longueur');
    expect(groups[2].textContent).toContain('Snecma M88-2');
  });

  const specs = () => Object.fromEntries([...document.querySelectorAll('#specs-grid .spec-row')].map((t) => [
    t.querySelector('dt').textContent, t.querySelector('dd').textContent.replace(/\s/g, ' '),
  ]));
  const groupTitles = () => [...document.querySelectorAll('#specs-grid .spec-group-title')].map((h) => h.textContent);

  test('valeurs calculées : charge emportable, poussée totale, charge alaire, poussée/poids', () => {
    boot('fr', { 'details.spec_per_engine': 'par moteur' });
    render.renderAircraftDetails({
      aircraftId: '30',
      aircraftData: {
        ...RAFALE, mtow: 24500, empty_weight: 10300, wing_area: 45.7,
        engine_name: 'Snecma M88-2', engine_count: 2, thrust_dry: 50.04, thrust_wet: 75.62,
      },
    });
    const s = specs();
    expect(s['details.spec_payload']).toBe('14 200 kg');
    expect(s['details.spec_thrust_total']).toBe('151,2 kN (2 × 75,62)');
    expect(s['details.spec_wing_loading']).toBe('536 kg/m²');
    expect(s['details.spec_thrust_weight']).toBe('0,63');
    // Poussée par moteur dite comme telle dès deux moteurs
    expect(s['details.spec_thrust_wet (par moteur)']).toBe('75,62 kN');
    // Vitesse et distance reprises dans « Performances »
    expect(s['details.spec_max_speed']).toBe('1 912 km/h');
    expect(s['details.spec_max_range']).toBe('3 700 km');
    expect(groupTitles()).toEqual([
      'details.spec_group_airframe', 'details.spec_group_performance',
      'details.spec_group_propulsion', 'details.spec_group_ratios',
    ]);
  });

  test('monomoteur : pas de total, rapport calculé sur la poussée sèche à défaut de PC', () => {
    boot();
    render.renderAircraftDetails({
      aircraftId: '1',
      aircraftData: { name: 'X', engine_count: 1, thrust_dry: 40, mtow: 8000 },
    });
    const s = specs();
    expect(s['details.spec_thrust_total']).toBeUndefined();
    expect(s['details.spec_thrust_dry']).toBe('40 kN');
    expect(s['details.spec_thrust_weight']).toBe('0,51');
  });

  test('motorisation mixte (« A + 8 B ») : ni total ni rapport poussée/poids', () => {
    boot();
    render.renderAircraftDetails({
      aircraftId: '1',
      aircraftData: {
        name: 'Mirage III V', engine_name: 'SNECMA TF106 + 8 Rolls-Royce RB.162',
        engine_count: 9, thrust_wet: 82.4, mtow: 13500, wing_area: 34,
      },
    });
    const s = specs();
    expect(s['details.spec_thrust_total']).toBeUndefined();
    expect(s['details.spec_thrust_weight']).toBeUndefined();
    expect(s['details.spec_wing_loading']).toBe('397 kg/m²');
    // La poussée stockée est celle du moteur principal, pas « par moteur »
    expect(s['details.spec_thrust_wet (details.spec_main_engine)']).toBe('82,4 kN');
    expect(Object.keys(s).some((k) => k.includes('spec_per_engine'))).toBe(false);
  });

  test('masse max ≤ masse à vide : pas de charge emportable', () => {
    boot();
    render.renderAircraftDetails({ aircraftId: '1', aircraftData: { name: 'D-21', mtow: 5000, empty_weight: 5000 } });
    expect(specs()['details.spec_payload']).toBeUndefined();
  });

  test('colonnes de la strate 7 : Mach, supercroisière, convoyage, emport, soute, radar, carburant', () => {
    boot('fr', { 'details.spec_yes': 'Oui', 'details.spec_no': 'Non' });
    render.renderAircraftDetails({
      aircraftId: '12',
      aircraftData: {
        name: 'F-22', mach_max: 2.25, supercruise: true, ferry_range: 3220, hardpoints: 4,
        internal_weapons_bay: true, radar_model: 'AN/APG-77', internal_fuel: 8200,
      },
    });
    const s = specs();
    expect(s['details.spec_mach_max']).toBe('Mach 2,25');
    expect(s['details.spec_supercruise']).toBe('Oui');
    expect(s['details.spec_ferry_range']).toBe('3 220 km');
    expect(s['details.spec_hardpoints']).toBe('4');
    expect(s['details.spec_weapons_bay']).toBe('Oui');
    expect(s['details.spec_radar']).toBe('AN/APG-77');
    expect(s['details.spec_internal_fuel']).toBe('8 200 kg');
    expect(groupTitles()).toContain('details.spec_group_stores');
  });

  test('supercroisière : « Non » seulement pour un appareil supersonique', () => {
    boot('fr', { 'details.spec_no': 'Non' });
    render.renderAircraftDetails({ aircraftId: '1', aircraftData: { name: 'Mirage', mach_max: 2.2, supercruise: false } });
    expect(specs()['details.spec_supercruise']).toBe('Non');
    render.renderAircraftDetails({ aircraftId: '1', aircraftData: { name: 'Alphajet', mach_max: 0.85, supercruise: false } });
    expect(specs()['details.spec_supercruise']).toBeUndefined();
  });

  test('soute interne : « Non » affiché quand la valeur est connue, rien si elle est nulle', () => {
    boot('fr', { 'details.spec_no': 'Non' });
    render.renderAircraftDetails({ aircraftId: '1', aircraftData: { name: 'F-16', internal_weapons_bay: false } });
    expect(specs()['details.spec_weapons_bay']).toBe('Non');
    render.renderAircraftDetails({ aircraftId: '1', aircraftData: { name: 'F-16', internal_weapons_bay: null, hardpoints: 11 } });
    expect(specs()['details.spec_weapons_bay']).toBeUndefined();
  });

  test('séparateur décimal anglais', () => {
    boot('en');
    render.renderAircraftDetails({ aircraftId: '30', aircraftData: { ...RAFALE, length: 15.27 } });
    const values = [...document.querySelectorAll('#specs-grid .spec-value')].map((v) => v.textContent);
    expect(values).toContain('15.27 m');
  });

  test('valeur texte de l\'API échappée (nom de moteur)', () => {
    boot();
    render.renderAircraftDetails({ aircraftId: '30', aircraftData: { ...RAFALE, engine_name: '<img src=x onerror=alert(1)>' } });
    expect(document.querySelector('#specs-grid img')).toBeNull();
    expect(document.getElementById('specs-grid').textContent).toContain('<img src=x onerror=alert(1)>');
  });

  test('aucune caractéristique : section masquée (chaîne vide = absente)', () => {
    boot();
    render.renderAircraftDetails({ aircraftId: '30', aircraftData: { name: 'X', engine_name: '', empty_weight: null } });
    expect(document.getElementById('specs-section').classList.contains('hidden')).toBe(true);
  });
});

describe('renderProduction (strate 3)', () => {
  const values = () => Object.fromEntries([...document.querySelectorAll('#production-grid .spec-row')].map((t) => [
    t.querySelector('.spec-label').textContent, t.querySelector('.spec-value').textContent,
  ]));

  test('années, exemplaires, coût, opérateurs, furtivité, surnom', () => {
    boot();
    render.renderAircraftDetails({
      aircraftId: '30',
      aircraftData: {
        ...RAFALE, production_start: 1986, production_end: null, units_built: 300,
        unit_cost_usd: 85000000, unit_cost_year: 2020, operators_count: 7,
        stealth_level: 'reduite', nickname: 'Omnirôle',
      },
    });
    expect(document.getElementById('production-section').classList.contains('hidden')).toBe(false);
    expect(values()).toEqual({
      'details.prod_years': '1986 – details.prod_today',
      'details.prod_units_built': '300',
      'details.prod_unit_cost': '85 M $ (2020)',
      'details.prod_operators': '7',
      'details.prod_stealth': 'details.stealth_reduced',
      'details.prod_nickname': 'Omnirôle',
    });
  });

  test('production terminée et coût en milliards', () => {
    boot();
    render.renderAircraftDetails({
      aircraftId: '30',
      aircraftData: { ...RAFALE, production_start: 1987, production_end: 2000, unit_cost_usd: 2100000000 },
    });
    expect(values()['details.prod_years']).toBe('1987 – 2000');
    expect(values()['details.prod_unit_cost']).toBe('2,1 Md $');
  });

  test('coût rond : décimales nulles retirées (1 Md $, 30 M $)', () => {
    boot();
    render.renderAircraftDetails({ aircraftId: '30', aircraftData: { ...RAFALE, unit_cost_usd: 1000000000 } });
    expect(values()['details.prod_unit_cost']).toBe('1 Md $');
    render.renderAircraftDetails({ aircraftId: '30', aircraftData: { ...RAFALE, unit_cost_usd: 30000000 } });
    expect(values()['details.prod_unit_cost']).toBe('30 M $');
  });

  test('coût sous le million : nombre localisé', () => {
    boot('fr');
    render.renderAircraftDetails({ aircraftId: '30', aircraftData: { ...RAFALE, unit_cost_usd: 450000 } });
    expect(values()['details.prod_unit_cost']).toMatch(/^450\s000 \$$/);
  });

  test('unit_cost_usd est un BIGINT : pg le renvoie en chaîne, le format tient', () => {
    boot();
    render.renderAircraftDetails({ aircraftId: '30', aircraftData: { ...RAFALE, unit_cost_usd: '85000000' } });
    expect(values()['details.prod_unit_cost']).toBe('85 M $');
  });

  test('niveau de furtivité inconnu : affiché tel quel ; « aucune » traduit', () => {
    boot();
    render.renderAircraftDetails({ aircraftId: '30', aircraftData: { ...RAFALE, stealth_level: 'inédit' } });
    expect(values()['details.prod_stealth']).toBe('inédit');
    render.renderAircraftDetails({ aircraftId: '30', aircraftData: { ...RAFALE, stealth_level: 'aucune' } });
    expect(values()['details.prod_stealth']).toBe('details.stealth_none');
  });

  test('variantes en Markdown : bloc affiché et assaini', () => {
    boot();
    render.renderAircraftDetails({
      aircraftId: '30',
      aircraftData: { ...RAFALE, variants: '- **Rafale B** : biplace\n- <script>x</script>' },
    });
    const block = document.getElementById('variants-block');
    expect(block.classList.contains('hidden')).toBe(false);
    expect(block.querySelector('#variants-content li strong').textContent).toBe('Rafale B');
    expect(block.querySelector('script')).toBeNull();
    // Seules les variantes : la section reste visible
    expect(document.getElementById('production-section').classList.contains('hidden')).toBe(false);
  });

  test('variantes sans safeSetHTML : insertion directe', () => {
    boot();
    delete global.safeSetHTML;
    render.renderAircraftDetails({ aircraftId: '30', aircraftData: { ...RAFALE, variants: '- A' } });
    expect(document.querySelector('#variants-content li').textContent).toBe('A');
  });

  test('ni production ni variantes : section et bloc masqués', () => {
    boot();
    render.renderAircraftDetails({ aircraftId: '30', aircraftData: { ...RAFALE, variants: null } });
    expect(document.getElementById('production-section').classList.contains('hidden')).toBe(true);
    expect(document.getElementById('variants-block').classList.contains('hidden')).toBe(true);
  });

  // Régression i18n (render.js, renderProduction) : « Md $ » restait en
  // français et le séparateur décimal était le point même en français.
  test('coût unitaire : abréviations et séparateur décimal selon la langue (B $ / M $ en anglais, virgule en français)', () => {
    boot('en', { 'details.cost_billion': 'B $', 'details.cost_million': 'M $' });
    render.renderAircraftDetails({ aircraftId: '30', aircraftData: { ...RAFALE, unit_cost_usd: 2100000000 } });
    expect(values()['details.prod_unit_cost']).toBe('2.1 B $');
    render.renderAircraftDetails({ aircraftId: '30', aircraftData: { ...RAFALE, unit_cost_usd: 85500000 } });
    expect(values()['details.prod_unit_cost']).toBe('85.5 M $');
    render.renderAircraftDetails({ aircraftId: '30', aircraftData: { ...RAFALE, unit_cost_usd: 450000 } });
    expect(values()['details.prod_unit_cost']).toBe('450,000 $');

    boot('fr', { 'details.cost_billion': 'Md $', 'details.cost_million': 'M $' });
    render.renderAircraftDetails({ aircraftId: '30', aircraftData: { ...RAFALE, unit_cost_usd: 2150000000 } });
    expect(values()['details.prod_unit_cost']).toBe('2,15 Md $');
    render.renderAircraftDetails({ aircraftId: '30', aircraftData: { ...RAFALE, unit_cost_usd: '85500000' } });
    expect(values()['details.prod_unit_cost']).toBe('85,5 M $');
  });

  test('les unités du coût existent dans les deux langues', () => {
    const fr = require('../locales/fr.json');
    const en = require('../locales/en.json');
    expect(fr.details.cost_billion).toBe('Md $');
    expect(en.details.cost_billion).toBe('B $');
    expect(fr.details.cost_million).toBe('M $');
    expect(en.details.cost_million).toBe('M $');
  });
});

describe('renderRelatedAircraft (strate 4) et renderSources (strate 6)', () => {
  test('cartes prédécesseur / successeur / rival avec liens slugifiés', () => {
    boot();
    render.renderAircraftDetails({
      aircraftId: '30',
      aircraftData: {
        ...RAFALE,
        predecessor_id: 68, predecessor_name: 'Mirage 2000', predecessor_image: '/assets/airplanes/m2000.jpg',
        rival_id: 12, rival_name: 'Eurofighter Typhoon', rival_image: null,
        successor_id: 99, successor_name: null,
      },
    });
    const cards = [...document.querySelectorAll('#related-grid .related-card')];
    expect(cards.map((c) => c.getAttribute('href'))).toEqual(['/details/mirage-2000-68', '/details/eurofighter-typhoon-12']);
    expect(cards.map((c) => c.querySelector('.related-relation').textContent))
      .toEqual(['details.related_predecessor', 'details.related_rival']);
    expect(document.getElementById('related-aircraft-section').classList.contains('hidden')).toBe(false);
  });

  test('sources : liens externes sûrs (nouvel onglet, noopener), icônes masquées', () => {
    boot();
    render.renderAircraftDetails({
      aircraftId: '30',
      aircraftData: { ...RAFALE, wikipedia_fr: 'https://fr.wikipedia.org/wiki/Rafale', youtube_showcase: 'https://youtu.be/x' },
    });
    const links = [...document.querySelectorAll('#sources-list a.source-link')];
    expect(links.map((a) => a.getAttribute('href'))).toEqual(['https://fr.wikipedia.org/wiki/Rafale', 'https://youtu.be/x']);
    links.forEach((a) => {
      expect(a.getAttribute('target')).toBe('_blank');
      expect(a.getAttribute('rel')).toBe('noopener noreferrer');
      a.querySelectorAll('i').forEach((i) => expect(i.getAttribute('aria-hidden')).toBe('true'));
    });
    expect(links[0].textContent.trim()).toBe('details.source_wikipedia_fr');
    expect(document.getElementById('sources-section').classList.contains('hidden')).toBe(false);
  });

  // Régression (render.js:291 + utils.js) : escapeHtml() n'échappait pas les
  // guillemets ; utilisé dans un attribut (href="${escapeHtml(url)}"), il
  // laissait sortir de l'attribut. Corrigé dans escapeHtml (" et ' échappés)
  // et côté backend (isOptionalUrl refuse guillemets, chevrons et blancs).
  test('une URL de source avec guillemet ne sort pas de l\'attribut href', () => {
    boot();
    render.renderAircraftDetails({
      aircraftId: '30', aircraftData: { ...RAFALE, manufacturer_page: 'https://ex.com/"onmouseover="alert(1)' },
    });
    const a = document.querySelector('#sources-list a');
    expect(a.getAttribute('onmouseover')).toBeNull();
    expect(a.getAttribute('href')).toBe('https://ex.com/"onmouseover="alert(1)');
  });

  test('aucune source : section masquée', () => {
    boot();
    render.renderAircraftDetails({ aircraftId: '30', aircraftData: { ...RAFALE } });
    expect(document.getElementById('sources-section').classList.contains('hidden')).toBe(true);
  });

  test('sections facultatives absentes de la page : aucune erreur', () => {
    boot();
    ['specs-section', 'production-section', 'related-aircraft-section', 'sources-section', 'image-credit', 'hero-image']
      .forEach((id) => document.getElementById(id).remove());
    expect(() => render.renderAircraftDetails({ aircraftId: '30', aircraftData: { ...RAFALE } })).not.toThrow();
  });
});

describe('renderWars — liens vers les conflits', () => {
  test('slug présent : titre lien /conflits/<slug> encodé, carte liée, invitation masquée aux AT', () => {
    boot();
    render.renderWars([{
      name: 'Guerre du Golfe', slug: 'guerre-du-golfe', description: 'Koweït',
      date_start: '1990-08-02', date_end: '1991-02-28',
    }]);
    const card = document.querySelector('#wars-list .war-card');
    expect(card.classList.contains('war-card-linked')).toBe(true);
    expect(card.querySelector('h3 a.war-link').getAttribute('href')).toBe('/conflits/guerre-du-golfe');
    expect(card.querySelector('.war-more').getAttribute('aria-hidden')).toBe('true');
  });

  test('slug à caractères spéciaux : encodé dans l\'URL', () => {
    boot();
    render.renderWars([{ name: 'X', slug: 'a b/c', description: 'd', date_start: '2000-01-01', date_end: '2001-01-01' }]);
    expect(document.querySelector('a.war-link').getAttribute('href')).toBe('/conflits/a%20b%2Fc');
  });

  test('conflit sans fin mais avec début : « en cours »', () => {
    boot();
    render.renderWars([{ name: 'Ukraine', description: 'd', date_start: '2022-02-24', date_end: null }]);
    expect(document.querySelector('.war-period span').textContent).toBe('2022 – details.war_ongoing');
  });

  test('conflit d\'une seule année : « 1999 », pas « 1999 – 1999 »', () => {
    boot();
    render.renderWars([
      { name: 'Kargil', description: 'd', date_start: '1999-05-03', date_end: '1999-07-26' },
      { name: 'Golfe', description: 'd', date_start: '1990-08-02', date_end: '1991-02-28' },
    ]);
    const periods = [...document.querySelectorAll('.war-period span')].map((s) => s.textContent);
    expect(periods).toEqual(['1999', '1990 – 1991']);
  });

  test('sans description : texte de repli ; sans slug : titre non cliquable', () => {
    boot();
    render.renderWars([{ name: 'Corée', description: null, date_start: '1950-06-25', date_end: '1953-07-27' }]);
    const card = document.querySelector('.war-card');
    expect(card.querySelector('a')).toBeNull();
    expect(card.querySelector('p').textContent).toBe('details.no_desc_available');
    expect(card.classList.contains('war-card-linked')).toBe(false);
  });
});

describe('renderWars — rôle de l\'appareil dans le conflit', () => {
  const IRAN = {
    name: 'Guerre Iran-Israël', slug: 'guerre-iran-israel', description: 'Guerre de douze jours',
    date_start: '2025-06-13', date_end: '2025-06-24',
    role: 'Sept B-2 frappent *Fordo* le 22 juin.', side_name: 'États-Unis',
  };

  test('rôle présent : il remplace la description générale, italique rendu', () => {
    boot();
    render.renderWars([IRAN]);
    const card = document.querySelector('.war-card');
    const role = card.querySelector('.war-role');
    expect(role.textContent).toContain('Sept B-2 frappent');
    expect(role.querySelector('em').textContent).toBe('Fordo');
    expect(card.textContent).not.toContain('Guerre de douze jours');
  });

  test('camp affiché avec son libellé', () => {
    boot();
    render.renderWars([IRAN]);
    const side = document.querySelector('.war-card .war-side');
    expect(side.textContent).toContain('details.war_side');
    expect(side.textContent).toContain('États-Unis');
  });

  test('sans camp : aucune ligne de camp', () => {
    boot();
    render.renderWars([{ ...IRAN, side_name: null }]);
    expect(document.querySelector('.war-side')).toBeNull();
    expect(document.querySelector('.war-role')).not.toBeNull();
  });

  test('sans rôle : description générale, comme avant', () => {
    boot();
    render.renderWars([{ ...IRAN, role: null, side_name: null }]);
    expect(document.querySelector('.war-role')).toBeNull();
    expect(document.querySelector('.war-card p').textContent).toBe('Guerre de douze jours');
  });

  test('rôle et camp échappés', () => {
    boot();
    render.renderWars([{ ...IRAN, role: '<img src=x onerror=alert(1)>', side_name: '<b>X</b>' }]);
    const card = document.querySelector('.war-card');
    expect(card.querySelector('img')).toBeNull();
    expect(card.querySelector('.war-side b')).toBeNull();
    expect(card.querySelector('.war-role').textContent).toContain('<img src=x');
  });
});

describe('renderMissions — lien vers le hangar filtré', () => {
  test('mission avec nom FR canonique → /hangar?mission=<nom encodé>', () => {
    boot('en');
    render.renderMissions([
      { name: 'Air superiority', name_fr: 'Supériorité aérienne' },
      { name: 'Sans clé' },
    ]);
    const items = document.querySelectorAll('#missions-list .capability-item');
    expect(items[0].querySelector('a.capability-link').getAttribute('href'))
      .toBe('/hangar?mission=Sup%C3%A9riorit%C3%A9%20a%C3%A9rienne');
    expect(items[0].textContent).toContain('Air superiority');
    expect(items[1].querySelector('a')).toBeNull();
    expect(items[1].querySelector('span.capability-name').textContent).toBe('Sans clé');
  });

  test('description de capacité affichée seulement si présente', () => {
    boot();
    render.renderArmament([{ name: 'MICA', description: 'Missile air-air' }, { name: 'Canon' }]);
    const items = document.querySelectorAll('#armament-list .capability-item');
    expect(items[0].querySelector('.capability-desc').textContent).toBe('Missile air-air');
    expect(items[1].querySelector('.capability-desc')).toBeNull();
  });

  test('liste vidée au rendu suivant sans élément : compteur vidé, colonne masquée', () => {
    boot();
    render.renderTechnologies([{ name: 'RBE2' }]);
    render.renderTechnologies([]);
    expect(document.getElementById('tech-count').textContent).toBe('');
    expect(document.getElementById('col-tech').classList.contains('hidden')).toBe(true);
  });
});
