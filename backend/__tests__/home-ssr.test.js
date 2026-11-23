/**
 * Accueil : photo de l'appareil du jour écrite par le serveur (élément LCP).
 * utils/home-ssr.js (règle de choix, injection) et GET / (base simulée).
 */

process.env.NODE_ENV = 'test';
process.env.JWT_SECRET = 'test-secret-key-for-jest';
process.env.REFRESH_SECRET = 'test-refresh-secret-key-for-jest';

const request = require('supertest');
const app = require('../app');
const homeSsr = require('../utils/home-ssr');

const mockPool = { query: jest.fn() };

const PICTURE = '<picture><source type="image/avif" srcset=""><source type="image/webp" srcset="">'
  + '<img id="hero-today-image" class="hero-today-image" src="data:image/gif;base64,R0lG" alt="" width="1600" height="1067" fetchpriority="high" decoding="async"></picture>';

const entry = (over) => ({
  kind: 'first_flight', day_gap: 0, event_date: '1968-09-08', year: 1968,
  airplane_id: 3, airplane_name: 'Jaguar', airplane_name_en: 'SEPECAT Jaguar',
  image_url: '/assets/airplanes/jaguar.jpg', ...over,
});

describe('home-ssr — choix de la photo du jour', () => {
  test('même règle que le client : première entrée de l\'écart le plus petit', () => {
    const payload = { ephemeris: [
      entry({ day_gap: 2, airplane_name: 'Loin' }),
      entry({ day_gap: 1, airplane_name: 'Proche', image_url: '/assets/airplanes/proche.jpg' }),
      entry({ day_gap: 1, airplane_name: 'Proche bis' }),
    ] };
    expect(homeSsr.dayEntry(payload).airplane_name).toBe('Proche');
    expect(homeSsr.dayPhoto(payload, { version: '4.28.0' })).toEqual({
      avif: '/assets/airplanes/proche.avif?v=4.28.0',
      webp: '/assets/airplanes/proche.webp?v=4.28.0',
      fallback: '/assets/airplanes/proche.jpg?v=4.28.0',
      alt: 'Proche',
    });
  });

  test('nom anglais selon la langue ; sans version, pas de ?v=', () => {
    const photo = homeSsr.dayPhoto({ ephemeris: [entry()] }, { lang: 'en' });
    expect(photo.alt).toBe('SEPECAT Jaguar');
    expect(photo.avif).toBe('/assets/airplanes/jaguar.avif');
  });

  test('aucune éphéméride, photo absente ou non locale : rien', () => {
    expect(homeSsr.dayEntry(null)).toBeNull();
    expect(homeSsr.dayPhoto({ ephemeris: [] })).toBeNull();
    expect(homeSsr.dayPhoto({ ephemeris: [entry({ image_url: null })] })).toBeNull();
    expect(homeSsr.dayPhoto({ ephemeris: [entry({ image_url: 'https://ailleurs.test/x.jpg' })] })).toBeNull();
    expect(homeSsr.dayPhoto({ ephemeris: [entry({ image_url: '/assets/airplanes/x".jpg' })] })).toBeNull();
  });
});

describe('home-ssr — injection dans le <picture> du hero', () => {
  test('sources, src et alt posés, autres attributs conservés, valeurs échappées', () => {
    const html = `<main>${PICTURE}</main>`;
    const out = homeSsr.injectDayPhoto(html, { ephemeris: [entry({ airplane_name: 'Mirage "III" <b>' })] }, { version: '1' });
    expect(out).toContain('<source type="image/avif" srcset="/assets/airplanes/jaguar.avif?v=1">');
    expect(out).toContain('<source type="image/webp" srcset="/assets/airplanes/jaguar.webp?v=1">');
    expect(out).toContain('<img id="hero-today-image" class="hero-today-image" src="/assets/airplanes/jaguar.jpg?v=1" alt="Mirage &quot;III&quot; &lt;b&gt;" width="1600" height="1067" fetchpriority="high" decoding="async">');
  });

  test('pas de photo du jour ou gabarit introuvable : HTML inchangé', () => {
    expect(homeSsr.injectDayPhoto(PICTURE, { ephemeris: [] })).toBe(PICTURE);
    expect(homeSsr.injectDayPhoto('<p>autre</p>', { ephemeris: [entry()] })).toBe('<p>autre</p>');
  });
});

describe('GET / — photo du jour dans le HTML de l\'accueil', () => {
  beforeAll(() => app.setPool(mockPool));
  beforeEach(() => {
    mockPool.query.mockReset();
    require('../utils/cache')._resetForTests();
  });

  function mockDiscoveries(ephemeris) {
    mockPool.query
      .mockResolvedValueOnce({ rows: [] })          // facts
      .mockResolvedValueOnce({ rows: [] })          // aircraft
      .mockResolvedValueOnce({ rows: ephemeris });  // ephemeris
  }

  test('la photo de l\'appareil du jour est demandée dès la lecture de la page', async () => {
    mockDiscoveries([entry()]);
    const res = await request(app).get('/');
    expect(res.status).toBe(200);
    expect(res.headers['content-type']).toMatch(/text\/html/);
    expect(res.text).toMatch(/<source type="image\/avif" srcset="\/assets\/airplanes\/jaguar\.avif\?v=[^"]+">/);
    expect(res.text).toMatch(/<img id="hero-today-image"[^>]* src="\/assets\/airplanes\/jaguar\.jpg\?v=[^"]+"[^>]* alt="Jaguar"/);
    // Le nonce CSP reste posé à chaque requête
    expect(res.text).toMatch(/nonce="/);
  });

  test('anglais : nom anglais dans l\'alt', async () => {
    mockDiscoveries([entry()]);
    const res = await request(app).get('/?lang=en');
    expect(res.text).toMatch(/<img id="hero-today-image"[^>]* alt="SEPECAT Jaguar"/);
  });

  test('base en panne : accueil servi quand même, sans photo écrite', async () => {
    mockPool.query.mockRejectedValue(new Error('panne'));
    const res = await request(app).get('/');
    expect(res.status).toBe(200);
    expect(res.text).toContain('<source type="image/avif" srcset="">');
    mockPool.query.mockReset();
  });

  test('deuxième visite le même jour : servie depuis le cache, sans requête', async () => {
    mockDiscoveries([entry()]);
    await request(app).get('/');
    const calls = mockPool.query.mock.calls.length;
    const res = await request(app).get('/');
    expect(mockPool.query.mock.calls.length).toBe(calls);
    expect(res.text).toContain('jaguar.avif');
  });
});
