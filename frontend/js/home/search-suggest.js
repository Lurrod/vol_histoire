/* Suggestions de la recherche du hero (accueil).
 *
 * La recherche plein texte de l'API ne fait pas de préfixe : « mira » ne trouve
 * rien, « mirage » trouve. Une liste de suggestions doit pourtant réagir dès
 * les premières lettres. On charge donc une seule fois la liste des appareils
 * (quatre pages de 100, ~30 Ko compressés) à la première interaction avec le
 * champ — jamais au chargement de la page — et on filtre ici.
 *
 * Logique pure (compact, toEntry, score, match) exportée pour Jest ; le
 * branchement DOM suit le motif combobox ARIA (aria-activedescendant : le
 * focus reste dans le champ, la liste ne fait que le refléter).
 */
(function () {
  const root = typeof window !== 'undefined' ? window : globalThis;
  root.VH = root.VH || {};
  root.VH.home = root.VH.home || {};

  const MAX_SUGGESTIONS = 6;
  const PAGE_SIZE = 100; // plafond serveur de ?limit

  /* ---------- Logique pure ---------- */

  /** « F-16 Fighting Falcon » → « f16fightingfalcon » : ni casse, ni accents,
   *  ni tirets ni espaces — « f16 », « F 16 » et « f-16 » se valent. */
  function compact(s) {
    return String(s == null ? '' : s)
      .toLowerCase()
      .normalize('NFD')
      .replace(/\p{M}/gu, '') // diacritiques, séparés de leur lettre par NFD
      .replace(/[^a-z0-9]+/g, '');
  }

  function toEntry(aircraft) {
    return {
      ...aircraft,
      key: compact(aircraft.name),
      words: String(aircraft.name || '').split(/\s+/).map(compact),
      full: compact(aircraft.complete_name),
    };
  }

  /** Rang de pertinence (plus petit = meilleur) ; -1 si aucune correspondance.
   *  0 : le nom commence par la saisie (« mira » → Mirage 2000)
   *  1 : un mot du nom commence par elle (« falcon » → F-16 Fighting Falcon)
   *  2 : le nom la contient
   *  3 : seul le nom complet la contient (constructeur : « dassault »)   */
  function score(entry, q) {
    if (!q) return -1;
    if (entry.key.startsWith(q)) return 0;
    if (entry.words.some((w) => w.startsWith(q))) return 1;
    if (entry.key.includes(q)) return 2;
    if (entry.full.includes(q)) return 3;
    return -1;
  }

  /** Toutes les correspondances, triées : rang, puis nom le plus court
   *  (« MiG-21 » avant « MiG-21 Bison »), puis ordre alphabétique. */
  function match(entries, query) {
    const q = compact(query);
    if (!q) return [];
    return entries
      .map((entry) => ({ entry, rank: score(entry, q) }))
      .filter((r) => r.rank >= 0)
      .sort((a, b) => a.rank - b.rank
        || a.entry.name.length - b.entry.name.length
        || a.entry.name.localeCompare(b.entry.name))
      .map((r) => r.entry);
  }

  /* ---------- Index (chargé une fois, à la demande) ---------- */

  let indexPromise = null;

  async function fetchPage(page) {
    const res = await auth.fetchWithTimeout(`/api/airplanes?limit=${PAGE_SIZE}&page=${page}`);
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    return res.json();
  }

  function loadIndex() {
    if (indexPromise) return indexPromise;
    indexPromise = fetchPage(1)
      .then(async (first) => {
        const pages = Math.ceil((first.total || 0) / PAGE_SIZE);
        const rest = [];
        for (let p = 2; p <= pages; p++) rest.push(fetchPage(p));
        const more = await Promise.all(rest);
        return [first, ...more].flatMap((p) => p.data || []).map(toEntry);
      })
      .catch((err) => {
        indexPromise = null; // nouvelle tentative à la prochaine frappe
        throw err;
      });
    return indexPromise;
  }

  /* ---------- DOM ---------- */

  function optionHtml(entry, i) {
    const { tr } = VH.home.text;
    const gen = entry.generation
      && (String(entry.generation) === '1' ? tr('gen_short_1') : tr('gen_short_other', { n: entry.generation }));
    // Index chargé avec ?lang= : country_name et type_name sont déjà traduits.
    const meta = [entry.country_name, gen, entry.type_name].filter(Boolean).map(escapeHtml).join(' · ');
    const thumb = VH.shared.picture.thumbHtml(entry.image_url, { alt: '', width: '96', height: '64', loading: 'lazy' });
    return `
      <li class="hero-suggest-item" id="hero-suggest-opt-${i}" role="option" aria-selected="false" data-index="${i}">
        <span class="hero-suggest-thumb">${thumb}</span>
        <span class="hero-suggest-text">
          <span class="hero-suggest-name">${escapeHtml(entry.name)}</span>
          <span class="hero-suggest-meta">${meta}</span>
        </span>
      </li>`;
  }

  /* Structure attendue : le champ (role=combobox) désigne par aria-controls un
   * role=listbox placé dans un panneau .hero-suggest, à côté d'un pied
   * .hero-suggest-footer. Le pied reste hors du listbox, qui ne doit contenir
   * que des options (règle axe aria-required-children). */
  function mount(form) {
    const input = form && form.querySelector('[role="combobox"]');
    const list = input && document.getElementById(input.getAttribute('aria-controls'));
    const panel = list && list.closest('.hero-suggest');
    const footer = panel && panel.querySelector('.hero-suggest-footer');
    const status = form && form.querySelector('[role="status"]');
    if (!input || !list || !panel || !footer) return;

    const { tr, trn } = VH.home.text;
    let targets = [];
    let active = -1;
    let timer = null;

    function close() {
      panel.hidden = true;
      list.innerHTML = '';
      footer.innerHTML = '';
      input.setAttribute('aria-expanded', 'false');
      input.removeAttribute('aria-activedescendant');
      targets = [];
      active = -1;
    }

    function setActive(i) {
      active = i;
      list.querySelectorAll('[role="option"]').forEach((el, j) => {
        el.setAttribute('aria-selected', String(j === i));
      });
      const el = i >= 0 ? document.getElementById(`hero-suggest-opt-${i}`) : null;
      if (el) {
        input.setAttribute('aria-activedescendant', el.id);
        el.scrollIntoView({ block: 'nearest' });
      } else {
        input.removeAttribute('aria-activedescendant');
      }
    }

    function render(query, results) {
      const shown = results.slice(0, MAX_SUGGESTIONS);
      targets = shown.map((a) => VH.shared.buildDetailsPath(a.id, a.name));
      list.innerHTML = shown.map(optionHtml).join('');
      // Un listbox vide est masqué : seul le message « aucun appareil » reste.
      list.hidden = !shown.length;
      footer.innerHTML = results.length
        ? `<button type="submit" class="hero-suggest-all" tabindex="-1">${escapeHtml(tr('search_all', { q: query }))}</button>`
        : `<p class="hero-suggest-empty">${escapeHtml(tr('search_empty'))}</p>`;
      panel.hidden = false;
      input.setAttribute('aria-expanded', 'true');
      active = -1;
      if (status) {
        status.textContent = shown.length ? trn('search_status', shown.length) : tr('search_status_none');
      }
    }

    async function update() {
      const query = input.value.trim();
      if (!query) { close(); return; }
      try {
        const index = await loadIndex();
        if (input.value.trim() !== query) return; // une frappe plus récente a pris le relais
        render(query, match(index, query));
      } catch {
        close(); // sans index, le formulaire reste utilisable tel quel
      }
    }

    function go(i) {
      if (targets[i]) window.location.assign(targets[i]);
    }

    // Préchargement dès le focus : l'index est prêt avant la première lettre.
    input.addEventListener('focus', () => { loadIndex().catch(() => {}); }, { once: true });
    input.addEventListener('input', () => {
      clearTimeout(timer);
      timer = setTimeout(update, 120);
    });

    input.addEventListener('keydown', (e) => {
      if (panel.hidden) {
        if (e.key === 'ArrowDown' && input.value.trim()) { e.preventDefault(); update(); }
        return;
      }
      if (e.key === 'ArrowDown' && targets.length) {
        e.preventDefault();
        setActive((active + 1) % targets.length);
      } else if (e.key === 'ArrowUp' && targets.length) {
        e.preventDefault();
        setActive(active <= 0 ? targets.length - 1 : active - 1);
      } else if (e.key === 'Enter' && active >= 0) {
        e.preventDefault();
        go(active);
      } else if (e.key === 'Escape') {
        e.preventDefault();
        close();
      }
    });

    // mousedown plutôt que click : le champ garde le focus jusqu'à la navigation
    // (sinon son blur fermerait le panneau avant que le clic n'arrive).
    panel.addEventListener('mousedown', (e) => {
      if (e.target.closest('.hero-suggest-all')) { e.preventDefault(); return; }
      const item = e.target.closest('[role="option"]');
      if (!item) return;
      e.preventDefault();
      go(Number(item.dataset.index));
    });
    list.addEventListener('mousemove', (e) => {
      const item = e.target.closest('[role="option"]');
      if (item && Number(item.dataset.index) !== active) setActive(Number(item.dataset.index));
    });

    input.addEventListener('blur', () => { setTimeout(close, 150); });
  }

  VH.home.searchSuggest = { MAX_SUGGESTIONS, compact, toEntry, score, match, mount };

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = VH.home.searchSuggest;
  }
})();
