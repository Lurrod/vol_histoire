/**
 * Tests DOM — shared/card.js (A11Y-005) : la carte d'appareil est un motif
 * « block link ». Le titre est un vrai lien vers la fiche, l'article n'est
 * plus un faux lien (role="link", tabindex, aria-label), et la case du
 * comparateur porte le nom de l'appareil.
 */

function boot({ withI18n = true } = {}) {
  jest.resetModules();
  window.VH = {
    shared: {
      ALPHA3_TO_ALPHA2: { FRA: 'fr' },
      picture: { pictureHtml: (src, { alt }) => `<img src="${src}" alt="${alt}">` },
    },
  };
  window.escapeHtml = (s) => String(s == null ? '' : s).replace(/[&<>"']/g, (c) => ({
    '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;',
  }[c]));
  if (withI18n) {
    const dict = {
      'hangar.compare_label': 'Comparer',
      'hangar.compare_label_named': 'Comparer {name}',
      'details.no_desc_available': 'Pas de description',
      'details.remove_favorite': 'Retirer des favoris',
    };
    window.i18n = {
      currentLang: 'fr',
      t: (k, p = {}) => (dict[k] || k).replace(/\{(\w+)\}/g, (_, n) => p[n]),
    };
  } else {
    delete window.i18n;
  }
  return require('../js/shared/card');
}

const RAFALE = {
  id: 30, name: 'Rafale', little_description: 'Omnirôle', country_code: 'FRA', country_name: 'France',
  generation: 4, type_name: 'Chasseur', max_speed: 1912, date_operationel: '2001-12-04',
  image_url: '/assets/airplanes/rafale.jpg',
};

function render(aircraft, options) {
  const card = boot();
  document.body.innerHTML = `<section id="grid">${card.renderAircraftCard(aircraft, options)}</section>`;
  return document.querySelector('#grid .aircraft-card');
}

describe('shared/card — carte « block link »', () => {
  test('le titre est un lien vers la fiche (slug + id)', () => {
    const article = render(RAFALE);
    const link = article.querySelector('h3 > a.aircraft-card-link');
    expect(link).not.toBeNull();
    expect(link.getAttribute('href')).toBe('/details/rafale-30');
    expect(link.textContent).toBe('Rafale');
    expect(article.querySelectorAll('a')).toHaveLength(1);
  });

  test('l\'article n\'est plus un faux lien', () => {
    const article = render(RAFALE);
    expect(article.tagName).toBe('ARTICLE');
    expect(article.hasAttribute('role')).toBe(false);
    expect(article.hasAttribute('tabindex')).toBe(false);
    expect(article.hasAttribute('aria-label')).toBe(false);
    expect(article.dataset.id).toBe('30');
  });

  test('le contenu de la carte reste exposé (badges, pays, vitesse, année)', () => {
    const article = render(RAFALE);
    expect(article.textContent).toContain('Chasseur');
    expect(article.textContent).toContain('1912 km/h');
    expect(article.textContent).toContain('2001');
    expect(article.querySelector('.country-flag').getAttribute('alt')).toBe('France');
    expect(article.querySelector('.aircraft-description').textContent).toBe('Omnirôle');
  });

  test('nom échappé dans le lien et dans l\'URL', () => {
    const article = render({ ...RAFALE, id: 5, name: 'Su-27 <b>"Flanker"</b>' });
    const link = article.querySelector('.aircraft-card-link');
    expect(link.textContent).toBe('Su-27 <b>"Flanker"</b>');
    expect(link.querySelector('b')).toBeNull();
    expect(link.getAttribute('href')).toBe('/details/su-27-b-flanker-b-5');
  });

  test('sans case de comparaison par défaut (favoris, conflits)', () => {
    const article = render(RAFALE);
    expect(article.querySelector('.compare-check')).toBeNull();
  });

  test('compare: true → case nommée « Comparer <nom> », après le lien dans l\'ordre de tabulation', () => {
    const article = render(RAFALE, { compare: true });
    const input = article.querySelector('.compare-check input[type="checkbox"]');
    expect(input.dataset.compareId).toBe('30');
    expect(input.getAttribute('aria-label')).toBe('Comparer Rafale');
    expect(article.querySelector('.compare-check span').textContent).toBe('Comparer');
    const focusables = [...article.querySelectorAll('a, input, button')];
    expect(focusables.map((el) => el.tagName)).toEqual(['A', 'INPUT']);
  });

  test('removeBtn, footer et description masquée (favoris)', () => {
    const article = render(RAFALE, { removeBtn: true, footerHtml: '<div class="favorited-date">hier</div>', showDescription: false });
    const btn = article.querySelector('.favorite-remove');
    expect(btn.dataset.airplaneId).toBe('30');
    expect(btn.getAttribute('title')).toBe('Retirer des favoris');
    expect(article.querySelector('.favorited-date')).not.toBeNull();
    expect(article.querySelector('.aircraft-description')).toBeNull();
  });

  test('sans image ni pays ni description : repli', () => {
    const article = render({ id: 7, name: 'X', little_description: '' });
    expect(article.querySelector('img').getAttribute('src')).toBe('/assets/logo/placeholder-airplane-fr.svg');
    expect(article.querySelector('.country-flag')).toBeNull();
    expect(article.querySelector('.aircraft-description').textContent).toBe('Pas de description');
  });

  test('sans i18n : libellés de repli en français', () => {
    const card = boot({ withI18n: false });
    document.body.innerHTML = card.renderAircraftCard(RAFALE, { compare: true });
    expect(document.querySelector('.compare-check input').getAttribute('aria-label')).toBe('Comparer Rafale');
  });
});

describe('shared/card — buildDetailsPath', () => {
  test('slug sans accents ; nom vide → /details/<id>', () => {
    const { buildDetailsPath } = boot();
    expect(buildDetailsPath(12, 'Mirage 2000-5 Électrique')).toBe('/details/mirage-2000-5-electrique-12');
    expect(buildDetailsPath(3, '')).toBe('/details/3');
    expect(window.VH.shared.buildDetailsPath).toBe(buildDetailsPath);
  });
});

describe('hangar/render — cartes du hangar', () => {
  test('cartes-liens avec case « Comparer <nom> », sans gestionnaire de navigation', () => {
    boot();
    window.VH.hangar = {};
    const render = require('../js/hangar/render');
    document.body.innerHTML = '<div id="airplanes-container"></div>';
    render.renderAircraft({ aircraft: [RAFALE, { ...RAFALE, id: 12, name: 'F-22' }] });
    const cards = document.querySelectorAll('#airplanes-container .aircraft-card');
    expect(cards).toHaveLength(2);
    expect(cards[1].querySelector('.aircraft-card-link').getAttribute('href')).toBe('/details/f-22-12');
    expect(cards[1].querySelector('[data-compare-id]').getAttribute('aria-label')).toBe('Comparer F-22');
    expect(document.querySelector('[role="link"]')).toBeNull();
    // Le clic sur la case ne navigue pas : aucun gestionnaire ne touche à location.
    const before = window.location.href;
    cards[0].querySelector('[data-compare-id]').click();
    expect(window.location.href).toBe(before);
  });

  test('liste vide : état vide', () => {
    boot();
    window.VH.hangar = {};
    const render = require('../js/hangar/render');
    document.body.innerHTML = '<div id="airplanes-container"></div>';
    render.renderAircraft({ aircraft: [] });
    expect(document.querySelector('.empty-state')).not.toBeNull();
  });
});
