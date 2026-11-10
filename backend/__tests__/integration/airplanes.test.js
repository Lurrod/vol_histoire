'use strict';

/**
 * Intégration SQL — catalogue (routes/airplanes.js, routes/facets.js).
 * Exécute réellement chaque requête contre PostgreSQL (voir helpers/it-db.js).
 */

const request = require('supertest');
const { describeIt, airplaneId, FIXTURE_FILES } = require('./helpers/it-db');
const { startItApp } = require('./helpers/it-app');

describeIt('Intégration SQL — catalogue', () => {
  let ctx;
  let editorToken;
  let memberToken;
  let rafaleId;

  beforeAll(async () => {
    ctx = await startItApp('airplanes');
    editorToken = await ctx.login('editor@it.local');
    memberToken = await ctx.login('member@it.local');
    rafaleId = await airplaneId(ctx.pool, 'Rafale');
  }, 60000);

  afterAll(async () => {
    if (ctx) await ctx.stop();
  });

  const api = () => request(ctx.app);
  const names = (rows) => rows.map((r) => r.name);

  describe('jeu de données', () => {
    test('chaque fiche entre en base avec ses clés étrangères', async () => {
      const { rows } = await ctx.pool.query(
        'SELECT name FROM airplanes WHERE id_manufacturer IS NULL OR country_id IS NULL OR type IS NULL'
      );
      expect(rows).toEqual([]);
      const count = await ctx.pool.query('SELECT COUNT(*)::int AS n FROM airplanes');
      expect(count.rows[0].n).toBe(FIXTURE_FILES.length);
    });
  });

  describe('GET /api/airplanes', () => {
    test('liste paginée par défaut, total réel', async () => {
      const res = await api().get('/api/airplanes?limit=5');
      expect(res.status).toBe(200);
      expect(res.body.total).toBe(FIXTURE_FILES.length);
      expect(res.body.data).toHaveLength(5);
      expect(res.body.page).toBe(1);
      expect(res.body.data[0]).toEqual(expect.objectContaining({
        id: expect.any(Number), name: expect.any(String), country_code: expect.any(String),
        type_name_fr: expect.any(String), country_name_fr: expect.any(String),
      }));
    });

    test('page 3 de 5 : les derniers éléments', async () => {
      const res = await api().get('/api/airplanes?limit=5&page=3');
      expect(res.status).toBe(200);
      expect(res.body.data).toHaveLength(FIXTURE_FILES.length - 10);
    });

    test.each([
      ['nation'], ['service-date'], ['alphabetical'], ['generation'], ['type'], ['default'],
      // Clé héritée du prototype : ne doit pas remonter jusque dans l'ORDER BY.
      ['constructor'], ['toString'],
    ])('tri %s accepté par PostgreSQL', async (sort) => {
      const res = await api().get(`/api/airplanes?sort=${sort}`);
      expect(res.status).toBe(200);
      expect(res.body.data).toHaveLength(FIXTURE_FILES.length);
    });

    test('tri alphabétique réellement ordonné', async () => {
      const res = await api().get('/api/airplanes?sort=alphabetical');
      // Ordre de la collation de la base (pas celui de JS) : on compare au tri SQL.
      const { rows } = await ctx.pool.query('SELECT name FROM airplanes ORDER BY name ASC');
      expect(names(res.body.data)).toEqual(names(rows));
    });

    test('filtres pays + génération + type combinés', async () => {
      const res = await api().get('/api/airplanes')
        .query({ country: 'France', generation: '4', type: 'Multirôle' });
      expect(res.status).toBe(200);
      expect(names(res.body.data).sort()).toEqual(['Mirage 2000', 'Rafale']);
      expect(res.body.total).toBe(2);
    });

    test('filtre conflit (EXISTS sur airplane_wars)', async () => {
      const res = await api().get('/api/airplanes').query({ war: 'Guerre civile syrienne' });
      expect(res.status).toBe(200);
      expect(names(res.body.data)).toContain('Rafale');
      expect(res.body.total).toBe(res.body.data.length);
    });

    test('filtre mission (EXISTS sur airplane_missions)', async () => {
      const res = await api().get('/api/airplanes').query({ mission: 'Supériorité aérienne' });
      expect(res.status).toBe(200);
      expect(names(res.body.data)).toContain('Rafale');
    });

    test('400 sur une valeur hors référentiel (whitelist chargée en base)', async () => {
      const war = await api().get('/api/airplanes').query({ war: 'Guerre imaginaire' });
      const type = await api().get('/api/airplanes').query({ type: 'Hélicoptère' });
      const gen = await api().get('/api/airplanes').query({ generation: '9' });
      expect([war.status, type.status, gen.status]).toEqual([400, 400, 400]);
    });

    test('recherche plein texte exacte', async () => {
      const res = await api().get('/api/airplanes').query({ search: 'rafale' });
      expect(res.status).toBe(200);
      expect(res.body.data[0].name).toBe('Rafale');
    });

    test('recherche par début de mot (préfixe to_tsquery)', async () => {
      const res = await api().get('/api/airplanes').query({ search: 'mira' });
      expect(res.status).toBe(200);
      const list = names(res.body.data);
      expect(list).toEqual(expect.arrayContaining(['Mirage III', 'Mirage F1', 'Mirage 2000']));
    });

    test('recherche websearch avec exclusion : pas de préfixe', async () => {
      const res = await api().get('/api/airplanes').query({ search: 'mirage -2000' });
      expect(res.status).toBe(200);
      expect(names(res.body.data)).not.toContain('Mirage 2000');
    });

    test('recherche avec ponctuation (F-16) sans erreur SQL', async () => {
      const res = await api().get('/api/airplanes').query({ search: 'F-16' });
      expect(res.status).toBe(200);
      expect(names(res.body.data)).toContain('F-16 Fighting Falcon');
    });

    test('?lang=en traduit les champs, garde les clés FR canoniques', async () => {
      const res = await api().get('/api/airplanes?lang=en').query({ country: 'France', type: 'Multirôle' });
      expect(res.status).toBe(200);
      const rafale = res.body.data.find((a) => a.id === rafaleId);
      expect(rafale.type_name).toBe('Multirole');
      expect(rafale.type_name_fr).toBe('Multirôle');
      expect(rafale.country_name_fr).toBe('France');
    });
  });

  describe('fiche et relations', () => {
    test('GET /api/airplanes/:id — jointures constructeur, génération, filiation', async () => {
      const res = await api().get(`/api/airplanes/${rafaleId}`);
      expect(res.status).toBe(200);
      expect(res.body.name).toBe('Rafale');
      expect(res.body.manufacturer_name).toMatch(/Dassault/);
      expect(res.body.generation).toBe(4);
      expect(res.body.predecessor_name).toBe('Mirage 2000');
      expect(res.body.successor_name).toBeNull();
    });

    test('GET /api/airplanes/:id — 404 sur un id absent', async () => {
      const res = await api().get('/api/airplanes/999999');
      expect(res.status).toBe(404);
    });

    test('armement, technologies, missions et conflits', async () => {
      const [arm, tech, mis, wars] = await Promise.all([
        api().get(`/api/airplanes/${rafaleId}/armament`),
        api().get(`/api/airplanes/${rafaleId}/tech`),
        api().get(`/api/airplanes/${rafaleId}/missions`),
        api().get(`/api/airplanes/${rafaleId}/wars`),
      ]);
      expect(names(arm.body)).toContain('Meteor');
      expect(names(tech.body)).toContain('Radar RBE2 AESA');
      expect(names(mis.body)).toContain('Supériorité aérienne');
      expect(names(wars.body)).toContain('Guerre civile syrienne');
    });

    test('GET /api/airplanes/:id/related — clés de lien (name_fr, slug)', async () => {
      const res = await api().get(`/api/airplanes/${rafaleId}/related`);
      expect(res.status).toBe(200);
      expect(res.body.armament.length).toBeGreaterThan(0);
      expect(res.body.tech.length).toBeGreaterThan(0);
      const syrie = res.body.wars.find((w) => w.name_fr === 'Guerre civile syrienne');
      expect(syrie.slug).toBe('guerre-civile-syrienne');
      expect(res.body.missions.every((m) => typeof m.name_fr === 'string')).toBe(true);
      // Conflits triés par date de début
      const starts = res.body.wars.map((w) => new Date(w.date_start).getTime());
      expect(starts).toEqual([...starts].sort((a, b) => a - b));
    });

    test('GET /api/airplanes/:id/lineage — lignée Dassault complète (CTE récursives)', async () => {
      const res = await api().get(`/api/airplanes/${rafaleId}/lineage`);
      expect(res.status).toBe(200);
      expect(names(res.body.chain)).toEqual([
        'Ouragan', 'Mystère IV', 'Super Mystère B2', 'Mirage III', 'Mirage F1', 'Mirage 2000', 'Rafale',
      ]);
      expect(res.body.chain.map((c) => c.depth)).toEqual([-6, -5, -4, -3, -2, -1, 0]);
      expect(res.body.chain[0].year).toEqual(expect.any(Number));
      expect(res.body.chain[0].country_code).toBe('FRA');
      expect(res.body.truncated).toBe(false);
    });

    test('lineage depuis le milieu de la chaîne : ancêtres et descendants', async () => {
      const id = await airplaneId(ctx.pool, 'Mirage III');
      const res = await api().get(`/api/airplanes/${id}/lineage`);
      expect(res.body.chain.map((c) => [c.name, c.depth])).toEqual([
        ['Ouragan', -3], ['Mystère IV', -2], ['Super Mystère B2', -1], ['Mirage III', 0],
        ['Mirage F1', 1], ['Mirage 2000', 2], ['Rafale', 3],
      ]);
    });

    test('lineage : un cycle A → B → A ne boucle pas', async () => {
      const a = await airplaneId(ctx.pool, 'MiG-29');
      const b = await airplaneId(ctx.pool, 'Su-27');
      const client = await ctx.pool.connect();
      try {
        await client.query('BEGIN');
        await client.query('UPDATE airplanes SET successor_id = $2, predecessor_id = $2 WHERE id = $1', [a, b]);
        await client.query('UPDATE airplanes SET successor_id = $2, predecessor_id = $2 WHERE id = $1', [b, a]);
        const repo = require('../../repositories/airplanes');
        const rows = await repo.findLineage(client, a, 6);
        expect(rows.map((r) => r.id).sort()).toEqual([a, b].sort());
      } finally {
        await client.query('ROLLBACK');
        client.release();
      }
    });

    test('lineage — 404 sur un id absent', async () => {
      const res = await api().get('/api/airplanes/999999/lineage');
      expect(res.status).toBe(404);
    });

    test('GET /api/airplanes/:id/favorite — requête réelle sur favorites', async () => {
      const res = await api().get(`/api/airplanes/${rafaleId}/favorite`)
        .set('Authorization', `Bearer ${memberToken}`);
      expect(res.status).toBe(200);
      expect(res.body).toEqual({ isFavorite: false });
    });
  });

  describe('référentiels', () => {
    test('GET /api/countries — seulement les nations ayant des fiches', async () => {
      const res = await api().get('/api/countries');
      expect(res.status).toBe(200);
      expect(names(res.body).sort()).toEqual(['États-Unis', 'France', 'Russie'].sort());
    });

    test('GET /api/nations — compte par nation', async () => {
      const res = await api().get('/api/nations');
      expect(res.status).toBe(200);
      const fra = res.body.find((n) => n.code === 'FRA');
      expect(fra).toEqual(expect.objectContaining({ name_fr: 'France', count: 7 }));
      expect(res.body[0].count).toBeGreaterThanOrEqual(res.body[res.body.length - 1].count);
    });

    test('GET /api/generations, /types, /manufacturers', async () => {
      const [gen, types, man] = await Promise.all([
        api().get('/api/generations'),
        api().get('/api/types'),
        api().get('/api/manufacturers'),
      ]);
      expect(gen.body).toEqual([...gen.body].sort((a, b) => a - b));
      expect(gen.body).toEqual(expect.arrayContaining([1, 2, 3, 4, 5]));
      expect(names(types.body)).toContain('Multirôle');
      expect(man.body.find((m) => m.code === 'DAS')).toEqual(expect.objectContaining({ country_name: 'France' }));
    });

    test('GET /api/referentials — six requêtes en un aller-retour', async () => {
      const res = await api().get('/api/referentials');
      expect(res.status).toBe(200);
      expect(Object.keys(res.body).sort()).toEqual(
        ['countries', 'generations', 'manufacturers', 'missions', 'types', 'wars']
      );
      expect(res.body.wars.find((w) => w.name_fr === 'Guerre civile syrienne').slug).toBe('guerre-civile-syrienne');
      expect(res.body.missions.length).toBeGreaterThan(0);
    });
  });

  describe('GET /api/airplanes/facets', () => {
    test('compteurs par groupe, sans filtre', async () => {
      const res = await api().get('/api/airplanes/facets');
      expect(res.status).toBe(200);
      expect(res.body.countries.France).toBe(7);
      expect(res.body.generations['4']).toBeGreaterThan(0);
      expect(res.body.types['Multirôle']).toBeGreaterThan(0);
      expect(res.body.wars['Guerre civile syrienne']).toBeGreaterThan(0);
      expect(Object.keys(res.body.missions).length).toBeGreaterThan(0);
    });

    test('chaque groupe ignore son propre filtre et applique les autres', async () => {
      const res = await api().get('/api/airplanes/facets').query({
        country: 'France', generation: '4', type: 'Multirôle',
        war: 'Guerre civile syrienne', mission: 'Supériorité aérienne',
      });
      expect(res.status).toBe(200);
      // Le groupe « pays » ignore le filtre pays : d'autres nations peuvent apparaître.
      expect(res.body.countries.France).toBeGreaterThan(0);
      expect(res.body.wars['Guerre civile syrienne']).toBeGreaterThan(0);
    });
  });

  describe('écriture (POST / PUT / DELETE)', () => {
    const payload = (extra = {}) => ({
      name: 'Appareil IT', complete_name: 'Appareil d\'intégration', little_description: 'Fiche de test',
      country_id: null, date_first_fly: '1990-05-17', date_operationel: '1995-06-20',
      max_speed: 1800, length: 15.2, wingspan: 10.1, empty_weight: 9000, mtow: 18000,
      engine_count: 2, crew: 1, production_start: 1994, production_end: 2001,
      stealth_level: 'reduite', variants: 'A, B', variants_en: 'A, B', engine_type_en: 'Turbofan',
      image_credit: 'IT', image_licence: 'CC0',
      ...extra,
    });

    test('cycle complet : création, lecture, modification, suppression', async () => {
      const country = await ctx.pool.query("SELECT id FROM countries WHERE code = 'FRA'");
      const created = await api().post('/api/airplanes')
        .set('Authorization', `Bearer ${editorToken}`)
        .send(payload({ country_id: country.rows[0].id, predecessor_id: rafaleId }));
      expect(created.status).toBe(201);
      expect(created.body.name).toBe('Appareil IT');
      expect(created.body.engine_type_en).toBe('Turbofan');
      const id = created.body.id;

      // search_vector est GENERATED : la fiche est trouvable dès l'INSERT.
      const found = await api().get('/api/airplanes').query({ search: 'intégration' });
      expect(found.body.data.map((a) => a.id)).toContain(id);

      const updated = await api().put(`/api/airplanes/${id}`)
        .set('Authorization', `Bearer ${editorToken}`)
        .send(payload({ name: '  Appareil IT modifié  ', max_speed: 2000 }));
      expect(updated.status).toBe(200);
      expect(updated.body.name).toBe('Appareil IT modifié');
      expect(Number(updated.body.max_speed)).toBe(2000);
      // Champ absent du corps (predecessor_id n'est pas dans payload()) : conservé.
      expect(updated.body.predecessor_id).toBe(rafaleId);

      const removed = await api().delete(`/api/airplanes/${id}`)
        .set('Authorization', `Bearer ${editorToken}`);
      expect(removed.status).toBe(200);
      expect(removed.body.message).toContain('Appareil IT modifié');
      const gone = await api().get(`/api/airplanes/${id}`);
      expect(gone.status).toBe(404);
    });

    test('PUT partiel : les champs absents sont conservés, les champs à null effacés', async () => {
      const created = await api().post('/api/airplanes')
        .set('Authorization', `Bearer ${editorToken}`)
        .send(payload({ name: 'Appareil partiel', predecessor_id: rafaleId }));
      expect(created.status).toBe(201);
      const id = created.body.id;

      // Ce qu'envoie le formulaire de la fiche : ni engine_type_en ni variants_en.
      const partial = await api().put(`/api/airplanes/${id}`)
        .set('Authorization', `Bearer ${editorToken}`)
        .send({ name: 'Appareil partiel', max_speed: 1500 });
      expect(partial.status).toBe(200);
      const row = (await ctx.pool.query('SELECT * FROM airplanes WHERE id = $1', [id])).rows[0];
      expect(Number(row.max_speed)).toBe(1500);
      expect(row.engine_type_en).toBe('Turbofan');
      expect(row.variants_en).toBe('A, B');
      expect(row.predecessor_id).toBe(rafaleId);
      expect(Number(row.mtow)).toBe(18000);

      const cleared = await api().put(`/api/airplanes/${id}`)
        .set('Authorization', `Bearer ${editorToken}`)
        .send({ name: 'Appareil partiel', engine_type_en: null, variants_en: '', predecessor_id: '' });
      expect(cleared.status).toBe(200);
      expect(cleared.body.engine_type_en).toBeNull();
      expect(cleared.body.variants_en).toBeNull();
      expect(cleared.body.predecessor_id).toBeNull();
      expect(Number(cleared.body.max_speed)).toBe(1500);

      await api().delete(`/api/airplanes/${id}`).set('Authorization', `Bearer ${editorToken}`);
    });

    test('POST — clé étrangère inconnue refusée par la vérification groupée', async () => {
      const res = await api().post('/api/airplanes')
        .set('Authorization', `Bearer ${editorToken}`)
        .send(payload({ country_id: 999999, id_manufacturer: 999999, id_generation: 999999, type: 999999 }));
      expect(res.status).toBe(400);
      expect(res.body.errors).toEqual([
        'country_id invalide', 'id_manufacturer invalide', 'id_generation invalide', 'type invalide',
      ]);
    });

    test('POST — contrainte CHECK de la base (mtow < empty_weight) → 500 sans insertion', async () => {
      const quiet = jest.spyOn(console, 'error').mockImplementation(() => {});
      const res = await api().post('/api/airplanes')
        .set('Authorization', `Bearer ${editorToken}`)
        .send(payload({ name: 'Appareil CHECK', empty_weight: 20000, mtow: 10000 }));
      expect(res.status).toBe(500);
      const { rows } = await ctx.pool.query("SELECT 1 FROM airplanes WHERE name = 'Appareil CHECK'");
      expect(rows).toHaveLength(0);
      expect(quiet).toHaveBeenCalledWith(expect.stringContaining('chk_airplanes_masses'));
      quiet.mockRestore();
    });

    test('PUT / DELETE — 404 sur un id absent', async () => {
      const put = await api().put('/api/airplanes/999999')
        .set('Authorization', `Bearer ${editorToken}`).send(payload());
      const del = await api().delete('/api/airplanes/999999')
        .set('Authorization', `Bearer ${editorToken}`);
      expect([put.status, del.status]).toEqual([404, 404]);
    });
  });
});
