/* Formulaire d'appareil — un seul module pour la modale de création (hangar)
 * et la modale d'édition (fiche). ARCH-007.
 *
 * Les champs viennent de VH.shared.AIRPLANE_FIELDS (shared/airplane-fields.js,
 * généré par scripts/build-js.js depuis backend/utils/airplane-fields.js, la
 * table qui pilote aussi l'INSERT et l'UPDATE). Ce module n'ajoute que la
 * présentation : sections, libellés i18n, largeur, exemples de saisie.
 * Ajouter une colonne éditable = une ligne dans la table backend, une ligne
 * dans SECTIONS ci-dessous (le test airplane-form.test.js refuse un champ
 * non placé), puis `node scripts/build-js.js`.
 *
 * Protections reprises de JS-001 : listes de filiation complètes (toutes les
 * pages de l'API), valeur sans option ajoutée à la volée plutôt que perdue
 * (airplaneOptions.selectValue), référentiels invalides = erreur levée pour
 * que l'appelant bloque l'enregistrement.
 */
(function () {
  window.VH = window.VH || {};
  window.VH.shared = window.VH.shared || {};

  // Valeur que l'API substitue à une colonne `_en` vide quand sa jumelle
  // française est remplie (backend/i18n.js, TRANSLATION_NEEDED).
  const TRANSLATION_NEEDED = 'Translation needed';

  /* Identifiants DOM : `<préfixe>-<colonne en kebab-case>`, sauf ces
   * exceptions, qui reprennent les identifiants historiques du formulaire de
   * création (ciblés par la spec E2E admin-crud). */
  const ID_SUFFIX = Object.freeze({
    country_id: 'country',
    id_manufacturer: 'manufacturer',
    id_generation: 'generation',
    date_operationel: 'date-operational',
  });

  // Libellés des niveaux de furtivité (valeurs : AIRPLANE_FIELDS.values).
  const STEALTH_LABELS = Object.freeze({
    aucune: 'details.stealth_none',
    reduite: 'details.stealth_reduced',
    moderee: 'details.stealth_moderate',
    elevee: 'details.stealth_high',
    tres_elevee: 'details.stealth_very_high',
  });

  /* Mise en page. Chaque champ : [colonne, options] avec
   *   label       clé i18n du libellé
   *   wide        occupe deux colonnes de la grille
   *   rows        hauteur d'un <textarea>
   *   placeholder exemple de saisie (texte brut, non traduit)
   *   maxlength   longueur maximale
   *   uiRequired  obligatoire dans le formulaire (le serveur, lui, n'exige
   *               que `name` : ces clés étrangères sont attendues de toute
   *               fiche publiée)
   *   labelFrom   propriété de la fiche qui nomme la valeur d'un <select>
   *               (option ajoutée à la volée si la liste ne la contient pas) */
  const SECTIONS = Object.freeze([
    { icon: 'fa-info-circle', title: 'details.general_info', fields: [
      ['name', { label: 'details.name' }],
      ['complete_name', { label: 'details.complete_name' }],
      ['little_description', { label: 'details.short_desc', wide: true }],
      ['image_url', { label: 'details.image_url', wide: true }],
      ['description', { label: 'details.full_desc', wide: true, rows: 4 }],
    ] },
    { icon: 'fa-tags', title: 'details.classification', fields: [
      ['country_id', { label: 'details.country', uiRequired: true, labelFrom: 'country_name' }],
      ['id_manufacturer', { label: 'details.manufacturer', uiRequired: true, labelFrom: 'manufacturer_name' }],
      ['id_generation', { label: 'details.generation', uiRequired: true }],
      ['type', { label: 'details.type', uiRequired: true, labelFrom: 'type_name' }],
      ['status', { label: 'details.status', wide: true }],
    ] },
    { icon: 'fa-calendar', title: 'details.important_dates', fields: [
      ['date_concept', { label: 'details.date_concept' }],
      ['date_first_fly', { label: 'details.date_first_fly' }],
      ['date_operationel', { label: 'details.date_operational' }],
    ] },
    { icon: 'fa-tachometer-alt', title: 'details.admin_section_basic_specs', fields: [
      ['max_speed', { label: 'details.max_speed' }],
      ['max_range', { label: 'details.max_range' }],
    ] },
    { icon: 'fa-ruler-combined', title: 'details.admin_section_extended_specs', fields: [
      ['length', { label: 'details.admin_length' }],
      ['wingspan', { label: 'details.admin_wingspan' }],
      ['height', { label: 'details.admin_height' }],
      ['wing_area', { label: 'details.admin_wing_area' }],
      ['empty_weight', { label: 'details.admin_empty_weight' }],
      ['mtow', { label: 'details.admin_mtow' }],
      ['service_ceiling', { label: 'details.admin_service_ceiling' }],
      ['climb_rate', { label: 'details.admin_climb_rate' }],
      ['g_limit_pos', { label: 'details.admin_g_pos' }],
      ['g_limit_neg', { label: 'details.admin_g_neg' }],
      ['combat_radius', { label: 'details.admin_combat_radius' }],
      ['crew', { label: 'details.admin_crew' }],
    ] },
    { icon: 'fa-cogs', title: 'details.admin_section_engine', fields: [
      ['engine_name', { label: 'details.admin_engine_name', wide: true, placeholder: 'Snecma M88-2E4' }],
      ['engine_count', { label: 'details.admin_engine_count' }],
      ['engine_type', { label: 'details.admin_engine_type', placeholder: 'Turbofan' }],
      ['engine_type_en', { label: 'details.admin_engine_type_en', placeholder: 'Turbofan' }],
      ['thrust_dry', { label: 'details.admin_thrust_dry' }],
      ['thrust_wet', { label: 'details.admin_thrust_wet' }],
    ] },
    { icon: 'fa-industry', title: 'details.admin_section_production', fields: [
      ['production_start', { label: 'details.admin_production_start', placeholder: '1986' }],
      ['production_end', { label: 'details.admin_production_end' }],
      ['units_built', { label: 'details.admin_units_built' }],
      ['unit_cost_usd', { label: 'details.admin_unit_cost' }],
      ['unit_cost_year', { label: 'details.admin_unit_cost_year', placeholder: '2024' }],
      ['operators_count', { label: 'details.admin_operators_count' }],
      ['variants', { label: 'details.admin_variants', wide: true, rows: 3 }],
      ['variants_en', { label: 'details.admin_variants_en', wide: true, rows: 3 }],
    ] },
    { icon: 'fa-award', title: 'details.admin_section_qualitative', fields: [
      ['stealth_level', { label: 'details.admin_stealth' }],
      ['nickname', { label: 'details.admin_nickname' }],
      ['predecessor_id', { label: 'details.admin_predecessor', labelFrom: 'predecessor_name' }],
      ['successor_id', { label: 'details.admin_successor', labelFrom: 'successor_name' }],
      ['rival_id', { label: 'details.admin_rival', labelFrom: 'rival_name' }],
    ] },
    { icon: 'fa-link', title: 'details.admin_section_external_links', fields: [
      ['wikipedia_fr', { label: 'details.admin_wikipedia_fr', wide: true, placeholder: 'https://fr.wikipedia.org/wiki/…' }],
      ['wikipedia_en', { label: 'details.admin_wikipedia_en', wide: true, placeholder: 'https://en.wikipedia.org/wiki/…' }],
      ['youtube_showcase', { label: 'details.admin_youtube', wide: true, placeholder: 'https://youtube.com/watch?v=…' }],
      ['manufacturer_page', { label: 'details.admin_manufacturer_page', wide: true }],
      ['image_credit', { label: 'details.admin_image_credit', maxlength: 255 }],
      ['image_licence', { label: 'details.admin_image_licence', maxlength: 100, placeholder: 'CC BY-SA 4.0' }],
    ] },
  ]);

  // Colonne → options de présentation.
  const PRESENTATION = Object.freeze(Object.fromEntries(
    SECTIONS.flatMap((section) => section.fields)
  ));

  function fields() {
    const list = VH.shared.AIRPLANE_FIELDS;
    if (!Array.isArray(list)) throw new Error('VH.shared.AIRPLANE_FIELDS absent : charger shared/airplane-fields.js');
    return list;
  }

  function fieldByColumn(column) {
    return fields().find((field) => field.column === column) || null;
  }

  function fieldId(prefix, column) {
    return `${prefix}-${ID_SUFFIX[column] || column.replace(/_/g, '-')}`;
  }

  function t(key, params) {
    return (window.i18n && typeof i18n.t === 'function') ? i18n.t(key, params) : key;
  }

  // ── Construction ─────────────────────────────────────────────────────

  function attr(name, value) {
    return value == null || value === false ? '' : ` ${name}="${escapeHtml(String(value))}"`;
  }

  function controlHtml(field, id, opts) {
    const required = field.required || opts.uiRequired;
    const common = `id="${escapeHtml(id)}" name="${escapeHtml(field.column)}"${required ? ' required' : ''}` +
      attr('placeholder', opts.placeholder) + attr('maxlength', opts.maxlength);
    switch (field.kind) {
      case 'longtext':
        return `<textarea ${common} rows="${Number(opts.rows) || 3}"></textarea>`;
      case 'url':
      case 'date':
        return `<input type="${field.kind}" ${common}>`;
      case 'int':
        return `<input type="number" step="1" ${common}>`;
      case 'number':
        return `<input type="number" step="any" ${common}>`;
      case 'enum': {
        const options = (field.values || []).map((value) => {
          const key = STEALTH_LABELS[value];
          return `<option value="${escapeHtml(value)}"${attr('data-i18n', key)}>${escapeHtml(key ? t(key) : value)}</option>`;
        });
        return `<select ${common}><option value="">—</option>${options.join('')}</select>`;
      }
      case 'ref': {
        const empty = field.ref === 'airplanes' ? '—' : t('details.select');
        return `<select ${common} data-ref="${escapeHtml(field.ref)}"><option value="">${escapeHtml(empty)}</option></select>`;
      }
      default:
        return `<input type="text" ${common}>`;
    }
  }

  function groupHtml(field, prefix) {
    const opts = PRESENTATION[field.column] || {};
    const id = fieldId(prefix, field.column);
    const labelKey = opts.label || field.column;
    const required = field.required || opts.uiRequired;
    return `<div class="form-group${opts.wide ? ' span-2' : ''}">` +
      `<label for="${escapeHtml(id)}"><span data-i18n="${escapeHtml(labelKey)}">${escapeHtml(t(labelKey))}</span>` +
      `${required ? '<span aria-hidden="true"> *</span>' : ''}</label>` +
      controlHtml(field, id, opts) +
      '</div>';
  }

  /**
   * HTML des sections du formulaire (champs vides, listes de référentiels à
   * remplir ensuite par setReferentials / setAirplanes).
   * @param {string} prefix préfixe des identifiants ('aircraft', 'edit')
   * @returns {string}
   */
  function formHtml(prefix) {
    return SECTIONS.map((section) => {
      const groups = section.fields
        .map(([column]) => fieldByColumn(column))
        .filter(Boolean)
        .map((field) => groupHtml(field, prefix))
        .join('');
      return `<div class="form-section"><h3><i class="fas ${escapeHtml(section.icon)}" aria-hidden="true"></i> ` +
        `<span data-i18n="${escapeHtml(section.title)}">${escapeHtml(t(section.title))}</span></h3>` +
        `<div class="form-grid">${groups}</div></div>`;
    }).join('');
  }

  // ── Référentiels ─────────────────────────────────────────────────────

  /**
   * Charge /api/referentials. Rejette si la réponse n'est pas exploitable :
   * l'appelant doit alors bloquer l'enregistrement (des listes vides
   * réécriraient les clés étrangères à NULL).
   * @returns {Promise<{countries: Array, manufacturers: Array, generations: Array, types: Array}>}
   */
  async function loadReferentials() {
    const res = await auth.fetchWithTimeout('/api/referentials');
    if (!res.ok) throw new Error(`Chargement des référentiels impossible (HTTP ${res.status})`);
    const refs = await res.json();
    if (!isReferentials(refs)) throw new Error('Référentiels incomplets');
    return refs;
  }

  function isReferentials(refs) {
    return !!refs && ['countries', 'manufacturers', 'generations', 'types'].every((k) => Array.isArray(refs[k]));
  }

  function refOptions(ref, refs) {
    switch (ref) {
      case 'countries':
        return refs.countries.map((c) => [c.id, c.name]);
      case 'manufacturer':
        return refs.manufacturers.map((m) => [m.id, m.country_name ? `${m.name} (${m.country_name})` : m.name]);
      case 'generation':
        return refs.generations.map((g) => [g, t('details.admin_generation_option', { n: g })]);
      case 'type':
        return refs.types.map((ty) => [ty.id, ty.name]);
      default:
        return null;
    }
  }

  /* Remplace les options d'une liste en gardant la valeur choisie (saisie
   * pendant le chargement, ou valeur ajoutée à la volée). */
  function replaceOptions(select, html) {
    const current = select.value;
    const currentLabel = select.selectedOptions && select.selectedOptions[0] ? select.selectedOptions[0].textContent : '';
    select.innerHTML = html;
    if (current) VH.shared.airplaneOptions.selectValue(select, current, currentLabel);
  }

  // ── Contrôleur monté dans une modale ─────────────────────────────────

  /**
   * Construit le formulaire dans `container` et renvoie de quoi le piloter.
   * @param {HTMLElement} container
   * @param {{prefix: string}} options
   */
  function mount(container, { prefix }) {
    if (!container) throw new Error('Conteneur du formulaire d\'appareil introuvable');
    container.innerHTML = formHtml(prefix);

    const element = (column) => container.querySelector(`#${fieldId(prefix, column)}`);

    function setReferentials(refs) {
      if (!isReferentials(refs)) throw new Error('Référentiels incomplets');
      const placeholder = `<option value="">${escapeHtml(t('details.select'))}</option>`;
      fields().filter((f) => f.kind === 'ref').forEach((field) => {
        const select = element(field.column);
        const options = select && refOptions(field.ref, refs);
        if (!options) return;
        replaceOptions(select, placeholder + options
          .map(([value, label]) => `<option value="${escapeHtml(String(value))}">${escapeHtml(String(label == null ? '' : label))}</option>`)
          .join(''));
      });
    }

    /** Listes prédécesseur / successeur / rival : tout le catalogue sauf `excludeId`. */
    function setAirplanes(list, excludeId) {
      const html = VH.shared.airplaneOptions.optionsHtml(list, excludeId);
      fields().filter((f) => f.kind === 'ref' && f.ref === 'airplanes').forEach((field) => {
        const select = element(field.column);
        if (select) replaceOptions(select, html);
      });
    }

    /* Valeur d'une colonne. Les colonnes `_en` (engine_type_en, variants_en)
     * ne sont pas renvoyées par GET /api/airplanes/:id?lang=fr (pickLang les
     * retire) : on les lit dans la fiche anglaise, où l'API a mis la valeur
     * anglaise à la place de la colonne française — ou TRANSLATION_NEEDED. */
    function valueOf(field, record, recordEn) {
      if (Object.hasOwn(record, field.column) || !field.column.endsWith('_en') || !recordEn) {
        return record[field.column];
      }
      const translated = recordEn[field.column.slice(0, -3)];
      return translated === TRANSLATION_NEEDED ? null : translated;
    }

    /**
     * Remplit le formulaire depuis une fiche.
     * @param {object} record fiche en français (colonnes à écrire)
     * @param {object} [recordEn] même fiche en anglais, pour les colonnes `_en`
     */
    function fill(record, recordEn) {
      const { selectValue } = VH.shared.airplaneOptions;
      fields().forEach((field) => {
        const el = element(field.column);
        if (!el) return;
        const raw = valueOf(field, record || {}, recordEn);
        if (field.kind === 'ref' || field.kind === 'enum') {
          const labelFrom = (PRESENTATION[field.column] || {}).labelFrom;
          selectValue(el, raw, labelFrom ? record[labelFrom] : undefined);
        } else if (field.kind === 'date') {
          el.value = raw ? String(raw).split('T')[0] : '';
        } else {
          el.value = raw == null ? '' : raw;
        }
      });
    }

    function convert(field, value) {
      if (value === '' || value == null) return field.required ? '' : null;
      if (field.kind === 'int' || field.kind === 'ref') {
        const n = parseInt(value, 10);
        return Number.isNaN(n) ? null : n;
      }
      if (field.kind === 'number') {
        const n = Number(value);
        return Number.isNaN(n) ? null : n;
      }
      return value;
    }

    /**
     * Corps JSON de POST / PUT : tous les champs du formulaire, '' → null,
     * nombres convertis. Un champ absent du DOM n'est pas envoyé (un PUT le
     * laisse alors inchangé).
     * @returns {object}
     */
    function read() {
      const body = {};
      fields().forEach((field) => {
        const el = element(field.column);
        if (el) body[field.column] = convert(field, el.value);
      });
      return body;
    }

    return { prefix, container, element, setReferentials, setAirplanes, fill, read };
  }

  VH.shared.airplaneForm = {
    SECTIONS, PRESENTATION, ID_SUFFIX, TRANSLATION_NEEDED,
    fieldId, formHtml, loadReferentials, isReferentials, mount,
  };

  // Export conditionnel pour les tests unitaires (Node.js / jsdom)
  if (typeof module !== 'undefined' && module.exports) {
    module.exports = VH.shared.airplaneForm;
  }
})();
