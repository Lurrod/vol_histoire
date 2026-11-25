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
