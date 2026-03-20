// -----------------------------------------------------------------------------
// Fonctions de validation — extraites pour être testables unitairement
// -----------------------------------------------------------------------------

function isValidEmail(email) {
  return typeof email === 'string' && /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email) && email.length <= 255;
}

function isValidName(name) {
  return typeof name === 'string' && name.trim().length >= 2 && name.length <= 255;
}

function isValidPassword(password) {
  return typeof password === 'string' && password.length >= 4 && password.length <= 128;
}

function isValidString(value, maxLength = 255) {
  return typeof value === 'string' && value.trim().length > 0 && value.length <= maxLength;
}

function isOptionalString(value, maxLength = 255) {
  return value == null || value === '' || (typeof value === 'string' && value.length <= maxLength);
}

function isOptionalText(value, maxLength = 10000) {
  return value == null || value === '' || (typeof value === 'string' && value.length <= maxLength);
}

function isOptionalUrl(value) {
  if (value == null || value === '') return true;
  if (typeof value !== 'string' || value.length > 2048) return false;
  return /^https?:\/\/.+/i.test(value);
}

function isOptionalDate(value) {
  if (value == null || value === '') return true;
  return typeof value === 'string' && !isNaN(Date.parse(value));
}

function isOptionalPositiveNumber(value) {
  if (value == null || value === '' || value === null) return true;
  const num = Number(value);
  return !isNaN(num) && num >= 0;
}

function isOptionalId(value) {
  if (value == null || value === '' || value === null) return true;
  const num = Number(value);
  return Number.isInteger(num) && num > 0;
}

function validateAirplaneData(body) {
  const errors = [];

  if (!isValidString(body.name, 255)) {
    errors.push('Le nom est requis (max 255 caractères).');
  }
  if (!isOptionalString(body.complete_name, 255)) {
    errors.push('Le nom complet ne doit pas dépasser 255 caractères.');
  }
  if (!isOptionalString(body.little_description, 255)) {
    errors.push('La description courte ne doit pas dépasser 255 caractères.');
  }
  if (!isOptionalUrl(body.image_url)) {
    errors.push("L'URL de l'image doit être une URL valide (http/https, max 2048 caractères).");
  }
  if (!isOptionalText(body.description, 10000)) {
    errors.push('La description ne doit pas dépasser 10 000 caractères.');
  }
  if (!isOptionalId(body.country_id)) {
    errors.push("L'ID du pays doit être un entier positif.");
  }
  if (!isOptionalDate(body.date_concept)) {
    errors.push('La date de conception doit être une date valide.');
  }
  if (!isOptionalDate(body.date_first_fly)) {
    errors.push('La date du premier vol doit être une date valide.');
  }
  if (!isOptionalDate(body.date_operationel)) {
    errors.push('La date opérationnelle doit être une date valide.');
  }
  if (!isOptionalPositiveNumber(body.max_speed)) {
    errors.push('La vitesse max doit être un nombre positif.');
  }
  if (!isOptionalPositiveNumber(body.max_range)) {
    errors.push('La portée max doit être un nombre positif.');
  }
  if (!isOptionalId(body.id_manufacturer)) {
    errors.push("L'ID du fabricant doit être un entier positif.");
  }
  if (!isOptionalId(body.id_generation)) {
    errors.push("L'ID de la génération doit être un entier positif.");
  }
  if (!isOptionalId(body.type)) {
    errors.push("L'ID du type doit être un entier positif.");
  }
  if (!isOptionalString(body.status, 50)) {
    errors.push('Le statut ne doit pas dépasser 50 caractères.');
  }
  if (!isOptionalPositiveNumber(body.weight)) {
    errors.push('Le poids doit être un nombre positif.');
  }

  return errors;
}

module.exports = {
  isValidEmail,
  isValidName,
  isValidPassword,
  isValidString,
  isOptionalString,
  isOptionalText,
  isOptionalUrl,
  isOptionalDate,
  isOptionalPositiveNumber,
  isOptionalId,
  validateAirplaneData,
};
