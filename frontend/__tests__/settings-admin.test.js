/**
 * Tests — panneau d'administration des réglages (js/settings/admin.js) :
 * liste, filtre par rôle et compteurs, rôle changé dans la liste, modale
 * nom / email, suppression confirmée sur place, pagination.
 */
global.DOMPurify = require('dompurify');
const { jsonResponse, tick, env, rolled, loadModules, resetEnv } = require('./helpers/settings-env');

let auth;
let toasts;

beforeEach(() => {
  resetEnv();
  ({ auth, toasts } = env);
});

afterEach(() => {
  jest.useRealTimers();
  jest.restoreAllMocks();
});

const USERS = [
  { id: 1, name: 'Chef', email: 'chef@x.fr', role_id: 1 },
  { id: 2, name: '<img src=x onerror=alert(1)>', email: 'b@x.fr', role_id: 2 },
  { id: 3, name: '', email: 'c@x.fr', role_id: 3 },
];
const ROLES = { 1: 1, 2: 4, 3: 14 };

function setup(meta = { total: 19, totalPages: 3, roles: ROLES }) {
  const S = loadModules();
  const state = { currentUser: { id: 1 } };
  S.admin.init(state);
  auth.authFetch.mockResolvedValue(jsonResponse(200, { data: USERS, meta }));
  return S;
}
const select = (id) => document.getElementById(`user-role-${id}`);
const chip = (role) => document.querySelector(`.role-chip[data-role="${role}"]`);
const count = (role) => document.querySelector(`[data-count-role="${role}"]`).textContent;

describe('VH.settings.admin — liste', () => {
  test('roleView traduit ; carte échappée, sans suppression pour soi', () => {
    const S = setup();
    expect(S.admin.roleView(2)).toEqual({ label: 't:common.role_editor', badge: 'badge-editor' });
    expect(S.admin.roleView(1).badge).toBe('badge-admin');
    expect(S.admin.roleView(3).badge).toBe('badge-member');
    const own = S.admin.userCardHtml(USERS[0], 1);
    expect(own).not.toContain('btn-delete');
    expect(own).toContain('is-self');
    const other = S.admin.userCardHtml(USERS[1], 1);
    expect(other).toContain('&lt;img');
    expect(other).toContain('btn-delete');
    expect(other).toContain('aria-label="t:settings.admin_edit"');
    expect(S.admin.userCardHtml(USERS[2], 1)).toContain('>?<');
  });

  test('chargement : cartes, sélecteur de rôle par ligne (le sien désactivé), total accordé, compteurs', async () => {
    const S = setup();
    await S.admin.loadUsers();
    expect(auth.authFetch).toHaveBeenLastCalledWith('/api/users?page=1&limit=8');
    expect(document.querySelectorAll('.user-card')).toHaveLength(3);
    expect(select(2).value).toBe('2');
    expect(select(2).getAttribute('aria-label')).toBe('t:settings.admin_role_label:{"name":"<img src=x onerror=alert(1)>"}');
    expect([...select(2).options].map((o) => o.textContent)).toEqual(['t:common.role_admin', 't:common.role_editor', 't:nav.user_role']);
    expect(select(1).disabled).toBe(true);
    expect(select(1).title).toBe('t:settings.admin_role_self');
    expect(select(3).getAttribute('aria-label')).toBe('t:settings.admin_role_label:{"name":"c@x.fr"}');
    expect(rolled('total-users')).toBe('19');
    expect(document.getElementById('total-users-label').textContent).toBe('t:settings.admin_users_many');
    expect([count('all'), count('1'), count('2'), count('3')]).toEqual(['19', '1', '4', '14']);
  });

  test('un seul utilisateur : libellé au singulier ; liste vide : message', async () => {
    const S = setup({ total: 1, totalPages: 1 });
    auth.authFetch.mockResolvedValueOnce(jsonResponse(200, { data: [USERS[0]], meta: { total: 1, totalPages: 1 } }));
    await S.admin.loadUsers();
    expect(document.getElementById('total-users-label').textContent).toBe('t:settings.admin_users_one');
    // meta.roles absent : pastilles sans nombre.
    expect(count('all')).toBe('');
    auth.authFetch.mockResolvedValueOnce(jsonResponse(200, { data: [], meta: { total: 0 } }));
    await S.admin.loadUsers();
    expect(document.getElementById('user-list').textContent).toBe('t:settings.admin_empty');
  });

  test('pastilles de rôle : filtre envoyé, état pressé, retour à « Tous » ; pastille active recliquée : rien', async () => {
    const S = setup();
    await S.admin.loadUsers();
    chip('2').click();
    await tick();
    expect(auth.authFetch).toHaveBeenLastCalledWith('/api/users?page=1&limit=8&role=2');
    expect(chip('2').getAttribute('aria-pressed')).toBe('true');
    expect(chip('').getAttribute('aria-pressed')).toBe('false');
    const calls = auth.authFetch.mock.calls.length;
    chip('2').click();
    expect(auth.authFetch.mock.calls.length).toBe(calls);
    chip('').click();
    await tick();
    expect(auth.authFetch).toHaveBeenLastCalledWith('/api/users?page=1&limit=8');
    await S.admin.selectRole('9'); // rôle inconnu : tous
    expect(auth.authFetch).toHaveBeenLastCalledWith('/api/users?page=1&limit=8');
  });

  test('pagination : navigation entre pages ; une seule page : pas de pagination', async () => {
    const S = setup();
    await S.admin.loadUsers();
    expect(document.querySelector('.prev-page-btn').disabled).toBe(true);
    document.querySelector('.next-page-btn').click();
    await tick();
    expect(auth.authFetch).toHaveBeenLastCalledWith('/api/users?page=2&limit=8');
    document.querySelector('.prev-page-btn').click();
    await tick();
    expect(auth.authFetch).toHaveBeenLastCalledWith('/api/users?page=1&limit=8');
    auth.authFetch.mockResolvedValue(jsonResponse(200, { data: USERS, meta: { total: 3, totalPages: 1 } }));
    await S.admin.loadUsers();
    expect(document.getElementById('user-pagination').innerHTML).toBe('');
  });

  test('page au-delà du total : recul et nouveau chargement', async () => {
    const S = setup({ total: 3, totalPages: 1 });
    const ctx = S.admin.init({ currentUser: { id: 1 } });
    ctx.page = 4;
    await S.admin.loadUsers();
    expect(ctx.page).toBe(1);
  });

  test('total nul : pagination vide ; meta absente : déduite de la liste', async () => {
    const S = setup({ total: 0, totalPages: 1 });
    auth.authFetch.mockResolvedValue(jsonResponse(200, { data: [], meta: { total: 0 } }));
    await S.admin.loadUsers();
    expect(document.getElementById('user-pagination').innerHTML).toBe('');
    auth.authFetch.mockResolvedValue(jsonResponse(200, { data: 'pas un tableau' }));
    await S.admin.loadUsers();
    expect(rolled('total-users')).toBe('0');
  });

  test('401 : session effacée ; 500 et réseau : message dans la liste', async () => {
    jest.useFakeTimers();
    const S = setup();
    auth.authFetch.mockResolvedValueOnce(jsonResponse(401, {}));
    await S.admin.loadUsers();
    expect(auth.clearSession).toHaveBeenCalled();
    expect(toasts).toContainEqual(['error', 't:settings.toast_session_expired']);
    auth.authFetch.mockResolvedValueOnce(jsonResponse(500, {}));
    await S.admin.loadUsers();
    expect(document.getElementById('user-list').textContent).toBe('t:settings.admin_api_unavailable');
    auth.authFetch.mockRejectedValueOnce(new Error('réseau'));
    await S.admin.loadUsers();
    expect(document.getElementById('user-list').textContent).toBe('t:settings.toast_users_error');
  });

  test('recherche temporisée côté serveur, filtre de rôle conservé', async () => {
    const S = setup();
    await S.admin.selectRole('3');
    jest.useFakeTimers();
    auth.authFetch.mockClear();
    const input = document.getElementById('user-filter');
    input.value = ' pil ';
    input.dispatchEvent(new window.Event('input'));
    input.value = ' pilo ';
    input.dispatchEvent(new window.Event('input'));
    jest.advanceTimersByTime(300);
    expect(auth.authFetch).toHaveBeenCalledTimes(1);
    expect(auth.authFetch).toHaveBeenCalledWith('/api/users?page=1&limit=8&search=pilo&role=3');
  });

  test('loadUsers avant init : sans effet', async () => {
    const S = loadModules();
    await S.admin.loadUsers();
    expect(auth.authFetch).not.toHaveBeenCalled();
  });
});

describe('VH.settings.admin — rôle dans la liste', () => {
  test('changement : PUT { name, role_id }, toast, liste rechargée', async () => {
    const S = setup();
    await S.admin.loadUsers();
    auth.authFetch.mockClear();
    auth.authFetch.mockResolvedValueOnce(jsonResponse(200, {}));
    auth.authFetch.mockResolvedValue(jsonResponse(200, { data: USERS, meta: { total: 3, totalPages: 1, roles: ROLES } }));
    select(3).value = '2';
    select(3).dispatchEvent(new window.Event('change'));
    expect(select(3).disabled).toBe(true);
    expect(select(3).closest('.user-card').getAttribute('aria-busy')).toBe('true');
    await tick();
    const [url, opts] = auth.authFetch.mock.calls[0];
    expect(url).toBe('/api/admin/users/3');
    expect(JSON.parse(opts.body)).toEqual({ name: '', role_id: 2 });
    expect(toasts).toContainEqual(['success', 't:settings.admin_role_updated:{"name":"","role":"t:common.role_editor"}']);
    expect(auth.authFetch).toHaveBeenLastCalledWith('/api/users?page=1&limit=8');
  });

  test('refus du serveur (message ou repli), réseau : ancien rôle rétabli', async () => {
    const S = setup();
    await S.admin.loadUsers();
    const s2 = select(2);
    auth.authFetch.mockResolvedValueOnce(jsonResponse(403, { message: 'Interdit' }));
    s2.value = '3';
    expect(await S.admin.changeRole(s2, USERS[1])).toBe(false);
    expect(toasts).toContainEqual(['error', 'Interdit']);
    expect(s2.value).toBe('2');
    expect(s2.disabled).toBe(false);
    auth.authFetch.mockResolvedValueOnce({ ok: false, status: 500, json: () => Promise.reject(new Error('x')) });
    s2.value = '1';
    await S.admin.changeRole(s2, USERS[1]);
    expect(toasts).toContainEqual(['error', 't:settings.admin_role_error']);
    auth.authFetch.mockRejectedValueOnce(new Error('réseau'));
    s2.value = '1';
    await S.admin.changeRole(s2, USERS[1]);
    expect(toasts).toContainEqual(['error', 't:settings.toast_network_error']);
    expect(s2.value).toBe('2');
  });

  test('même rôle : aucune requête ; sélecteur hors carte toléré', async () => {
    const S = setup();
    auth.authFetch.mockClear();
    const loose = S.admin.roleSelect(USERS[1], 1);
    expect(await S.admin.changeRole(loose, USERS[1])).toBe(false);
    expect(auth.authFetch).not.toHaveBeenCalled();
    auth.authFetch.mockResolvedValueOnce(jsonResponse(500, {}));
    loose.value = '3';
    expect(await S.admin.changeRole(loose, USERS[1])).toBe(false);
  });
});

describe('VH.settings.admin — modale et suppression', () => {
  test('édition : modale pré-remplie (nom, email), validation, enregistrement avec le rôle de la ligne', async () => {
    const S = setup();
    await S.admin.loadUsers();
    document.querySelectorAll('.btn-edit')[2].click();
    const modal = document.getElementById('edit-user-modal');
    expect(modal.classList.contains('hidden')).toBe(false);
    expect(document.getElementById('edit-user-email').value).toBe('c@x.fr');

    document.getElementById('edit-user-name').value = 'Z';
    document.getElementById('edit-user-save').click();
    expect(document.getElementById('edit-user-name-error').textContent).toBe('t:settings.toast_name_min');
    document.getElementById('edit-user-name').dispatchEvent(new window.Event('input'));
    expect(document.getElementById('edit-user-name').hasAttribute('aria-invalid')).toBe(false);

    document.getElementById('edit-user-name').value = 'Zoé';
    document.getElementById('edit-user-email').value = 'pas-email';
    document.getElementById('edit-user-save').click();
    expect(document.getElementById('edit-user-email-error').textContent).toBe('t:settings.toast_email_invalid');
    document.getElementById('edit-user-email').dispatchEvent(new window.Event('input'));

    document.getElementById('edit-user-email').value = 'zoe@x.fr';
    auth.authFetch.mockResolvedValueOnce(jsonResponse(200, {}));
    await S.admin.saveEditedUser();
    const call = auth.authFetch.mock.calls.find(([url]) => url === '/api/admin/users/3');
    expect(JSON.parse(call[1].body)).toEqual({ name: 'Zoé', email: 'zoe@x.fr', role_id: 3 });
    expect(toasts).toContainEqual(['success', 't:settings.toast_user_updated']);
    expect(modal.classList.contains('show')).toBe(false);
  });

  test('édition : utilisateur disparu de la liste (rôle membre par défaut), refus, réseau, annulation et voile', async () => {
    const S = setup();
    S.admin.openEditUserModal({ id: 99, name: 'Bob', email: 'b@x.fr', role_id: 2 });
    auth.authFetch.mockResolvedValueOnce(jsonResponse(409, {}));
    await S.admin.saveEditedUser();
    expect(JSON.parse(auth.authFetch.mock.calls[0][1].body).role_id).toBe(3);
    expect(toasts).toContainEqual(['error', 't:settings.toast_user_update_error']);
    auth.authFetch.mockResolvedValueOnce({ ok: false, json: () => Promise.reject(new Error('x')) });
    await S.admin.saveEditedUser();
    auth.authFetch.mockRejectedValueOnce(new Error('réseau'));
    await S.admin.saveEditedUser();
    expect(toasts).toContainEqual(['error', 't:settings.toast_network_error']);
    jest.useFakeTimers();
    document.getElementById('edit-user-cancel').click();
    jest.advanceTimersByTime(300);
    expect(document.getElementById('edit-user-modal').classList.contains('hidden')).toBe(true);
    document.querySelector('.logout-modal-backdrop').click();
  });

  test('fermeture animée de la modale, annulée par une réouverture', () => {
    const S = setup();
    const modal = document.getElementById('edit-user-modal');
    window.VH.motion.exit = (el, done) => {
      const timer = setTimeout(() => done(), 300);
      return () => clearTimeout(timer);
    };
    jest.useFakeTimers();
    S.admin.openEditUserModal(USERS[1]);
    jest.advanceTimersByTime(10);
    expect(modal.classList.contains('show')).toBe(true);
    document.getElementById('edit-user-cancel').click();
    expect(modal.classList.contains('hidden')).toBe(false);
    S.admin.openEditUserModal(USERS[1]);
    jest.advanceTimersByTime(400);
    expect(modal.classList.contains('hidden')).toBe(false);
    document.getElementById('edit-user-cancel').click();
    document.getElementById('edit-user-cancel').click(); // double clic : une seule sortie
    jest.advanceTimersByTime(300);
    expect(modal.classList.contains('hidden')).toBe(true);
    expect(modal.classList.contains('show')).toBe(false);
  });

  test('mouvements réduits (sortie immédiate) : la fermeture suivante n\'est pas bloquée', () => {
    const S = setup();
    const modal = document.getElementById('edit-user-modal');
    window.VH.motion.exit = (el, done) => { done(); return () => {}; };
    jest.useFakeTimers();
    S.admin.openEditUserModal(USERS[1]);
    jest.advanceTimersByTime(10);
    document.getElementById('edit-user-cancel').click();
    expect(modal.classList.contains('hidden')).toBe(true);
    S.admin.openEditUserModal(USERS[1]);
    jest.advanceTimersByTime(10);
    document.getElementById('edit-user-cancel').click();
    expect(modal.classList.contains('hidden')).toBe(true);
  });

  test('suppression : confirmation sur place, succès, refus serveur, réseau', async () => {
    jest.useFakeTimers();
    const S = setup();
    await S.admin.loadUsers();
    const trigger = () => document.querySelector('.btn-delete');
    const wrapper = () => document.querySelector('.adm-del');
    expect(trigger().querySelector('svg.cfm-bin .cfm-bin-lid')).not.toBeNull();
    expect(trigger().getAttribute('aria-label')).toBe('t:settings.delete_user');
    expect(wrapper().dataset.state).toBe('idle');

    auth.authFetch.mockClear();
    trigger().click();
    expect(wrapper().dataset.state).toBe('confirm');
    wrapper().querySelector('.cfm-no').click();
    expect(wrapper().dataset.state).toBe('idle');
    expect(auth.authFetch).not.toHaveBeenCalled();

    auth.authFetch.mockResolvedValueOnce(jsonResponse(200, {}));
    trigger().click();
    wrapper().querySelector('.cfm-yes').click();
    expect(wrapper().dataset.state).toBe('done');
    jest.advanceTimersByTime(400);
    await Promise.resolve();
    expect(auth.authFetch).toHaveBeenCalledWith(expect.stringMatching(/\/users\/\d+$/), { method: 'DELETE' });
    await Promise.resolve();
    await Promise.resolve();
    expect(toasts).toContainEqual(['success', 't:settings.toast_user_deleted']);

    await S.admin.loadUsers();
    auth.authFetch.mockResolvedValueOnce(jsonResponse(403, { message: 'Interdit' }));
    trigger().click();
    wrapper().querySelector('.cfm-yes').click();
    jest.advanceTimersByTime(400);
    for (let i = 0; i < 6; i++) await Promise.resolve();
    expect(toasts).toContainEqual(['error', 'Interdit']);
    expect(wrapper().dataset.state).toBe('idle');

    auth.authFetch.mockRejectedValueOnce(new Error('réseau'));
    trigger().click();
    wrapper().querySelector('.cfm-yes').click();
    jest.advanceTimersByTime(400);
    for (let i = 0; i < 6; i++) await Promise.resolve();
    expect(toasts).toContainEqual(['error', 't:settings.toast_network_error']);
    expect(wrapper().dataset.state).toBe('idle');
  });

  test('deleteUser sans confirmation attachée : requête directe, repli du message', async () => {
    const S = setup();
    auth.authFetch.mockResolvedValueOnce(jsonResponse(200, {}));
    await S.admin.deleteUser(2);
    expect(auth.authFetch).toHaveBeenCalledWith('/api/users/2', { method: 'DELETE' });
    auth.authFetch.mockResolvedValueOnce({ ok: false, json: () => Promise.reject(new Error('x')) });
    await S.admin.deleteUser(2);
    expect(toasts).toContainEqual(['error', 't:settings.toast_delete_error']);
    auth.authFetch.mockRejectedValueOnce(new Error('réseau'));
    await S.admin.deleteUser(2);
    expect(toasts).toContainEqual(['error', 't:settings.toast_network_error']);
  });
});
