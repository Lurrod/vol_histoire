#!/usr/bin/env node
/**
 * Scope toutes les règles d'un fichier CSS sous un sélecteur parent.
 * Usage : node scripts/scope-css.js <file.css> <scope-selector>
 *
 * Parseur récursif : gère les @media/@supports imbriqués en scopant les
 * règles à l'intérieur de leur body. Les @keyframes / @font-face / @import
 * sont laissés tels quels (pas de sélecteurs à scoper dedans).
 */
const fs = require('fs');
const path = require('path');

const [,, file, scope] = process.argv;
if (!file || !scope) {
  console.error('Usage: node scripts/scope-css.js <file.css> <scope-selector>');
  process.exit(1);
}

const src = fs.readFileSync(file, 'utf8');
const output = scopeCss(src, scope);
fs.writeFileSync(file, output, 'utf8');
console.log(`scoped ${path.basename(file)} under "${scope}"`);

// -----------------------------------------------------------------------------

function scopeCss(css, scope) {
  const tokens = tokenize(css);
  return render(tokens, scope);
}

/* Tokenize CSS into a flat tree :
 *   { type: 'rule',    selector: '...', body: [tokens] }
 *   { type: 'atrule',  name: '@media', prelude: '...', body: [tokens] | null }
 *   { type: 'decl',    text: 'color: red;' }
 *   { type: 'comment', text: '/* ... *\/' }
 *   { type: 'ws',      text: '  \n' }
 */
function tokenize(css) {
  let i = 0;
  const len = css.length;

  function peek() { return css[i]; }
  function rest() { return css.slice(i); }

  function skipComment() {
    if (css[i] === '/' && css[i + 1] === '*') {
      const end = css.indexOf('*/', i + 2);
      const text = end === -1 ? css.slice(i) : css.slice(i, end + 2);
      i = end === -1 ? len : end + 2;
      return { type: 'comment', text };
    }
    return null;
  }

  function skipWs() {
    const start = i;
    while (i < len && /\s/.test(css[i])) i++;
    return start === i ? null : { type: 'ws', text: css.slice(start, i) };
  }

  function readUntilBalanced(open, close) {
    // Read everything from current position until matching close
    // Returns the inner content (exclusive of the close)
    let depth = 1;
    const start = i;
    while (i < len && depth > 0) {
      const c = css[i];
      if (c === '/' && css[i + 1] === '*') {
        const end = css.indexOf('*/', i + 2);
        i = end === -1 ? len : end + 2;
        continue;
      }
      if (c === '"' || c === "'") {
        i++;
        while (i < len && css[i] !== c) {
          if (css[i] === '\\') i++;
          i++;
        }
        i++;
        continue;
      }
      if (c === open) depth++;
      else if (c === close) depth--;
      if (depth > 0) i++;
    }
    const inner = css.slice(start, i);
    if (i < len && css[i] === close) i++;
    return inner;
  }

  function parseSelectorOrPrelude() {
    // Read until '{' or ';' (for @import etc.)
    let buf = '';
    while (i < len) {
      const c = css[i];
      if (c === '/' && css[i + 1] === '*') {
        const end = css.indexOf('*/', i + 2);
        buf += css.slice(i, end === -1 ? len : end + 2);
        i = end === -1 ? len : end + 2;
        continue;
      }
      if (c === '{' || c === ';') break;
      if (c === '"' || c === "'") {
        const quote = c;
        buf += c; i++;
        while (i < len && css[i] !== quote) {
          if (css[i] === '\\') { buf += css[i]; i++; }
          buf += css[i]; i++;
        }
        if (i < len) { buf += css[i]; i++; }
        continue;
      }
      buf += c;
      i++;
    }
    return buf;
  }

  function parseBlock(stopOnClose) {
    const tokens = [];
    while (i < len) {
      if (stopOnClose && css[i] === '}') { i++; return tokens; }

      const ws = skipWs();
      if (ws) { tokens.push(ws); continue; }
      const cm = skipComment();
      if (cm) { tokens.push(cm); continue; }

      if (css[i] === '@') {
        // at-rule
        const prelude = parseSelectorOrPrelude();
        if (i < len && css[i] === ';') {
          i++;
          tokens.push({ type: 'atrule', name: prelude.split(/\s+/)[0], prelude, body: null, terminator: ';' });
          continue;
        }
        if (i < len && css[i] === '{') {
          i++;
          const body = parseBlock(true);
          tokens.push({ type: 'atrule', name: prelude.split(/\s+/)[0], prelude, body });
          continue;
        }
        // eof
        tokens.push({ type: 'atrule', name: prelude.split(/\s+/)[0], prelude, body: null });
        continue;
      }

      // rule or decl
      const prelude = parseSelectorOrPrelude();
      if (i < len && css[i] === '{') {
        i++;
        const body = parseBlock(true);
        tokens.push({ type: 'rule', selector: prelude, body });
      } else if (i < len && css[i] === ';') {
        i++;
        tokens.push({ type: 'decl', text: prelude + ';' });
      } else {
        // eof
        if (prelude.trim()) tokens.push({ type: 'decl', text: prelude });
      }
    }
    return tokens;
  }

  return parseBlock(false);
}

function renderUnscoped(tokens) {
  // Rendu brut sans scoping — pour l'intérieur de @keyframes et autres at-rules
  // dont le contenu n'est pas composé de sélecteurs classiques.
  let out = '';
  for (const tok of tokens) {
    switch (tok.type) {
      case 'ws':
      case 'comment':
      case 'decl':
        out += tok.text;
        break;
      case 'atrule':
        if (tok.body === null) out += tok.prelude + (tok.terminator || ';');
        else out += tok.prelude + '{' + renderUnscoped(tok.body) + '}';
        break;
      case 'rule':
        out += tok.selector + '{' + renderUnscoped(tok.body) + '}';
        break;
    }
  }
  return out;
}

function render(tokens, scope) {
  let out = '';
  for (const tok of tokens) {
    switch (tok.type) {
      case 'ws':
      case 'comment':
        out += tok.text;
        break;
      case 'decl':
        out += tok.text;
        break;
      case 'atrule':
        if (tok.body === null) {
          out += tok.prelude + (tok.terminator || ';');
        } else if (/^@(keyframes|font-face|page|counter-style|property)\b/.test(tok.name)) {
          // Ne PAS scoper l'intérieur — ce ne sont pas des sélecteurs classiques
          // (@keyframes contient `from`/`to`/`50%`, @font-face des descriptors, etc.)
          out += tok.prelude + '{' + renderUnscoped(tok.body) + '}';
        } else {
          // @media / @supports / @layer / autres : scoper les rules à l'intérieur
          out += tok.prelude + '{' + render(tok.body, scope) + '}';
        }
        break;
      case 'rule':
        out += prefixSelectors(tok.selector, scope) + '{' + render(tok.body, scope) + '}';
        break;
    }
  }
  return out;
}

function prefixSelectors(selectorLine, scope) {
  const parts = splitTopLevel(selectorLine, ',');
  return parts.map(p => {
    const leading = p.match(/^\s*/)[0];
    const trailing = p.match(/\s*$/)[0];
    const s = p.trim();
    if (!s) return p;
    if (s.startsWith(scope)) return p;
    // Cas spécial : les sélecteurs qui commencent par `body` ou `html` doivent
    // se FUSIONNER avec le scope (body.page-X) au lieu d'être en descendance
    // (.page-X body) — cette descendance est invalide puisque le scope est
    // lui-même appliqué au <body>.
    const rootMatch = s.match(/^(body|html)\b/);
    if (rootMatch) {
      const root = rootMatch[0];
      const rest = s.slice(root.length);
      return leading + root + scope + rest + trailing;
    }
    return leading + scope + ' ' + s + trailing;
  }).join(',');
}

function splitTopLevel(str, sep) {
  const out = [];
  let cur = '';
  let depth = 0;
  for (let j = 0; j < str.length; j++) {
    const ch = str[j];
    if (ch === '(' || ch === '[') depth++;
    else if (ch === ')' || ch === ']') depth--;
    if (ch === sep && depth === 0) {
      out.push(cur);
      cur = '';
    } else {
      cur += ch;
    }
  }
  out.push(cur);
  return out;
}
