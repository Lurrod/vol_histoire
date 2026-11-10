/**
 * Tests unitaires — construction des meta et du JSON-LD des rendus serveur
 * (utils/ssr-head.js, routes/details-ssr.js, routes/conflicts-ssr.js) et
 * requêtes des repositories ssr-* (ARCH-004, ARCH-010, HTML-001/003/004/005).
 */
const {
  escapeJson, toAbsoluteUrl, applyHeadMeta, replaceJsonLd, jsonLdScript, truncate,
  langUrl, markdownToText, buildDescription,
  DEFAULT_OG_IMAGE, PUBLISHER_LOGO,
} = require('../utils/ssr-head');
const details = require('../routes/details-ssr');
const conflicts = require('../routes/conflicts-ssr');
const { findAircraftForSsr } = require('../repositories/ssr-details');
const { listEngagedWars } = require('../repositories/ssr-conflicts');

const TEMPLATE = [
  '<html lang="fr"><head>',
  '<title>Gabarit</title>',
  '<meta name="description" content="x">',
  '<link rel="canonical" href="x">',
  '<link rel="alternate" hreflang="fr" href="x">',
  '<link rel="alternate" hreflang="en" href="x">',
  '<link rel="alternate" hreflang="x-default" href="x">',
  '<meta property="og:title" content="x">',
  '<meta property="og:locale" content="fr_FR">',
  '<meta property="og:image" content="x">',
  '<meta name="twitter:image" content="x">',
  '<script type="application/ld+json" id="jsonld-article">{"@type":"Article"}</script>',
  '<script type="application/ld+json" id="jsonld-breadcrumb">{"@type":"BreadcrumbList"}</script>',
  '<link rel="preload" href="fonts/BarlowCondensed-700.woff2" as="font">',
  '</head><body>',
  '<h1 id="aircraft-name" data-i18n="x">Gabarit</h1>',
  '<h1 id="page-hero-heading" data-i18n-html="conflicts.hero_title">Les<span>Conflits</span></h1>',
  '<picture><source id="hero-image-avif" type="image/avif" srcset=""><source id="hero-image-webp" type="image/webp" srcset=""><img id="hero-image" src="data:," alt=""></picture>',
  '</body></html>',
].join('\n');

function jsonLdTypes(html) {
  return [...html.matchAll(/<script type="application\/ld\+json"[^>]*>([\s\S]*?)<\/script>/g)]
    .map(m => JSON.parse(m[1])['@type']);
}

describe('utils/ssr-head', () => {
  test('toAbsoluteUrl : relatif → site, http → https, data: inchangé', () => {
    expect(toAbsoluteUrl('/a.jpg')).toBe('https://vol-histoire.titouan-borde.com/a.jpg');
    expect(toAbsoluteUrl('http://x.org/a.jpg')).toBe('https://x.org/a.jpg');
    expect(toAbsoluteUrl('data:image/png;base64,x')).toBe('data:image/png;base64,x');
    expect(toAbsoluteUrl('')).toBe('');
  });

  test('escapeJson neutralise </script> et les séparateurs de ligne', () => {
    const out = escapeJson('a</script>\u2028b');
    expect(out).not.toContain('</script>');
    expect(out).toContain('\\u003c/script>');
    expect(out).toContain('\\u2028');
  });

  test('truncate coupe sur un mot et ajoute …', () => {
    expect(truncate('un deux trois quatre', 10)).toBe('un deux…');
    expect(truncate('court', 10)).toBe('court');
    // Coupé après une fin de phrase : pas de « .… »
    expect(truncate('Un deux. Trois quatre', 12)).toBe('Un deux.');
  });

  test('applyHeadMeta : un « $& » reste du texte, hreflang par langue, langue anglaise', () => {
    const html = applyHeadMeta(TEMPLATE, {
      title: 'Opération $& test', description: 'd', url: 'https://s/x', image: 'https://s/i.jpg', lang: 'en',
    });
    expect(html).toContain('<title>Opération $&amp; test</title>');
    // SEO-001 : la version anglaise est canonique sur elle-même.
    expect(html).toContain('<link rel="canonical" href="https://s/x?lang=en">');
    expect(html).toContain('<link rel="alternate" hreflang="fr" href="https://s/x">');
    expect(html).toContain('<link rel="alternate" hreflang="en" href="https://s/x?lang=en">');
    expect(html).toContain('<link rel="alternate" hreflang="x-default" href="https://s/x">');
    expect(html).toContain('<meta property="og:locale" content="en_US">');
    expect(html).toContain('<meta property="og:image" content="https://s/i.jpg">');
    expect(html).toContain('<html lang="en">');
  });

  test('SEO-001 : en français, canonical sur l\'URL nue, hreflang réciproques', () => {
    const html = applyHeadMeta(TEMPLATE, { title: 't', description: 'd', url: 'https://s/x', lang: 'fr' });
    expect(html).toContain('<link rel="canonical" href="https://s/x">');
    expect(html).toContain('<link rel="alternate" hreflang="fr" href="https://s/x">');
    expect(html).toContain('<link rel="alternate" hreflang="en" href="https://s/x?lang=en">');
    expect(html).toContain('<link rel="alternate" hreflang="x-default" href="https://s/x">');
    expect(html).toContain('<html lang="fr">');
  });

  test('langUrl : URL nue en français, ?lang=en (ou &lang=en) en anglais', () => {
    expect(langUrl('https://s/x', 'fr')).toBe('https://s/x');
    expect(langUrl('https://s/x', 'en')).toBe('https://s/x?lang=en');
    expect(langUrl('https://s/x?a=1', 'en')).toBe('https://s/x?a=1&lang=en');
  });

  test('markdownToText : premier paragraphe, sans titres, emphase, liens ni puces', () => {
    const md = [
      '## Genèse',
      'Programme **top-secret** du *Skunk Works*, voir [ici](https://x.org) et `code`.',
      '- suite',
      '',
      '## Carrière',
      'Autre.',
    ].join('\n');
    expect(markdownToText(md)).toBe('Programme top-secret du Skunk Works, voir ici et code. suite');
    expect(markdownToText('')).toBe('');
    expect(markdownToText('## Seulement un titre')).toBe('');
  });

  test('buildDescription : accroche ponctuée + récit, coupée sur un mot, ≤ 158', () => {
    const d = buildDescription('Avion espion', '## Genèse\n' + 'mot '.repeat(80), 'repli');
    expect(d.startsWith('Avion espion. mot mot')).toBe(true);
    expect(d.length).toBeLessThanOrEqual(158);
    expect(d.endsWith('mot…')).toBe(true);
    expect(buildDescription('Court', '', 'Repli.')).toBe('Court. Repli.');
    expect(buildDescription('Fini !', '', '', 158, 'en')).toBe('Fini !');
    expect(buildDescription('', '', 'Repli.')).toBe('Repli.');
  });

  test('buildDescription en français : typographie de markdown.js, URL intactes ; anglais inchangé', () => {
    const NBSP = String.fromCharCode(0xA0);
    const NNBSP = String.fromCharCode(0x202F);
    const fr = buildDescription("L'avion « Mirage »", 'Pourquoi ? Réponse : voir https://x.org/a?b, 12:30.', '');
    expect(fr).toBe(`L’avion «${NBSP}Mirage${NBSP}». Pourquoi${NNBSP}? Réponse${NBSP}: voir https://x.org/a?b, 12:30.`);
    const en = buildDescription("It's fast", 'Why ? Because : yes.', '', 158, 'en');
    expect(en).toBe("It's fast. Why ? Because : yes.");
  });

  test('replaceJsonLd remplace tous les blocs ; sans bloc, insère avant </head>', () => {
    const one = replaceJsonLd(TEMPLATE, [jsonLdScript('a', { '@type': 'WebPage' })]);
    expect(jsonLdTypes(one)).toEqual(['WebPage']);
    const none = replaceJsonLd('<head></head>', [jsonLdScript('a', { '@type': 'WebPage' })]);
    expect(none).toMatch(/<script type="application\/ld\+json" id="a">.*<\/script>\n<\/head>/);
  });
});

describe('details-ssr — construction', () => {
  const aircraft = {
    id: 42, name: 'Rafale', name_en: 'Rafale', complete_name: 'Dassault Rafale', complete_name_en: null,
    little_description: 'Chasseur omnirôle français', little_description_en: 'French omnirole fighter',
    image_url: '/assets/airplanes/rafale.jpg', date_operationel: '2001-05-18', date_first_fly: '1986-07-04',
    country_name: 'France', country_name_en: 'France', generation: 4, type_name: 'Multirôle', type_name_en: 'Multirole',
    manufacturer_name: 'Dassault', max_speed: 1912, empty_weight: 10000, max_range: 3700,
    created_at: '2026-01-02T00:00:00Z', updated_at: '2026-03-04T00:00:00Z',
  };

  test('buildHeroSources : sources versionnées pour un asset local, null sinon', () => {
    expect(details.buildHeroSources('/assets/airplanes/rafale.jpg', '4.14.0')).toEqual({
      avif: '/assets/airplanes/rafale.avif?v=4.14.0',
      webp: '/assets/airplanes/rafale.webp?v=4.14.0',
      img: '/assets/airplanes/rafale.jpg?v=4.14.0',
    });
    expect(details.buildHeroSources('https://cdn.example.com/a.jpg', '1')).toBeNull();
  });

  test('buildDetailsMeta en anglais : description EN, og:image absolue non versionnée', () => {
    const meta = details.buildDetailsMeta(aircraft, 'en', '4.14.0');
    expect(meta.title).toBe("Rafale — Multirole, France (2001) | Vol d'Histoire");
    expect(meta.description).toBe('French omnirole fighter. Specifications, armament, production and history of the Rafale.');
    expect(meta.canonical).toBe('https://vol-histoire.titouan-borde.com/details/rafale-42?lang=en');
    expect(meta.ogImage).toBe('https://vol-histoire.titouan-borde.com/assets/airplanes/rafale.jpg');
    expect(meta.url).toBe('https://vol-histoire.titouan-borde.com/details/rafale-42');
  });

  test('buildDetailsMeta : repli EN générique si la description anglaise manque', () => {
    const meta = details.buildDetailsMeta({ id: 1, name: 'X-1' }, 'en', '1');
    expect(meta.description).toBe('Specifications, armament, production and history of the X-1.');
    expect(meta.ogImage).toBe(DEFAULT_OG_IMAGE);
  });

  test('SEO-004 : type réel de l\'appareil, plus de « Chasseur Ne génération »', () => {
    const victor = {
      id: 7, name: 'Handley Page Victor', complete_name: 'Handley Page Victor B.2', generation: 1,
      type_name: 'Bombardier', type_name_en: 'Bomber', country_name: 'Royaume-Uni', country_name_en: 'United Kingdom',
      date_operationel: '1958-04-01',
    };
    const fr = details.buildDetailsMeta(victor, 'fr', '1');
    expect(fr.title).toBe("Handley Page Victor — Bombardier, Royaume-Uni | Vol d'Histoire");
    expect(fr.title).not.toMatch(/Chasseur|génération|1e /);
    const en = details.buildDetailsMeta(victor, 'en', '1');
    expect(en.title).toBe("Handley Page Victor — Bomber, United Kingdom | Vol d'Histoire");
    expect(en.title).not.toMatch(/fighter|th gen/);
    expect(fr.ogImageAlt).toBe('Handley Page Victor — Bombardier — Royaume-Uni');
  });

  test('SEO-007 : ≤ 65 caractères, l\'année puis le pays tombent au besoin', () => {
    const f35 = {
      id: 9, name: 'F-35 Lightning II Italien', type_name: 'Multirôle', country_name: 'Italie',
      date_operationel: '2016-01-01',
      complete_name: 'Lockheed Martin F-35A/B Lightning II (Aeronautica Militare / Marina Militare)',
    };
    expect(details.buildDetailsMeta(f35, 'fr', '1').title)
      .toBe("F-35 Lightning II Italien — Multirôle, Italie | Vol d'Histoire");
    const huge = { id: 1, name: 'Un nom d\'appareil vraiment très long qui dépasse seul la limite', type_name: 'Transport' };
    expect(details.buildDetailsMeta(huge, 'fr', '1').title).toBe(`${huge.name} | Vol d'Histoire`);
    // Sans mise en service : année du premier vol ; sans type : le pays.
    const proto = { id: 2, name: 'X-1', type_name: 'Recherche', date_first_fly: '1946-01-19' };
    expect(details.buildDetailsMeta(proto, 'fr', '1').title).toBe("X-1 — Recherche (1946) | Vol d'Histoire");
    expect(details.buildDetailsMeta({ id: 3, name: 'Y', country_name: 'France' }, 'fr', '1').title)
      .toBe("Y — France | Vol d'Histoire");
  });

  test('SEO-006 : description sans Markdown, accroche puis récit', () => {
    const sr71 = {
      id: 31, name: 'SR-71 Blackbird', little_description: 'Avion de reconnaissance stratégique',
      description: '## Genèse\nProgramme top-secret développé par le **Skunk Works** de Lockheed.',
    };
    expect(details.buildDetailsMeta(sr71, 'fr', '1').description)
      .toBe('Avion de reconnaissance stratégique. Programme top-secret développé par le Skunk Works de Lockheed.');
  });

  test('SEC-005 : « $` », « $\' » et « $& » d\'une fiche restent du texte', () => {
    const tick = String.fromCharCode(96);
    const evil = {
      ...aircraft, name: `Proto $${tick} fin`, complete_name: 'Proto $\' fin', little_description: 'A $& B',
    };
    const html = details.renderHtml(TEMPLATE, evil, 'fr', '1');
    const title = /<title>([^<]*)<\/title>/.exec(html)[1];
    expect(title.startsWith(`Proto $${tick} fin — Multirôle`)).toBe(true);
    expect(html.match(/<html/g)).toHaveLength(1);
    expect(html.match(/<head>/g)).toHaveLength(1);
    expect(html).toContain(`<h1 id="aircraft-name">Proto $${tick} fin</h1>`);
    expect(html).toContain('<meta name="description" content="A $&amp; B.');
  });

  test('HTML-003 / HTML-004 : un Article dont l\'objet est le Vehicle, logo éditeur carré', () => {
    const meta = details.buildDetailsMeta(aircraft, 'fr', '1');
    const article = details.buildArticleLd(aircraft, meta);
    expect(article['@type']).toBe('Article');
    expect(article.publisher.logo.url).toBe(PUBLISHER_LOGO);
    expect(article.about['@type']).toBe('Vehicle');
    expect(article.about.manufacturer).toEqual({ '@type': 'Organization', name: 'Dassault' });
    expect(article.about.productionDate).toBe('1986-07-04');
    expect(article.about.vehicleConfiguration).toBe('Multirôle');
    expect(article.datePublished).toBe('2026-01-02');
    expect(article.url).toBe('https://vol-histoire.titouan-borde.com/details/rafale-42');
    const metaEn = details.buildDetailsMeta(aircraft, 'en', '1');
    const articleEn = details.buildArticleLd(aircraft, metaEn);
    expect(articleEn.url).toBe('https://vol-histoire.titouan-borde.com/details/rafale-42?lang=en');
    expect(articleEn.about.url).toBe(articleEn.url);
    expect(details.buildDetailsBreadcrumbLd(metaEn).itemListElement.map(c => c.item)).toEqual([
      'https://vol-histoire.titouan-borde.com/?lang=en',
      'https://vol-histoire.titouan-borde.com/hangar?lang=en',
      'https://vol-histoire.titouan-borde.com/details/rafale-42?lang=en',
    ]);
  });

  test('renderHtml : deux blocs JSON-LD (Article, BreadcrumbList) aux id partagés avec le client', () => {
    const html = details.renderHtml(TEMPLATE, aircraft, 'fr', '4.14.0');
    expect(jsonLdTypes(html)).toEqual(['Article', 'BreadcrumbList']);
    expect(html).toContain('id="jsonld-article"');
    expect(html).toContain('id="jsonld-breadcrumb"');
    expect(html).toContain('<link rel="preload" as="image" href="/assets/airplanes/rafale.avif?v=4.14.0" type="image/avif" fetchpriority="high">');
    expect(html).toContain('<img id="hero-image" src="/assets/airplanes/rafale.jpg?v=4.14.0"');
    expect(html).toContain('<h1 id="aircraft-name">Rafale</h1>');
    expect(details.renderHtml('', aircraft, 'fr', '1')).toBeNull();
  });
});

describe('conflicts-ssr — construction', () => {
  const war = {
    id: 3, name: 'Guerre du Golfe', name_en: 'Gulf War', description: 'FR', description_en: 'EN',
    date_start: '1990-08-02', date_end: '1991-02-28', image_url: '/assets/airplanes/f117.jpg',
  };

  test('HTML-001 : nom, titre et description dans la langue demandée', () => {
    const meta = conflicts.buildConflictMeta(war, 'guerre-du-golfe', 'en');
    expect(meta.name).toBe('Gulf War');
    expect(meta.title).toBe("Gulf War (1990-1991) | Vol d'Histoire");
    expect(meta.description).toBe('EN');
    expect(meta.lang).toBe('en');
  });

  test('HTML-005 : image d\'un appareil engagé, sinon visuel par défaut', () => {
    expect(conflicts.buildConflictMeta(war, 's', 'fr').image)
      .toBe('https://vol-histoire.titouan-borde.com/assets/airplanes/f117.jpg');
    expect(conflicts.buildConflictMeta({ ...war, image_url: null }, 's', 'fr').image).toBe(DEFAULT_OG_IMAGE);
  });

  test('années : conflit en cours, conflit d\'une seule année', () => {
    expect(conflicts.buildConflictMeta({ name: 'A', date_start: '2022-02-24' }, 'a', 'fr').title).toBe("A (depuis 2022) | Vol d'Histoire");
    expect(conflicts.buildConflictMeta({ name: 'A', date_start: '2022-02-24' }, 'a', 'en').title).toBe("A (since 2022) | Vol d'Histoire");
    expect(conflicts.buildConflictMeta({ name: 'A', date_start: '1961-12-17', date_end: '1961-12-19' }, 'a', 'fr').title).toBe("A (1961) | Vol d'Histoire");
  });

  test('renderHtml : fil d\'Ariane à trois niveaux et h1 du conflit', () => {
    const meta = conflicts.buildConflictMeta(war, 'guerre-du-golfe', 'fr');
    const html = conflicts.renderHtml(TEMPLATE, meta, meta.name);
    expect(jsonLdTypes(html)).toEqual(['BreadcrumbList']);
    const crumbs = JSON.parse(html.match(/id="jsonld-breadcrumb">([^<]*)</)[1]).itemListElement;
    expect(crumbs.map(c => c.name)).toEqual(['Accueil', 'Conflits', 'Guerre du Golfe']);
    expect(crumbs[2].item).toBe('https://vol-histoire.titouan-borde.com/conflits/guerre-du-golfe');
    expect(html).toContain('<h1 id="page-hero-heading">Guerre du Golfe</h1>');
  });

  test('liste des conflits : deux niveaux, h1 laissé à la traduction client', () => {
    const html = conflicts.renderHtml(TEMPLATE, conflicts.buildConflictsIndexMeta('en'));
    expect(html).toContain('<title>Conflicts | Vol d&#39;Histoire</title>');
    expect(html).toContain('data-i18n-html="conflicts.hero_title"');
    const crumbs = JSON.parse(html.match(/id="jsonld-breadcrumb">([^<]*)</)[1]).itemListElement;
    expect(crumbs.map(c => c.name)).toEqual(['Home', 'Conflicts']);
    expect(crumbs.map(c => c.item)).toEqual([
      'https://vol-histoire.titouan-borde.com/?lang=en',
      'https://vol-histoire.titouan-borde.com/conflits?lang=en',
    ]);
    expect(html).toContain('<link rel="canonical" href="https://vol-histoire.titouan-borde.com/conflits?lang=en">');
  });
});

describe('repositories ssr-*', () => {
  test('findAircraftForSsr : requête paramétrée, null si absent', async () => {
    const pool = { query: jest.fn().mockResolvedValueOnce({ rows: [{ id: 7 }] }).mockResolvedValueOnce({ rows: [] }) };
    await expect(findAircraftForSsr(pool, 7)).resolves.toEqual({ id: 7 });
    await expect(findAircraftForSsr(pool, 8)).resolves.toBeNull();
    const [sql, params] = pool.query.mock.calls[0];
    expect(sql).toMatch(/WHERE a\.id = \$1/);
    expect(sql).toMatch(/name_en/);
    expect(params).toEqual([7]);
  });

  test('listEngagedWars : conflits rattachés, avec une photo d\'appareil', async () => {
    const pool = { query: jest.fn().mockResolvedValue({ rows: [{ id: 1, name: 'A' }] }) };
    await expect(listEngagedWars(pool)).resolves.toEqual([{ id: 1, name: 'A' }]);
    const [sql] = pool.query.mock.calls[0];
    expect(sql).toMatch(/LEFT JOIN LATERAL/);
    expect(sql).toMatch(/WHERE EXISTS \(SELECT 1 FROM airplane_wars/);
  });
});
