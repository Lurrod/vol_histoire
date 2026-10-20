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
