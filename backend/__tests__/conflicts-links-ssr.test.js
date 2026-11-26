/**
 * Liens explorables des pages de conflit, écrits par le serveur (SEO-005).
 */
const fs = require('fs');
const path = require('path');
const { applyList, applySides, period } = require('../utils/conflicts-links-ssr');

const TEMPLATE = fs.readFileSync(path.join(__dirname, '../../frontend/conflits.html'), 'utf8');
const WARS = [
  { id: 1, name: 'Guerre de Corée', name_en: 'Korean War', date_start: '1950-06-25', date_end: '1953-07-27', description: 'Péninsule', count: 40 },
  { id: 2, name: 'Guerre russo-ukrainienne', date_start: '2022-02-24', date_end: null, count: 1 },
  { id: 3, name: 'Sans appareil', date_start: '1990-01-01', count: 0 },
];

describe('liste des conflits', () => {
  test('une carte-lien par conflit engagé, silhouettes masquées', () => {
    const out = applyList(TEMPLATE, WARS, 'fr');
    expect(out).toContain('<div id="conflicts-loading" class="conflicts-grid hidden"');
    expect(out).toContain('<a class="conflict-card" href="/conflits/guerre-de-coree">');
    expect(out).toContain('<span class="conflict-period">1950 – 1953</span>');
    expect(out).toContain('40 appareils');
    expect(out).toContain('1 appareil<');
    expect(out).not.toContain('sans-appareil');
  });

  test('anglais : noms traduits, ?lang=en dans les liens', () => {
    const out = applyList(TEMPLATE, WARS, 'en');
    expect(out).toContain('href="/conflits/guerre-de-coree?lang=en"');
    expect(out).toContain('<h2 class="conflict-name">Korean War</h2>');
    expect(period(WARS[1], 'en')).toBe('since 2022');
  });
});

describe('appareils engagés', () => {
  const SIDES = [{ side_key: 'onu', name: 'ONU', members: 'États-Unis, Royaume-Uni' }];
  const AIRPLANES = [
    { id: 7, name: 'F-86 Sabre', image_url: '/assets/airplanes/f86.jpg', type_name: 'Chasseur', country_name: 'États-Unis',
      side_key: 'onu', role: "Chasseur d'escorte face au *MiG-15*", role_sources: 'https://fr.wikipedia.org/wiki/F-86\nhttps://www.af.mil/x' },
    { id: 8, name: 'MiG-15', image_url: null, side_key: null, role: 'Interception' },
    { id: 9, name: 'Sans rôle', side_key: 'onu', role: null },
  ];

  test('cartes de rôle par camp, liens vers les fiches, vignette 320 px', () => {
    const out = applySides(TEMPLATE, AIRPLANES, SIDES, 'fr');
    expect(out).toContain('<div id="conflict-sides" class="conflict-sides">');
    expect(out).toContain('<h4 class="role-name"><a href="/details/f-86-sabre-7">F-86 Sabre</a></h4>');
    expect(out).toContain('src="/assets/airplanes/thumbs/f86.webp"');
    expect(out).toContain('Chasseur d’escorte face au <em>MiG-15</em>');
    expect(out).toContain('fr.wikipedia.org</a>, <a href="https://www.af.mil/x"');
    expect(out).toContain('Dans plusieurs camps');
    expect(out).not.toContain('Sans rôle');
  });

  test('aucun rôle : section laissée au navigateur', () => {
    expect(applySides(TEMPLATE, [{ id: 1, name: 'X', role: null }], [], 'fr')).toBe(TEMPLATE);
  });
});
