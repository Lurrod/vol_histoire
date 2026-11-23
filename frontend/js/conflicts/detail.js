/* Page d'un conflit étoffée (2026-11-22) : issue, contexte et guerre aérienne
 * en Markdown, dates clés, appareils rangés par camp avec ce qu'ils ont fait
 * dans ce conflit, sources. Les dates clés sont rendues par conflicts/dates.js.
 *
 * Données : GET /api/wars/:slug → outcome, context, narrative, sources[],
 * sides[{ key, name, members, count }], events[{ date (AAAA-MM-JJ),
 * precision (day|month|year), title, body, source, airplane }],
 * airplanes[{ …, side_key, role, role_sources[] }].
 * Un conflit pas encore rédigé n'a ni camps ni rôles : la page garde alors la
 * grille de cartes habituelle.
 *
 * Rendu : Markdown par VH.details.markdown (même rendu que les récits des
 * fiches) puis safeSetHTML ; les autres fragments sont construits ici avec
 * des données toutes échappées (escapeHtml).
 */
(function () {
  const root = typeof window !== 'undefined' ? window : globalThis;
  root.VH = root.VH || {};
  root.VH.conflicts = root.VH.conflicts || {};

  const esc = (s) => (typeof escapeHtml === 'function' ? escapeHtml(s) : String(s == null ? '' : s));

  function t(key, fallback, params) {
    const i = root.i18n;
    const v = i && typeof i.t === 'function' ? i.t(key, params) : null;
    if (v && v !== key) return v;
    return Object.keys(params || {}).reduce((s, k) => s.split(`{${k}}`).join(String(params[k])), fallback);
  }

  /** Texte échappé, *italique* Markdown rendu (noms d'opérations : *Desert Storm*). */
  function inline(text) {
    // Typographie française (insécables avant « : ; ? ! », dans les « »,
    // apostrophe ’), comme les récits Markdown des fiches.
    const md = root.VH.details && root.VH.details.markdown;
    const source = md && lang() === 'fr' ? md.typographyFr(String(text == null ? '' : text)) : text;
    return esc(source).replace(/\*([^*]+)\*/g, '<em>$1</em>');
  }

  function lang() {
    return root.i18n && root.i18n.currentLang === 'en' ? 'en' : 'fr';
  }

  /** Nom de domaine lisible d'une source (« en.wikipedia.org »). */
  function sourceHost(url) {
    try {
      return new URL(url).hostname.replace(/^www\./, '');
    } catch {
      return '';
    }
  }

  function detailsPath(id, name) {
    const build = root.VH.shared && root.VH.shared.buildDetailsPath;
    return build ? build(id, name) : `/details/${encodeURIComponent(id)}`;
  }

  function markdown(text) {
    const md = root.VH.details && root.VH.details.markdown;
    if (!text) return '';
    return md ? md.parse(text, { lang: lang() }) : `<p>${esc(text)}</p>`;
  }

  /** Remplit une section de prose et la montre si elle a du contenu. */
  function fillProse(sectionId, targetId, text, doc) {
    const d = doc || document;
    const section = d.getElementById(sectionId);
    const target = d.getElementById(targetId);
    if (!section || !target) return false;
    const html = markdown(text);
    safeSetHTML(target, html);
    section.classList.toggle('hidden', !html);
    return Boolean(html);
  }

  function thumbHtml(a) {
    const pic = root.VH.shared && root.VH.shared.picture;
    if (!a.image_url) return '<span class="role-thumb-empty"><i class="fas fa-plane" aria-hidden="true"></i></span>';
    return pic
      ? pic.thumbHtml(a.image_url, { alt: '', width: 160, height: 107, loading: 'lazy', decoding: 'async' })
      : `<img src="${esc(a.image_url)}" alt="" width="160" height="107" loading="lazy" decoding="async">`;
  }

  /** Carte « appareil + ce qu'il a fait » ; le lien couvre le nom. */
  function roleCardHtml(a) {
    const href = esc(detailsPath(a.id, a.name));
    const meta = [a.type_name, a.country_name].filter(Boolean).map(esc).join(' · ');
    // Un lien par site (deux pages de Wikipédia anglais → un seul « en.wikipedia.org »).
    const hosts = new Map();
    (a.role_sources || []).forEach((url) => {
      const host = sourceHost(url);
      if (host && !hosts.has(host)) hosts.set(host, url);
    });
    const sources = Array.from(hosts).slice(0, 3)
      .map(([host, url]) => `<a href="${esc(url)}" target="_blank" rel="noopener noreferrer">${esc(host)}</a>`)
      .join(', ');
    return `<li class="role-card" data-morph-id="${esc(a.id)}">
      <a class="role-thumb" href="${href}" tabindex="-1" aria-hidden="true" data-morph="photo">${thumbHtml(a)}</a>
      <div class="role-body">
        <h4 class="role-name"><a href="${href}">${esc(a.name)}</a></h4>
        ${meta ? `<p class="role-meta">${meta}</p>` : ''}
        <p class="role-text">${inline(a.role)}</p>
        ${sources ? `<p class="role-sources">${esc(t('conflicts.source_label', 'Source'))} : ${sources}</p>` : ''}
      </div>
    </li>`;
  }

  /**
   * Appareils répartis : un groupe par camp (dans l'ordre des camps), puis
   * « Dans plusieurs camps » (rôle sans camp), puis les appareils sans rôle.
   */
  function groupBySide(war) {
    const airplanes = war.airplanes || [];
    const withRole = airplanes.filter((a) => a.role);
    const groups = (war.sides || []).map((s) => ({
      key: s.key, name: s.name, members: s.members,
      airplanes: withRole.filter((a) => a.side_key === s.key),
    })).filter((g) => g.airplanes.length);
    const several = withRole.filter((a) => !a.side_key || !(war.sides || []).some((s) => s.key === a.side_key));
    if (several.length) {
      groups.push({ key: '', name: t('conflicts.several_sides', 'Dans plusieurs camps'), members: '', airplanes: several });
    }
    return { groups, rest: airplanes.filter((a) => !a.role) };
  }

  function sidesHtml(groups) {
    return groups.map((g) => `<section class="conflict-side"${g.key ? ` data-side="${esc(g.key)}"` : ''}>
      <header class="conflict-side-head">
        <h3 class="conflict-side-name">${esc(g.name)} <span class="conflict-side-count">${esc(g.airplanes.length)}</span></h3>
        ${g.members && g.members !== g.name ? `<p class="conflict-side-members">${esc(g.members)}</p>` : ''}
      </header>
      <ul class="role-list">${g.airplanes.map(roleCardHtml).join('')}</ul>
    </section>`).join('');
  }

  function sourcesHtml(urls) {
    return (urls || []).map((url) => {
      const host = sourceHost(url);
      return host ? `<li><a href="${esc(url)}" target="_blank" rel="noopener noreferrer">${esc(decodeSafe(url))}</a></li>` : '';
    }).join('');
  }

  /** URL lisible (« …/wiki/Guerre_du_Golfe ») ; l'adresse brute en repli. */
  function decodeSafe(url) {
    try {
      return decodeURI(url);
    } catch {
      return url;
    }
  }

  /**
   * Rend tout le contenu étoffé ; renvoie true si la page l'est (au moins un
   * rôle ou une section de texte), false pour un conflit pas encore rédigé.
   */
  function render(war, doc) {
    const d = doc || document;
    const outcome = d.getElementById('conflict-outcome');
    const outcomeText = d.getElementById('conflict-outcome-text');
    if (outcome && outcomeText) {
      outcomeText.innerHTML = inline(war.outcome || '');
      outcome.classList.toggle('hidden', !war.outcome);
    }
    const hasContext = fillProse('contexte', 'conflict-context', war.context, d);
    const hasNarrative = fillProse('guerre-aerienne', 'conflict-narrative', war.narrative, d);

    // Fragments construits ici, données toutes échappées : innerHTML direct,
    // comme les cartes d'appareil (safeSetHTML retirerait <picture>, <time>
    // et les target/rel des liens vers les sources).
    // Dates clés : bandeau d'onglets + panneau (conflicts/dates.js).
    const dates = root.VH.conflicts.dates;
    if (dates) dates.render(war, d);

    const { groups, rest } = groupBySide(war);
    const sidesBox = d.getElementById('conflict-sides');
    if (sidesBox) {
      sidesBox.innerHTML = sidesHtml(groups);
      sidesBox.classList.toggle('hidden', !groups.length);
    }
    const grid = d.getElementById('conflict-aircraft');
    if (grid) {
      const card = root.VH.shared && root.VH.shared.renderAircraftCard;
      grid.innerHTML = card ? rest.map((a) => card(a)).join('') : '';
      grid.classList.toggle('hidden', !rest.length);
      // Titre « Autres appareils » entre les camps et la grille, seulement
      // quand les deux existent.
      const old = d.getElementById('conflict-others-heading');
      if (old) old.remove();
      if (groups.length && rest.length) {
        grid.insertAdjacentHTML('beforebegin',
          `<h3 class="conflict-others-heading" id="conflict-others-heading">${esc(t('conflicts.other_aircraft', 'Autres appareils engagés'))}</h3>`);
      }
    }

    const sourcesSection = d.getElementById('sources');
    const sourcesList = d.getElementById('conflict-sources');
    if (sourcesSection && sourcesList) {
      const html = sourcesHtml(war.sources);
      sourcesList.innerHTML = html;
      sourcesSection.classList.toggle('hidden', !html);
    }
    return Boolean(groups.length || hasContext || hasNarrative);
  }

  root.VH.conflicts.detail = {
    sourceHost, inline, groupBySide, roleCardHtml, sidesHtml, sourcesHtml, render,
  };

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = root.VH.conflicts.detail;
  }
})();
