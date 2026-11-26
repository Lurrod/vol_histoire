/**
 * Récit de la fiche écrit par le serveur (SEO-001).
 */
const fs = require('fs');
const path = require('path');
const { applyDescription, descriptionBody, applyRelated } = require('../utils/details-body-ssr');

const TEMPLATE = fs.readFileSync(path.join(__dirname, '../../frontend/details.html'), 'utf8');
const MD = '## Genèse\nL\'avion vole : Mach 2 ?\n\n- canon\n- missile';

describe('descriptionBody', () => {
  test('Markdown en français : titres, listes, typographie française', () => {
    const b = descriptionBody({ description: MD }, 'fr');
    expect(b.markdown).toBe(true);
    expect(b.html).toContain('<h3 class="md-section">Genèse</h3>');
    expect(b.html).toContain('<li>canon</li>');
    expect(b.html).toContain('L’avion vole : Mach 2 ?');
  });

  test('anglais : récit _en, sans typographie française', () => {
    const b = descriptionBody({ description: MD, description_en: '## Origins\nIt flies : fast ?' }, 'en');
    expect(b.html).toContain('<h3 class="md-section">Origins</h3>');
    expect(b.html).toContain('It flies : fast ?');
  });

  test('anglais sans traduction : même marqueur que l’API', () => {
    expect(descriptionBody({ description: 'Texte.', description_en: null }, 'en').html).toBe('<p>Translation needed</p>');
  });

  test('texte simple : échappé, dans un paragraphe', () => {
    const b = descriptionBody({ description: 'Un <b>chasseur</b> & co' }, 'fr');
    expect(b).toEqual({ markdown: false, html: '<p>Un &lt;b&gt;chasseur&lt;/b&gt; &amp; co</p>' });
  });

  test('sans récit : message « aucune description » de la langue', () => {
    expect(descriptionBody({ description: null }, 'fr').html).toMatch(/^<p>Aucune description/);
    expect(descriptionBody({ description: null, description_en: null }, 'en').html).toMatch(/^<p>No description/);
  });
});

describe('applyDescription', () => {
  test('remplace le texte d’attente, retire data-i18n, garde l’identifiant', () => {
    expect(TEMPLATE).toContain('Chargement de la description…');
    const out = applyDescription(TEMPLATE, { description: MD }, 'fr');
    expect(out).not.toContain('Chargement de la description…');
    expect(out).toMatch(/<div id="aircraft-description" class="description-body markdown-body"><h3 class="md-section">Genèse<\/h3>/);
    expect(out).not.toMatch(/id="aircraft-description"[^>]*data-i18n/);
  });
});

describe('appareils liés (SEO-001)', () => {
  const MIRAGE = {
    predecessor_id: 4, predecessor_name: 'Mirage III', predecessor_name_en: null, predecessor_image: '/assets/airplanes/mirage_iii.jpg',
    rival_id: 9, rival_name: 'F-16 Fighting Falcon', rival_image: null,
  };

  test('liens au slug canonique, libellés de la langue, image de repli', () => {
    const out = applyRelated(TEMPLATE, MIRAGE, 'fr');
    expect(out).toContain('<section class="content-section related-section" id="related-aircraft-section">');
    expect(out).toContain('<a class="related-card" href="/details/mirage-iii-4" data-morph-id="4"><span class="related-relation">Prédécesseur</span>');
    expect(out).toContain('href="/details/f-16-fighting-falcon-9"');
    expect(out).toContain('<img src="/assets/logo/placeholder-airplane-fr.svg"');
    expect(out).toContain('Rival direct');
  });

  test('anglais : ?lang=en conservé, libellés anglais', () => {
    const out = applyRelated(TEMPLATE, MIRAGE, 'en');
    expect(out).toContain('href="/details/mirage-iii-4?lang=en"');
    expect(out).toContain('>Predecessor<');
  });

  test('aucun lien : section laissée masquée', () => {
    expect(applyRelated(TEMPLATE, {}, 'fr')).toBe(TEMPLATE);
  });
});
