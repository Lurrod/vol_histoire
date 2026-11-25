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

    test('conflits datés avec slug et appareils ; le filtre decade du hangar retrouve le chapitre', async () => {
      const res = await api().get('/api/timeline?force=1');
      expect(res.body.wars.length).toBeGreaterThan(0);
      res.body.wars.forEach((w) => {
        expect(w.slug).toMatch(/^[a-z0-9-]+$/);
        expect(w.aircraft_ids.length).toBeGreaterThan(0);
        expect(w.era_decade).toBe(Math.floor(w.start_year / 10) * 10);
      });
      const all = res.body.decades.flatMap((d) => d.aircraft);
      all.forEach((a) => expect(['service', 'first_flight']).toContain(a.year_source));
      // Dates en texte : un DATE lu en objet Date se décalait d'un jour selon le fuseau.
      res.body.decades.flatMap((d) => d.events).forEach((e) => {
        if (e.event_date) expect(e.event_date).toMatch(/^\d{4}-\d{2}-\d{2}$/);
      });
      // Même règle (mise en service, à défaut premier vol) des deux côtés.
      for (const d of res.body.decades.filter((x) => x.aircraft.length > 0)) {
        const hangar = await api().get(`/api/airplanes?decade=${d.decade}&limit=1`);
        expect(hangar.status).toBe(200);
        expect(hangar.body.total).toBe(d.aircraft.length);
      }
    });

    test('conflits : dates clés en texte, triées, avec précision', async () => {
      const res = await api().get('/api/timeline?force=1');
      const withEvents = res.body.wars.filter((w) => w.events.length > 0);
      expect(withEvents.length).toBeGreaterThan(0);
      res.body.wars.forEach((w) => {
        expect(Array.isArray(w.events)).toBe(true);
        const dates = w.events.map((e) => e.date);
        expect([...dates].sort()).toEqual(dates);
        w.events.forEach((e) => {
          expect(e.date).toMatch(/^\d{4}-\d{2}-\d{2}$/);
          expect(['day', 'month', 'year']).toContain(e.precision);
          expect(e.title.length).toBeGreaterThan(0);
        });
      });
    });

    test('GET /timeline : chapitres rendus par le serveur', async () => {
      const res = await api().get('/timeline');
      expect(res.status).toBe(200);
      expect(res.text).toContain('tl-chapter--ssr');
      expect(res.text).toMatch(/href="\/details\/[a-z0-9-]+-\d+"/);
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

    test('page étoffée (zz_conflits.sql) : camps, dates clés en texte, rôles, sources', async () => {
      const res = await api().get('/api/wars/guerre-du-kippour');
      expect(res.status).toBe(200);
      expect(res.body.context).toEqual(expect.any(String));
      expect(res.body.narrative).toEqual(expect.any(String));
      expect(res.body.outcome).toEqual(expect.any(String));
      expect(res.body.sources.length).toBeGreaterThan(0);
      expect(res.body.sides.map((s) => s.key)).toEqual(['israel', 'coalition-arabe', 'soutiens']);
      // Dates en AAAA-MM-JJ, sans décalage de fuseau, dans l'ordre
      const dates = res.body.events.map((e) => e.date);
      expect(dates[0]).toBe('1973-10-06');
      expect(dates).toEqual([...dates].sort());
      expect(res.body.events.every((e) => /^\d{4}-\d{2}-\d{2}$/.test(e.date))).toBe(true);
      const mig21 = res.body.airplanes.find((a) => a.name === 'MiG-21');
      expect(mig21).toEqual(expect.objectContaining({ side_key: 'coalition-arabe', role: expect.any(String) }));
      expect(mig21.role_sources.length).toBeGreaterThan(0);
      const arab = res.body.sides.find((s) => s.key === 'coalition-arabe');
      expect(arab.count).toBe(res.body.airplanes.filter((a) => a.side_key === 'coalition-arabe').length);
      // Anglais : textes traduits
      const en = await api().get('/api/wars/guerre-du-kippour?lang=en');
      expect(en.body.sides[0].name).toBe('Israel');
      expect(en.body.airplanes.find((a) => a.name === 'MiG-21').role).not.toBe(mig21.role);
    });

    test('zz_conflits.sql rejoué : aucune écriture', async () => {
      const fs = require('fs');
      const path = require('path');
      const sql = fs.readFileSync(path.join(__dirname, '../../db_backup/zz_conflits.sql'), 'utf8');
      const results = await ctx.pool.query(sql);
      const writes = (Array.isArray(results) ? results : [results])
        .filter((r) => ['UPDATE', 'INSERT', 'DELETE'].includes(r.command))
        .reduce((n, r) => n + r.rowCount, 0);
      expect(writes).toBe(0);
    });

    test('conflit sans appareil → 404, slug mal formé → 400', async () => {
      const unknown = await api().get('/api/wars/guerre-de-cent-ans');
      const bad = await api().get('/api/wars/Pas_Un_Slug');
      expect([unknown.status, bad.status]).toEqual([404, 400]);
    });
  });

  describe('GET /api/airplanes/:id/related — rôle dans les conflits', () => {
    test('le F-15 porte son rôle et son camp dans la guerre du Golfe', async () => {
      const { rows } = await ctx.pool.query("SELECT id FROM airplanes WHERE name = 'F-15 Eagle'");
      const id = rows[0].id;
      const fr = await api().get(`/api/airplanes/${id}/related`);
      const war = fr.body.wars.find((w) => w.slug === 'guerre-du-golfe');
      expect(war.role).toMatch(/Arabie saoudite/);
      expect(war.side_name).toBe('Coalition');
      const en = await api().get(`/api/airplanes/${id}/related?lang=en`);
      const warEn = en.body.wars.find((w) => w.slug === 'guerre-du-golfe');
      expect(warEn.role).toMatch(/Saudi Arabia/);
      expect(warEn).not.toHaveProperty('role_en');
    });

    test('toute liaison appareil-conflit porte un rôle', async () => {
      const { rows } = await ctx.pool.query('SELECT count(*)::int AS n FROM airplane_wars WHERE role IS NULL');
      expect(rows[0].n).toBe(0);
    });
  });

  describe('GET /details/<slug> — faits du héros rendus par le serveur (PERF-004)', () => {
    test('fil d’Ariane, pays, constructeur, chiffres clés et statut écrits dans le HTML', async () => {
      const id = await airplaneId(ctx.pool, 'Rafale');
      const res = await api().get(`/details/rafale-${id}`);
      expect(res.status).toBe(200);
      expect(res.text).toMatch(/<span id="breadcrumb-name">Rafale<\/span>/);
      expect(res.text).not.toContain('<span id="hero-country">-</span>');
      expect(res.text).not.toContain('<span id="hero-manufacturer">-</span>');
      expect(res.text).toMatch(/<div class="stat-value" id="stat-speed">[\d\s\u202f\u00a0]+ km\/h<\/div>/);
      expect(res.text).not.toContain('<div class="stat-value" id="stat-status">-</div>');
    });
  });

  describe('GET /details/<slug> — récit et appareils liés écrits par le serveur (SEO-001)', () => {
    test('récit de la fiche dans le HTML ; rival lu par la jointure, en lien canonique', async () => {
      const id = await airplaneId(ctx.pool, 'Rafale');
      const rival = await airplaneId(ctx.pool, 'Mirage 2000');
      const { rows: [before] } = await ctx.pool.query('SELECT rival_id FROM airplanes WHERE id = $1', [id]);
      await ctx.pool.query('UPDATE airplanes SET rival_id = $2 WHERE id = $1', [id, rival]);
      try {
        const res = await api().get(`/details/rafale-${id}`);
        expect(res.status).toBe(200);
        expect(res.text).not.toContain('Chargement de la description...');
        expect(res.text).toMatch(/<div id="aircraft-description" class="description-body[^"]*"><(h3|p)/);
        expect(res.text).toContain(`href="/details/mirage-2000-${rival}"`);
        expect(res.text).toContain('<section class="content-section related-section" id="related-aircraft-section">');
      } finally {
        await ctx.pool.query('UPDATE airplanes SET rival_id = $2 WHERE id = $1', [id, before.rival_id]);
      }
    });
  });

  describe('GET /conflits — liens explorables écrits par le serveur (SEO-005)', () => {
    test('liste : un lien par conflit engagé ; page de conflit : liens vers les appareils engagés', async () => {
      const list = await api().get('/conflits');
      expect(list.status).toBe(200);
      const warLinks = new Set(list.text.match(/href="\/conflits\/[a-z0-9-]+"/g) || []);
      const { rows: [{ n }] } = await ctx.pool.query('SELECT count(DISTINCT id_wars)::int AS n FROM airplane_wars');
      expect(warLinks.size).toBe(n);

      const { rows: [war] } = await ctx.pool.query(`
        SELECT w.name, count(*)::int AS roles FROM wars w JOIN airplane_wars aw ON aw.id_wars = w.id
        WHERE aw.role IS NOT NULL GROUP BY w.id ORDER BY roles DESC LIMIT 1`);
      const { slugify } = require('../../utils/url');
      const page = await api().get(`/conflits/${slugify(war.name)}`);
      expect(page.status).toBe(200);
      const planeLinks = new Set((page.text.match(/<h4 class="role-name"><a href="\/details\/[^"]+">/g) || []));
      expect(planeLinks.size).toBe(war.roles);
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
      const wars = (await ctx.pool.query('SELECT COUNT(*)::int AS n FROM wars')).rows[0].n;
      expect(wars).toBeGreaterThan(0);
      expect(res.body).toEqual({
        airplanes: FIXTURE_FILES.length,
        earliest_year: 1949,
        latest_year: 2000,
        countries: 3,
        generations: 5,
        wars,
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
