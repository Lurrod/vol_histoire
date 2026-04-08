const express = require('express');

module.exports = function createFacetsRouter(getPool) {
  const router = express.Router();

  function buildConditions(filters, exclude) {
    const params = [];
    const conds = [];
    if (filters.country && exclude !== 'country') {
      params.push(filters.country);
      conds.push(`c.name = $${params.length}`);
    }
    if (filters.generation && exclude !== 'generation') {
      params.push(Number(filters.generation));
      conds.push(`g.generation = $${params.length}`);
    }
    if (filters.type && exclude !== 'type') {
      params.push(filters.type);
      conds.push(`t.name = $${params.length}`);
    }
    return { params, where: conds.length ? ' WHERE ' + conds.join(' AND ') : '' };
  }

  router.get('/airplanes/facets', async (req, res, next) => {
    try {
      const filters = {
        country: req.query.country || '',
        generation: req.query.generation || '',
        type: req.query.type || '',
      };
      const base = `
        FROM airplanes a
        LEFT JOIN countries c ON a.country_id = c.id
        LEFT JOIN generation g ON a.id_generation = g.id
        LEFT JOIN type t ON a.type = t.id`;

      const ctryQ = buildConditions(filters, 'country');
      const genQ = buildConditions(filters, 'generation');
      const typQ = buildConditions(filters, 'type');

      const pool = getPool();
      const [ctryRes, genRes, typRes] = await Promise.all([
        pool.query(
          `SELECT c.name AS k, COUNT(*)::int AS n ${base}${ctryQ.where}
           GROUP BY c.name ORDER BY c.name`,
          ctryQ.params
        ),
        pool.query(
          `SELECT g.generation AS k, COUNT(*)::int AS n ${base}${genQ.where}
           GROUP BY g.generation ORDER BY g.generation`,
          genQ.params
        ),
        pool.query(
          `SELECT t.name AS k, COUNT(*)::int AS n ${base}${typQ.where}
           GROUP BY t.name ORDER BY t.name`,
          typQ.params
        ),
      ]);

      const toMap = rows =>
        rows.reduce((acc, row) => {
          if (row.k != null) acc[row.k] = row.n;
          return acc;
        }, {});

      res.json({
        countries: toMap(ctryRes.rows),
        generations: toMap(genRes.rows),
        types: toMap(typRes.rows),
      });
    } catch (err) {
      next(err);
    }
  });

  return router;
};
