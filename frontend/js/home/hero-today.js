/* Accueil — widget « Ce jour-là ».
 *
 * L'ancien widget « Saviez-vous ? » tirait un fait au hasard : jamais deux
 * fois le même, mais aucune raison de revenir demain. Il devient une
 * éphéméride — les anniversaires de la date du jour — et ne retombe sur le
 * fait éditorial que les rares jours sans anniversaire (ou hors ligne).
 */
(function () {
  const root = typeof window !== 'undefined' ? window : globalThis;
  root.VH = root.VH || {};
  root.VH.home = root.VH.home || {};

  /** Phrase d'un anniversaire (HTML : le nom, échappé, est mis en gras). */
  function entrySentence(entry, lang) {
    const { tHero } = VH.home.heroHelpers;
    const name = (lang === 'en' ? entry.airplane_name_en : entry.airplane_name) || entry.airplane_name || '';
    const strong = `<strong>${escapeHtml(name)}</strong>`;
    const sentence = entry.kind === 'service'
      ? tHero('home.hero_today_service', { name: strong }, 'Mise en service : {name}', 'Entered service: {name}')
      : tHero('home.hero_today_first_flight', { name: strong }, 'Premier vol : {name}', 'First flight: {name}');
    return { name, sentence };
  }

  /** Fait éditorial (HTML) : titre échappé, nom de l'appareil remis en gras. */
  function factSentence(fact, lang) {
    const title = (lang === 'en' ? fact.title_en : fact.title_fr) || fact.title_fr || '';
    const name  = (lang === 'en' ? fact.airplane_name_en : fact.airplane_name) || fact.airplane_name || '';
    const safeTitle = escapeHtml(title);
    const safeName = escapeHtml(name);
    // On échappe puis on remet l'éventuel nom d'avion en <strong> pour
    // garder le ton "highlight" du widget.
    const sentence = safeName
      ? safeTitle.replace(safeName, `<strong>${safeName}</strong>`)
      : safeTitle;
    return { name, sentence };
  }

  /* Grande photo du haut de l'accueil : l'appareil de l'anniversaire affiché
   * (v4.17). Elle entre en fondu une fois chargée ; sans photo connue, le
   * cadre reste vide (.is-empty) plutôt que d'afficher une image cassée. */
  function setPhoto(plane, name) {
    const media = document.getElementById('hero-today-media');
    const img = document.getElementById('hero-today-image');
    const credit = document.getElementById('hero-today-credit');
    if (!media || !img) return;
    const url = plane && plane.image_url;
    media.classList.toggle('is-empty', !url);
    if (credit) { credit.textContent = ''; credit.hidden = true; }
    if (!url) return;

    media.classList.remove('is-loaded');
    img.addEventListener('load', () => media.classList.add('is-loaded'), { once: true });
    img.setAttribute('alt', name || '');
    const picture = VH.shared && VH.shared.picture;
    if (picture) picture.applySourcesTo(img, url);
    else img.setAttribute('src', url);
    if (img.complete && img.naturalWidth > 0) media.classList.add('is-loaded');

    const photoCredit = VH.shared && VH.shared.photoCredit;
    if (credit && photoCredit) {
      const shown = photoCredit.fillCredit(credit, { author: plane.image_credit, licence: plane.image_licence }, (k) => i18n.t(k));
      credit.hidden = !shown;
    }
  }

  function init(ephemeris, facts, dayKey, aircraft = []) {
    const body   = document.getElementById('hero-fact-body');
    const link   = document.getElementById('hero-fact-link');
    const label  = document.getElementById('hero-fact-label');
    const reroll = document.getElementById('hero-fact-reroll');
    if (!body) return;

    const { daily, getHeroLang, tHero, nameToSearchSlug, airplaneHref } = VH.home.heroHelpers;
    const dailyApi = daily();
    const selection = dailyApi ? dailyApi.selectEphemeris(ephemeris) : { list: [], exact: false };
    const entries = selection.list;
    let index = 0;
    let fact = null;

    function setLabel(key, fr, en) {
      if (!label) return;
      label.setAttribute('data-i18n', key);
      label.textContent = tHero(key, {}, fr, en);
    }

    function setBody(dateBadge, sentenceHtml) {
      // Le corps porte data-i18n="hero_fact_loading" tant qu'il affiche son
      // texte d'attente. Sans ce retrait, applyToDOM() le remettrait à
      // « Tirage en cours… » au prochain changement de langue.
      body.removeAttribute('data-i18n');
      // Animation rejouée à chaque rendu (reflow forcé). Par classe et non par
      // style inline : la CSP interdit style-src-attr, donc écrire dans
      // body.style est bloqué par le navigateur — silencieusement côté rendu,
      // bruyamment dans la console.
      body.classList.remove('is-fading-in');
      void body.offsetWidth;
      body.classList.add('is-fading-in');
      const badge = dateBadge
        ? `<span class="hero-fact-year hero-fact-date">${escapeHtml(dateBadge)}</span>`
        : '';
      // innerHTML est sûr : le seul markup vient des balises construites ici,
      // les données passent toutes par escapeHtml().
      body.innerHTML = badge + sentenceHtml;
    }

    function renderEntry() {
      const entry = entries[index % entries.length];
      const lang = getHeroLang();
      const { name, sentence } = entrySentence(entry, lang);

      if (selection.exact) setLabel('home.hero_today_label', 'Ce jour-là', 'On this day');
      else                 setLabel('home.hero_today_label_week', 'Cette semaine-là', 'That week');

      setBody(dailyApi ? dailyApi.formatEventDate(entry.event_date, lang) : '', sentence);
      if (link) link.setAttribute('href', airplaneHref(entry.airplane_id, name));
      setPhoto(entry, name);
    }

    function renderFact() {
      const { name, sentence } = factSentence(fact, getHeroLang());
      setLabel('home.hero_fact_label', 'Saviez-vous ?', 'Did you know?');
      setBody(fact.year ? String(fact.year) : '', sentence);
      // Le fait éditorial n'a pas de photo : celle de son appareil, s'il est
      // dans la liste du quiz.
      setPhoto((aircraft || []).find(a => a && a.name === fact.airplane_name) || null, name);

      if (link) {
        link.setAttribute('href', fact.airplane_id
          ? '/details?id=' + encodeURIComponent(fact.airplane_id)
          : (name ? '/hangar?q=' + encodeURIComponent(nameToSearchSlug(name)) : '#'));
      }
    }

    function render() {
      if (entries.length) renderEntry();
      else if (fact)      renderFact();
    }

    if (!entries.length) {
      if (!facts.length) return;
      // Même logique que l'éphéméride : le fait de repli est celui du jour,
      // identique pour tout le monde, et non un tirage par rechargement.
      fact = dailyApi ? dailyApi.pickDaily(facts, dayKey) : facts[0];
    }

    if (reroll) {
      // Un seul anniversaire ce jour-là : le bouton n'aurait rien à montrer.
      if (entries.length === 1) reroll.setAttribute('hidden', '');
      else reroll.addEventListener('click', () => {
        if (entries.length) index++;
        else fact = facts[Math.floor(Math.random() * facts.length)];
        render();
      });
    }

    // Le contenu est construit en JS : applyToDOM() ne le retraduit pas.
    window.addEventListener('langChanged', render);
    render();
  }

  VH.home.heroToday = { entrySentence, factSentence, init, setPhoto };

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = VH.home.heroToday;
  }
})();
