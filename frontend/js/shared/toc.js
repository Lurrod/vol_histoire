/* VH.toc — sommaire collant avec suivi de lecture (2026-11-21).
 *
 * D'après le comportement du « Hook Sidebar » de Rare UI — licence sans
 * portage autorisé : aucun code repris. Un filet pointillé or descend du haut
 * de la liste jusqu'à la section en cours et s'y termine par un crochet
 * arrondi ; au survol, un second filet, plus pâle, s'arrête sur le lien visé.
 * Sous 75em, le sommaire devient une barre collante « Sommaire · section en
 * cours » qui déplie la liste.
 *
 * Déclaration dans la page : un conteneur [data-toc] portant
 *   data-toc-sections : sélecteur des sections (enfants du conteneur) ;
 *   data-toc-min      : nombre minimal de sections (défaut 4).
 * Le sommaire est inséré juste avant le conteneur. Les sections masquées
 * (.hidden, display: none) sont ignorées ; le sommaire se reconstruit quand
 * l'une d'elles apparaît (fiche : sections remplies après le chargement).
 *
 * Positions posées en CSSOM (--toc-y, --toc-hy) : la CSP interdit les
 * attributs style, pas le CSSOM.
 */
(function () {
  const root = typeof window !== 'undefined' ? window : globalThis;
  root.VH = root.VH || {};

  const DEFAULT_MIN = 4;
  const SPY_RATIO = 0.3;      // une section est « en cours » quand son titre passe sous 30 % de l'écran

  let uid = 0;

  function t(key, fallback) {
    const i18n = root.i18n;
    const v = i18n && typeof i18n.t === 'function' ? i18n.t(key) : null;
    return v && v !== key ? v : fallback;
  }

  function reduced() {
    const m = root.VH.motion;
    return Boolean(m && typeof m.prefersReducedMotion === 'function' && m.prefersReducedMotion());
  }

  function isShown(el) {
    return !el.classList.contains('hidden') && !el.hidden && el.getClientRects().length > 0;
  }

  function slug(text, i) {
    const s = String(text).toLowerCase().normalize('NFD').replace(/[̀-ͯ]/g, '')
      .replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '').slice(0, 40);
    return 'toc-' + (s || 'section') + '-' + i;
  }

  function labelOf(section) {
    const h = section.querySelector('h2');
    return h ? h.textContent.replace(/\s+/g, ' ').trim() : '';
  }

  function build(host) {
    const id = 'toc-' + (++uid);
    const nav = document.createElement('nav');
    nav.className = 'toc';
    nav.setAttribute('aria-labelledby', id + '-title');
    nav.innerHTML =
      '<button type="button" class="toc-toggle" aria-expanded="false" aria-controls="' + id + '-list">' +
        '<span class="toc-toggle-title"></span><span class="toc-toggle-current"></span>' +
        '<i class="fas fa-chevron-down" aria-hidden="true"></i>' +
      '</button>' +
      '<div class="toc-panel">' +
        '<p class="toc-title" id="' + id + '-title"></p>' +
        '<div class="toc-track">' +
          '<span class="toc-rail toc-rail--hover" aria-hidden="true"></span>' +
          '<span class="toc-rail toc-rail--active" aria-hidden="true"></span>' +
          '<ol class="toc-list" id="' + id + '-list"></ol>' +
        '</div>' +
      '</div>';
    host.parentNode.insertBefore(nav, host);
    host.parentNode.classList.add('has-toc');
    return nav;
  }

  function mount(host) {
    const selector = host.getAttribute('data-toc-sections') || 'section';
    const min = parseInt(host.getAttribute('data-toc-min'), 10) || DEFAULT_MIN;
    let nav = null;
    let items = [];          // [{ section, link }]
    let active = -1;
    let frame = 0;

    function sections() {
      return Array.from(host.querySelectorAll(selector)).filter((s) => isShown(s) && labelOf(s));
    }

    function setTexts() {
      if (!nav) return;
      const title = t('toc.title', 'Sommaire');
      nav.querySelector('.toc-title').textContent = title;
      nav.querySelector('.toc-toggle-title').textContent = title;
      items.forEach(({ section, link }) => { link.textContent = labelOf(section); });
      const current = items[active];
      nav.querySelector('.toc-toggle-current').textContent = current ? current.link.textContent : '';
    }

    function linkY(link) {
      return link.offsetTop + link.offsetHeight / 2;
    }

    function setActive(index) {
      if (!nav || index === active || !items[index]) return;
      if (items[active]) {
        items[active].link.classList.remove('is-active');
        items[active].link.removeAttribute('aria-current');
      }
      active = index;
      const { link } = items[index];
      link.classList.add('is-active');
      link.setAttribute('aria-current', 'location');
      nav.style.setProperty('--toc-y', linkY(link) + 'px');
      nav.querySelector('.toc-toggle-current').textContent = link.textContent;
    }

    function spy() {
      frame = 0;
      if (!nav || !items.length) return;
      const line = root.innerHeight * SPY_RATIO;
      let index = 0;
      items.forEach(({ section }, i) => {
        if (section.getBoundingClientRect().top <= line) index = i;
      });
      // Bas de page atteint : la dernière section, même courte, est la bonne.
      const doc = document.documentElement;
      if (root.innerHeight + root.scrollY >= doc.scrollHeight - 2) index = items.length - 1;
      setActive(index);
    }

    // Pendant le défilement doux qui suit un clic, le suivi attend : sinon il
    // désignait chaque section traversée et le point faisait des allers-retours.
    let locked = false;
    let unlockTimer = 0;

    function unlock() {
      locked = false;
      root.clearTimeout(unlockTimer);
      root.removeEventListener('scrollend', unlock);
      schedule();
    }

    function goTo(i) {
      const { section } = items[i];
      setActive(i);
      locked = true;
      root.addEventListener('scrollend', unlock, { once: true });
      root.clearTimeout(unlockTimer);
      unlockTimer = root.setTimeout(unlock, 1500); // filet : pas de scrollend (Safari) ou pas de défilement
      section.scrollIntoView({ behavior: reduced() ? 'auto' : 'smooth', block: 'start' });
      root.history.replaceState(root.history.state, '', root.location.pathname + root.location.search + '#' + section.id);
      // Focus sur la section, sans second défilement, pour les lecteurs d'écran
      if (!section.hasAttribute('tabindex')) section.setAttribute('tabindex', '-1');
      section.focus({ preventScroll: true });
    }

    function schedule() {
      if (!frame && !locked) frame = root.requestAnimationFrame(spy);
    }

    function setOpen(open) {
      nav.classList.toggle('is-open', open);
      nav.querySelector('.toc-toggle').setAttribute('aria-expanded', String(open));
    }

    function refresh() {
      const list = sections();
      if (list.length < min) {
        if (nav) { nav.remove(); host.parentNode.classList.remove('has-toc'); nav = null; }
        items = [];
        return;
      }
      if (!nav) {
        nav = build(host);
        wire();
      } else if (list.length === items.length && list.every((s, i) => items[i].section === s)) {
        // Mêmes sections (une classe a changé ailleurs) : rien à reconstruire.
        setTexts();
        if (!locked) spy();
        return;
      }
      const ol = nav.querySelector('.toc-list');
      ol.textContent = '';
      items = list.map((section, i) => {
        if (!section.id) section.id = slug(labelOf(section), i + 1);
        section.setAttribute('data-toc-target', '');
        const li = document.createElement('li');
        const link = document.createElement('a');
        link.className = 'toc-link';
        // Adresse complète : la fiche déclare <base href="/">, où « #x »
        // mènerait à l'accueil.
        link.href = root.location.pathname + root.location.search + '#' + section.id;
        li.appendChild(link);
        ol.appendChild(li);
        return { section, link };
      });
      active = -1;
      setTexts();
      if (!locked) spy();
    }

    function wire() {
      const track = nav.querySelector('.toc-track');
      track.addEventListener('pointerover', (e) => {
        const link = e.target.closest && e.target.closest('.toc-link');
        if (!link) return;
        nav.style.setProperty('--toc-hy', linkY(link) + 'px');
        nav.classList.add('is-hovering');
      });
      track.addEventListener('pointerleave', () => nav.classList.remove('is-hovering'));
      track.addEventListener('focusin', (e) => {
        if (!e.target.classList.contains('toc-link')) return;
        nav.style.setProperty('--toc-hy', linkY(e.target) + 'px');
        nav.classList.add('is-hovering');
      });
      track.addEventListener('focusout', () => nav.classList.remove('is-hovering'));
      nav.querySelector('.toc-list').addEventListener('click', (e) => {
        const link = e.target.closest('.toc-link');
        if (!link || e.button !== 0 || e.metaKey || e.ctrlKey || e.shiftKey || e.altKey) return;
        const i = items.findIndex((it) => it.link === link);
        if (i < 0) return;
        e.preventDefault();
        goTo(i);
        setOpen(false);
      });
      nav.querySelector('.toc-toggle').addEventListener('click', () => setOpen(!nav.classList.contains('is-open')));
      nav.addEventListener('keydown', (e) => {
        if (e.key === 'Escape' && nav.classList.contains('is-open')) {
          setOpen(false);
          nav.querySelector('.toc-toggle').focus();
        }
      });
      document.addEventListener('click', (e) => {
        if (nav && nav.classList.contains('is-open') && !nav.contains(e.target)) setOpen(false);
      });
    }

    refresh();
    root.addEventListener('scroll', schedule, { passive: true });
    root.addEventListener('resize', () => { if (nav) { const i = active; active = -1; setActive(i); } schedule(); });
    root.addEventListener('langChanged', setTexts);
    root.addEventListener('i18nReady', setTexts);

    // Fiche : des sections apparaissent après le chargement des données.
    if (typeof root.MutationObserver === 'function') {
      let pending = 0;
      new root.MutationObserver(() => {
        if (pending) return;
        pending = root.requestAnimationFrame(() => { pending = 0; refresh(); });
      }).observe(host, { attributes: true, attributeFilter: ['class', 'hidden'], subtree: true, childList: true });
    }

    return { refresh, spy, get nav() { return nav; }, get active() { return active; } };
  }

  function init(doc) {
    const d = doc || document;
    return Array.from(d.querySelectorAll('[data-toc]')).map(mount);
  }

  root.VH.toc = { init, mount };

  if (typeof document !== 'undefined') {
    if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', () => init());
    else init();
  }

  if (typeof module !== 'undefined' && module.exports) module.exports = root.VH.toc;
})();
