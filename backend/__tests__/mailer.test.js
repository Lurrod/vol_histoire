'use strict';

/**
 * mailer.js — gabarits d'email (purs) et envoi via un transport simulé.
 * Aucun email réel : nodemailer est remplacé, les identifiants sont fictifs.
 */

const ENV_KEYS = ['MAIL_USER', 'MAIL_PASS', 'NODE_ENV', 'CI', 'FRONTEND_URL'];
let savedEnv;

beforeEach(() => {
  savedEnv = Object.fromEntries(ENV_KEYS.map((k) => [k, process.env[k]]));
  jest.resetModules();
});

afterEach(() => {
  for (const [k, v] of Object.entries(savedEnv)) {
    if (v === undefined) delete process.env[k];
    else process.env[k] = v;
  }
  jest.restoreAllMocks();
});

/** Charge mailer.js avec un environnement donné et un nodemailer simulé. */
function loadMailer(env = {}) {
  for (const k of ENV_KEYS) delete process.env[k];
  Object.assign(process.env, { NODE_ENV: 'test' }, env);
  const sendMail = jest.fn().mockResolvedValue({ messageId: 'm1' });
  const verify = jest.fn().mockResolvedValue(true);
  const createTransport = jest.fn(() => ({ sendMail, verify }));
  jest.doMock('nodemailer', () => ({ createTransport }));
  const logger = require('../logger');
  jest.spyOn(logger, 'info').mockImplementation(() => ({}));
  jest.spyOn(logger, 'warn').mockImplementation(() => ({}));
  jest.spyOn(logger, 'error').mockImplementation(() => ({ errorId: 'x' }));
  const mailer = require('../mailer');
  return { mailer, sendMail, verify, createTransport, logger };
}

const SMTP = { MAIL_USER: 'robot@example.test', MAIL_PASS: 'secret-fictif', FRONTEND_URL: 'https://vh.example.test' };
const TOKEN = 'ab'.repeat(32);

describe('gabarits purs', () => {
  test('escapeHtmlEmail échappe & < > " et tolère le vide', () => {
    const { mailer } = loadMailer();
    expect(mailer.escapeHtmlEmail('<b>"A&B"</b>')).toBe('&lt;b&gt;&quot;A&amp;B&quot;&lt;/b&gt;');
    expect(mailer.escapeHtmlEmail('')).toBe('');
    expect(mailer.escapeHtmlEmail(null)).toBe('');
    expect(mailer.escapeHtmlEmail(42)).toBe('42');
  });

  test.each([
    ['buildVerifyTemplate', 'Confirmez votre adresse email'],
    ['buildResetTemplate', 'Réinitialisation'],
  ])('%s : lien présent deux fois (bouton + copie), nom échappé', (fn, heading) => {
    const { mailer } = loadMailer();
    const link = `https://vh.example.test/x?token=${TOKEN}`;
    const html = mailer[fn]('<script>alert(1)</script>', link);
    expect(html).toContain('<!DOCTYPE html>');
    expect(html.split(`href="${link}"`).length - 1).toBe(2);
    expect(html).toContain('&lt;script&gt;alert(1)&lt;/script&gt;');
    expect(html).not.toContain('<script>');
    expect(html).toMatch(new RegExp(heading.replace(/[éè]/g, '.')));
    expect(html).toContain(String(new Date().getFullYear()));
  });

  test('buildContactTemplate échappe chaque champ et conserve les retours à la ligne', () => {
    const { mailer } = loadMailer();
    const html = mailer.buildContactTemplate('Jean <b>', 'j"@x.fr', 'Sujet & co', 'ligne 1\n<i>ligne 2</i>');
    expect(html).toContain('Jean &lt;b&gt;');
    expect(html).toContain('mailto:j&quot;@x.fr');
    expect(html).toContain('Sujet &amp; co');
    expect(html).toContain('ligne 1<br>&lt;i&gt;ligne 2&lt;/i&gt;');
  });

  test('buildWelcomeTemplate : nom échappé, lien vers le hangar', () => {
    const { mailer } = loadMailer({ FRONTEND_URL: 'https://vh.example.test' });
    const html = mailer.buildWelcomeTemplate('Ana & "Bob"');
    expect(html).toContain('Ana &amp; &quot;Bob&quot;');
    expect(html).toContain('href="https://vh.example.test/hangar"');
  });

  test('buildNoticeTemplate : avec et sans bouton', () => {
    const { mailer } = loadMailer();
    const withCta = mailer.buildNoticeTemplate({
      heading: 'Titre <h>', name: 'Nom', paragraph: 'Texte & suite', note: 'Note',
      cta: { label: 'Cliquer <ici>', link: 'https://vh.example.test/l?token=1' },
    });
    expect(withCta).toContain('<title>Titre &lt;h&gt;</title>');
    expect(withCta).toContain('Texte &amp; suite');
    expect(withCta).toContain('Cliquer &lt;ici&gt;');
    expect(withCta.split('href="https://vh.example.test/l?token=1"').length - 1).toBe(2);

    const without = mailer.buildNoticeTemplate({ heading: 'H', name: 'N', paragraph: 'P', note: 'N2', cta: null });
    expect(without).not.toContain('href="http');
    expect(without).toContain('N2');
  });
});

describe('envoi via SMTP (transport simulé)', () => {
  test('transport OVH configuré avec les identifiants de l\'environnement', () => {
    const { createTransport } = loadMailer(SMTP);
    expect(createTransport).toHaveBeenCalledWith(expect.objectContaining({
      host: 'ssl0.ovh.net', port: 465, secure: true,
      auth: { user: SMTP.MAIL_USER, pass: SMTP.MAIL_PASS },
    }));
  });

  test('vérification : lien /verify-email avec jeton encodé', async () => {
    const { mailer, sendMail } = loadMailer(SMTP);
    await mailer.sendVerificationEmail('a@b.fr', 'Ana', 'a b&c');
    const mail = sendMail.mock.calls[0][0];
    expect(mail.to).toBe('a@b.fr');
    expect(mail.from).toBe(`"Vol d'Histoire" <${SMTP.MAIL_USER}>`);
    expect(mail.subject).toMatch(/Confirmez votre adresse email/);
    expect(mail.html).toContain('href="https://vh.example.test/verify-email?token=a%20b%26c"');
  });

  test('réinitialisation : lien /reset-password', async () => {
    const { mailer, sendMail } = loadMailer(SMTP);
    await mailer.sendPasswordResetEmail('a@b.fr', 'Ana', TOKEN);
    const mail = sendMail.mock.calls[0][0];
    expect(mail.subject).toMatch(/Réinitialisation/);
    expect(mail.html).toContain(`https://vh.example.test/reset-password?token=${TOKEN}`);
  });

  test('changement d\'adresse : lien type=email à la nouvelle, avertissement sans lien à l\'ancienne', async () => {
    const { mailer, sendMail } = loadMailer(SMTP);
    await mailer.sendEmailChangeConfirmation('new@b.fr', 'Ana', TOKEN);
    await mailer.sendEmailChangeNotice('old@b.fr', 'Ana');
    const [confirm, notice] = sendMail.mock.calls.map((c) => c[0]);
    expect(confirm.to).toBe('new@b.fr');
    expect(confirm.html).toContain(`https://vh.example.test/verify-email?type=email&token=${TOKEN}`);
    expect(notice.to).toBe('old@b.fr');
    expect(notice.subject).toMatch(/Changement d'adresse demandé/);
    expect(notice.html).not.toContain('verify-email');
  });

  test('contact : replyTo, sujet préfixé, message échappé', async () => {
    const { mailer, sendMail } = loadMailer(SMTP);
    await mailer.sendContactEmail({
      to: 'vdh@x.fr', replyTo: 'v@x.fr', name: 'V', email: 'v@x.fr', subject: 'Bug', message: '<img src=x>',
    });
    const mail = sendMail.mock.calls[0][0];
    expect(mail.replyTo).toBe('v@x.fr');
    expect(mail.subject).toBe("[Vol d'Histoire] Bug");
    expect(mail.html).toContain('&lt;img src=x&gt;');
  });

  test('bienvenue', async () => {
    const { mailer, sendMail } = loadMailer(SMTP);
    await mailer.sendWelcomeEmail('a@b.fr', 'Ana');
    expect(sendMail.mock.calls[0][0].subject).toMatch(/Bienvenue/);
  });

  test('verifyConnection : succès journalisé, échec journalisé sans lever', async () => {
    const { mailer, verify, logger } = loadMailer(SMTP);
    await mailer.verifyConnection();
    expect(logger.info).toHaveBeenCalledWith('Connexion SMTP OVH établie');
    verify.mockRejectedValueOnce(new Error('refus'));
    await expect(mailer.verifyConnection()).resolves.toBeUndefined();
    expect(logger.error).toHaveBeenCalledWith('Erreur SMTP', { error: 'refus' });
  });
});

describe('sans identifiants SMTP', () => {
  test('test/CI : transport no-op silencieux, verifyConnection sautée', async () => {
    const { mailer, createTransport, logger } = loadMailer({ CI: 'true' });
    expect(createTransport).not.toHaveBeenCalled();
    await expect(mailer.sendWelcomeEmail('a@b.fr', 'Ana')).resolves.toBeUndefined();
    await expect(mailer.verifyConnection()).resolves.toBeUndefined();
    expect(logger.warn).not.toHaveBeenCalled();
  });

  test('développement local : avertissement', () => {
    const { logger } = loadMailer({ NODE_ENV: 'development' });
    expect(logger.warn).toHaveBeenCalledWith(expect.stringMatching(/no-op/));
  });

  test('production : arrêt du processus', () => {
    const exit = jest.spyOn(process, 'exit').mockImplementation(() => {});
    const { logger } = loadMailer({ NODE_ENV: 'production' });
    expect(logger.error).toHaveBeenCalledWith(expect.stringMatching(/MAIL_USER et MAIL_PASS requises/));
    expect(exit).toHaveBeenCalledWith(1);
  });
});
