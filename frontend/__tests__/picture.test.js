/**
 * Tests unitaires — frontend/js/shared/picture.js
 *
 * Le module s'attache à window.VH.shared.picture (pas d'export CommonJS) :
 * on le charge pour son effet de bord puis on lit l'objet global.
 */
require('../js/shared/picture');

const { pictureHtml, thumbHtml, getSources, getThumbSources } = window.VH.shared.picture;

describe('getSources', () => {
  test('dérive les jumeaux AVIF et WebP d\'un asset local', () => {
    expect(getSources('/assets/airplanes/rafale.jpg')).toEqual({
      avif: '/assets/airplanes/rafale.avif',
      webp: '/assets/airplanes/rafale.webp',
      fallback: '/assets/airplanes/rafale.jpg',
    });
  });

  test('null pour une URL externe ou vide', () => {
    expect(getSources('https://example.com/a.jpg')).toBeNull();
    expect(getSources('')).toBeNull();
    expect(getSources(null)).toBeNull();
  });
});

describe('getThumbSources', () => {
  test('pointe AVIF et WebP sur thumbs/, garde la photo pleine en repli', () => {
    expect(getThumbSources('/assets/airplanes/mig17.jpg')).toEqual({
      avif: '/assets/airplanes/thumbs/mig17.avif',
      webp: '/assets/airplanes/thumbs/mig17.webp',
      fallback: '/assets/airplanes/mig17.jpg',
    });
  });

  test('gère une extension en majuscules et un PNG', () => {
    expect(getThumbSources('/assets/airplanes/x-15.PNG').avif).toBe('/assets/airplanes/thumbs/x-15.avif');
  });

  test('null pour une URL non convertible', () => {
    expect(getThumbSources('https://example.com/a.jpg')).toBeNull();
    expect(getThumbSources(undefined)).toBeNull();
  });
});

describe('thumbHtml', () => {
  test('émet un <picture> dont les sources sont les vignettes', () => {
    const html = thumbHtml('/assets/airplanes/rafale.jpg', { alt: 'Rafale', loading: 'lazy' });
    expect(html).toContain('srcset="/assets/airplanes/thumbs/rafale.avif"');
    expect(html).toContain('srcset="/assets/airplanes/thumbs/rafale.webp"');
    expect(html).toContain('src="/assets/airplanes/rafale.jpg"');
    expect(html).toContain('alt="Rafale"');
    expect(html).toContain('loading="lazy"');
  });

  test('retombe sur un <img> simple pour une URL externe', () => {
    expect(thumbHtml('https://example.com/a.jpg', { alt: '' })).toBe('<img src="https://example.com/a.jpg" alt="">');
  });

  test('échappe les attributs', () => {
    expect(thumbHtml('/assets/airplanes/a.jpg', { alt: '"><script>' })).not.toContain('<script>');
  });
});

describe('pictureHtml (inchangé par la factorisation)', () => {
  test('sources pleine taille', () => {
    const html = pictureHtml('/assets/airplanes/rafale.jpg', { alt: '' });
    expect(html).toContain('srcset="/assets/airplanes/rafale.avif"');
    expect(html).not.toContain('thumbs/');
  });
});

describe('PERF-010 — URL versionnées', () => {
  afterEach(() => { delete window.APP_VERSION; });

  test('?v= de window.APP_VERSION (repli) sur les sources, la vignette et le repli JPEG', () => {
    window.APP_VERSION = '4.14.0';
    expect(getSources('/assets/airplanes/rafale.jpg')).toEqual({
      avif: '/assets/airplanes/rafale.avif?v=4.14.0',
      webp: '/assets/airplanes/rafale.webp?v=4.14.0',
      fallback: '/assets/airplanes/rafale.jpg?v=4.14.0',
    });
    expect(getThumbSources('/assets/airplanes/mig17.jpg').avif).toBe('/assets/airplanes/thumbs/mig17.avif?v=4.14.0');
  });

  test('une URL déjà paramétrée n\'est pas re-versionnée', () => {
    window.APP_VERSION = '4.14.0';
    expect(window.VH.shared.picture.withVersion('/a.jpg?x=1')).toBe('/a.jpg?x=1');
  });

  test('la version du <script> qui charge le module prime sur APP_VERSION', () => {
    const original = window.VH.shared.picture;
    jest.isolateModules(() => {
      Object.defineProperty(document, 'currentScript', {
        configurable: true, get: () => ({ src: 'http://h/js/dist/app.min.js?v=9.9.9' }),
      });
      try {
        require('../js/shared/picture');
      } finally {
        delete document.currentScript;
      }
      window.APP_VERSION = '1.0.0';
      expect(window.VH.shared.picture.getSources('/assets/airplanes/a.jpg').avif).toBe('/assets/airplanes/a.avif?v=9.9.9');
    });
    window.VH.shared.picture = original;
  });
});

describe('applySourcesTo', () => {
  function mountPicture(avif = '') {
    document.body.innerHTML = `<picture><source type="image/avif" srcset="${avif}"><source type="image/webp" srcset=""><img id="i" src="data:,"></picture>`;
    return document.getElementById('i');
  }

  test('PERF-002 : pose les srcset AVIF / WebP dans un <picture>', () => {
    const img = mountPicture();
    window.VH.shared.picture.applySourcesTo(img, '/assets/airplanes/rafale.jpg');
    expect(document.querySelector('source[type="image/avif"]').getAttribute('srcset')).toBe('/assets/airplanes/rafale.avif');
    expect(document.querySelector('source[type="image/webp"]').getAttribute('srcset')).toBe('/assets/airplanes/rafale.webp');
    expect(img.getAttribute('src')).toBe('/assets/airplanes/rafale.jpg');
  });

  test('même photo déjà posée (rendu serveur, autre version) : rien n\'est retéléchargé', () => {
    const img = mountPicture('/assets/airplanes/rafale.avif?v=1.0.0');
    window.VH.shared.picture.applySourcesTo(img, '/assets/airplanes/rafale.jpg');
    expect(document.querySelector('source[type="image/avif"]').getAttribute('srcset')).toBe('/assets/airplanes/rafale.avif?v=1.0.0');
    expect(img.getAttribute('src')).toBe('data:,');
  });

  test('URL externe : srcset retirés, src direct', () => {
    const img = mountPicture('/assets/airplanes/rafale.avif');
    window.VH.shared.picture.applySourcesTo(img, 'https://example.com/a.jpg');
    expect(document.querySelector('source[type="image/avif"]').hasAttribute('srcset')).toBe(false);
    expect(img.getAttribute('src')).toBe('https://example.com/a.jpg');
  });
});

describe('attributs on* ignorés (CSP : aucun gestionnaire en ligne)', () => {
  test('onerror / onload ne sont jamais émis', () => {
    const html = pictureHtml('/assets/airplanes/rafale.jpg', { alt: '', onerror: 'alert(1)', OnLoad: 'x' });
    expect(html).not.toMatch(/onerror|onload/i);
    expect(thumbHtml('https://example.com/a.jpg', { alt: '', onerror: 'x' })).toBe('<img src="https://example.com/a.jpg" alt="">');
  });
});
