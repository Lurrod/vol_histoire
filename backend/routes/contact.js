'use strict';
const { Router } = require('express');
const { isValidEmail, isValidString } = require('../validators');
const verifyHcaptcha = require('../middleware/hcaptcha');
const { isValidDbId } = require('../middleware/input-guards');
const airplanesRepo = require('../repositories/airplanes');
const { buildDetailsPath } = require('../utils/url');
const { SITE_URL } = require('../utils/ssr-head');
const logger = require('../logger');

const VALID_SUBJECTS = ['general', 'bug', 'contrib', 'partner', 'other'];
const CONTACT_TO = process.env.CONTACT_EMAIL || process.env.MAIL_USER || 'vdh@titouan-borde.com';

function createContactRouter(getPool, { contactLimiter, mailer }) {
  const router = Router();

  router.post('/contact', contactLimiter, verifyHcaptcha, async (req, res) => {
    // name : champ unique du formulaire (2026-11-21) ; firstname/lastname :
    // ancien formulaire, encore accepté. aircraft_id : « fiche concernée »,
    // facultatif — le nom et le lien sont relus en base, jamais recopiés.
    const { name, firstname, lastname, email, subject, message, aircraft_id: aircraftId } = req.body;

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
    if (name != null && name !== '' && !isValidString(name, 100)) {
      return res.status(400).json({ message: 'Nom invalide (100 caractères max).' });
    }
    if (aircraftId != null && aircraftId !== '' && !isValidDbId(aircraftId)) {
      return res.status(400).json({ message: 'Fiche invalide.' });
    }

    const safeName = (typeof name === 'string' && name.trim())
      || [(firstname || '').trim(), (lastname || '').trim()].filter(Boolean).join(' ')
      || 'Anonyme';

    // Fiche concernée : en tête du message, avec son lien. Fiche inconnue ou
    // base indisponible → message envoyé sans cette ligne.
    let aircraftLine = '';
    if (aircraftId != null && aircraftId !== '') {
      try {
        const aircraft = await airplanesRepo.findNameById(getPool(), Number(aircraftId));
        if (aircraft) {
          aircraftLine = `Fiche concernée : ${aircraft.name} — ${SITE_URL}${buildDetailsPath(aircraft.id, aircraft.name)}\n\n`;
        }
      } catch (err) {
        logger.warn('Contact : fiche concernée illisible', { error: err.message });
      }
    }
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
        message: aircraftLine + message.trim(),
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
