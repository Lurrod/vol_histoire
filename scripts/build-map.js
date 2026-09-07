#!/usr/bin/env node
/**
 * Build de la carte des nations — génère frontend/assets/map/world-nations.svg
 * à partir des frontières Natural Earth 110m.
 *
 * Source : ne_110m_admin_0_countries.geojson (Natural Earth, domaine public).
 *   https://github.com/nvkelso/natural-earth-vector/blob/master/geojson/
 * Le fichier n'est pas versionné : passer son chemin en argument, ou laisser le
 * script le télécharger (nécessite un accès réseau).
 *
 *   node scripts/build-map.js [chemin/ne_110m_admin_0_countries.geojson]
 *
 * Sortie : un SVG statique, chargé à la demande par js/home/nations-map.js.
 *   - un tracé de fond (tous les pays réunis) pour situer le regard ;
 *   - un tracé par nation de conception, portant data-code="<ISO alpha-3>",
 *     que le JS colore selon le nombre de fiches.
 *
 * La liste des nations est lue dans backend/db_backup/db.sql : ajouter un pays
 * au référentiel et relancer ce script suffit à le faire apparaître.
 *
 * Projection : Robinson — compromis habituel des planisphères. Mercator
 * gonflerait la Russie et le Canada au point de fausser la lecture d'une carte
 * dont le sujet est justement « qui construit ».
 */

const fs = require('fs');
const path = require('path');
const https = require('https');

const ROOT = path.join(__dirname, '..');
const SRC_URL = 'https://raw.githubusercontent.com/nvkelso/natural-earth-vector/master/geojson/ne_110m_admin_0_countries.geojson';
const OUT_FILE = path.join(ROOT, 'frontend', 'assets', 'map', 'world-nations.svg');
const DB_SQL = path.join(ROOT, 'backend', 'db_backup', 'db.sql');

// Largeur du repère SVG ; la hauteur en découle par la projection.
const WIDTH = 1000;
// Arrondi des coordonnées et surface minimale d'un anneau, en pixels du repère.
// Le fond n'a pas à être précis : il sert à situer le regard, pas à mesurer.
// Les nations, elles, sont l'objet de la carte et gardent une décimale.
const NATION_OPTS = { decimals: 0, minArea: 0.5 };
const LAND_OPTS = { decimals: 0, minArea: 3 };

// Codes de la base sans équivalent Natural Earth, ou désignant une entité
// disparue. Une entité historique est rendue par l'union de ses successeurs :
// approximation assumée, et documentée dans la légende de la carte.
const CODE_ALIASES = {
  ROK: ['KOR'],                                    // Corée du Sud : KOR côté Natural Earth
  CSK: ['CZE', 'SVK'],                             // Tchécoslovaquie
  YUG: ['SRB', 'BIH', 'HRV', 'SVN', 'MNE', 'MKD', 'KOS'], // Yougoslavie
};

// ── Projection Robinson ────────────────────────────────────────────────

const ROBINSON_X = [
  1.0000, 0.9986, 0.9954, 0.9900, 0.9822, 0.9730, 0.9600, 0.9427, 0.9216,
  0.8962, 0.8679, 0.8350, 0.7986, 0.7597, 0.7186, 0.6732, 0.6213, 0.5722, 0.5322,
];
const ROBINSON_Y = [
  0.0000, 0.0620, 0.1240, 0.1860, 0.2480, 0.3100, 0.3720, 0.4340, 0.4958,
  0.5571, 0.6176, 0.6769, 0.7346, 0.7903, 0.8435, 0.8936, 0.9394, 0.9761, 1.0000,
];

function interpolate(table, absLat) {
  const pos = Math.min(absLat, 90) / 5;
  const i = Math.min(Math.floor(pos), ROBINSON_X.length - 2);
  const frac = pos - i;
  return table[i] + (table[i + 1] - table[i]) * frac;
}

/** [lon, lat] en degrés → [x, y] en unités arbitraires (y vers le bas). */
function robinson(lon, lat) {
  const absLat = Math.abs(lat);
  const x = 0.8487 * interpolate(ROBINSON_X, absLat) * (lon * Math.PI / 180);
  const y = 1.3523 * interpolate(ROBINSON_Y, absLat) * (lat < 0 ? -1 : 1);
  return [x, -y]; // SVG : y croît vers le bas
}

// Bornes du monde entier, pour caler le repère SVG.
const BOUNDS = (() => {
  const [xMax] = robinson(180, 0);
  const [, yTop] = robinson(0, 90);
  const [, yBottom] = robinson(0, -90);
  return { xMin: -xMax, xMax, yMin: yTop, yMax: yBottom };
})();

const SCALE = WIDTH / (BOUNDS.xMax - BOUNDS.xMin);
const HEIGHT = Math.round((BOUNDS.yMax - BOUNDS.yMin) * SCALE);

function toSvg(lon, lat) {
  const [x, y] = robinson(lon, lat);
  return [
    (x - BOUNDS.xMin) * SCALE,
    (y - BOUNDS.yMin) * SCALE,
  ];
}

// ── GeoJSON → tracé SVG ────────────────────────────────────────────────

function ringArea(pts) {
  let sum = 0;
  for (let i = 0, j = pts.length - 1; i < pts.length; j = i++) {
    sum += (pts[j][0] * pts[i][1]) - (pts[i][0] * pts[j][1]);
  }
  return Math.abs(sum) / 2;
}

// Cadre réellement occupé par les tracés retenus — l'Antarctique étant écarté,
// le repère théorique (-90°..90°) laisserait une large bande vide au sud.
const bbox = { x0: Infinity, y0: Infinity, x1: -Infinity, y1: -Infinity };

function growBbox(pts) {
  pts.forEach(([x, y]) => {
    if (x < bbox.x0) bbox.x0 = x;
    if (y < bbox.y0) bbox.y0 = y;
    if (x > bbox.x1) bbox.x1 = x;
    if (y > bbox.y1) bbox.y1 = y;
  });
}

/** Un anneau de moins de 3 points projetés distincts, ou d'une surface
 *  inférieure au seuil, ne dessine rien de visible : on l'écarte. */
function ringToPath(ring, { decimals, minArea }) {
  const pts = [];
  let prev = null;
  ring.forEach(([lon, lat]) => {
    const [x, y] = toSvg(lon, lat);
    const p = [Number(x.toFixed(decimals)), Number(y.toFixed(decimals))];
    if (prev && p[0] === prev[0] && p[1] === prev[1]) return;
    pts.push(p);
    prev = p;
  });
  if (pts.length < 3 || ringArea(pts) < minArea) return '';
  growBbox(pts);
  return 'M' + pts.map((p) => `${p[0]} ${p[1]}`).join('L') + 'Z';
}

function geometryToPath(geometry, options) {
  if (!geometry) return '';
  const polygons = geometry.type === 'Polygon' ? [geometry.coordinates]
    : geometry.type === 'MultiPolygon' ? geometry.coordinates
      : [];
  return polygons.map((poly) => poly.map((ring) => ringToPath(ring, options)).join('')).join('');
}

/** Centroïde de l'anneau le plus vaste — point d'ancrage de l'infobulle.
 *  Le centre de la boîte englobante ne convient pas : celle de la France
 *  englobe la Guyane et La Réunion, et son centre tombe dans l'Atlantique. */
function anchorOf(geometry) {
  const polygons = geometry.type === 'Polygon' ? [geometry.coordinates]
    : geometry.type === 'MultiPolygon' ? geometry.coordinates
      : [];
  let best = null;
  polygons.forEach((poly) => {
    const ring = (poly[0] || []).map(([lon, lat]) => toSvg(lon, lat));
    if (ring.length < 3) return;
    const area = ringArea(ring);
    if (!best || area > best.area) best = { area, ring };
  });
  if (!best) return null;

  // Centroïde polygonal signé ; on retombe sur la moyenne des sommets si
  // l'anneau est dégénéré (surface nulle après projection).
  let a = 0, cx = 0, cy = 0;
  const r = best.ring;
  for (let i = 0, j = r.length - 1; i < r.length; j = i++) {
    const f = (r[j][0] * r[i][1]) - (r[i][0] * r[j][1]);
    a += f;
    cx += (r[j][0] + r[i][0]) * f;
    cy += (r[j][1] + r[i][1]) * f;
  }
  if (Math.abs(a) < 1e-6) {
    const avg = r.reduce((acc, p) => [acc[0] + p[0], acc[1] + p[1]], [0, 0]);
    return { x: Math.round(avg[0] / r.length), y: Math.round(avg[1] / r.length), area: best.area };
  }
  return { x: Math.round(cx / (3 * a)), y: Math.round(cy / (3 * a)), area: best.area };
}

// ── Lecture des codes pays du référentiel ──────────────────────────────

function readCountryCodes() {
  const sql = fs.readFileSync(DB_SQL, 'utf8');
  const start = sql.indexOf('INSERT INTO countries');
  if (start === -1) throw new Error('Bloc INSERT INTO countries introuvable dans db.sql');
  const block = sql.slice(start, sql.indexOf(';', start));
  const codes = [...block.matchAll(/'([A-Z]{3})'\s*\)/g)].map((m) => m[1]);
  return [...new Set(codes)];
}

// ── Source ─────────────────────────────────────────────────────────────

function download(url) {
  return new Promise((resolve, reject) => {
    https.get(url, (res) => {
      if (res.statusCode >= 300 && res.statusCode < 400 && res.headers.location) {
        return resolve(download(res.headers.location));
      }
      if (res.statusCode !== 200) return reject(new Error(`HTTP ${res.statusCode} sur ${url}`));
      let body = '';
      res.setEncoding('utf8');
      res.on('data', (chunk) => { body += chunk; });
      res.on('end', () => resolve(body));
    }).on('error', reject);
  });
}

async function readSource() {
  const arg = process.argv[2];
  if (arg) {
    console.log(`  source locale : ${arg}`);
    return JSON.parse(fs.readFileSync(arg, 'utf8'));
  }
  console.log('  téléchargement de Natural Earth 110m…');
  return JSON.parse(await download(SRC_URL));
}

// ── Build ──────────────────────────────────────────────────────────────

async function build() {
  const geo = await readSource();
  const wanted = readCountryCodes();

  // Index des géométries par code Natural Earth (ADM0_A3 couvre les cas où
  // ISO_A3 vaut '-99', notamment pour le Kosovo et la France métropolitaine).
  const byCode = new Map();
  geo.features.forEach((f) => {
    const p = f.properties || {};
    [p.ADM0_A3, p.ISO_A3, p.ISO_A3_EH].forEach((code) => {
      if (code && code !== '-99' && !byCode.has(code)) byCode.set(code, f.geometry);
    });
  });

  const nations = [];
  const missing = [];
  const drawnAsNation = new Set();
  wanted.forEach((code) => {
    const sources = CODE_ALIASES[code] || [code];
    sources.forEach((src) => drawnAsNation.add(src));
    const d = sources
      .map((src) => (byCode.has(src) ? geometryToPath(byCode.get(src), NATION_OPTS) : ''))
      .join('');
    if (!d) { missing.push(code); return; }
    // Ancrage : centroïde de la plus vaste des géométries réunies sous ce code
    // (la Yougoslavie en agrège six).
    const anchor = sources
      .filter((src) => byCode.has(src))
      .map((src) => anchorOf(byCode.get(src)))
      .filter(Boolean)
      .reduce((best, cur) => (!best || cur.area > best.area ? cur : best), null);
    nations.push({ code, d, anchor });
  });

  // Fond : le reste du monde, en un seul tracé. Les nations de conception en
  // sont exclues — elles sont redessinées par-dessus, opaques. L'Antarctique
  // sort du cadre (aucun appareil, et un littoral qui pèse lourd).
  const landPath = geo.features
    .filter((f) => {
      const p = f.properties || {};
      if (p.ADM0_A3 === 'ATA') return false;
      return !drawnAsNation.has(p.ADM0_A3) && !drawnAsNation.has(p.ISO_A3);
    })
    .map((f) => geometryToPath(f.geometry, LAND_OPTS))
    .join('');

  const pad = 4;
  const vb = {
    x: Math.max(0, Math.floor(bbox.x0 - pad)),
    y: Math.max(0, Math.floor(bbox.y0 - pad)),
  };
  vb.w = Math.ceil(Math.min(WIDTH, bbox.x1 + pad)) - vb.x;
  vb.h = Math.ceil(Math.min(HEIGHT, bbox.y1 + pad)) - vb.y;

  const svg = [
    `<svg xmlns="http://www.w3.org/2000/svg" viewBox="${vb.x} ${vb.y} ${vb.w} ${vb.h}" class="world-map" role="img" aria-hidden="true" preserveAspectRatio="xMidYMid meet">`,
    `<path class="wm-land" d="${landPath}"/>`,
    `<g class="wm-nations">`,
    ...nations.map((n) => {
      const anchor = n.anchor ? ` data-cx="${n.anchor.x}" data-cy="${n.anchor.y}"` : '';
      return `<path class="wm-nation" data-code="${n.code}"${anchor} d="${n.d}"/>`;
    }),
    `</g>`,
    `</svg>`,
    '',
  ].join('\n');

  fs.mkdirSync(path.dirname(OUT_FILE), { recursive: true });
  fs.writeFileSync(OUT_FILE, svg, 'utf8');

  const kb = (Buffer.byteLength(svg, 'utf8') / 1024).toFixed(1);
  console.log(`  repère        ${vb.w} × ${vb.h} (sur ${WIDTH} × ${HEIGHT})`);
  console.log(`  nations       ${nations.length} / ${wanted.length}`);
  if (missing.length) console.log(`  sans tracé    ${missing.join(', ')}`);
  console.log(`  écrit         ${path.relative(ROOT, OUT_FILE)}  (${kb} KB)`);
}

build().catch((err) => {
  console.error(err.message);
  process.exit(1);
});
