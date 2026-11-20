/* Tableau des départs de la 404 : un panneau à palettes d'aéroport. La page
 * demandée y figure en « ANNULÉ », suivie de quatre vols vers des appareils
 * réels du catalogue (chaque ligne mène à sa fiche). Les palettes tournent
 * avant de s'arrêter, de gauche à droite et ligne après ligne.
 * Lecteurs d'écran : une phrase complète par ligne (sr-only), palettes masquées.
 * Mouvements réduits : texte posé directement. Bascule : Web Animations (CSP).
 * Textes : clés error404.* (i18n.js), repli français si la langue manque. */
(function () {
  const COLS = { time: 5, flight: 5, dest: 12, gate: 3, status: 12 };
  const FLIGHTS = 4;
  const TICK = 55;
  const ROW_STAGGER = 4;     // ticks entre deux lignes
  const CHAR_STAGGER = 1;    // ticks entre deux palettes d'une ligne
  const SPIN = [5, 9];       // nombre de bascules aléatoires avant l'arrêt
  const START_DELAY = 700;
  const CHARSET = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  const I18N_WAIT = 1500;
  const STATUSES = [
    { key: 'status_boarding', fr: 'EMBARQUEMENT', cls: 'is-boarding' },
    { key: 'status_on_time', fr: 'À L’HEURE' },
    { key: 'status_on_time', fr: 'À L’HEURE' },
    { key: 'status_delayed', fr: 'RETARDÉ' },
  ];
  // Repli sans réseau : les vols partent vers les rubriques du site.
  const FALLBACK = [
    { key: 'dest_hangar', fr: 'HANGAR', href: '/hangar', flight: 'VH001', gate: 'H' },
    { key: 'dest_timeline', fr: 'CHRONOLOGIE', href: '/timeline', flight: 'VH002', gate: 'C' },
    { key: 'dest_conflicts', fr: 'CONFLITS', href: '/conflits', flight: 'VH003', gate: 'W' },
    { key: 'dest_home', fr: 'ACCUEIL', href: '/', flight: 'VH004', gate: 'A' },
  ];

  function reduced() {
    return !!(window.VH && VH.motion && VH.motion.prefersReducedMotion());
  }

  /** Texte traduit (error404.<key>) ou repli français, avec {param}. */
  function t(key, fallback, params = {}) {
    const i18n = window.i18n;
    const full = `error404.${key}`;
    const v = i18n && typeof i18n.t === 'function' ? i18n.t(full, params) : null;
    if (v && v !== full) return v;
    return fallback.replace(/\{(\w+)\}/g, (m, k) => (k in params ? String(params[k]) : m));
  }

  /** Attend les traductions (au plus I18N_WAIT ms) : le tableau s'écrit une seule fois. */
  function whenI18n() {
    const i18n = window.i18n;
    if (!i18n || i18n.isLoaded) return Promise.resolve();
    return new Promise((resolve) => {
      window.addEventListener('i18nReady', resolve, { once: true });
      setTimeout(resolve, I18N_WAIT);
    });
  }

  const lower = (s) => s.toLocaleLowerCase();

  const fit = (str, n) => {
    const s = String(str || '').toUpperCase();
    return s.length > n ? s.slice(0, n) : s.padEnd(n, ' ');
  };
  const hhmm = (d) => `${String(d.getHours()).padStart(2, '0')}:${String(d.getMinutes()).padStart(2, '0')}`;

  /** Nom du vol annulé, tiré de l'adresse manquante (404.js) : « RAFAL », « MIRAGE 2000 C ». */
  function lostName(path) {
    const e404 = window.VH && window.VH.e404;
    const q = e404 ? e404.queryFromPath(path) : '';
    return q ? q.toUpperCase() : t('lost_default', 'PAGE 404');
  }

  /** Heures de départ : de 5 en 5 minutes à partir de maintenant. */
  function departureTimes(now, offsets) {
    const base = new Date(now);
    base.setSeconds(0, 0);
    base.setMinutes(Math.ceil(base.getMinutes() / 5) * 5);
    return offsets.map((m) => hhmm(new Date(base.getTime() + m * 60000)));
  }

  // ---------- Palettes ----------

  function flapField(cls, width) {
    const fld = document.createElement('span');
    fld.className = `e4-fld ${cls}`;
    const cells = [];
    for (let i = 0; i < width; i++) {
      const c = document.createElement('span');
      c.className = 'e4-flap';
      c.textContent = ' ';
      fld.appendChild(c);
      cells.push(c);
    }
    return { fld, cells };
  }

  function show(cell, ch, animate) {
    cell.textContent = ch === ' ' ? ' ' : ch;
    if (animate && cell.animate) {
      cell.animate(
        [{ transform: 'rotateX(80deg)', filter: 'brightness(1.8)' }, { transform: 'none', filter: 'none' }],
        { duration: TICK * 1.3, easing: 'ease-out' }
      );
    }
  }

  /**
   * Fait tourner une liste de palettes jusqu'à leur caractère final.
   * jobs : [{ cell, ch, start }] (start en ticks). Résout quand tout est posé.
   */
  function spin(jobs) {
    if (reduced()) {
      jobs.forEach((j) => show(j.cell, j.ch, false));
      return Promise.resolve();
    }
    const plan = jobs.map((j) => ({
      ...j,
      end: j.start + (j.ch === ' ' ? 0 : SPIN[0] + Math.floor(Math.random() * (SPIN[1] - SPIN[0]))),
    }));
    return new Promise((resolve) => {
      let tick = 0;
      const id = setInterval(() => {
        let pending = 0;
        plan.forEach((j) => {
          if (j.done) return;
          pending++;
          if (tick < j.start) return;
          if (tick >= j.end) { show(j.cell, j.ch, j.ch !== ' '); j.done = true; return; }
          show(j.cell, CHARSET[Math.floor(Math.random() * CHARSET.length)], true);
        });
        tick++;
        if (!pending) { clearInterval(id); resolve(); }
      }, TICK);
    });
  }

  // ---------- Lignes ----------

  /** Une ligne vide (hauteur réservée) ; remplie plus tard par fill(). */
  function buildRow(board) {
    const li = document.createElement('li');
    const row = document.createElement('a');
    row.className = 'e4-fids-row';
    const sr = document.createElement('span');
    sr.className = 'sr-only';
    const fields = {
      time: flapField('is-time', COLS.time),
      flight: flapField('is-flight', COLS.flight),
      dest: flapField('is-dest', COLS.dest),
      gate: flapField('is-gate', COLS.gate),
      status: flapField('is-status', COLS.status),
    };
    const visual = document.createDocumentFragment();
    Object.values(fields).forEach((f) => {
      f.fld.setAttribute('aria-hidden', 'true');
      visual.appendChild(f.fld);
    });
    row.append(sr, visual);
    li.appendChild(row);
    board.appendChild(li);
    return { li, row, sr, fields };
  }

  /** Programme les palettes d'une ligne ; `order` décale la ligne dans la cascade. */
  function fill(r, data, order) {
    if (data.href) r.row.href = data.href;
    if (data.cls) r.row.classList.add(data.cls);
    r.sr.textContent = data.sr;
    const jobs = [];
    let k = 0;
    ['time', 'flight', 'dest', 'gate', 'status'].forEach((key) => {
      const text = fit(data[key], COLS[key]);
      r.fields[key].cells.forEach((cell, i) => {
        jobs.push({ cell, ch: text[i], start: order * ROW_STAGGER + k * CHAR_STAGGER });
        k++;
      });
    });
    return jobs;
  }

  // ---------- Données ----------

  async function pickAircraft(n) {
    const get = async (q) => {
      const res = await fetch(`/api/airplanes?${q}`);
      if (!res.ok) throw new Error(`HTTP ${res.status}`);
      return res.json();
    };
    const head = await get('limit=1&page=1');
    const pages = Math.max(1, Math.floor((Number(head.total) || 0) / 100));
    const page = await get(`limit=100&page=${1 + Math.floor(Math.random() * pages)}`);
    const fits = (page.data || []).filter((a) => a.name && a.name.length <= COLS.dest);
    for (let i = fits.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [fits[i], fits[j]] = [fits[j], fits[i]];
    }
    if (fits.length < n) throw new Error('pas assez d’appareils');
    return fits.slice(0, n);
  }

  /** Phrase lue par les lecteurs d'écran pour un vol. */
  function flightSentence(flight, name, time, gate, status) {
    const gatePart = gate ? t('sr_gate', ', porte {gate}', { gate }) : '';
    return t('sr_flight', 'Vol {flight} à destination de {name}, départ {time}{gate}, {status}.',
      { flight, name, time, gate: gatePart, status: lower(status) });
  }

  /** Lignes de vol : appareils du catalogue (avec href) ou rubriques de repli. */
  function flightsFrom(list, times) {
    return list.map((a, i) => {
      const st = STATUSES[i] || STATUSES[1];
      const status = t(st.key, st.fr);
      return {
        time: times[i], flight: a.flight, dest: a.name, gate: a.gate, status, cls: st.cls, href: a.href,
        sr: flightSentence(a.flight, a.name, times[i], a.gate, status),
      };
    });
  }

  function aircraftFlights(list) {
    return list.map((a) => ({
      flight: `VH${String(a.id).padStart(3, '0')}`,
      name: a.name,
      gate: a.country_code || '',
      href: VH.shared.buildDetailsPath(a.id, a.name),
    }));
  }

  const fallbackFlights = () => FALLBACK.map((f) => ({ flight: f.flight, name: t(f.key, f.fr), gate: f.gate, href: f.href }));

  // ---------- Horloge ----------

  function startClock(clockEl) {
    const { fld, cells } = flapField('is-clock', 5);
    clockEl.appendChild(fld);
    let shown = '';
    const update = () => {
      const now = hhmm(new Date());
      if (now === shown) return;
      const prev = shown;
      shown = now;
      spin(cells.map((cell, i) => ({ cell, ch: now[i], start: 0 }))
        .filter((j, i) => prev[i] !== now[i]));
    };
    update();
    setInterval(update, 1000);
  }

  // ---------- Montage ----------

  async function setup() {
    const board = document.getElementById('e4-fids-board');
    if (!board) return;
    const clock = document.getElementById('e4-fids-clock');
    if (clock) startClock(clock);

    const now = new Date();
    const path = window.VH && VH.e404 ? VH.e404.missingPath() : window.location.pathname;
    const cancelled = buildRow(board);
    cancelled.row.removeAttribute('href');
    const rows = Array.from({ length: FLIGHTS }, () => buildRow(board));
    const times = departureTimes(now, [5, 15, 25, 40]);

    const list = pickAircraft(FLIGHTS).then(aircraftFlights).catch((err) => {
      if (window.Sentry && window.Sentry.captureException) window.Sentry.captureException(err);
      return null;
    });
    await Promise.all([whenI18n(), new Promise((r) => setTimeout(r, reduced() ? 0 : START_DELAY))]);

    const cancelledStatus = t('status_cancelled', 'ANNULÉ');
    const name = lostName(path);
    const first = spin(fill(cancelled, {
      time: hhmm(now), flight: 'VH404', dest: name, gate: '', status: cancelledStatus, cls: 'is-cancelled',
      sr: t('sr_cancelled', 'Vol VH404 à destination de {name} : annulé, cette page n’existe pas.', { name: lower(name) }),
    }, 0));

    const flights = flightsFrom((await list) || fallbackFlights(), times);
    const jobs = flights.flatMap((f, i) => fill(rows[i], f, i + 1));
    await Promise.all([first, spin(jobs)]);
    rows.concat(cancelled).forEach((r) => r.row.classList.add('is-settled'));
  }

  if (typeof document !== 'undefined') document.addEventListener('DOMContentLoaded', setup);

  if (typeof module !== 'undefined' && module.exports) module.exports = { lostName, departureTimes, fit, t, setup };
})();
