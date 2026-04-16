'use strict';
const { Router } = require('express');
const { isValidEmail, isValidString } = require('../validators');
const verifyHcaptcha = require('../middleware/hcaptcha');
const logger = require('../logger');

const VALID_SUBJECTS = ['general', 'bug', 'contrib', 'partner', 'other'];
const CONTACT_TO = process.env.CONTACT_EMAIL || process.env.MAIL_USER || 'vdh@titouan-borde.com';

function createContactRouter(getPool, { contactLimiter, mailer }) {
  const router = Router();

  router.post('/contact', contactLimiter, verifyHcaptcha, async (req, res) => {
    const { firstname, lastname, email, subject, message } = req.body;

    // Validation
    if (!isValidEmail(email)) {
      return res.status(400).json({ message: 'Adresse email invalide.' });
    }
    if (!isValidString(message, 5000)) {
      return res.status(400).json({ message: 'Le message est requis (5000 caractères max).' });
    }
    if (subject && !VALID_SUBJECTS.includes(subject)) {
      return res.status(400).json({ message: 'Sujet invalide.' });
    }

    const safeName = [(firstname || '').trim(), (lastname || '').trim()].filter(Boolean).join(' ') || 'Anonyme';
    const safeSubject = subject || 'general';

    const subjectLabels = {
      general: 'Question générale',
      bug: 'Signalement de bug',
      contrib: 'Contribution',
      partner: 'Partenariat',
      other: 'Autre',
    };

    try {
      await mailer.sendContactEmail({
        to: CONTACT_TO,
        replyTo: email,
        name: safeName,
        email,
        subject: subjectLabels[safeSubject] || safeSubject,
        message: message.trim(),
      });

      logger.info('Email de contact envoyé', { from: email, subject: safeSubject });
      return res.json({ message: 'Message envoyé avec succès.' });
    } catch (err) {
      logger.error('Erreur envoi email contact', { error: err.message });
      return res.status(500).json({ message: 'Erreur lors de l\'envoi du message.' });
    }
  });

  return router;
}

module.exports = createContactRouter;
