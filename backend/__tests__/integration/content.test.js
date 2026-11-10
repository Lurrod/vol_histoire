'use strict';

/**
 * Intégration SQL — contenus éditoriaux et pages dérivées :
 * routes/hero.js, timeline.js, wars.js, sitemap.js, stats.js, monitoring.js (ready).
 */

// Jour de référence piloté par le test : l'éphéméride doit fonctionner à toute
// date de l'année, 29 février compris (incident v4.10.0 : to_date('02-29-2001')
// faisait tomber la route en 500 tous les jours).
let mockDay = '2024-02-29';
jest.mock('../../utils/day', () => ({
  todayInParis: () => mockDay,
  REFERENCE_TZ: 'Europe/Paris',
}));

const request = require('supertest');
const { describeIt, airplaneId, FIXTURE_FILES } = require('./helpers/it-db');
const { startItApp } = require('./helpers/it-app');

describeIt('Intégration SQL — contenus', () => {
  let ctx;

  beforeAll(async () => {
    ctx = await startItApp('content');
  }, 60000);

  afterAll(async () => {
    if (ctx) await ctx.stop();
  });

  const api = () => request(ctx.app);

  describe('GET /api/hero/discoveries — éphéméride', () => {
    test.each([
      ['2024-02-29', 'MiG 1.44', 0],   // premier vol le 29/02/2000, année bissextile
      ['2025-02-28', 'MiG 1.44', 1],   // année commune : l'écart compte un jour de plus
      ['2026-07-04', 'Rafale', 0],     // premier vol du Rafale A, 04/07/1986
      ['2026-01-02', null, null],      // passage d'année (fenêtre circulaire)
      ['2026-12-31', null, null],
    ])('jour %s', async (day, expectedName, expectedGap) => {
      mockDay = day;
      const res = await api().get('/api/hero/discoveries?force=1');
      expect(res.status).toBe(200);
      expect(res.body.day).toBe(day);
      expect(Array.isArray(res.body.ephemeris)).toBe(true);
      for (const e of res.body.ephemeris) {
        expect(e.day_gap).toBeLessThanOrEqual(3);
        // Jamais de date au 1er du mois (précision inventée)
        expect(e.event_date.slice(8, 10)).not.toBe('01');
        expect(['first_flight', 'service']).toContain(e.kind);
      }
      if (expectedName) {
        const hit = res.body.ephemeris.find((e) => e.airplane_name === expectedName);
        expect(hit).toEqual(expect.objectContaining({ day_gap: expectedGap, year: expect.any(Number) }));
      }
    });

    test('appareils du quiz et faits éditoriaux liés à une fiche', async () => {
      mockDay = '2026-11-10';
      const res = await api().get('/api/hero/discoveries?force=1');
      expect(res.status).toBe(200);
      expect(res.headers['x-cache']).toBe('MISS');
      expect(res.body.aircraft).toHaveLength(FIXTURE_FILES.length);
      const ids = res.body.aircraft.map((a) => a.id);
      expect(ids).toEqual([...ids].sort((a, b) => a - b));
      expect(res.body.facts.length).toBeGreaterThan(0);
      expect(res.body.facts.every((f) => typeof f.airplane_id === 'number')).toBe(true);

      const again = await api().get('/api/hero/discoveries');
      expect(again.headers['x-cache']).toBe('HIT');
    });
  });

  describe('GET /api/timeline', () => {
    test('décennies 1940 → 2020, événements et appareils rangés', async () => {
      const res = await api().get('/api/timeline?force=1');
      expect(res.status).toBe(200);
      expect(res.body.decades.map((d) => d.decade)).toEqual([1940, 1950, 1960, 1970, 1980, 1990, 2000, 2010, 2020]);
      const events = res.body.decades.flatMap((d) => d.events);
      expect(events.length).toBe(54);
      const rafaleEvent = events.find((e) => e.airplane && e.airplane.name === 'Rafale');
      expect(rafaleEvent).toBeDefined();
      const aircraft = res.body.decades.flatMap((d) => d.aircraft);
      const rafale = aircraft.find((a) => a.name === 'Rafale');
      expect(rafale.type_name).toBe('Multirôle');
      const in2000 = res.body.decades.find((d) => d.decade === 2000).aircraft.map((a) => a.name);
      expect(in2000).toContain('Rafale');
    });
  });

  describe('GET /api/wars', () => {
    test('liste : seulement les conflits rattachés, avec slug et compte', async () => {
      const res = await api().get('/api/wars');
      expect(res.status).toBe(200);
      expect(res.body.length).toBeGreaterThan(0);
      expect(res.body.every((w) => w.count > 0)).toBe(true);
      const syrie = res.body.find((w) => w.name_fr === 'Guerre civile syrienne');
      expect(syrie.slug).toBe('guerre-civile-syrienne');
    });

    test('page d\'un conflit : appareils triés par premier vol', async () => {
      const res = await api().get('/api/wars/guerre-civile-syrienne?lang=en');
      expect(res.status).toBe(200);
      expect(res.body.name).toBe('Syrian Civil War');
      expect(res.body.name_fr).toBe('Guerre civile syrienne');
      const names = res.body.airplanes.map((a) => a.name);
      expect(names).toContain('Rafale');
      expect(res.body.count).toBe(res.body.airplanes.length);
      const flights = res.body.airplanes.map((a) => new Date(a.date_first_fly).getTime());
      expect(flights).toEqual([...flights].sort((a, b) => a - b));
      expect(res.body.airplanes[0].type_name_fr).toEqual(expect.any(String));
    });

    test('conflit sans appareil → 404, slug mal formé → 400', async () => {
      const unknown = await api().get('/api/wars/guerre-de-cent-ans');
      const bad = await api().get('/api/wars/Pas_Un_Slug');
      expect([unknown.status, bad.status]).toEqual([404, 400]);
    });
  });

  describe('GET /sitemap.xml', () => {
    test('pages fixes, conflits et fiches', async () => {
      require('../../utils/cache')._resetForTests();
      const res = await api().get('/sitemap.xml');
      expect(res.status).toBe(200);
      expect(res.headers['x-cache']).toBe('MISS');
      const rafaleId = await airplaneId(ctx.pool, 'Rafale');
      expect(res.text).toContain(`/details/rafale-${rafaleId}`);
      expect(res.text).toContain('/conflits/guerre-civile-syrienne');
      expect((res.text.match(/<url>/g) || []).length).toBeGreaterThan(FIXTURE_FILES.length + 8);
    });
  });

  describe('GET /api/stats', () => {
    test('compteurs réels', async () => {
      ctx.app.invalidateStatsCache();
      const res = await api().get('/api/stats');
      expect(res.status).toBe(200);
      expect(res.body).toEqual({
        airplanes: FIXTURE_FILES.length,
        earliest_year: 1949,
        latest_year: 2000,
        countries: 3,
        generations: 5,
      });
    });
  });

  describe('GET /api/ready', () => {
    test('la base répond', async () => {
      const res = await api().get('/api/ready');
      expect(res.status).toBe(200);
      expect(res.body.db.ok).toBe(true);
    });
  });
});
