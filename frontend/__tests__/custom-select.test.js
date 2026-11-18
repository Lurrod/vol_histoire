/**
 * Tests unitaires — frontend/js/shared/custom-select.js
 *
 * Le <select> natif reste la source de vérité (valeur, formulaire, événements
 * `change`) ; VH.customSelect pose devant lui une liste personnalisée au motif
 * « select-only combobox » de l'APG (WAI-ARIA).
 */
require('../js/shared/motion');
const { enhance, enhanceAll } = require('../js/shared/custom-select');

const flush = () => new Promise(r => setTimeout(r, 0));
const key = (el, k, extra = {}) => el.dispatchEvent(new window.KeyboardEvent('keydown', { key: k, bubbles: true, cancelable: true, ...extra }));

function page(html) {
  document.body.innerHTML = html;
}

const SORT = `
  <label for="sort" id="sort-label">Trier</label>
  <select id="sort" class="sort-select">
    <option value="default">Par défaut</option>
    <option value="alpha">Ordre alphabétique</option>
    <option value="nation" disabled>Pays</option>
    <option value="date">Date</option>
    <option value="gen">Génération</option>
  </select>`;

let select, trigger, list;
function setup(html = SORT) {
  page(html);
  select = document.querySelector('select');
  enhance(select);
  trigger = document.querySelector('.cselect-trigger');
  list = document.querySelector('.cselect-list');
}
const options = () => [...list.querySelectorAll('[role="option"]')];
const active = () => document.getElementById(trigger.getAttribute('aria-activedescendant'));

describe('structure et accessibilité', () => {
  beforeEach(() => setup());

  test('combobox relié à son label, liste et options ARIA, natif retiré du parcours', () => {
    expect(trigger.getAttribute('role')).toBe('combobox');
    expect(trigger.getAttribute('aria-haspopup')).toBe('listbox');
    expect(trigger.getAttribute('aria-expanded')).toBe('false');
    expect(trigger.getAttribute('aria-labelledby')).toBe('sort-label');
    expect(trigger.tabIndex).toBe(0);
    expect(list.getAttribute('role')).toBe('listbox');
    expect(trigger.getAttribute('aria-controls')).toBe(list.id);
    expect(list.hidden).toBe(true);
    expect(options()).toHaveLength(5);
    expect(options()[2].getAttribute('aria-disabled')).toBe('true');
    expect(select.tabIndex).toBe(-1);
    expect(select.getAttribute('aria-hidden')).toBe('true');
    expect(select.closest('.cselect')).toBe(trigger.parentElement);
  });

  test('affiche le libellé de l\'option choisie', () => {
    expect(trigger.querySelector('.cselect-value').textContent).toBe('Par défaut');
    expect(options()[0].getAttribute('aria-selected')).toBe('true');
  });

  test('un second enhance ne double rien', () => {
    expect(enhance(select)).toBeNull();
    expect(document.querySelectorAll('.cselect-trigger')).toHaveLength(1);
  });

  test('sans label : le nom vient de aria-label', () => {
    page('<select aria-label="Rôle"><option>A</option></select>');
    enhance(document.querySelector('select'));
    expect(document.querySelector('.cselect-trigger').getAttribute('aria-label')).toBe('Rôle');
  });

  test('select multiple ou en liste : laissé natif', () => {
    page('<select multiple><option>A</option></select><select size="4"><option>B</option></select>');
    document.querySelectorAll('select').forEach(s => expect(enhance(s)).toBeNull());
    expect(document.querySelector('.cselect')).toBeNull();
  });
});

describe('souris', () => {
  beforeEach(() => setup());

  test('clic : ouvre, choix d\'une option → valeur native + un seul `change`, fermeture', () => {
    const onChange = jest.fn();
    select.addEventListener('change', onChange);
    trigger.click();
    expect(trigger.getAttribute('aria-expanded')).toBe('true');
    expect(list.hidden).toBe(false);
    options()[3].click();
    expect(select.value).toBe('date');
    expect(onChange).toHaveBeenCalledTimes(1);
    expect(trigger.querySelector('.cselect-value').textContent).toBe('Date');
    expect(trigger.getAttribute('aria-expanded')).toBe('false');
  });

  test('option désactivée : rien ne change', () => {
    trigger.click();
    options()[2].click();
    expect(select.value).toBe('default');
  });

  test('reprendre la même option ne déclenche pas `change`', () => {
    const onChange = jest.fn();
    select.addEventListener('change', onChange);
    trigger.click();
    options()[0].click();
    expect(onChange).not.toHaveBeenCalled();
  });

  test('clic ailleurs : fermeture sans changement', () => {
    trigger.click();
    document.body.dispatchEvent(new window.MouseEvent('pointerdown', { bubbles: true }));
    expect(trigger.getAttribute('aria-expanded')).toBe('false');
    expect(select.value).toBe('default');
  });

  test('second clic sur le déclencheur : fermeture', () => {
    trigger.click();
    trigger.click();
    expect(trigger.getAttribute('aria-expanded')).toBe('false');
  });

  test('clic sur le label : le focus va au déclencheur', () => {
    trigger.blur();
    select.dispatchEvent(new window.FocusEvent('focus'));
    expect(document.activeElement).toBe(trigger);
  });
});

describe('clavier', () => {
  beforeEach(() => { setup(); trigger.focus(); });

  test('Flèche bas ouvre sur l\'option choisie, puis descend en sautant les désactivées', () => {
    key(trigger, 'ArrowDown');
    expect(trigger.getAttribute('aria-expanded')).toBe('true');
    expect(active().textContent).toContain('Par défaut');
    key(trigger, 'ArrowDown');
    expect(active().textContent).toContain('Ordre alphabétique');
    key(trigger, 'ArrowDown');
    expect(active().textContent).toContain('Date');
    key(trigger, 'Enter');
    expect(select.value).toBe('date');
    expect(trigger.getAttribute('aria-expanded')).toBe('false');
  });

  test('Home / End, puis Espace pour choisir', () => {
    key(trigger, 'Enter');
    key(trigger, 'End');
    expect(active().textContent).toContain('Génération');
    key(trigger, 'Home');
    expect(active().textContent).toContain('Par défaut');
    key(trigger, 'ArrowDown');
    key(trigger, ' ');
    expect(select.value).toBe('alpha');
  });

  test('Échap ferme sans changer et ne remonte pas à la page', () => {
    const pageEsc = jest.fn();
    document.addEventListener('keydown', pageEsc);
    key(trigger, 'ArrowDown');
    key(trigger, 'ArrowDown');
    key(trigger, 'Escape');
    expect(select.value).toBe('default');
    expect(trigger.getAttribute('aria-expanded')).toBe('false');
    expect(pageEsc).not.toHaveBeenCalledWith(expect.objectContaining({ key: 'Escape' }));
    document.removeEventListener('keydown', pageEsc);
  });

  test('Échap liste fermée : laissé à la page', () => {
    const pageEsc = jest.fn();
    document.addEventListener('keydown', pageEsc);
    key(trigger, 'Escape');
    expect(pageEsc).toHaveBeenCalled();
    document.removeEventListener('keydown', pageEsc);
  });

  test('Tab choisit l\'option active et ferme', () => {
    key(trigger, 'ArrowDown');
    key(trigger, 'ArrowDown');
    key(trigger, 'Tab');
    expect(select.value).toBe('alpha');
    expect(trigger.getAttribute('aria-expanded')).toBe('false');
  });

  test('frappe : saute à l\'option qui commence par ces lettres (accents ignorés)', () => {
    key(trigger, 'g');
    expect(trigger.getAttribute('aria-expanded')).toBe('true');
    expect(active().textContent).toContain('Génération');
    key(trigger, 'Enter');
    expect(select.value).toBe('gen');
  });

  test('Alt + Flèche haut : choisit et ferme', () => {
    key(trigger, 'ArrowDown');
    key(trigger, 'ArrowDown');
    key(trigger, 'ArrowUp', { altKey: true });
    expect(select.value).toBe('alpha');
    expect(trigger.getAttribute('aria-expanded')).toBe('false');
  });

  test('perte du focus : fermeture', () => {
    key(trigger, 'ArrowDown');
    trigger.dispatchEvent(new window.FocusEvent('blur'));
    expect(trigger.getAttribute('aria-expanded')).toBe('false');
  });
});

describe('synchronisation avec le natif', () => {
  beforeEach(() => setup());

  test('le code qui écrit select.value met l\'affichage à jour', () => {
    // jsdom fait du <select> un Proxy (options indexées) : une affectation
    // `select.value = …` n'y passe pas par l'accesseur posé sur l'instance,
    // contrairement aux navigateurs (vérifié à l'écran). On appelle donc
    // l'accesseur installé lui-même.
    const own = (prop) => Object.getOwnPropertyDescriptor(select, prop);
    own('value').set.call(select, 'gen');
    expect(trigger.querySelector('.cselect-value').textContent).toBe('Génération');
    own('selectedIndex').set.call(select, 1);
    expect(trigger.querySelector('.cselect-value').textContent).toBe('Ordre alphabétique');
    expect(own('value').get.call(select)).toBe('alpha');
    expect(own('selectedIndex').get.call(select)).toBe(1);
  });

  test('options traduites ou remplacées après coup : la liste suit', async () => {
    select.options[1].textContent = 'Alphabetical order';
    await flush();
    expect(options()[1].textContent).toContain('Alphabetical order');
    select.innerHTML = '<option value="x">Nouvelle</option><option value="y" selected>Autre</option>';
    await flush();
    expect(options()).toHaveLength(2);
    expect(trigger.querySelector('.cselect-value').textContent).toBe('Autre');
  });

  test('`change` déclenché par un autre script : affichage resynchronisé', () => {
    const desc = Object.getOwnPropertyDescriptor(window.HTMLSelectElement.prototype, 'value');
    desc.set.call(select, 'date');
    select.dispatchEvent(new Event('change'));
    expect(trigger.querySelector('.cselect-value').textContent).toBe('Date');
  });

  test('select désactivé : déclencheur inerte', async () => {
    select.disabled = true;
    await flush();
    expect(trigger.getAttribute('aria-disabled')).toBe('true');
    expect(trigger.tabIndex).toBe(-1);
    trigger.click();
    expect(trigger.getAttribute('aria-expanded')).toBe('false');
  });

  test('réinitialisation du formulaire : affichage remis à la valeur par défaut', async () => {
    page(`<form><select id="s"><option value="a">A</option><option value="b">B</option></select></form>`);
    select = document.getElementById('s');
    enhance(select);
    trigger = document.querySelector('.cselect-trigger');
    select.value = 'b';
    select.form.reset();
    await flush();
    expect(trigger.querySelector('.cselect-value').textContent).toBe('A');
  });
});

describe('accessibilité de l’état du champ (relecture)', () => {
  test('required, aria-invalid et le message d’erreur sont reflétés sur le déclencheur', async () => {
    setup(`<label for="s">Rôle</label><select id="s" required><option value="">—</option><option value="1">A</option></select>
      <span id="s-error"></span>`);
    expect(trigger.getAttribute('aria-required')).toBe('true');
    select.setAttribute('aria-invalid', 'true');
    select.setAttribute('aria-describedby', 's-error');
    await flush();
    expect(trigger.getAttribute('aria-invalid')).toBe('true');
    expect(trigger.getAttribute('aria-describedby')).toBe('s-error');
    select.removeAttribute('aria-invalid');
    await flush();
    expect(trigger.hasAttribute('aria-invalid')).toBe(false);
  });

  test('nom accessible : aria-labelledby du select, sinon title', () => {
    setup('<span id="ext">Tri</span><select aria-labelledby="ext"><option>A</option></select>');
    expect(trigger.getAttribute('aria-labelledby')).toBe('ext');
    setup('<select title="Choix"><option>A</option></select>');
    expect(trigger.getAttribute('aria-label')).toBe('Choix');
  });

  test('aria-label du select réécrit plus tard (i18n) : le déclencheur suit', async () => {
    setup('<select aria-label="Rôle"><option>A</option></select>');
    select.setAttribute('aria-label', 'Role');
    await flush();
    expect(trigger.getAttribute('aria-label')).toBe('Role');
  });

  test('select enveloppé dans son label : le nom n’inclut pas le texte des options', () => {
    setup('<label>Pays <select><option>France</option><option>Japon</option></select></label>');
    expect(trigger.getAttribute('aria-label')).toBe('Pays');
    expect(trigger.hasAttribute('aria-labelledby')).toBe(false);
  });
});

describe('cas natifs particuliers (relecture)', () => {
  test('options hidden (placeholder) absentes de la liste', () => {
    setup('<select><option value="" hidden>Choisir…</option><option value="a">A</option></select>');
    expect(options().map(o => o.textContent)).toEqual(['A']);
  });

  test('select dans un fieldset désactivé : déclencheur inerte', () => {
    setup('<fieldset disabled><select><option>A</option></select></fieldset>');
    expect(trigger.getAttribute('aria-disabled')).toBe('true');
    trigger.click();
    expect(trigger.getAttribute('aria-expanded')).toBe('false');
  });

  test('clone d’un champ déjà amélioré : le clone redevient un champ complet', async () => {
    setup();
    const copy = document.querySelector('.cselect').cloneNode(true);
    const holder = document.createElement('div');
    holder.appendChild(copy);
    document.body.appendChild(holder);
    await flush();
    expect(holder.querySelectorAll('.cselect-trigger')).toHaveLength(1);
    expect(holder.querySelectorAll('.cselect-list')).toHaveLength(1);
    const t = holder.querySelector('.cselect-trigger');
    t.click();
    expect(t.getAttribute('aria-expanded')).toBe('true');
  });
});

describe('clavier et souris (relecture)', () => {
  beforeEach(() => { setup(); trigger.focus(); });

  test('espace pendant une frappe : caractère, pas choix', () => {
    page(`<label for="p" id="pl">Pays</label><select id="p">
      <option>Espagne</option><option>Etats-Unis</option><option>Etats Unis</option></select>`);
    select = document.querySelector('select');
    enhance(select);
    trigger = document.querySelector('.cselect-trigger');
    list = document.querySelector('.cselect-list');
    trigger.focus();
    for (const ch of 'etats') key(trigger, ch);
    key(trigger, ' ');
    expect(trigger.getAttribute('aria-expanded')).toBe('true');
    key(trigger, 'u');
    expect(active().textContent).toContain('Etats Unis');
  });

  test('souris immobile au-dessus de la liste : l’option active clavier ne bouge pas', () => {
    key(trigger, 'ArrowDown');
    key(trigger, 'ArrowDown');
    const opt = options()[4];
    opt.dispatchEvent(new window.MouseEvent('mousemove', { bubbles: true, clientX: 10, clientY: 10 }));
    expect(active()).toBe(opt);
    key(trigger, 'ArrowUp');
    // même position du pointeur (la liste a défilé sous lui) : ignoré
    opt.dispatchEvent(new window.MouseEvent('mousemove', { bubbles: true, clientX: 10, clientY: 10 }));
    expect(active().textContent).toContain('Date');
  });

  test('options réécrites pendant que la liste est ouverte : l’option active est conservée', async () => {
    key(trigger, 'ArrowDown');
    key(trigger, 'ArrowDown');
    select.options[1].textContent = 'Alphabetical';
    await flush();
    expect(active().textContent).toContain('Alphabetical');
  });

  test('retour arrière (pageshow) : l’affichage reprend la valeur restaurée', () => {
    const desc = Object.getOwnPropertyDescriptor(window.HTMLSelectElement.prototype, 'selectedIndex');
    desc.set.call(select, 4);
    window.dispatchEvent(new window.Event('pageshow'));
    expect(trigger.querySelector('.cselect-value').textContent).toBe('Génération');
  });
});

describe('enhanceAll', () => {
  test('améliore les select présents, ignore data-native, suit les select ajoutés ensuite', async () => {
    page('<select id="a"><option>1</option></select><select id="b" data-native><option>2</option></select><div id="later"></div>');
    enhanceAll(document);
    expect(document.getElementById('a').closest('.cselect')).not.toBeNull();
    expect(document.getElementById('b').closest('.cselect')).toBeNull();
    document.getElementById('later').innerHTML = '<select id="c"><option>3</option></select>';
    await flush();
    expect(document.getElementById('c').closest('.cselect')).not.toBeNull();
  });
});
