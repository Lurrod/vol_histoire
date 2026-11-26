/**
 * Typographie française des chaînes d'interface (CONT-003) : espace
 * insécable avant « : » et dans les « », fine insécable avant ; ? !. Même
 * règle que typographyFr des récits, appliquée ici aux textes eux-mêmes
 * (fr.json et pages HTML, texte hors balises, URL mises de côté).
 */
const fs = require('fs');
const path = require('path');

const ROOT = path.join(__dirname, '..');
const URL_RE = /\bhttps?:\/\/[^\s)\]<"]+|\bwww\.[^\s)\]<"]+/g;

/** Segments de texte visibles : hors balises, <script>, <style>, <code>, commentaires. */
function textSegments(html) {
  return html
    .replace(/<script\b[\s\S]*?<\/script>|<style\b[\s\S]*?<\/style>|<code\b[\s\S]*?<\/code>|<!--[\s\S]*?-->/g, ' ')
    .split(/<[^>]*>/)
    .map((t) => t.replace(URL_RE, ''));
}

function faults(text) {
  const found = [];
  textSegments(text).forEach((seg) => {
    const re = /.{0,20}(?:[ \t][:;?!]|«[ \t]|[ \t]»).{0,10}/g;
    let m;
    while ((m = re.exec(seg))) found.push(m[0]);
  });
  return found;
}

function strings(o, out = []) {
  if (typeof o === 'string') out.push(o);
  else if (o && typeof o === 'object') Object.values(o).forEach((v) => strings(v, out));
  return out;
}

test('fr.json : aucune espace ordinaire avant : ; ? ! ni dans les « »', () => {
  const fr = require('../locales/fr.json');
  expect(strings(fr).flatMap(faults)).toEqual([]);
});

const pages = fs.readdirSync(ROOT).filter((f) => f.endsWith('.html') && !f.startsWith('google'))
  .concat(fs.readdirSync(path.join(ROOT, 'partials')).map((f) => `partials/${f}`));

test.each(pages)('%s : aucune espace ordinaire avant : ; ? ! ni dans les « »', (page) => {
  expect(faults(fs.readFileSync(path.join(ROOT, page), 'utf8'))).toEqual([]);
});

/* CONT-004 : apostrophe typographique ’ et points de suspension … dans le
 * texte visible. Restent droites : <head> (titres, métadonnées, JSON-LD) et
 * les clés de titre d'onglet qui le réécrivent, pour que le nom du site y
 * garde une seule graphie. */
const TITLE_KEYS = new Set(pages.flatMap((page) =>
  [...fs.readFileSync(path.join(ROOT, page), 'utf8').matchAll(/<title data-i18n="([^"]+)"/g)].map((m) => m[1])));

function apostropheFaults(text) {
  return textSegments(text.replace(/<head\b[\s\S]*?<\/head>/g, ' '))
    .flatMap((seg) => seg.match(/.{0,15}(?:\p{L}'\p{L}|(?<!\.)\.\.\.(?!\.)).{0,10}/gu) || []);
}

function entries(o, prefix = '', out = []) {
  if (typeof o === 'string') out.push([prefix, o]);
  else if (o && typeof o === 'object') Object.entries(o).forEach(([k, v]) => entries(v, prefix ? `${prefix}.${k}` : k, out));
  return out;
}

test('fr.json : apostrophes ’ et points de suspension … (hors titres d’onglet)', () => {
  const fr = require('../locales/fr.json');
  const found = entries(fr).filter(([k]) => !TITLE_KEYS.has(k)).flatMap(([, v]) => apostropheFaults(v));
  expect(found).toEqual([]);
});

test.each(pages)('%s : apostrophes ’ et points de suspension … dans le texte visible', (page) => {
  expect(apostropheFaults(fs.readFileSync(path.join(ROOT, page), 'utf8'))).toEqual([]);
});
