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
// Email de vérification de compte
// -----------------------------------------------------------------------------
async function sendVerificationEmail(to, name, token) {
  const link = `${BASE_URL}/verify-email?token=${encodeURIComponent(token)}`;
  await transporter.sendMail({
    from: FROM,
    to,
    subject: "Confirmez votre adresse email — Vol d'Histoire",
    html: buildVerifyTemplate(name, link),
  });
}

// -----------------------------------------------------------------------------
// Email de réinitialisation de mot de passe
// -----------------------------------------------------------------------------
async function sendPasswordResetEmail(to, name, token) {
  const link = `${BASE_URL}/reset-password?token=${encodeURIComponent(token)}`;
  await transporter.sendMail({
    from: FROM,
    to,
    subject: "Réinitialisation de votre mot de passe — Vol d'Histoire",
    html: buildResetTemplate(name, link),
  });
}

// -----------------------------------------------------------------------------
// Templates HTML d'emails
// -----------------------------------------------------------------------------
function buildVerifyTemplate(name, link) {
  return `<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Confirmez votre email</title>
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
              <h2 style="margin:0 0 16px;font-size:20px;font-weight:700;color:#ffffff;">Confirmez votre adresse email</h2>
              <p style="margin:0 0 28px;font-size:15px;color:rgba(255,255,255,0.55);line-height:1.75;">
                Bonjour <strong style="color:#ffffff;">${escapeHtmlEmail(name)}</strong>,<br><br>
                Merci de vous être inscrit sur <strong style="color:#C8A96E;">Vol d'Histoire</strong>. Cliquez sur le bouton ci-dessous pour confirmer votre adresse email et activer votre compte.
              </p>
              <table cellpadding="0" cellspacing="0" width="100%">
                <tr>
                  <td align="center" style="padding:0 0 32px;">
                    <a href="${link}"
                       style="display:inline-block;background:#141414;color:#C8A96E;text-decoration:none;font-size:14px;font-weight:700;letter-spacing:0.5px;padding:15px 40px;border-radius:8px;border:2px solid rgba(200,169,110,0.4);">
                      Confirmer mon email
                    </a>
                  </td>
                </tr>
              </table>
              <p style="margin:0 0 10px;font-size:13px;color:rgba(255,255,255,0.35);text-align:center;">Ce lien expire dans <strong style="color:rgba(255,255,255,0.55);">24 heures</strong>.</p>
              <p style="margin:0;font-size:12px;color:rgba(255,255,255,0.25);text-align:center;line-height:1.6;">
                Si le bouton ne fonctionne pas, copiez ce lien :<br>
                <a href="${link}" style="color:#C8A96E;word-break:break-all;">${link}</a>
              </p>
            </td>
          </tr>
          <tr>
            <td style="background:#141414;border-top:1px solid rgba(200,169,110,0.1);border-radius:0 0 12px 12px;padding:20px 40px;text-align:center;">
              <p style="margin:0;font-size:12px;color:rgba(255,255,255,0.25);line-height:1.6;">
                &copy; ${new Date().getFullYear()} Vol d'Histoire &mdash; Si vous n'avez pas cr&eacute;&eacute; de compte, ignorez cet email.
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

function buildResetTemplate(name, link) {
  return `<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Réinitialisation de mot de passe</title>
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
              <h2 style="margin:0 0 16px;font-size:20px;font-weight:700;color:#ffffff;">R&eacute;initialisation de mot de passe</h2>
              <p style="margin:0 0 28px;font-size:15px;color:rgba(255,255,255,0.55);line-height:1.75;">
                Bonjour <strong style="color:#ffffff;">${escapeHtmlEmail(name)}</strong>,<br><br>
                Vous avez demand&eacute; &agrave; r&eacute;initialiser votre mot de passe. Cliquez sur le bouton ci-dessous pour en choisir un nouveau.
              </p>
              <table cellpadding="0" cellspacing="0" width="100%">
                <tr>
                  <td align="center" style="padding:0 0 32px;">
                    <a href="${link}"
                       style="display:inline-block;background:#141414;color:#C8A96E;text-decoration:none;font-size:14px;font-weight:700;letter-spacing:0.5px;padding:15px 40px;border-radius:8px;border:2px solid rgba(200,169,110,0.4);">
                      R&eacute;initialiser mon mot de passe
                    </a>
                  </td>
                </tr>
              </table>
              <p style="margin:0 0 10px;font-size:13px;color:rgba(255,255,255,0.35);text-align:center;">Ce lien expire dans <strong style="color:rgba(255,255,255,0.55);">1 heure</strong>.</p>
              <p style="margin:0 0 20px;font-size:12px;color:rgba(255,255,255,0.25);text-align:center;line-height:1.6;">
                Si le bouton ne fonctionne pas, copiez ce lien :<br>
                <a href="${link}" style="color:#C8A96E;word-break:break-all;">${link}</a>
              </p>
              <p style="margin:0;font-size:13px;color:#e74c3c;text-align:center;padding:12px;background:rgba(231,76,60,0.08);border-radius:6px;border:1px solid rgba(231,76,60,0.2);">
                Si vous n'avez pas fait cette demande, ignorez cet email. Votre mot de passe reste inchang&eacute;.
              </p>
            </td>
          </tr>
          <tr>
            <td style="background:#141414;border-top:1px solid rgba(200,169,110,0.1);border-radius:0 0 12px 12px;padding:20px 40px;text-align:center;">
              <p style="margin:0;font-size:12px;color:rgba(255,255,255,0.25);line-height:1.6;">
                &copy; ${new Date().getFullYear()} Vol d'Histoire &mdash; Pour votre s&eacute;curit&eacute;, ce lien n'est valable qu'une seule fois.
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

module.exports = { sendVerificationEmail, sendPasswordResetEmail, sendContactEmail, verifyConnection };
