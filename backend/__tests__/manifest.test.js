/**
 * Manifestes PWA (MOB-001) : captures d'écran réelles aux dimensions
 * déclarées, icônes de raccourcis typées, version anglaise cohérente.
 */
const fs = require('fs');
const path = require('path');
const request = require('supertest');

const FRONT = path.join(__dirname, '../../frontend');
const read = (f) => JSON.parse(fs.readFileSync(path.join(FRONT, f), 'utf8'));

/** Largeur × hauteur d'un JPEG (segment SOF). */
function jpegSize(file) {
  const b = fs.readFileSync(file);
  let i = 2;
  while (i < b.length) {
    const marker = b[i + 1];
    const len = b.readUInt16BE(i + 2);
    if (marker >= 0xc0 && marker <= 0xc3) return `${b.readUInt16BE(i + 7)}x${b.readUInt16BE(i + 5)}`;
    i += 2 + len;
  }
  return null;
}

describe.each([['manifest.webmanifest', 'fr'], ['manifest.en.webmanifest', 'en']])('%s', (file, lang) => {
  const m = read(file);

  test('langue et adresse de départ', () => {
    expect(m.lang).toBe(lang);
    expect(m.start_url).toMatch(lang === 'en' ? /lang=en/ : /^\/\?source=pwa$/);
  });

  test('captures : fichiers présents, dimensions déclarées exactes, une étroite et une large', () => {
    expect(m.screenshots.map((s) => s.form_factor).sort()).toEqual(expect.arrayContaining(['narrow', 'wide']));
    m.screenshots.forEach((s) => {
      const f = path.join(FRONT, s.src);
      expect(fs.existsSync(f)).toBe(true);
      expect(jpegSize(f)).toBe(s.sizes);
      const [w, h] = s.sizes.split('x').map(Number);
      expect(s.form_factor === 'wide' ? w > h : h > w).toBe(true);
      expect(s.label).toBeTruthy();
    });
  });

  test('icônes des raccourcis typées', () => {
    m.shortcuts.flatMap((s) => s.icons).forEach((i) => {
      expect(i.type).toBe('image/png');
      expect(i.purpose).toBe('any');
    });
  });
});

describe('page anglaise → manifeste anglais', () => {
  const app = require('../app');
  beforeAll(() => app.setPool({ query: jest.fn().mockResolvedValue({ rows: [] }) }));
  afterAll(() => app.stopCleanup());

  test('/hangar?lang=en lie manifest.en.webmanifest, /hangar le français', async () => {
    const en = await request(app).get('/hangar?lang=en');
    expect(en.text).toContain('<link rel="manifest" href="/manifest.en.webmanifest">');
    const fr = await request(app).get('/hangar');
    expect(fr.text).toContain('<link rel="manifest" href="/manifest.webmanifest">');
    const res = await request(app).get('/manifest.en.webmanifest');
    expect(res.status).toBe(200);
    expect(res.headers['content-type']).toMatch(/application\/manifest\+json/);
  });
});
