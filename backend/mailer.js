'use strict';
const nodemailer = require('nodemailer');
const logger = require('./logger');

// -----------------------------------------------------------------------------
// Détection mode "no-mailer" : test, CI, ou MAIL_USER/MAIL_PASS absents
// En production, MAIL_USER/MAIL_PASS sont OBLIGATOIRES (exit 1).
// Sinon : transporter no-op qui résout sans rien envoyer (logs en debug).
// -----------------------------------------------------------------------------
const HAS_SMTP_CREDS = Boolean(process.env.MAIL_USER && process.env.MAIL_PASS);
const IS_TEST_OR_CI = process.env.NODE_ENV === 'test' || process.env.CI === 'true';

if (!HAS_SMTP_CREDS) {
  if (process.env.NODE_ENV === 'production') {
    logger.error('Variables MAIL_USER et MAIL_PASS requises en production');
    process.exit(1);
  }
  if (!IS_TEST_OR_CI) {
    logger.warn('MAIL_USER/MAIL_PASS absents — mailer en mode no-op (dev local)');
  }
}

// -----------------------------------------------------------------------------
// Configuration SMTP — OVH (uniquement si credentials présents)
// -----------------------------------------------------------------------------
const transporter = HAS_SMTP_CREDS
  ? nodemailer.createTransport({
      host: 'ssl0.ovh.net',
      port: 465,
      secure: true, // SSL/TLS
      auth: {
        user: process.env.MAIL_USER,
        pass: process.env.MAIL_PASS,
      },
      tls: {
        rejectUnauthorized: true,
      },
    })
  : {
      // No-op transporter : résout sans rien envoyer
      sendMail: async () => ({ messageId: 'noop', accepted: [], rejected: [] }),
      verify: async () => true,
    };

const BASE_URL = process.env.FRONTEND_URL || 'https://vol-histoire.titouan-borde.com';
const FROM = `"Vol d'Histoire" <${process.env.MAIL_USER || 'noreply@vol-histoire.local'}>`;

// -----------------------------------------------------------------------------
// Vérification de la connexion SMTP au démarrage
// -----------------------------------------------------------------------------
async function verifyConnection() {
  if (!HAS_SMTP_CREDS) return; // skip silencieux en mode no-op
  try {
    await transporter.verify();
    logger.info('Connexion SMTP OVH établie');
  } catch (err) {
    logger.error('Erreur SMTP', { error: err.message });
  }
}

// -----------------------------------------------------------------------------
// Emails à code (activation, mot de passe oublié, changement d'adresse)
// -----------------------------------------------------------------------------
// Plus de lien : un code à 6 chiffres, saisi sur le site (page de connexion,
// réglages). Le code n'apparaît pas dans l'objet du message, qui s'affiche
// dans les notifications du téléphone, verrouillé compris.

async function sendVerificationEmail(to, name, code) {
  await transporter.sendMail({
    from: FROM,
    to,
    subject: "Votre code d'activation — Vol d'Histoire",
    html: buildCodeTemplate({
      heading: "Votre code d'activation",
      name,
      paragraph: "Merci de vous être inscrit sur Vol d'Histoire. Saisissez ce code sur la page de connexion pour activer votre compte et choisir votre mot de passe.",
      code,
      validity: '30 minutes',
      note: "Si vous n'avez pas créé de compte, ignorez cet email : aucun compte ne sera activé.",
    }),
  });
}

async function sendPasswordResetEmail(to, name, code) {
  await transporter.sendMail({
    from: FROM,
    to,
    subject: "Réinitialisation de votre mot de passe — Vol d'Histoire",
    html: buildCodeTemplate({
      heading: 'Réinitialisation de mot de passe',
      name,
      paragraph: 'Vous avez demandé à réinitialiser votre mot de passe. Saisissez ce code sur la page de connexion pour en choisir un nouveau.',
      code,
      validity: '15 minutes',
      note: "Si vous n'avez pas fait cette demande, ignorez cet email. Votre mot de passe reste inchangé.",
    }),
  });
}

/**
 * Gabarit des emails à code : le code en grand, chiffres espacés, sa durée
 * de validité, puis l'avertissement de sécurité.
 */
function buildCodeTemplate({ heading, name, paragraph, code, validity, note }) {
  const esc = escapeHtmlEmail;
  return `<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${esc(heading)}</title>
</head>
<body style="margin:0;padding:0;background:#0D0D0D;font-family:'Segoe UI',Arial,sans-serif;">
  <table width="100%" cellpadding="0" cellspacing="0" style="background:#0D0D0D;padding:40px 16px;">
    <tr>
      <td align="center">
        <table width="560" cellpadding="0" cellspacing="0" style="max-width:560px;width:100%;">
          <tr>
            <td style="background:#141414;border-radius:12px 12px 0 0;padding:32px 40px;text-align:center;border-bottom:2px solid rgba(200,169,110,0.25);">
              <p style="margin:0;font-size:11px;font-weight:700;letter-spacing:3px;text-transform:uppercase;color:rgba(200,169,110,0.5);">AVIATION MILITAIRE</p>
              <h1 style="margin:10px 0 0;font-size:26px;font-weight:700;color:#ffffff;letter-spacing:-0.5px;">Vol d'Histoire</h1>
              <div style="width:32px;height:2px;background:#C8A96E;margin:14px auto 0;border-radius:1px;"></div>
            </td>
          </tr>
          <tr>
            <td style="background:#1A1A1A;padding:40px 40px 32px;">
              <h2 style="margin:0 0 16px;font-size:20px;font-weight:700;color:#ffffff;">${esc(heading)}</h2>
              <p style="margin:0 0 28px;font-size:15px;color:rgba(255,255,255,0.55);line-height:1.75;">
                Bonjour <strong style="color:#ffffff;">${esc(name)}</strong>,<br><br>
                ${esc(paragraph)}
              </p>
              <table cellpadding="0" cellspacing="0" width="100%">
                <tr>
                  <td align="center" style="padding:0 0 24px;">
                    <div style="display:inline-block;background:#141414;border:2px solid rgba(200,169,110,0.4);border-radius:10px;padding:18px 28px;font-family:'Courier New',Courier,monospace;font-size:34px;font-weight:700;letter-spacing:12px;color:#C8A96E;">${esc(code)}</div>
                  </td>
                </tr>
              </table>
              <p style="margin:0 0 24px;font-size:13px;color:rgba(255,255,255,0.35);text-align:center;">Ce code est valable <strong style="color:rgba(255,255,255,0.55);">${esc(validity)}</strong>, pour un seul usage.</p>
              <p style="margin:0;font-size:13px;color:#e74c3c;text-align:center;padding:12px;background:rgba(231,76,60,0.08);border-radius:6px;border:1px solid rgba(231,76,60,0.2);">
                ${esc(note)} Ne communiquez ce code à personne.
              </p>
            </td>
          </tr>
          <tr>
            <td style="background:#141414;border-top:1px solid rgba(200,169,110,0.1);border-radius:0 0 12px 12px;padding:20px 40px;text-align:center;">
              <p style="margin:0;font-size:12px;color:rgba(255,255,255,0.25);line-height:1.6;">
                &copy; ${new Date().getFullYear()} Vol d'Histoire &mdash; Message de sécurité envoyé automatiquement.
              </p>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</body>
</html>`;
}

// -----------------------------------------------------------------------------
// Email de contact (formulaire public)
// -----------------------------------------------------------------------------
async function sendContactEmail({ to, replyTo, name, email, subject, message }) {
  await transporter.sendMail({
    from: FROM,
    to,
    replyTo,
    subject: `[Vol d'Histoire] ${subject}`,
    html: buildContactTemplate(name, email, subject, message),
  });
}

function buildContactTemplate(name, email, subject, message) {
  const safeName = escapeHtmlEmail(name);
  const safeEmail = escapeHtmlEmail(email);
  const safeSubject = escapeHtmlEmail(subject);
  const safeMessage = escapeHtmlEmail(message).replace(/\n/g, '<br>');

  return `<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Nouveau message de contact</title>
</head>
<body style="margin:0;padding:0;background:#0D0D0D;font-family:'Segoe UI',Arial,sans-serif;">
  <table width="100%" cellpadding="0" cellspacing="0" style="background:#0D0D0D;padding:40px 16px;">
    <tr>
      <td align="center">
        <table width="560" cellpadding="0" cellspacing="0" style="max-width:560px;width:100%;">
          <tr>
            <td style="background:#141414;border-radius:12px 12px 0 0;padding:32px 40px;text-align:center;border-bottom:2px solid rgba(200,169,110,0.25);">
              <p style="margin:0;font-size:11px;font-weight:700;letter-spacing:3px;text-transform:uppercase;color:rgba(200,169,110,0.5);">FORMULAIRE DE CONTACT</p>
              <h1 style="margin:10px 0 0;font-size:26px;font-weight:700;color:#ffffff;letter-spacing:-0.5px;">Vol d'Histoire</h1>
              <div style="width:32px;height:2px;background:#C8A96E;margin:14px auto 0;border-radius:1px;"></div>
            </td>
          </tr>
          <tr>
            <td style="background:#1A1A1A;padding:40px;">
              <table width="100%" cellpadding="0" cellspacing="0" style="margin-bottom:24px;">
                <tr>
                  <td style="padding:8px 0;font-size:13px;color:rgba(255,255,255,0.45);width:80px;vertical-align:top;">De</td>
                  <td style="padding:8px 0;font-size:14px;color:#ffffff;">${safeName}</td>
                </tr>
                <tr>
                  <td style="padding:8px 0;font-size:13px;color:rgba(255,255,255,0.45);vertical-align:top;">Email</td>
                  <td style="padding:8px 0;font-size:14px;"><a href="mailto:${safeEmail}" style="color:#C8A96E;text-decoration:none;">${safeEmail}</a></td>
                </tr>
                <tr>
                  <td style="padding:8px 0;font-size:13px;color:rgba(255,255,255,0.45);vertical-align:top;">Sujet</td>
                  <td style="padding:8px 0;font-size:14px;color:#ffffff;">${safeSubject}</td>
                </tr>
              </table>
              <div style="border-top:1px solid rgba(200,169,110,0.15);padding-top:24px;">
                <h2 style="margin:0 0 12px;font-size:16px;font-weight:600;color:rgba(255,255,255,0.6);">Message</h2>
                <p style="margin:0;font-size:15px;color:rgba(255,255,255,0.8);line-height:1.75;">${safeMessage}</p>
              </div>
            </td>
          </tr>
          <tr>
            <td style="background:#141414;border-top:1px solid rgba(200,169,110,0.1);border-radius:0 0 12px 12px;padding:20px 40px;text-align:center;">
              <p style="margin:0;font-size:12px;color:rgba(255,255,255,0.25);line-height:1.6;">
                R&eacute;pondre directement &agrave; cet email enverra votre r&eacute;ponse &agrave; ${safeEmail}.
              </p>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</body>
</html>`;
}

function escapeHtmlEmail(text) {
  if (!text) return '';
  return String(text)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}

// -----------------------------------------------------------------------------
// Email de bienvenue (envoyé après vérification de l'email)
// -----------------------------------------------------------------------------
async function sendWelcomeEmail(to, name) {
  await transporter.sendMail({
    from: FROM,
    to,
    subject: "Bienvenue sur Vol d'Histoire !",
    html: buildWelcomeTemplate(name),
  });
}

function buildWelcomeTemplate(name) {
  return `<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Bienvenue sur Vol d'Histoire</title>
</head>
<body style="margin:0;padding:0;background:#0D0D0D;font-family:'Segoe UI',Arial,sans-serif;">
  <table width="100%" cellpadding="0" cellspacing="0" style="background:#0D0D0D;padding:40px 16px;">
    <tr>
      <td align="center">
        <table width="560" cellpadding="0" cellspacing="0" style="max-width:560px;width:100%;">
          <tr>
            <td style="background:#141414;border-radius:12px 12px 0 0;padding:32px 40px;text-align:center;border-bottom:2px solid rgba(200,169,110,0.25);">
              <p style="margin:0;font-size:11px;font-weight:700;letter-spacing:3px;text-transform:uppercase;color:rgba(200,169,110,0.5);">AVIATION MILITAIRE</p>
              <h1 style="margin:10px 0 0;font-size:26px;font-weight:700;color:#ffffff;letter-spacing:-0.5px;">Vol d'Histoire</h1>
              <div style="width:32px;height:2px;background:#C8A96E;margin:14px auto 0;border-radius:1px;"></div>
            </td>
          </tr>
          <tr>
            <td style="background:#1A1A1A;padding:40px 40px 32px;">
              <h2 style="margin:0 0 16px;font-size:20px;font-weight:700;color:#ffffff;">Bienvenue &agrave; bord, ${escapeHtmlEmail(name)}&nbsp;!</h2>
              <p style="margin:0 0 28px;font-size:15px;color:rgba(255,255,255,0.55);line-height:1.75;">
                Votre compte est activ&eacute; et pr&ecirc;t. Voici ce que vous pouvez faire sur <strong style="color:#C8A96E;">Vol d'Histoire</strong>&nbsp;:
              </p>
              <table width="100%" cellpadding="0" cellspacing="0">
                <tr>
                  <td style="padding:12px 0;border-bottom:1px solid rgba(200,169,110,0.1);">
                    <table cellpadding="0" cellspacing="0"><tr>
                      <td style="width:36px;vertical-align:top;padding-top:2px;font-size:18px;color:#C8A96E;">&#9992;</td>
                      <td style="font-size:14px;color:rgba(255,255,255,0.7);line-height:1.6;"><strong style="color:#fff;">Explorez le Hangar</strong><br>Parcourez notre catalogue de plus de 50 avions de chasse avec fiches techniques, armement et historique.</td>
                    </tr></table>
                  </td>
                </tr>
                <tr>
                  <td style="padding:12px 0;border-bottom:1px solid rgba(200,169,110,0.1);">
                    <table cellpadding="0" cellspacing="0"><tr>
                      <td style="width:36px;vertical-align:top;padding-top:2px;font-size:18px;color:#C8A96E;">&#128150;</td>
                      <td style="font-size:14px;color:rgba(255,255,255,0.7);line-height:1.6;"><strong style="color:#fff;">Sauvegardez vos favoris</strong><br>Ajoutez des avions &agrave; votre collection personnelle d'un clic.</td>
                    </tr></table>
                  </td>
                </tr>
                <tr>
                  <td style="padding:12px 0;">
                    <table cellpadding="0" cellspacing="0"><tr>
                      <td style="width:36px;vertical-align:top;padding-top:2px;font-size:18px;color:#C8A96E;">&#128336;</td>
                      <td style="font-size:14px;color:rgba(255,255,255,0.7);line-height:1.6;"><strong style="color:#fff;">Parcourez la Chronologie</strong><br>Voyagez &agrave; travers 75 ans d'aviation militaire sur notre frise interactive.</td>
                    </tr></table>
                  </td>
                </tr>
              </table>
              <table cellpadding="0" cellspacing="0" width="100%" style="margin-top:28px;">
                <tr>
                  <td align="center">
                    <a href="${BASE_URL}/hangar"
                       style="display:inline-block;background:#141414;color:#C8A96E;text-decoration:none;font-size:14px;font-weight:700;letter-spacing:0.5px;padding:15px 40px;border-radius:8px;border:2px solid rgba(200,169,110,0.4);">
                      Commencer l'exploration
                    </a>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
          <tr>
            <td style="background:#141414;border-top:1px solid rgba(200,169,110,0.1);border-radius:0 0 12px 12px;padding:20px 40px;text-align:center;">
              <p style="margin:0;font-size:12px;color:rgba(255,255,255,0.25);line-height:1.6;">
                &copy; ${new Date().getFullYear()} Vol d'Histoire &mdash; Une question&nbsp;? Contactez-nous &agrave; <a href="mailto:vdh@titouan-borde.com" style="color:#C8A96E;text-decoration:none;">vdh@titouan-borde.com</a>
              </p>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</body>
</html>`;
}

// -----------------------------------------------------------------------------
// Changement d'adresse email (demandé depuis les paramètres)
// -----------------------------------------------------------------------------
// Code envoyé à la NOUVELLE adresse : le changement n'est appliqué qu'une
// fois le code saisi dans les réglages.
async function sendEmailChangeConfirmation(to, name, code) {
  await transporter.sendMail({
    from: FROM,
    to,
    subject: "Confirmez votre nouvelle adresse — Vol d'Histoire",
    html: buildCodeTemplate({
      heading: 'Confirmez votre nouvelle adresse',
      name,
      paragraph: "Une demande de changement d'adresse email a été faite pour votre compte. Saisissez ce code dans vos réglages pour que cette adresse remplace l'ancienne.",
      code,
      validity: '30 minutes',
      note: "Si vous n'êtes pas à l'origine de cette demande, ignorez cet email : rien ne sera modifié.",
    }),
  });
}

// Avertissement envoyé à l'ANCIENNE adresse : le titulaire doit savoir qu'un
// changement a été demandé, même s'il n'en est pas l'auteur.
async function sendEmailChangeNotice(to, name) {
  await transporter.sendMail({
    from: FROM,
    to,
    subject: "Changement d'adresse demandé — Vol d'Histoire",
    html: buildNoticeTemplate({
      heading: "Changement d'adresse demandé",
      name,
      paragraph: "Une demande de changement de l'adresse email associée à votre compte vient d'être faite. Elle ne prendra effet que si le code envoyé à la nouvelle adresse est saisi.",
      cta: null,
      note: "Si vous n'êtes pas à l'origine de cette demande, changez votre mot de passe dès maintenant : « Mot de passe oublié » sur la page de connexion.",
    }),
  });
}

// Inscription tentée avec une adresse qui a déjà un compte vérifié. La
// réponse HTTP reste identique (anti-énumération) : seul le titulaire de la
// boîte apprend que l'adresse est prise. Aucun code : rien à saisir de
// sensible, juste les chemins habituels (connexion, mot de passe oublié).
async function sendAccountExistsNotice(to, name) {
  await transporter.sendMail({
    from: FROM,
    to,
    subject: "Tentative d'inscription avec votre adresse — Vol d'Histoire",
    html: buildNoticeTemplate({
      heading: "Vous avez déjà un compte",
      name,
      paragraph: "Quelqu'un — peut-être vous — vient de demander la création d'un compte avec cette adresse email, qui en possède déjà un. Aucun nouveau compte n'a été créé et le vôtre n'a pas été modifié.",
      cta: { label: 'Se connecter', link: `${BASE_URL}/login` },
      note: "Mot de passe oublié ? Demandez un code depuis « Mot de passe oublié » sur la page de connexion. Si vous n'êtes pas à l'origine de cette demande, ignorez cet email.",
    }),
  });
}

function buildNoticeTemplate({ heading, name, paragraph, cta, note }) {
  const esc = escapeHtmlEmail;
  const button = cta
    ? `<table cellpadding="0" cellspacing="0" width="100%">
                <tr>
                  <td align="center" style="padding:0 0 32px;">
                    <a href="${cta.link}"
                       style="display:inline-block;background:#141414;color:#C8A96E;text-decoration:none;font-size:14px;font-weight:700;letter-spacing:0.5px;padding:15px 40px;border-radius:8px;border:2px solid rgba(200,169,110,0.4);">
                      ${esc(cta.label)}
                    </a>
                  </td>
                </tr>
              </table>
              <p style="margin:0 0 20px;font-size:12px;color:rgba(255,255,255,0.25);text-align:center;line-height:1.6;">
                Si le bouton ne fonctionne pas, copiez ce lien :<br>
                <a href="${cta.link}" style="color:#C8A96E;word-break:break-all;">${cta.link}</a>
              </p>`
    : '';
  return `<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${esc(heading)}</title>
</head>
<body style="margin:0;padding:0;background:#0D0D0D;font-family:'Segoe UI',Arial,sans-serif;">
  <table width="100%" cellpadding="0" cellspacing="0" style="background:#0D0D0D;padding:40px 16px;">
    <tr>
      <td align="center">
        <table width="560" cellpadding="0" cellspacing="0" style="max-width:560px;width:100%;">
          <tr>
            <td style="background:#141414;border-radius:12px 12px 0 0;padding:32px 40px;text-align:center;border-bottom:2px solid rgba(200,169,110,0.25);">
              <p style="margin:0;font-size:11px;font-weight:700;letter-spacing:3px;text-transform:uppercase;color:rgba(200,169,110,0.5);">AVIATION MILITAIRE</p>
              <h1 style="margin:10px 0 0;font-size:26px;font-weight:700;color:#ffffff;letter-spacing:-0.5px;">Vol d'Histoire</h1>
              <div style="width:32px;height:2px;background:#C8A96E;margin:14px auto 0;border-radius:1px;"></div>
            </td>
          </tr>
          <tr>
            <td style="background:#1A1A1A;padding:40px 40px 32px;">
              <h2 style="margin:0 0 16px;font-size:20px;font-weight:700;color:#ffffff;">${esc(heading)}</h2>
              <p style="margin:0 0 28px;font-size:15px;color:rgba(255,255,255,0.55);line-height:1.75;">
                Bonjour <strong style="color:#ffffff;">${esc(name)}</strong>,<br><br>
                ${esc(paragraph)}
              </p>
              ${button}
              <p style="margin:0;font-size:13px;color:#e74c3c;text-align:center;padding:12px;background:rgba(231,76,60,0.08);border-radius:6px;border:1px solid rgba(231,76,60,0.2);">
                ${esc(note)}
              </p>
            </td>
          </tr>
          <tr>
            <td style="background:#141414;border-top:1px solid rgba(200,169,110,0.1);border-radius:0 0 12px 12px;padding:20px 40px;text-align:center;">
              <p style="margin:0;font-size:12px;color:rgba(255,255,255,0.25);line-height:1.6;">
                &copy; ${new Date().getFullYear()} Vol d'Histoire &mdash; Message de sécurité envoyé automatiquement.
              </p>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</body>
</html>`;
}

module.exports = {
  sendVerificationEmail,
  sendPasswordResetEmail,
  sendEmailChangeConfirmation,
  sendEmailChangeNotice,
  sendAccountExistsNotice,
  sendContactEmail,
  sendWelcomeEmail,
  verifyConnection,
  // Gabarits purs (entrée → HTML), exposés pour les tests.
  buildCodeTemplate,
  buildContactTemplate,
  buildWelcomeTemplate,
  buildNoticeTemplate,
  escapeHtmlEmail,
};
