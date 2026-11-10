/**
 * Tests unitaires — middleware/serveHtml.js : inclusions d'en-tête / pied de
 * page (ARCH-006), lien actif par page, cache-busting (PERF-001, PERF-003).
 */
const fs = require('fs');
const os = require('os');
const path = require('path');
const {
  buildHtmlCache, rewrite, resolveIncludes, loadPartials, renderTemplate, localizeHead,
} = require('../middleware/serveHtml');

const FRONTEND = path.join(__dirname, '../../frontend');

function tmpFrontend(files) {
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'vh-serve-'));
  for (const [name, content] of Object.entries(files)) {
    fs.mkdirSync(path.dirname(path.join(dir, name)), { recursive: true });
    fs.writeFileSync(path.join(dir, name), content);
  }
  return dir;
}

const NAV_PARTIAL = [
  '<ul>',
  '  <li><a href="/"{{active:/}}>Accueil</a></li>',
  '  <li><a href="/hangar"{{active:/hangar}}>Hangar</a></li>',
  '</ul>',
  '<a id="login-icon" class="login-icon{{current:login}}"></a>',
  '<div class="logo"><picture><img alt=""></picture></div>',
  '',
].join('\n');

describe('resolveIncludes', () => {
  const partials = new Map([['nav', NAV_PARTIAL.trimEnd()], ['footer', '<footer>pied</footer>']]);

  test('remplace le marqueur par le fragment et marque le lien de la page', () => {
    const out = resolveIncludes('<body>\n  <!-- @include nav -->\n</body>', 'hangar', partials);
    expect(out).toContain('<a href="/hangar" class="active" aria-current="page">Hangar</a>');
    expect(out).toContain('<a href="/">Accueil</a>');
    expect(out).not.toContain('@include');
    expect(out).not.toContain('{{');
  });

  test('aucun lien actif pour une page hors navigation', () => {
    const out = resolveIncludes('<!-- @include nav -->', 'cgu', partials);
    expect(out).not.toContain('aria-current');
    expect(out).not.toMatch(/class="active"/);
  });

  test('variantes : icône de compte active sur login, logo-lien sur 404', () => {
    expect(resolveIncludes('<!-- @include nav -->', 'login', partials)).toContain('class="login-icon active"');
    const notFound = resolveIncludes('<!-- @include nav -->', '404', partials);
    expect(notFound).toContain('<a href="/" class="logo" aria-label="Vol d\'Histoire — Accueil"><picture>');
    expect(notFound).not.toContain('<div class="logo">');
  });

  test('conserve les fins de ligne CRLF de la page', () => {
    const out = resolveIncludes('<body>\r\n  <!-- @include nav -->\r\n</body>', 'index', partials);
    expect(out).toContain('<ul>\r\n  <li>');
    expect(out).not.toMatch(/[^\r]\n/);
  });

  test('fragment inconnu : marqueur laissé en place et signalé', () => {
    const warnings = [];
    const out = resolveIncludes('<!-- @include inconnu -->', 'index', partials, warnings);
    expect(out).toContain('<!-- @include inconnu -->');
    expect(warnings).toEqual(['index: fragment inconnu « inconnu »']);
  });

  test('un marqueur qui n\'est pas seul sur sa ligne est ignoré', () => {
    const html = '<p>texte <!-- @include footer --></p>';
    expect(resolveIncludes(html, 'index', partials)).toBe(html);
  });
});

describe('buildHtmlCache / renderTemplate', () => {
  test('résout les inclusions, versionne css/js, ignore partials/', () => {
    const dir = tmpFrontend({
      'partials/footer.html': '<footer>pied</footer>\n',
      'index.html': '<link rel="stylesheet" href="css/a.css">\n<!-- @include footer -->\n<script src="js/a.js"></script>',
    });
    const cache = buildHtmlCache(dir, '9.9.9');
    expect(cache.count).toBe(1); // le fragment n'est pas une page
    const html = cache.get(path.join(dir, 'index.html'));
    expect(html).toContain('<footer>pied</footer>');
    expect(html).toContain('css/a.css?v=9.9.9');
    expect(html).toContain('js/a.js?v=9.9.9');
    expect(cache.warnings).toEqual([]);
    expect(cache.has(path.join(dir, 'partials/footer.html'))).toBe(false);
    expect(renderTemplate(dir, 'index.html', '1.0.0')).toContain('<footer>pied</footer>');
    expect(renderTemplate(dir, 'absent.html', '1.0.0')).toBe('');
  });

  test('loadPartials : dossier absent → aucun fragment', () => {
    expect(loadPartials(path.join(os.tmpdir(), 'vh-inexistant-xyz')).size).toBe(0);
  });
});

describe('rewrite — cache-busting', () => {
  test('PERF-001 : les preload de polices ne sont pas versionnés (même URL que @font-face)', () => {
    const html = '<link rel="preload" href="fonts/DMSans.woff2" as="font" type="font/woff2" crossorigin>';
    expect(rewrite(html, '1.2.3')).toBe(html);
  });

  test('une URL déjà paramétrée est laissée telle quelle', () => {
    const html = '<script src="js/a.js?v=1"></script>';
    expect(rewrite(html, '2')).toBe(html);
  });
});

describe('pages réelles de frontend/', () => {
  const cache = buildHtmlCache(FRONTEND, 'test');
  const page = (name) => cache.get(path.join(FRONTEND, `${name}.html`));
  const NAV_PAGES = { index: '/', hangar: '/hangar', timeline: '/timeline', favorites: '/favorites' };
  const HEADER_PAGES = ['404', 'cgu', 'conflits', 'contact', 'details', 'favorites', 'hangar', 'index',
    'login', 'mentions-legales', 'politique-confidentialite', 'settings', 'timeline'];

  test('toutes les inclusions sont résolues', () => {
    expect(cache.warnings).toEqual([]);
    for (const name of HEADER_PAGES) {
      const html = page(name);
      expect(html).not.toContain('@include');
      expect(html.match(/<header>/g)).toHaveLength(1);
      expect(html.match(/<footer>/g)).toHaveLength(1);
      expect(html).toContain('id="nav-links"');
    }
  });

  test('un seul lien actif, celui de la page (ou aucun)', () => {
    for (const name of HEADER_PAGES) {
      const current = page(name).match(/aria-current="page"[^>]*>\s*<i class="fas fa-[a-z]+"><\/i>/g) || [];
      const navActive = page(name).match(/<a href="([^"]*)" class="active" aria-current="page">/g) || [];
      if (NAV_PAGES[name]) {
        expect(navActive).toEqual([`<a href="${NAV_PAGES[name]}" class="active" aria-current="page">`]);
      } else {
        expect(navActive).toEqual([]);
        expect(current).toEqual([]);
      }
    }
    expect(page('login')).toContain('class="login-icon active"');
    expect(page('settings')).toContain('class="dropdown-item active" role="menuitem"');
  });

  test('A11Y-008 : les noms de langue portent leur attribut lang', () => {
    const html = page('hangar');
    expect(html).toMatch(/data-lang="en" lang="en"[^>]*><span class="lang-code">EN<\/span> English/);
    expect(html).toMatch(/data-lang="fr" lang="fr"[^>]*><span class="lang-code">FR<\/span> Français/);
  });

  test('PERF-003 : aucun ?v= codé en dur dans les sources HTML', () => {
    const offenders = fs.readdirSync(FRONTEND)
      .filter(f => f.endsWith('.html'))
      .filter(f => /\?v=\d/.test(fs.readFileSync(path.join(FRONTEND, f), 'utf8')));
    expect(offenders).toEqual([]);
  });
});

describe('SEO-001 — versions linguistiques des pages statiques', () => {
  const HEAD = [
    '<html lang="fr"><head>',
    '<title data-i18n="hangar.title">Hangar FR | Vol d\'Histoire</title>',
    '<meta name="description" content="Description FR">',
    '<link rel="canonical" href="https://s/hangar">',
    '<link rel="alternate" hreflang="fr" href="https://s/hangar?lang=fr">',
    '<link rel="alternate" hreflang="en" href="https://s/hangar?lang=en">',
    '<link rel="alternate" hreflang="x-default" href="https://s/hangar">',
    '<meta property="og:title" content="Hangar FR">',
    '<meta property="og:description" content="Description FR">',
    '<meta property="og:url" content="https://s/hangar">',
    '<meta property="og:locale" content="fr_FR">',
    '<meta name="twitter:title" content="Hangar FR">',
    '<meta name="twitter:description" content="Description FR">',
    '</head><body></body></html>',
  ].join('\n');
  const EN = { hangar: { title: 'Hangar EN $& | Vol' }, seo: { description: { hangar: 'Description EN' } } };

  test('localizeHead fr : hreflang fr sur l\'URL nue, le reste inchangé', () => {
    const html = localizeHead(HEAD, 'hangar', 'fr', {});
    expect(html).toContain('<link rel="alternate" hreflang="fr" href="https://s/hangar">');
    expect(html).toContain('<link rel="canonical" href="https://s/hangar">');
    expect(html).toContain('<html lang="fr">');
    expect(html).toContain('Hangar FR | Vol d\'Histoire</title>');
  });

  test('localizeHead en : lang, titre, description, og:locale, canonical auto-référent', () => {
    const html = localizeHead(HEAD, 'hangar', 'en', EN);
    expect(html).toContain('<html lang="en">');
    expect(html).toContain('<title data-i18n="hangar.title">Hangar EN $&amp; | Vol</title>');
    expect(html).toContain('<meta name="description" content="Description EN">');
    expect(html).toContain('<meta property="og:description" content="Description EN">');
    expect(html).toContain('<meta name="twitter:description" content="Description EN">');
    expect(html).toContain('<meta property="og:title" content="Hangar EN $&amp; | Vol">');
    expect(html).toContain('<meta name="twitter:title" content="Hangar EN $&amp; | Vol">');
    expect(html).toContain('<meta property="og:locale" content="en_US">');
    expect(html).toContain('<link rel="canonical" href="https://s/hangar?lang=en">');
    expect(html).toContain('<meta property="og:url" content="https://s/hangar?lang=en">');
    expect(html).toContain('<link rel="alternate" hreflang="fr" href="https://s/hangar">');
    expect(html).toContain('<link rel="alternate" hreflang="x-default" href="https://s/hangar">');
  });

  test('localizeHead en sans traduction ni canonical : rien n\'est inventé', () => {
    const html = localizeHead('<html lang="fr"><title>T</title>', 'x', 'en', {});
    expect(html).toBe('<html lang="en"><title>T</title>');
  });

  test('buildHtmlCache : get(page, lang) sert la variante, français par défaut', () => {
    const dir = tmpFrontend({
      'hangar.html': HEAD,
      'locales/en.json': JSON.stringify(EN),
    });
    const cache = buildHtmlCache(dir, '1');
    const file = path.join(dir, 'hangar.html');
    expect(cache.get(file)).toContain('<html lang="fr">');
    expect(cache.get(file, 'fr')).toBe(cache.get(file));
    expect(cache.get(file, 'de')).toBe(cache.get(file));
    expect(cache.get(file, 'en')).toContain('<link rel="canonical" href="https://s/hangar?lang=en">');
    expect(cache.get(path.join(dir, 'absent.html'), 'en')).toBeNull();
  });

  test('pages réelles : chaque page indexable a sa version anglaise traduite', () => {
    const cache = buildHtmlCache(FRONTEND, '1');
    for (const name of ['index', 'hangar', 'timeline', 'contact', 'credits', 'cgu', 'mentions-legales', 'politique-confidentialite']) {
      const fr = cache.get(path.join(FRONTEND, `${name}.html`), 'fr');
      const en = cache.get(path.join(FRONTEND, `${name}.html`), 'en');
      const canonical = /<link rel="canonical" href="([^"]+)">/.exec(fr)[1];
      expect(en).toContain('<html lang="en">');
      expect(en).toContain(`<link rel="canonical" href="${canonical}?lang=en">`);
      expect(fr).toContain(`<link rel="alternate" hreflang="fr" href="${canonical}">`);
      expect(/<meta name="description" content="([^"]+)">/.exec(en)[1])
        .not.toBe(/<meta name="description" content="([^"]+)">/.exec(fr)[1]);
      expect(/<title[^>]*>([^<]+)</.exec(en)[1]).not.toBe(/<title[^>]*>([^<]+)</.exec(fr)[1]);
    }
  });
});
