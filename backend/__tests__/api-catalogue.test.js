/**
 * Tests d'intégration — Catalogue : appareils, facettes, relations, référentiels, favoris,
 * statistiques, frise, découvertes, conflits.
 * Base de données simulée : banc commun __tests__/helpers/api-harness.js
 * (découpé de l'ancien api.test.js — ARCH-004).
 */
jest.mock('../mailer', () => require('./helpers/mailer-mock')());
const h = require('./helpers/api-harness');

const {
  request, app, mockPool, tokenAdmin, tokenEditor, tokenMember,
} = h;

h.installHooks();


// =============================================================================
// AVIONS — GET /api/airplanes
// =============================================================================
describe('GET /api/airplanes', () => {
  const mockPlanes = [
    { id: 1, name: 'F-22', country_name: 'USA', generation: 5 },
    { id: 2, name: 'Rafale', country_name: 'France', generation: 4 },
  ];

  test('200 — retourne la liste des avions', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [{ count: '2' }] })
      .mockResolvedValueOnce({ rows: mockPlanes });

    const res = await request(app).get('/api/airplanes');
    expect(res.status).toBe(200);
    expect(res.body.data).toHaveLength(2);
    expect(res.body.total).toBe(2);
  });

  test('200 — filtre par pays', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [{ count: '1' }] })
      .mockResolvedValueOnce({ rows: [mockPlanes[0]] });

    const res = await request(app).get('/api/airplanes?country=USA');
    expect(res.status).toBe(200);
  });

  test('200 — filtre par génération (castée en nombre)', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [{ generation: 4 }, { generation: 5 }] }) // whitelist gens
      .mockResolvedValueOnce({ rows: [{ name: 'Chasseur' }] })                  // whitelist types
      .mockResolvedValueOnce({ rows: [] })                                       // whitelist wars
      .mockResolvedValueOnce({ rows: [] })                                       // whitelist missions
      .mockResolvedValueOnce({ rows: [{ count: '1' }] })
      .mockResolvedValueOnce({ rows: [mockPlanes[0]] });

    const res = await request(app).get('/api/airplanes?generation=5');
    expect(res.status).toBe(200);
  });

  test('400 — generation hors whitelist (99)', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [{ generation: 4 }, { generation: 5 }] })
      .mockResolvedValueOnce({ rows: [{ name: 'Chasseur' }] })
      .mockResolvedValueOnce({ rows: [] })                                       // whitelist wars
      .mockResolvedValueOnce({ rows: [] })                                       // whitelist missions;

    const res = await request(app).get('/api/airplanes?generation=99');
    expect(res.status).toBe(400);
    expect(res.body.message).toMatch(/generation invalide/);
  });

  test('400 — type hors whitelist', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [{ generation: 5 }] })
      .mockResolvedValueOnce({ rows: [{ name: 'Chasseur' }] })
      .mockResolvedValueOnce({ rows: [] })                                       // whitelist wars
      .mockResolvedValueOnce({ rows: [] })                                       // whitelist missions;

    const res = await request(app).get('/api/airplanes?type=NotAType');
    expect(res.status).toBe(400);
    expect(res.body.message).toMatch(/type invalide/);
  });

  test('200 — type valide passe la whitelist', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [{ generation: 5 }] })
      .mockResolvedValueOnce({ rows: [{ name: 'Chasseur' }, { name: 'Bombardier' }] })
      .mockResolvedValueOnce({ rows: [] })                                       // whitelist wars
      .mockResolvedValueOnce({ rows: [] })                                       // whitelist missions
      .mockResolvedValueOnce({ rows: [{ count: '0' }] })
      .mockResolvedValueOnce({ rows: [] });

    const res = await request(app).get('/api/airplanes?type=Chasseur');
    expect(res.status).toBe(200);
  });

  test('400 — generation invalide (texte)', async () => {
    const res = await request(app).get('/api/airplanes?generation=abc');
    expect(res.status).toBe(400);
    expect(res.body.message).toMatch(/generation invalide/);
  });

  test('400 — generation invalide (0)', async () => {
    const res = await request(app).get('/api/airplanes?generation=0');
    expect(res.status).toBe(400);
  });

  test('400 — generation invalide (négatif)', async () => {
    const res = await request(app).get('/api/airplanes?generation=-1');
    expect(res.status).toBe(400);
  });

  test('200 — filtres combinés country + generation (AND)', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [{ generation: 5 }] }) // whitelist gens
      .mockResolvedValueOnce({ rows: [{ name: 'Chasseur' }] }) // whitelist types
      .mockResolvedValueOnce({ rows: [] })                                       // whitelist wars
      .mockResolvedValueOnce({ rows: [] })                                       // whitelist missions
      .mockResolvedValueOnce({ rows: [{ count: '1' }] })
      .mockResolvedValueOnce({ rows: [mockPlanes[0]] });

    const res = await request(app).get('/api/airplanes?country=USA&generation=5');
    expect(res.status).toBe(200);
    // Le COUNT est le 5e call (après les 4 requêtes de whitelist)
    const countCall = mockPool.query.mock.calls[4];
    expect(countCall[0]).toContain('c.name = $1');
    expect(countCall[0]).toContain('g.generation = $2');
    expect(countCall[0]).toContain('AND');
    expect(countCall[1]).toEqual(expect.arrayContaining(['USA', 5]));
  });

  test('200 — tri alphabétique', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [{ count: '2' }] })
      .mockResolvedValueOnce({ rows: mockPlanes });

    const res = await request(app).get('/api/airplanes?sort=alphabetical');
    expect(res.status).toBe(200);
  });

  test('200 — tri inconnu → fallback ORDER BY a.id ASC', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [{ count: '2' }] })
      .mockResolvedValueOnce({ rows: mockPlanes });

    const res = await request(app).get('/api/airplanes?sort=INVALID_SORT');
    expect(res.status).toBe(200);
  });

  test('500 — erreur base de données', async () => {
    mockPool.query.mockRejectedValueOnce(new Error('DB error'));

    const res = await request(app).get('/api/airplanes');
    expect(res.status).toBe(500);
  });

  test('200 — full-text search via ?search= utilise websearch_to_tsquery + ts_rank', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [{ count: '1' }] })
      .mockResolvedValueOnce({ rows: [mockPlanes[1]] }); // rafale

    const res = await request(app).get('/api/airplanes?search=rafale');
    expect(res.status).toBe(200);
    expect(res.body.data).toHaveLength(1);

    const mainCall = mockPool.query.mock.calls[1];
    expect(mainCall[0]).toContain("search_vector @@ (websearch_to_tsquery('simple', $1) || to_tsquery('simple', $2))");
    expect(mainCall[0]).toContain('ORDER BY ts_rank');
    expect(mainCall[1]).toEqual(expect.arrayContaining(['rafale', 'rafale:*']));
  });

  test('200 — search vide ignoré (aucune condition FTS)', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [{ count: '0' }] })
      .mockResolvedValueOnce({ rows: [] });

    const res = await request(app).get('/api/airplanes?search=');
    expect(res.status).toBe(200);
    const mainCall = mockPool.query.mock.calls[1];
    expect(mainCall[0]).not.toContain('search_vector');
  });

  test('200 — search combinable avec filtres (AND)', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [{ count: '1' }] })
      .mockResolvedValueOnce({ rows: [mockPlanes[0]] });

    const res = await request(app).get('/api/airplanes?country=USA&search=F-22');
    expect(res.status).toBe(200);

    const countCall = mockPool.query.mock.calls[0];
    expect(countCall[0]).toContain('c.name = $1');
    expect(countCall[0]).toContain('search_vector @@');
    expect(countCall[0]).toContain('AND');
    // queryParams est muté post-appel (push de limit/offset), donc on
    // vérifie seulement la présence des 2 premiers params de la recherche.
    expect(countCall[1][0]).toBe('USA');
    expect(countCall[1][1]).toBe('F-22');
  });

  test('200 — search trop long (>100 chars) ignoré', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [{ count: '0' }] })
      .mockResolvedValueOnce({ rows: [] });

    const res = await request(app).get('/api/airplanes?search=' + 'a'.repeat(101));
    expect(res.status).toBe(200);
    const mainCall = mockPool.query.mock.calls[1];
    expect(mainCall[0]).not.toContain('search_vector');
  });
});


// =============================================================================
// AVIONS — GET /api/airplanes/facets
// =============================================================================
describe('GET /api/airplanes/facets', () => {
  test('200 — retourne les trois groupes de facettes', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [{ k: 'France', n: 5 }, { k: 'USA', n: 8 }] })
      .mockResolvedValueOnce({ rows: [{ k: 4, n: 10 }, { k: 5, n: 3 }] })
      .mockResolvedValueOnce({ rows: [{ k: 'Chasseur', n: 9 }, { k: 'Bombardier', n: 4 }] })
      .mockResolvedValueOnce({ rows: [{ k: 'Guerre du Vietnam', n: 12 }] })
      .mockResolvedValueOnce({ rows: [{ k: 'Interception', n: 7 }] });

    const res = await request(app).get('/api/airplanes/facets');
    expect(res.status).toBe(200);
    expect(res.body).toHaveProperty('countries');
    expect(res.body).toHaveProperty('generations');
    expect(res.body).toHaveProperty('types');
    expect(res.body.countries).toEqual({ France: 5, USA: 8 });
    expect(res.body.generations).toEqual({ 4: 10, 5: 3 });
    expect(res.body.types).toEqual({ Chasseur: 9, Bombardier: 4 });
    expect(res.body.wars).toEqual({ 'Guerre du Vietnam': 12 });
    expect(res.body.missions).toEqual({ Interception: 7 });
  });

  test('200 — accepte les filtres country/generation/type en query', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [{ k: 'France', n: 2 }] })
      .mockResolvedValueOnce({ rows: [{ k: 4, n: 2 }] })
      .mockResolvedValueOnce({ rows: [{ k: 'Multirôle', n: 2 }] })
      .mockResolvedValueOnce({ rows: [] })
      .mockResolvedValueOnce({ rows: [] });

    const res = await request(app)
      .get('/api/airplanes/facets')
      .query({ country: 'France', generation: '4', type: 'Multirôle' });
    expect(res.status).toBe(200);
    // Chaque groupe exclut son propre filtre (pattern facet), donc 5 queries lancées
    expect(mockPool.query).toHaveBeenCalledTimes(5);
  });

  test('200 — ignore les clés nulles dans les réponses', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [{ k: null, n: 0 }, { k: 'France', n: 5 }] })
      .mockResolvedValueOnce({ rows: [] })
      .mockResolvedValueOnce({ rows: [] })
      .mockResolvedValueOnce({ rows: [] })
      .mockResolvedValueOnce({ rows: [] });

    const res = await request(app).get('/api/airplanes/facets');
    expect(res.status).toBe(200);
    expect(res.body.countries).toEqual({ France: 5 });
  });
});


// =============================================================================
// AVIONS — GET /api/airplanes/:id
// =============================================================================
describe('GET /api/airplanes/:id', () => {
  test('200 — retourne le détail d\'un avion', async () => {
    mockPool.query.mockResolvedValueOnce({
      rows: [{ id: 1, name: 'F-22 Raptor', manufacturer_name: 'Lockheed' }],
    });

    const res = await request(app).get('/api/airplanes/1');
    expect(res.status).toBe(200);
    expect(res.body.name).toBe('F-22 Raptor');
  });

  test('404 — avion inexistant', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [] });

    const res = await request(app).get('/api/airplanes/999');
    expect(res.status).toBe(404);
    expect(res.body.message).toBe('Avion non trouvé');
  });

  test('400 — ID non numérique', async () => {
    const res = await request(app).get('/api/airplanes/abc');
    expect(res.status).toBe(400);
  });
});


// =============================================================================
// AVIONS — POST /api/airplanes
// =============================================================================
describe('POST /api/airplanes', () => {
  const validAirplane = {
    name: 'Mirage 2000',
    complete_name: 'Dassault Mirage 2000',
    little_description: 'Chasseur français',
    image_url: 'https://example.com/mirage.jpg',
    description: null,
    country_id: 2,
    date_concept: '1972-01-01',
    date_first_fly: '1978-03-10',
    date_operationel: '1984-07-01',
    max_speed: 2336,
    max_range: 1850,
    id_manufacturer: 1,
    id_generation: 4,
    type: 1,
    status: 'en service',
    empty_weight: 7500,
  };

  const fkAllValid = { rows: [{ country_ok: true, manufacturer_ok: true, generation_ok: true, type_ok: true }] };

  test('201 — création réussie (admin)', async () => {
    mockPool.query
      .mockResolvedValueOnce(fkAllValid)
      .mockResolvedValueOnce({ rows: [{ id: 10, name: 'Mirage 2000' }] });

    const res = await request(app)
      .post('/api/airplanes')
      .set('Authorization', `Bearer ${tokenAdmin}`)
      .send(validAirplane);

    expect(res.status).toBe(201);
    expect(res.body.name).toBe('Mirage 2000');
  });

  test('201 — création réussie (éditeur)', async () => {
    mockPool.query
      .mockResolvedValueOnce(fkAllValid)
      .mockResolvedValueOnce({ rows: [{ id: 11, name: 'Mirage 2000' }] });

    const res = await request(app)
      .post('/api/airplanes')
      .set('Authorization', `Bearer ${tokenEditor}`)
      .send(validAirplane);

    expect(res.status).toBe(201);
  });

  test('400 — country_id inexistant', async () => {
    mockPool.query.mockResolvedValueOnce({
      rows: [{ country_ok: false, manufacturer_ok: true, generation_ok: true, type_ok: true }],
    });

    const res = await request(app)
      .post('/api/airplanes')
      .set('Authorization', `Bearer ${tokenAdmin}`)
      .send({ ...validAirplane, country_id: 9999 });

    expect(res.status).toBe(400);
    expect(res.body.errors).toContain('country_id invalide');
  });

  test('400 — plusieurs FK invalides', async () => {
    mockPool.query.mockResolvedValueOnce({
      rows: [{ country_ok: true, manufacturer_ok: false, generation_ok: false, type_ok: true }],
    });

    const res = await request(app)
      .post('/api/airplanes')
      .set('Authorization', `Bearer ${tokenAdmin}`)
      .send({ ...validAirplane, id_manufacturer: 9999, id_generation: 9999 });

    expect(res.status).toBe(400);
    expect(res.body.errors).toContain('id_manufacturer invalide');
    expect(res.body.errors).toContain('id_generation invalide');
  });

  test('403 — membre ne peut pas créer un avion', async () => {
    const res = await request(app)
      .post('/api/airplanes')
      .set('Authorization', `Bearer ${tokenMember}`)
      .send(validAirplane);
    expect(res.status).toBe(403);
  });

  test('400 — nom manquant', async () => {
    const res = await request(app)
      .post('/api/airplanes')
      .set('Authorization', `Bearer ${tokenAdmin}`)
      .send({ ...validAirplane, name: '' });

    expect(res.status).toBe(400);
    expect(res.body.errors).toBeDefined();
  });

  test('400 — URL image invalide', async () => {
    const res = await request(app)
      .post('/api/airplanes')
      .set('Authorization', `Bearer ${tokenAdmin}`)
      .send({ ...validAirplane, image_url: 'not-a-url' });

    expect(res.status).toBe(400);
  });

  test('403 — sans token', async () => {
    const res = await request(app).post('/api/airplanes').send(validAirplane);
    expect(res.status).toBe(403);
  });
});


// =============================================================================
// AVIONS — PUT /api/airplanes/:id
// =============================================================================
describe('PUT /api/airplanes/:id', () => {
  const updatedData = {
    name: 'F-16 Block 60',
    complete_name: 'F-16 Fighting Falcon Block 60',
    little_description: null,
    image_url: null,
    description: null,
    country_id: 1,
    date_concept: null,
    date_first_fly: null,
    date_operationel: null,
    max_speed: 2100,
    max_range: 4200,
    id_manufacturer: null,
    id_generation: null,
    type: null,
    status: null,
    empty_weight: null,
  };

  const fkAllValid = { rows: [{ country_ok: true, manufacturer_ok: true, generation_ok: true, type_ok: true }] };

  test('200 — mise à jour réussie', async () => {
    mockPool.query
      .mockResolvedValueOnce(fkAllValid)
      .mockResolvedValueOnce({ rows: [{ id: 5, name: 'F-16 Block 60' }] });

    const res = await request(app)
      .put('/api/airplanes/5')
      .set('Authorization', `Bearer ${tokenAdmin}`)
      .send(updatedData);

    expect(res.status).toBe(200);
  });

  test('404 — avion inexistant', async () => {
    mockPool.query
      .mockResolvedValueOnce(fkAllValid)
      .mockResolvedValueOnce({ rows: [] });

    const res = await request(app)
      .put('/api/airplanes/999')
      .set('Authorization', `Bearer ${tokenAdmin}`)
      .send(updatedData);

    expect(res.status).toBe(404);
  });

  test('400 — type inexistant', async () => {
    mockPool.query.mockResolvedValueOnce({
      rows: [{ country_ok: true, manufacturer_ok: true, generation_ok: true, type_ok: false }],
    });

    const res = await request(app)
      .put('/api/airplanes/5')
      .set('Authorization', `Bearer ${tokenAdmin}`)
      .send({ ...updatedData, type: 9999 });

    expect(res.status).toBe(400);
    expect(res.body.errors).toContain('type invalide');
  });

  test('403 — membre ne peut pas modifier un avion', async () => {
    const res = await request(app)
      .put('/api/airplanes/1')
      .set('Authorization', `Bearer ${tokenMember}`)
      .send(updatedData);
    expect(res.status).toBe(403);
  });

  // Perte de données silencieuse : le formulaire de la fiche n'envoie ni
  // engine_type_en ni variants_en, et l'UPDATE réécrivait toutes les colonnes —
  // chaque modification les remettait à NULL. Un champ ABSENT du corps n'est
  // plus touché ; un champ PRÉSENT à null ou '' est effacé.
  test('200 — un champ absent du corps n\'est pas modifié', async () => {
    mockPool.query
      .mockResolvedValueOnce(fkAllValid)
      .mockResolvedValueOnce({ rows: [{ id: 5, name: 'F-16 Block 60' }] });

    const res = await request(app)
      .put('/api/airplanes/5')
      .set('Authorization', `Bearer ${tokenAdmin}`)
      .send({ max_speed: 2100, name: '  F-16 Block 60  ' });

    expect(res.status).toBe(200);
    const [sql, params] = mockPool.query.mock.calls[1];
    expect(sql).toMatch(/^UPDATE airplanes SET/);
    expect(sql).toMatch(/\bname = \$1\b/);
    expect(sql).toMatch(/\bmax_speed = \$2\b/);
    expect(sql).not.toMatch(/engine_type_en|variants_en|predecessor_id|image_credit/);
    expect(sql).toMatch(/WHERE id = \$3 RETURNING \*/);
    expect(params).toEqual(['F-16 Block 60', 2100, '5']);
  });

  test('200 — un champ présent à null ou vide est effacé', async () => {
    mockPool.query
      .mockResolvedValueOnce(fkAllValid)
      .mockResolvedValueOnce({ rows: [{ id: 5, name: 'F-16' }] });

    const res = await request(app)
      .put('/api/airplanes/5')
      .set('Authorization', `Bearer ${tokenAdmin}`)
      .send({ name: 'F-16', variants_en: '', engine_type_en: null });

    expect(res.status).toBe(200);
    const [sql, params] = mockPool.query.mock.calls[1];
    expect(sql).toMatch(/\bengine_type_en = \$2\b/);
    expect(sql).toMatch(/\bvariants_en = \$3\b/);
    expect(params).toEqual(['F-16', null, null, '5']);
  });
});


// =============================================================================
// AVIONS — DELETE /api/airplanes/:id
// =============================================================================
describe('DELETE /api/airplanes/:id', () => {
  test('200 — suppression réussie', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [{ id: 3, name: 'Jaguar' }] });

    const res = await request(app)
      .delete('/api/airplanes/3')
      .set('Authorization', `Bearer ${tokenAdmin}`);

    expect(res.status).toBe(200);
    expect(res.body.message).toContain('Jaguar');
  });

  test('404 — avion inexistant', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [] });

    const res = await request(app)
      .delete('/api/airplanes/999')
      .set('Authorization', `Bearer ${tokenAdmin}`);
    expect(res.status).toBe(404);
  });

  test('403 — éditeur peut supprimer un avion', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [{ id: 1, name: 'F-22' }] });

    const res = await request(app)
      .delete('/api/airplanes/1')
      .set('Authorization', `Bearer ${tokenEditor}`);
    expect(res.status).toBe(200);
  });

  test('403 — membre ne peut pas supprimer', async () => {
    const res = await request(app)
      .delete('/api/airplanes/1')
      .set('Authorization', `Bearer ${tokenMember}`);
    expect(res.status).toBe(403);
  });
});


// =============================================================================
// AVIONS — Routes relations (armement, tech, missions, guerres)
// =============================================================================
describe('Relations avions', () => {
  test('GET /api/airplanes/:id/armament — 200', async () => {
    mockPool.query.mockResolvedValueOnce({
      rows: [{ name: 'AIM-120', description: 'Missile air-air' }],
    });
    const res = await request(app).get('/api/airplanes/1/armament');
    expect(res.status).toBe(200);
    expect(res.body[0].name).toBe('AIM-120');
  });

  test('GET /api/airplanes/:id/tech — 200', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [{ name: 'Stealth', description: 'Furtivité' }] });
    const res = await request(app).get('/api/airplanes/1/tech');
    expect(res.status).toBe(200);
  });

  test('GET /api/airplanes/:id/missions — 200', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [{ name: 'CAS', description: 'Appui aérien' }] });
    const res = await request(app).get('/api/airplanes/1/missions');
    expect(res.status).toBe(200);
  });

  test('GET /api/airplanes/:id/wars — 200', async () => {
    mockPool.query.mockResolvedValueOnce({
      rows: [{ name: 'Guerre du Golfe', date_start: '1990-08-02', date_end: '1991-02-28' }],
    });
    const res = await request(app).get('/api/airplanes/1/wars');
    expect(res.status).toBe(200);
    expect(res.body[0].name).toBe('Guerre du Golfe');
  });

  test('500 — erreur DB sur armament', async () => {
    mockPool.query.mockRejectedValueOnce(new Error('DB fail'));
    const res = await request(app).get('/api/airplanes/1/armament');
    expect(res.status).toBe(500);
  });

  test('GET /api/airplanes/:id/related — 200 (toutes les relations)', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [{ name: 'Missile MICA', description: 'IR/EM' }] }) // armement
      .mockResolvedValueOnce({ rows: [{ name: 'RBE2-AA', description: 'Radar AESA' }] }) // tech
      .mockResolvedValueOnce({ rows: [{ name: 'Supériorité aérienne', description: '' }] }) // missions
      .mockResolvedValueOnce({ rows: [{ name: 'Opération Serval', date_start: '2013', date_end: '2014', description: '' }] }); // wars

    const res = await request(app)
      .get('/api/airplanes/4/related')
      .set('Authorization', `Bearer ${tokenAdmin}`);

    expect(res.status).toBe(200);
    expect(res.body).toHaveProperty('armament');
    expect(res.body).toHaveProperty('tech');
    expect(res.body).toHaveProperty('missions');
    expect(res.body).toHaveProperty('wars');
    expect(res.body.armament[0].name).toBe('Missile MICA');
  });

  test('GET /api/airplanes/:id/lineage — 200 (chaîne ordonnée par profondeur)', async () => {
    mockPool.query.mockResolvedValueOnce({
      rows: [
        { id: 7, name: 'Mystère IV', name_en: null, image_url: '/a.jpg', depth: -1, country_code: 'FRA', year: 1955 },
        { id: 8, name: 'Mirage III', name_en: null, image_url: '/b.jpg', depth: 0, country_code: 'FRA', year: 1961 },
        { id: 9, name: 'Mirage F1', name_en: null, image_url: '/c.jpg', depth: 1, country_code: 'FRA', year: 1973 },
      ],
    });

    const res = await request(app).get('/api/airplanes/8/lineage');

    expect(res.status).toBe(200);
    expect(res.body.chain).toHaveLength(3);
    expect(res.body.chain.map((a) => a.depth)).toEqual([-1, 0, 1]);
    expect(res.body.chain[1].name).toBe('Mirage III');
    expect(res.body.truncated).toBe(false);
  });

  test('GET /api/airplanes/:id/lineage — 404 si l\'appareil n\'existe pas', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [] });
    const res = await request(app).get('/api/airplanes/9999/lineage');
    expect(res.status).toBe(404);
  });

  test('GET /api/airplanes/:id/lineage — 400 ID non numérique', async () => {
    const res = await request(app).get('/api/airplanes/abc/lineage');
    expect(res.status).toBe(400);
  });

  test('GET /api/airplanes/:id/lineage — 500 erreur BDD', async () => {
    mockPool.query.mockRejectedValueOnce(new Error('DB fail'));
    const res = await request(app).get('/api/airplanes/1/lineage');
    expect(res.status).toBe(500);
  });

  test('GET /api/airplanes/:id/related — 500 erreur BDD', async () => {
    mockPool.query.mockRejectedValueOnce(new Error('DB error'));

    const res = await request(app)
      .get('/api/airplanes/4/related')
      .set('Authorization', `Bearer ${tokenAdmin}`);

    expect(res.status).toBe(500);
    expect(res.body.message).toBe('Erreur interne du serveur');
    expect(res.body.errorId).toBeDefined();
  });
});


// =============================================================================
// RÉFÉRENTIELS — countries, generations, types, manufacturers
// =============================================================================
describe('Référentiels', () => {
  test('GET /api/countries — 200', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [{ id: 1, name: 'France' }, { id: 2, name: 'USA' }] });
    const res = await request(app).get('/api/countries');
    expect(res.status).toBe(200);
    expect(res.body).toHaveLength(2);
  });

  test('GET /api/nations — 200 (code, comptage, nom FR canonique)', async () => {
    mockPool.query.mockResolvedValueOnce({
      rows: [
        { code: 'USA', name: 'États-Unis', name_en: 'United States', count: 120 },
        { code: 'FRA', name: 'France', name_en: 'France', count: 42 },
      ],
    });
    const res = await request(app).get('/api/nations');
    expect(res.status).toBe(200);
    expect(res.body).toHaveLength(2);
    expect(res.body[0]).toMatchObject({ code: 'USA', count: 120, name_fr: 'États-Unis' });
    expect(res.headers['cache-control']).toContain('max-age');
  });

  test('GET /api/nations?lang=en — nom traduit, name_fr préservé', async () => {
    mockPool.query.mockResolvedValueOnce({
      rows: [{ code: 'USA', name: 'États-Unis', name_en: 'United States', count: 120 }],
    });
    const res = await request(app).get('/api/nations?lang=en');
    expect(res.status).toBe(200);
    expect(res.body[0].name).toBe('United States');
    expect(res.body[0].name_fr).toBe('États-Unis');
  });

  test('GET /api/generations — 200', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [{ generation: 4 }, { generation: 5 }] });
    const res = await request(app).get('/api/generations');
    expect(res.status).toBe(200);
    expect(res.body).toEqual([4, 5]);
  });

  test('GET /api/types — 200', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [{ id: 1, name: 'Chasseur' }] });
    const res = await request(app).get('/api/types');
    expect(res.status).toBe(200);
  });

  test('GET /api/manufacturers — 200', async () => {
    mockPool.query.mockResolvedValueOnce({
      rows: [{ id: 1, name: 'Dassault', country_name: 'France' }],
    });
    const res = await request(app).get('/api/manufacturers');
    expect(res.status).toBe(200);
  });

  test('500 — erreur DB sur countries', async () => {
    mockPool.query.mockRejectedValueOnce(new Error('DB fail'));
    const res = await request(app).get('/api/countries');
    expect(res.status).toBe(500);
  });

  test('GET /api/countries — 500 erreur BDD', async () => {
    mockPool.query.mockRejectedValueOnce(new Error('DB error'));
    const res = await request(app).get('/api/countries');
    expect(res.status).toBe(500);
  });

  test('GET /api/generations — 500 erreur BDD', async () => {
    mockPool.query.mockRejectedValueOnce(new Error('DB error'));
    const res = await request(app).get('/api/generations');
    expect(res.status).toBe(500);
  });

  test('GET /api/types — 500 erreur BDD', async () => {
    mockPool.query.mockRejectedValueOnce(new Error('DB error'));
    const res = await request(app).get('/api/types');
    expect(res.status).toBe(500);
  });
});


// =============================================================================
// FAVORIS
// =============================================================================
describe('Favoris', () => {
  test('GET /api/favorites — 200', async () => {
    mockPool.query.mockResolvedValueOnce({
      rows: [{ id: 1, name: 'F-22', favorited_at: new Date() }],
    });

    const res = await request(app)
      .get('/api/favorites')
      .set('Authorization', `Bearer ${tokenMember}`);
    expect(res.status).toBe(200);
    expect(res.body).toHaveLength(1);
  });

  test('GET /api/favorites — 403 sans token', async () => {
    const res = await request(app).get('/api/favorites');
    expect(res.status).toBe(403);
  });

  test('POST /api/favorites/:airplaneId — 201', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [] });

    const res = await request(app)
      .post('/api/favorites/1')
      .set('Authorization', `Bearer ${tokenMember}`);
    expect(res.status).toBe(201);
    expect(res.body.message).toBe('Ajouté aux favoris');
  });

  test('DELETE /api/favorites/:airplaneId — 200', async () => {
    mockPool.query.mockResolvedValueOnce({ rowCount: 1 });

    const res = await request(app)
      .delete('/api/favorites/1')
      .set('Authorization', `Bearer ${tokenMember}`);
    expect(res.status).toBe(200);
    expect(res.body.message).toBe('Supprimé des favoris');
  });

  test('DELETE /api/favorites/:airplaneId — 404 non trouvé', async () => {
    mockPool.query.mockResolvedValueOnce({ rowCount: 0 });

    const res = await request(app)
      .delete('/api/favorites/99')
      .set('Authorization', `Bearer ${tokenMember}`);
    expect(res.status).toBe(404);
  });

  test('GET /api/airplanes/:id/favorite — isFavorite: true', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [{ '?column?': 1 }] });

    const res = await request(app)
      .get('/api/airplanes/1/favorite')
      .set('Authorization', `Bearer ${tokenMember}`);
    expect(res.status).toBe(200);
    expect(res.body.isFavorite).toBe(true);
  });

  test('GET /api/airplanes/:id/favorite — isFavorite: false', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [] });

    const res = await request(app)
      .get('/api/airplanes/1/favorite')
      .set('Authorization', `Bearer ${tokenMember}`);
    expect(res.status).toBe(200);
    expect(res.body.isFavorite).toBe(false);
  });

  test('POST /api/favorites/:airplaneId — 400 ID non numérique', async () => {
    const res = await request(app)
      .post('/api/favorites/abc')
      .set('Authorization', `Bearer ${tokenMember}`);
    expect(res.status).toBe(400);
    expect(res.body.message).toBe('ID avion invalide');
  });

  test('POST /api/favorites/:airplaneId — 404 avion inexistant (FK 23503)', async () => {
    const fkError = new Error('violates foreign key constraint');
    fkError.code = '23503';
    mockPool.query.mockRejectedValueOnce(fkError);

    const res = await request(app)
      .post('/api/favorites/99999')
      .set('Authorization', `Bearer ${tokenMember}`);
    expect(res.status).toBe(404);
    expect(res.body.message).toBe('Avion introuvable');
  });

  test('POST /api/favorites/:airplaneId — 500 erreur DB non gérée (propagée)', async () => {
    const dbError = new Error('DB down');
    dbError.code = '08006';
    mockPool.query.mockRejectedValueOnce(dbError);

    const res = await request(app)
      .post('/api/favorites/1')
      .set('Authorization', `Bearer ${tokenMember}`);
    expect(res.status).toBe(500);
  });

  test('DELETE /api/favorites/:airplaneId — 400 ID non numérique', async () => {
    const res = await request(app)
      .delete('/api/favorites/xyz')
      .set('Authorization', `Bearer ${tokenMember}`);
    expect(res.status).toBe(400);
  });
});


// =============================================================================
// STATISTIQUES — GET /api/stats
// =============================================================================
describe('GET /api/stats', () => {
  test('200 — retourne les statistiques', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [{ total: 47 }] })
      .mockResolvedValueOnce({ rows: [{ earliest: 1953, latest: 2023 }] })
      .mockResolvedValueOnce({ rows: [{ total: 12 }] })
      .mockResolvedValueOnce({ rows: [{ total: 5 }] })
      .mockResolvedValueOnce({ rows: [{ total: 61 }] });

    const res = await request(app).get('/api/stats');
    expect(res.status).toBe(200);
    expect(res.body.wars).toBe(61);
    expect(res.body.airplanes).toBe(47);
    expect(res.body.earliest_year).toBe(1953);
    expect(res.body.latest_year).toBe(2023);
    expect(res.body.countries).toBe(12);
    expect(res.body.generations).toBe(5);
  });

  test('500 — erreur DB', async () => {
    mockPool.query.mockRejectedValueOnce(new Error('DB fail'));
    const res = await request(app).get('/api/stats');
    expect(res.status).toBe(500);
  });

  test('200 — second appel retourne le cache (pas de nouvelle requête)', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [{ total: 68 }] })
      .mockResolvedValueOnce({ rows: [{ earliest: 1970, latest: 2024 }] })
      .mockResolvedValueOnce({ rows: [{ total: 15 }] })
      .mockResolvedValueOnce({ rows: [{ total: 5 }] })
      .mockResolvedValueOnce({ rows: [{ total: 61 }] });

    const first = await request(app).get('/api/stats');
    expect(first.status).toBe(200);
    expect(first.body.airplanes).toBe(68);

    const callsBefore = mockPool.query.mock.calls.length;

    const second = await request(app).get('/api/stats');
    expect(second.status).toBe(200);
    expect(second.body.airplanes).toBe(68);

    expect(mockPool.query.mock.calls.length).toBe(callsBefore);
  });
});


// =============================================================================
// REFERENTIALS — Endpoint combiné + Cache-Control
// =============================================================================
describe('GET /api/referentials', () => {
  test('200 — retourne countries, generations, types, manufacturers en 1 réponse', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [{ id: 1, name: 'France' }] })           // countries
      .mockResolvedValueOnce({ rows: [{ generation: 4 }, { generation: 5 }] }) // generations
      .mockResolvedValueOnce({ rows: [{ id: 1, name: 'Chasseur', description: null }] }) // types
      .mockResolvedValueOnce({ rows: [{ id: 1, name: 'Dassault', code: 'DAS', country_id: 1, country_name: 'France' }] }) // manufacturers
      .mockResolvedValueOnce({ rows: [{ name: "Guerre d'Indochine", name_en: 'First Indochina War', date_start: '1946-12-19', date_end: '1954-07-21' }] }) // wars
      .mockResolvedValueOnce({ rows: [{ name: 'Interception', name_en: 'Interception' }] }); // missions

    const res = await request(app).get('/api/referentials');
    expect(res.status).toBe(200);
    expect(res.body).toHaveProperty('countries');
    expect(res.body).toHaveProperty('generations');
    expect(res.body).toHaveProperty('types');
    expect(res.body).toHaveProperty('manufacturers');
    expect(res.body.generations).toEqual([4, 5]);
    expect(res.body.countries).toHaveLength(1);
    // Conflits : nom FR canonique + slug de la page du conflit
    expect(res.body.wars[0]).toMatchObject({ name_fr: "Guerre d'Indochine", slug: 'guerre-d-indochine' });
    expect(res.body.missions[0]).toMatchObject({ name_fr: 'Interception' });
  });

  test('200 — header Cache-Control présent (cacheable)', async () => {
    // Six requêtes (pays, générations, types, constructeurs, conflits, missions).
    // Le test n'en simulait que quatre : la réponse partait en 500 après la pose
    // de l'en-tête, et l'assertion passait par accident.
    mockPool.query
      .mockResolvedValueOnce({ rows: [] })
      .mockResolvedValueOnce({ rows: [] })
      .mockResolvedValueOnce({ rows: [] })
      .mockResolvedValueOnce({ rows: [] })
      .mockResolvedValueOnce({ rows: [] })
      .mockResolvedValueOnce({ rows: [] });

    const res = await request(app).get('/api/referentials');
    expect(res.status).toBe(200);
    expect(res.headers['cache-control']).toBeDefined();
    expect(res.headers['cache-control']).toMatch(/public/);
    expect(res.headers['cache-control']).toMatch(/max-age=\d+/);
  });

  test('500 — une des 4 requêtes échoue → erreur globale', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [] })
      .mockRejectedValueOnce(new Error('DB error'))
      .mockResolvedValueOnce({ rows: [] })
      .mockResolvedValueOnce({ rows: [] });

    const res = await request(app).get('/api/referentials');
    expect(res.status).toBe(500);
  });

  test('Cache-Control présent sur /api/types (référentiel individuel)', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [{ id: 1, name: 'X', description: null }] });
    const res = await request(app).get('/api/types');
    expect(res.headers['cache-control']).toMatch(/public/);
  });
});


// =============================================================================
// TIMELINE — GET /api/timeline (chronologie cinématographique)
// =============================================================================
describe('GET /api/timeline', () => {
  test('200 — renvoie 9 décennies avec events + aircraft regroupés', async () => {
    // Requête 1 : events + LEFT JOIN airplanes
    mockPool.query.mockResolvedValueOnce({
      rows: [
        {
          id: 1,
          event_date: '1945-08-06',
          era_decade: 1940,
          kind: 'milestone',
          title_fr: 'Hiroshima',
          title_en: 'Hiroshima',
          body_fr: 'Bombe atomique.',
          body_en: 'Atomic bomb.',
          quote_author_fr: null,
          quote_author_en: null,
          airplane_id: 12,
          airplane_name: 'B-29',
          airplane_name_en: 'B-29',
          airplane_image_url: 'b29.jpg',
          airplane_little_description: 'Bombardier',
          airplane_little_description_en: 'Bomber',
        },
        {
          id: 2,
          event_date: '1962-10-16',
          era_decade: 1960,
          kind: 'war',
          title_fr: 'Crise de Cuba',
          title_en: 'Cuban Missile Crisis',
          body_fr: '13 jours.',
          body_en: '13 days.',
          quote_author_fr: null,
          quote_author_en: null,
          airplane_id: null,
          airplane_name: null,
          airplane_name_en: null,
          airplane_image_url: null,
          airplane_little_description: null,
          airplane_little_description_en: null,
        },
      ],
    });
    // Requête 2 : aircraft par décennie
    mockPool.query.mockResolvedValueOnce({
      rows: [
        {
          id: 10,
          name: 'F-14 Tomcat',
          name_en: 'F-14 Tomcat',
          image_url: 'f14.jpg',
          little_description: 'Intercepteur naval',
          little_description_en: 'Naval interceptor',
          status: 'Retiré',
          units_built: 712,
          year: 1974,
          year_source: 'service',
          era_decade: 1970,
          country_name: 'États-Unis',
          country_name_en: 'United States',
          generation: 4,
          type_name: 'Chasseur',
          type_name_en: 'Fighter',
        },
      ],
    });

    // Requête 3 : conflits datés, avec les appareils rattachés
    mockPool.query.mockResolvedValueOnce({
      rows: [
        { id: 4, name: 'Guerre de Corée', name_en: 'Korean War', date_start: '1950-06-25', date_end: '1953-07-27', aircraft_ids: [12, 10] },
        { id: 5, name: 'Guerre de 1914', name_en: null, date_start: '1914-08-01', date_end: null, aircraft_ids: [] },
      ],
    });

    const res = await request(app).get('/api/timeline');
    expect(res.status).toBe(200);
    expect(res.headers['x-cache']).toBe('MISS');
    // Conflit hors des décennies couvertes : écarté ; slug dérivé du nom.
    expect(res.body.wars).toEqual([{
      id: 4, slug: 'guerre-de-coree', name: 'Guerre de Corée', name_en: 'Korean War',
      start_year: 1950, end_year: 1953, era_decade: 1950, aircraft_ids: [12, 10], events: [],
    }]);
    expect(Array.isArray(res.body.decades)).toBe(true);
    expect(res.body.decades.length).toBe(9); // 1940 → 2020
    const d40 = res.body.decades.find(d => d.decade === 1940);
    expect(d40.events.length).toBe(1);
    expect(d40.events[0].airplane.name).toBe('B-29');
    const d60 = res.body.decades.find(d => d.decade === 1960);
    expect(d60.events[0].airplane).toBeNull();
    const d70 = res.body.decades.find(d => d.decade === 1970);
    expect(d70.aircraft.length).toBe(1);
    expect(d70.aircraft[0]).toMatchObject({ name: 'F-14 Tomcat', year: 1974, year_source: 'service', units_built: 712 });
  });

  test('X-Cache HIT au second appel sans ?force=1', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [] });
    mockPool.query.mockResolvedValueOnce({ rows: [] });
    mockPool.query.mockResolvedValueOnce({ rows: [] }); // conflits
    await request(app).get('/api/timeline'); // premier appel → MISS + warm cache
    const res = await request(app).get('/api/timeline');
    expect(res.status).toBe(200);
    expect(res.headers['x-cache']).toBe('HIT');
  });

  test('?force=1 bypasse le cache', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [] });
    mockPool.query.mockResolvedValueOnce({ rows: [] });
    mockPool.query.mockResolvedValueOnce({ rows: [] }); // conflits
    await request(app).get('/api/timeline');
    mockPool.query.mockResolvedValueOnce({ rows: [] });
    mockPool.query.mockResolvedValueOnce({ rows: [] });
    mockPool.query.mockResolvedValueOnce({ rows: [] }); // conflits
    const res = await request(app).get('/api/timeline?force=1');
    expect(res.status).toBe(200);
    expect(res.headers['x-cache']).toBe('MISS');
  });

  test('app.invalidateTimelineCache vide le cache', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [] });
    mockPool.query.mockResolvedValueOnce({ rows: [] });
    mockPool.query.mockResolvedValueOnce({ rows: [] }); // conflits
    await request(app).get('/api/timeline');
    await app.invalidateTimelineCache?.();
    mockPool.query.mockResolvedValueOnce({ rows: [] });
    mockPool.query.mockResolvedValueOnce({ rows: [] });
    mockPool.query.mockResolvedValueOnce({ rows: [] }); // conflits
    const res = await request(app).get('/api/timeline');
    expect(res.headers['x-cache']).toBe('MISS');
  });
});


// =============================================================================
// HERO — GET /api/hero/discoveries (widgets dynamiques landing)
// =============================================================================
describe('GET /api/hero/discoveries', () => {
  test('200 — renvoie facts + aircraft normalisés', async () => {
    mockPool.query.mockResolvedValueOnce({
      rows: [
        {
          id: 1, year: 1961,
          title_fr: 'Mach 2', title_en: 'Mach 2',
          airplane_id: 7,
          airplane_name: 'Mirage III', airplane_name_en: 'Mirage III',
        },
      ],
    });
    mockPool.query.mockResolvedValueOnce({
      rows: [
        {
          id: 10, name: 'F-15 Eagle', name_en: 'F-15 Eagle',
          image_url: '/assets/airplanes/f15-eagle.jpg',
          generation: 4, type_name: 'Supériorité aérienne', type_name_en: 'Air superiority',
        },
      ],
    });

    mockPool.query.mockResolvedValueOnce({
      rows: [
        {
          airplane_id: 3, airplane_name: 'Jaguar', airplane_name_en: 'Jaguar',
          kind: 'first_flight', day_gap: 0, event_date: '1968-09-08', year: 1968,
          image_url: '/assets/airplanes/jaguar.jpg', image_credit: 'SAC Tim Laurence', image_licence: 'OGL v1.0',
        },
      ],
    });

    const res = await request(app).get('/api/hero/discoveries');
    expect(res.status).toBe(200);
    expect(res.headers['x-cache']).toBe('MISS');
    expect(Array.isArray(res.body.facts)).toBe(true);
    expect(Array.isArray(res.body.aircraft)).toBe(true);
    expect(Array.isArray(res.body.ephemeris)).toBe(true);
    // La date de reference vient du serveur : c'est elle qui aligne tous les
    // visiteurs sur le meme appareil du jour, quel que soit leur fuseau.
    expect(res.body.day).toMatch(/^\d{4}-\d{2}-\d{2}$/);
    expect(res.body.ephemeris[0]).toMatchObject({
      kind: 'first_flight', day_gap: 0, event_date: '1968-09-08',
      year: 1968, airplane_id: 3, airplane_name: 'Jaguar',
      // Photo de l'appareil du jour (grande image du haut de l'accueil) et son crédit.
      image_url: '/assets/airplanes/jaguar.jpg', image_credit: 'SAC Tim Laurence', image_licence: 'OGL v1.0',
    });
    expect(res.body.facts[0]).toMatchObject({
      year: 1961, title_fr: 'Mach 2', airplane_id: 7, airplane_name: 'Mirage III',
    });
    expect(res.body.aircraft[0]).toMatchObject({
      id: 10, name: 'F-15 Eagle', image_url: '/assets/airplanes/f15-eagle.jpg', generation: 4,
    });
  });

  test('X-Cache HIT au second appel sans ?force=1', async () => {
    mockPool.query.mockResolvedValue({ rows: [] });
    await request(app).get('/api/hero/discoveries');
    const res = await request(app).get('/api/hero/discoveries');
    expect(res.headers['x-cache']).toBe('HIT');
  });

  test('app.invalidateHeroCache vide le cache', async () => {
    mockPool.query.mockResolvedValue({ rows: [] });
    await request(app).get('/api/hero/discoveries');
    await app.invalidateHeroCache?.();
    const res = await request(app).get('/api/hero/discoveries');
    expect(res.headers['x-cache']).toBe('MISS');
  });

  test("l'ephemeride est interrogee sur le jour courant, fenetre +/- 3 jours", async () => {
    mockPool.query.mockResolvedValue({ rows: [] });
    const res = await request(app).get('/api/hero/discoveries?force=1');

    const appel = mockPool.query.mock.calls.find(([sql]) => /WITH ref AS/.test(sql));
    expect(appel).toBeDefined();
    expect(appel[1]).toEqual([res.body.day, 3, 12]);
    // Les dates au 1er du mois sont des mois sans jour connu (223 des 330 mises
    // en service) : les publier inventerait un anniversaire precis.
    expect(appel[0]).toContain("to_char(a.date_first_fly, 'DD') <> '01'");
    expect(appel[0]).toContain("to_char(a.date_operationel, 'DD') <> '01'");
  });

  test("l'ephemeride compare les dates sur une annee bissextile (29 fevrier)", async () => {
    mockPool.query.mockResolvedValue({ rows: [] });
    await request(app).get('/api/hero/discoveries?force=1');

    const [sql] = mockPool.query.mock.calls.find(([q]) => /WITH ref AS/.test(q));
    // Ramener les dates sur 2001 fait lever to_date('02-29-2001') : une seule
    // fiche datee du 29 fevrier (MiG 1.44, premier vol le 29/02/2000) suffisait
    // a faire tomber toute la route en 500, chaque jour de l'annee.
    expect(sql).not.toMatch(/2001/);
    expect(sql).toMatch(/make_date\(2000,/);
    // 2000 compte 366 jours : l'ecart circulaire doit boucler sur 366, sinon le
    // 31 decembre et le 1er janvier seraient a 0 jour l'un de l'autre.
    expect(sql).toContain('366 - ABS(');
  });

  test('ephemeris vide quand aucun anniversaire ne tombe dans la fenetre', async () => {
    mockPool.query.mockResolvedValue({ rows: [] });
    const res = await request(app).get('/api/hero/discoveries?force=1');
    expect(res.status).toBe(200);
    expect(res.body.ephemeris).toEqual([]);
  });

  test('500 — erreur DB propage en 500', async () => {
    mockPool.query.mockRejectedValueOnce(new Error('DB fail'));
    const res = await request(app).get('/api/hero/discoveries?force=1');
    expect(res.status).toBe(500);
  });
});


// =============================================================================
// STATISTIQUES — GET /api/stats — cas null (earliest/latest nulls, ligne 36-37)
// =============================================================================
describe('GET /api/stats — valeurs null (lignes 36-37)', () => {
  test('200 — earliest/latest null → renvoie null dans la réponse', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [{ total: 0 }] })
      .mockResolvedValueOnce({ rows: [{ earliest: null, latest: null }] })
      .mockResolvedValueOnce({ rows: [{ total: 0 }] })
      .mockResolvedValueOnce({ rows: [{ total: 0 }] })
      .mockResolvedValueOnce({ rows: [{ total: 0 }] });

    const res = await request(app).get('/api/stats');
    expect(res.status).toBe(200);
    expect(res.body.airplanes).toBe(0);
    expect(res.body.earliest_year).toBeNull();
    expect(res.body.latest_year).toBeNull();
    expect(res.body.countries).toBe(0);
    expect(res.body.generations).toBe(0);
  });
});


// =============================================================================
// FACETS — GET /api/airplanes/facets — catch err → next(err) (ligne 72)
// =============================================================================
describe('GET /api/airplanes/facets — catch (ligne 72)', () => {
  test('500 — erreur DB déclenche next(err)', async () => {
    mockPool.query.mockRejectedValueOnce(new Error('db down'));
    const res = await request(app).get('/api/airplanes/facets');
    expect(res.status).toBe(500);
  });
});


// =============================================================================
// TIMELINE — cache.get throws (ligne 33) et cache.set ignoré (ligne 150)
// =============================================================================
describe('GET /api/timeline — cache errors silencieux', () => {
  const cache = require('../utils/cache');

  beforeEach(() => {
    cache._resetForTests();
  });

  afterEach(() => {
    cache._resetForTests();
    jest.restoreAllMocks();
  });

  test('cache.get throw → fallback vers DB, requête réussit (ligne 33)', async () => {
    jest.spyOn(cache, 'get').mockRejectedValueOnce(new Error('redis down'));
    mockPool.query
      .mockResolvedValueOnce({ rows: [] })
      .mockResolvedValueOnce({ rows: [] })
      .mockResolvedValueOnce({ rows: [] });

    const res = await request(app).get('/api/timeline');
    expect(res.status).toBe(200);
    // X-Cache reste MISS car cache.get a échoué
  });

  test('cache.set throw → 200 quand même (erreur silencieuse, ligne 150)', async () => {
    jest.spyOn(cache, 'set').mockRejectedValueOnce(new Error('redis write fail'));
    mockPool.query
      .mockResolvedValueOnce({ rows: [] })
      .mockResolvedValueOnce({ rows: [] })
      .mockResolvedValueOnce({ rows: [] });

    const res = await request(app).get('/api/timeline');
    expect(res.status).toBe(200);
  });
});


// =============================================================================
// POST /api/airplanes — validation échoue → 400 (ligne 473)
// =============================================================================
describe('POST /api/airplanes — validation invalide (ligne 473)', () => {
  test('400 — thrust_wet négatif → Données invalides avec errors[]', async () => {
    const res = await request(app)
      .post('/api/airplanes')
      .set('Authorization', `Bearer ${tokenAdmin}`)
      .send({ name: 'TestJet', thrust_wet: -5 });

    expect(res.status).toBe(400);
    expect(res.body.message).toBe('Données invalides');
    expect(Array.isArray(res.body.errors)).toBe(true);
    expect(res.body.errors.length).toBeGreaterThan(0);
  });
});


// =============================================================================
// PUT /api/airplanes/:id — auto-référence (ligne 507)
// =============================================================================
describe('PUT /api/airplanes/:id — auto-référence (ligne 507)', () => {
  const validPutData = {
    name: 'Rafale',
    complete_name: null,
    little_description: null,
    image_url: null,
    description: null,
    country_id: null,
    date_concept: null,
    date_first_fly: null,
    date_operationel: null,
    max_speed: null,
    max_range: null,
    id_manufacturer: null,
    id_generation: null,
    type: null,
    status: null,
    empty_weight: null,
  };

  test('400 — predecessor_id === :id → ne peut pas se référencer lui-même', async () => {
    mockPool.query.mockResolvedValueOnce({
      rows: [{ country_ok: true, manufacturer_ok: true, generation_ok: true, type_ok: true }],
    });

    const res = await request(app)
      .put('/api/airplanes/42')
      .set('Authorization', `Bearer ${tokenAdmin}`)
      .send({ ...validPutData, predecessor_id: 42 });

    expect(res.status).toBe(400);
    expect(res.body.message).toMatch(/ne peut pas se référencer lui-même/);
  });

  test('400 — successor_id === :id → auto-référence', async () => {
    mockPool.query.mockResolvedValueOnce({
      rows: [{ country_ok: true, manufacturer_ok: true, generation_ok: true, type_ok: true }],
    });

    const res = await request(app)
      .put('/api/airplanes/7')
      .set('Authorization', `Bearer ${tokenAdmin}`)
      .send({ ...validPutData, successor_id: 7 });

    expect(res.status).toBe(400);
    expect(res.body.message).toMatch(/ne peut pas se référencer lui-même/);
  });
});


// =============================================================================
// PUT /api/airplanes/:id — validation invalide → 400 (ligne 473)
// =============================================================================
describe('PUT /api/airplanes/:id — validation invalide (ligne 473)', () => {
  test('400 — thrust_wet négatif → Données invalides', async () => {
    const res = await request(app)
      .put('/api/airplanes/10')
      .set('Authorization', `Bearer ${tokenAdmin}`)
      .send({ name: 'TestJet', thrust_wet: -5 });

    expect(res.status).toBe(400);
    expect(res.body.message).toBe('Données invalides');
    expect(Array.isArray(res.body.errors)).toBe(true);
  });
});


// =============================================================================
// TIMELINE — décennie inconnue dans les events et aircraft (lignes 100, 124)
// =============================================================================
describe('GET /api/timeline — décennie hors plage ignorée (lignes 100, 124)', () => {
  beforeEach(() => {
    require('../utils/cache')._resetForTests();
  });

  afterEach(() => {
    require('../utils/cache')._resetForTests();
  });

  test('événement avec era_decade inconnue ignoré (ligne 100)', async () => {
    mockPool.query
      .mockResolvedValueOnce({
        rows: [{
          id: 99,
          event_date: '1939-09-01',
          era_decade: 1930, // hors des décennies allDecades [1940..2020]
          kind: 'milestone',
          title_fr: 'Début WWII',
          title_en: 'WWII Start',
          body_fr: 'text',
          body_en: 'text',
          quote_author_fr: null,
          quote_author_en: null,
          airplane_id: null,
          airplane_name: null,
          airplane_name_en: null,
          airplane_image_url: null,
          airplane_little_description: null,
          airplane_little_description_en: null,
        }],
      })
      .mockResolvedValueOnce({ rows: [] }) // aircraft
      .mockResolvedValueOnce({ rows: [] }); // conflits

    const res = await request(app).get('/api/timeline');
    expect(res.status).toBe(200);
    // Le bucket 1930 n'existe pas → continue → aucun événement dans les décennies
    const decades = res.body.decades;
    const allEvents = decades.flatMap(d => d.events);
    expect(allEvents.find(e => e.id === 99)).toBeUndefined();
  });

  test('aircraft avec era_decade inconnu ignoré (ligne 124)', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [] }) // events
      .mockResolvedValueOnce({
        rows: [{
          id: 77,
          name: 'Unknown Plane',
          name_en: null,
          image_url: null,
          little_description: null,
          little_description_en: null,
          date_operationel: null,
          era_decade: 1930, // hors plage
          country_name: null,
          country_name_en: null,
          generation: null,
          type_name: null,
          type_name_en: null,
        }],
      })
      .mockResolvedValueOnce({ rows: [] }); // conflits

    const res = await request(app).get('/api/timeline');
    expect(res.status).toBe(200);
    const decades = res.body.decades;
    const allAircraft = decades.flatMap(d => d.aircraft);
    expect(allAircraft.find(a => a.id === 77)).toBeUndefined();
  });
});


// =============================================================================
// CONFLITS ET MISSIONS — filtres du hangar, API /wars, pages /conflits
// =============================================================================
describe('Filtres conflit et mission — GET /api/airplanes', () => {
  // getValidReferentials : générations, types, conflits, missions
  function mockWhitelist({ wars = [], missions = [] } = {}) {
    mockPool.query
      .mockResolvedValueOnce({ rows: [{ generation: 4 }] })
      .mockResolvedValueOnce({ rows: [{ name: 'Chasseur' }] })
      .mockResolvedValueOnce({ rows: wars.map((name) => ({ name })) })
      .mockResolvedValueOnce({ rows: missions.map((name) => ({ name })) });
  }

  test('200 — ?war= filtre par EXISTS sur airplane_wars (nom FR canonique)', async () => {
    mockWhitelist({ wars: ['Guerre du Vietnam'] });
    mockPool.query
      .mockResolvedValueOnce({ rows: [{ count: '1' }] })
      .mockResolvedValueOnce({ rows: [{ id: 1, name: 'F-4 Phantom II' }] });

    const res = await request(app).get('/api/airplanes?war=' + encodeURIComponent('Guerre du Vietnam'));
    expect(res.status).toBe(200);
    const countCall = mockPool.query.mock.calls[4];
    expect(countCall[0]).toContain('FROM airplane_wars aw JOIN wars w');
    expect(countCall[1][0]).toBe('Guerre du Vietnam');
  });

  test('200 — ?mission= combinable avec ?war= (AND)', async () => {
    mockWhitelist({ wars: ['Guerre du Golfe'], missions: ['Interception'] });
    mockPool.query
      .mockResolvedValueOnce({ rows: [{ count: '0' }] })
      .mockResolvedValueOnce({ rows: [] });

    const res = await request(app).get('/api/airplanes?war=Guerre%20du%20Golfe&mission=Interception');
    expect(res.status).toBe(200);
    const countCall = mockPool.query.mock.calls[4];
    expect(countCall[0]).toContain('airplane_wars');
    expect(countCall[0]).toContain('airplane_missions');
    // queryParams reçoit ensuite limit/offset (muté après l'appel)
    expect(countCall[1].slice(0, 2)).toEqual(['Guerre du Golfe', 'Interception']);
  });

  test('400 — conflit hors référentiel', async () => {
    mockWhitelist({ wars: ['Guerre du Vietnam'] });
    const res = await request(app).get('/api/airplanes?war=Guerre%20invent%C3%A9e');
    expect(res.status).toBe(400);
    expect(res.body.message).toMatch(/war invalide/);
  });

  test('400 — mission hors référentiel', async () => {
    mockWhitelist({ missions: ['Interception'] });
    const res = await request(app).get('/api/airplanes?mission=Pique-nique');
    expect(res.status).toBe(400);
    expect(res.body.message).toMatch(/mission invalide/);
  });

  test('200 — recherche avec syntaxe websearch : pas de variante préfixe', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [{ count: '0' }] })
      .mockResolvedValueOnce({ rows: [] });

    const res = await request(app).get('/api/airplanes?search=' + encodeURIComponent('rafale -mirage'));
    expect(res.status).toBe(200);
    const mainCall = mockPool.query.mock.calls[1];
    expect(mainCall[0]).toContain("search_vector @@ websearch_to_tsquery('simple', $1)");
    expect(mainCall[0]).not.toContain("to_tsquery('simple', $2)");
  });
});


describe('GET /api/airplanes/:id/related — clés de lien des conflits et missions', () => {
  test('ajoute name_fr (missions, conflits) et slug (conflits)', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [] })
      .mockResolvedValueOnce({ rows: [] })
      .mockResolvedValueOnce({ rows: [{ name: 'Interception', name_en: 'Interception', description: 'd', description_en: 'd' }] })
      .mockResolvedValueOnce({ rows: [{ name: "Guerre d'Indochine", name_en: 'First Indochina War', description: 'd', description_en: 'd', date_start: '1946-12-19', date_end: '1954-07-21' }] });

    const res = await request(app).get('/api/airplanes/7/related?lang=en');
    expect(res.status).toBe(200);
    expect(res.body.wars[0]).toMatchObject({ name: 'First Indochina War', name_fr: "Guerre d'Indochine", slug: 'guerre-d-indochine' });
    expect(res.body.missions[0]).toMatchObject({ name_fr: 'Interception' });
  });

  const WAR_WITH_ROLE = {
    name: 'Guerre Iran-Israël', name_en: 'Iran–Israel war', description: 'd', description_en: 'd',
    date_start: '2025-06-13', date_end: '2025-06-24',
    role: 'Frappe sur *Fordo*.', role_en: 'Strike on *Fordo*.',
    side_name: 'États-Unis', side_name_en: 'United States',
  };

  test('rôle et camp de l\'appareil dans le conflit, traduits (lang=en)', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [] })
      .mockResolvedValueOnce({ rows: [] })
      .mockResolvedValueOnce({ rows: [] })
      .mockResolvedValueOnce({ rows: [{ ...WAR_WITH_ROLE }] });

    const res = await request(app).get('/api/airplanes/7/related?lang=en');
    expect(res.status).toBe(200);
    expect(res.body.wars[0]).toMatchObject({ role: 'Strike on *Fordo*.', side_name: 'United States' });
    expect(res.body.wars[0]).not.toHaveProperty('role_en');
    expect(res.body.wars[0]).not.toHaveProperty('side_name_en');
  });

  test('rôle et camp en français par défaut, sans les colonnes _en', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: [] })
      .mockResolvedValueOnce({ rows: [] })
      .mockResolvedValueOnce({ rows: [] })
      .mockResolvedValueOnce({ rows: [{ ...WAR_WITH_ROLE }] });

    const res = await request(app).get('/api/airplanes/7/related');
    expect(res.body.wars[0]).toMatchObject({ role: 'Frappe sur *Fordo*.', side_name: 'États-Unis' });
    expect(res.body.wars[0]).not.toHaveProperty('role_en');
  });

  test('GET /api/airplanes/:id/wars : rôle et camp traduits', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [{ ...WAR_WITH_ROLE }] });
    const res = await request(app).get('/api/airplanes/7/wars?lang=en');
    expect(res.status).toBe(200);
    expect(res.body[0]).toMatchObject({ role: 'Strike on *Fordo*.', side_name: 'United States' });
  });

  test('la requête des conflits lit le rôle et le camp (jointure war_sides)', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: [] });
    await request(app).get('/api/airplanes/7/wars');
    const sql = mockPool.query.mock.calls.at(-1)[0];
    expect(sql).toMatch(/airplane_wars\.role/);
    expect(sql).toMatch(/LEFT JOIN war_sides/);
  });
});


describe('API /api/wars', () => {
  const wars = [
    { id: 1, name: "Guerre d'Indochine", name_en: 'First Indochina War', date_start: '1946-12-19', date_end: '1954-07-21', description: 'fr', description_en: 'en', count: 5 },
    { id: 2, name: 'Guerre sans appareil', name_en: null, date_start: '1960-01-01', date_end: null, description: null, description_en: null, count: 0 },
  ];

  test('200 — liste : seuls les conflits rattachés à au moins un appareil, avec slug', async () => {
    mockPool.query.mockResolvedValueOnce({ rows: wars });
    const res = await request(app).get('/api/wars');
    expect(res.status).toBe(200);
    expect(res.body).toHaveLength(1);
    expect(res.body[0]).toMatchObject({ slug: 'guerre-d-indochine', name_fr: "Guerre d'Indochine", count: 5 });
    expect(res.headers['cache-control']).toMatch(/public/);
  });

  test('200 — détail : appareils traduits (EN) avec type_name_fr', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: wars })
      .mockResolvedValueOnce({ rows: [{ id: 3, name: 'F8F Bearcat', name_en: null, type_name: 'Chasseur', type_name_en: 'Fighter', country_name: 'États-Unis', country_name_en: 'United States', country_code: 'USA' }] })
      .mockResolvedValueOnce({ rows: [] })   // contenu : conflit pas encore rédigé
      .mockResolvedValueOnce({ rows: [] })   // camps
      .mockResolvedValueOnce({ rows: [] });  // dates clés
    const res = await request(app).get('/api/wars/guerre-d-indochine?lang=en');
    expect(res.status).toBe(200);
    expect(res.body).toMatchObject({ name: 'First Indochina War', name_fr: "Guerre d'Indochine", description: 'en', count: 5 });
    expect(res.body.airplanes[0]).toMatchObject({ name: 'F8F Bearcat', type_name: 'Fighter', type_name_fr: 'Chasseur', side_key: null, role: null, role_sources: [] });
    expect(res.body).toMatchObject({ outcome: null, context: null, narrative: null, sources: [], sides: [], events: [] });
    expect(mockPool.query.mock.calls[1][1]).toEqual([1]);
  });

  test('200 — page étoffée : contenu, camps comptés, dates clés en texte, rôles, sources filtrées', async () => {
    mockPool.query
      .mockResolvedValueOnce({ rows: wars })
      .mockResolvedValueOnce({ rows: [
        { id: 3, name: 'F8F Bearcat', name_en: null, side_key: 'france', role: 'Appui des postes.', role_en: 'Close support.', role_sources: 'https://a.test/1\njavascript:alert(1)\n  https://a.test/2  ' },
        { id: 4, name: 'C-47', name_en: null, side_key: null, role: 'Largages.', role_en: null, role_sources: null },
      ] })
      .mockResolvedValueOnce({ rows: [{ outcome: 'Issue', outcome_en: 'Outcome', context: 'Contexte', context_en: null, narrative: 'Récit', narrative_en: 'Narrative', sources: 'https://s.test/x\npas une url' }] })
      .mockResolvedValueOnce({ rows: [
        { side_key: 'france', name: 'France', name_en: 'France', members: 'France, États associés', members_en: 'France, Associated States' },
        { side_key: 'viet-minh', name: 'Việt Minh', name_en: null, members: null, members_en: null },
      ] })
      .mockResolvedValueOnce({ rows: [
        { date: '1954-03-13', precision: 'day', title: 'Diên Biên Phu', title_en: 'Dien Bien Phu', body: 'Début du siège.', body_en: null, source: 'https://s.test/e', airplane_id: 3, airplane_name: 'F8F Bearcat', airplane_name_en: null },
        { date: '1946-12-01', precision: 'month', title: 'Début', title_en: null, body: null, body_en: null, source: null, airplane_id: null, airplane_name: null, airplane_name_en: null },
      ] });
    const res = await request(app).get('/api/wars/guerre-d-indochine?lang=en');
    expect(res.status).toBe(200);
    expect(res.body).toMatchObject({ outcome: 'Outcome', context: 'Contexte', narrative: 'Narrative', sources: ['https://s.test/x'] });
    expect(res.body.sides).toEqual([
      { key: 'france', name: 'France', members: 'France, Associated States', count: 1 },
      { key: 'viet-minh', name: 'Việt Minh', members: null, count: 0 },
    ]);
    expect(res.body.events[0]).toEqual({ date: '1954-03-13', precision: 'day', title: 'Dien Bien Phu', body: 'Début du siège.', source: 'https://s.test/e', airplane: { id: 3, name: 'F8F Bearcat' } });
    expect(res.body.events[1]).toMatchObject({ precision: 'month', title: 'Début', airplane: null });
    expect(res.body.airplanes[0]).toMatchObject({ side_key: 'france', role: 'Close support.', role_sources: ['https://a.test/1', 'https://a.test/2'] });
    expect(res.body.airplanes[0]).not.toHaveProperty('role_en');
    // Rôle sans traduction : le français plutôt que « Translation needed »
    expect(res.body.airplanes[1]).toMatchObject({ side_key: null, role: 'Largages.', role_sources: [] });
  });

  test('404 — slug inconnu ou conflit sans appareil', async () => {
    mockPool.query.mockResolvedValue({ rows: wars });
    expect((await request(app).get('/api/wars/guerre-inconnue')).status).toBe(404);
    expect((await request(app).get('/api/wars/guerre-sans-appareil')).status).toBe(404);
  });

  test('400 — slug au format invalide', async () => {
    const res = await request(app).get('/api/wars/' + encodeURIComponent('Guerre <script>'));
    expect(res.status).toBe(400);
    expect(mockPool.query).not.toHaveBeenCalled();
  });
});
