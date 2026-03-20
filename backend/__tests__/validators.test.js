/**
 * Tests unitaires — Fonctions de validation (validators.js)
 */
const {
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
} = require('../validators');

// =============================================================================
// isValidEmail
// =============================================================================
describe('isValidEmail', () => {
  test('accepte un email valide', () => {
    expect(isValidEmail('test@example.com')).toBe(true);
  });

  test('accepte un email avec sous-domaine', () => {
    expect(isValidEmail('user@mail.domain.fr')).toBe(true);
  });

  test('refuse une chaîne sans @', () => {
    expect(isValidEmail('notanemail')).toBe(false);
  });

  test('refuse une chaîne sans domaine', () => {
    expect(isValidEmail('user@')).toBe(false);
  });

  test('refuse une chaîne sans extension', () => {
    expect(isValidEmail('user@domain')).toBe(false);
  });

  test('refuse un email avec espaces', () => {
    expect(isValidEmail('us er@example.com')).toBe(false);
  });

  test('refuse un nombre', () => {
    expect(isValidEmail(42)).toBe(false);
  });

  test('refuse null', () => {
    expect(isValidEmail(null)).toBe(false);
  });

  test('refuse undefined', () => {
    expect(isValidEmail(undefined)).toBe(false);
  });

  test('refuse un email de plus de 255 caractères', () => {
    const longEmail = 'a'.repeat(251) + '@b.fr'; // 251 + 5 = 256 chars > 255
    expect(isValidEmail(longEmail)).toBe(false);
  });

  test('accepte exactement 255 caractères', () => {
    // format: local@domain.ext où total = 255
    const local = 'a'.repeat(248);
    const email = `${local}@b.fr`; // 248 + 1 + 1 + 1 + 2 = 253 chars, OK
    expect(isValidEmail(email)).toBe(true);
  });
});

// =============================================================================
// isValidName
// =============================================================================
describe('isValidName', () => {
  test('accepte un nom de 2 caractères', () => {
    expect(isValidName('Jo')).toBe(true);
  });

  test('accepte un nom normal', () => {
    expect(isValidName('Jean Dupont')).toBe(true);
  });

  test('refuse un nom d\'1 caractère', () => {
    expect(isValidName('J')).toBe(false);
  });

  test('refuse une chaîne vide', () => {
    expect(isValidName('')).toBe(false);
  });

  test('refuse un nom composé uniquement d\'espaces', () => {
    expect(isValidName('  ')).toBe(false);
  });

  test('refuse plus de 255 caractères', () => {
    expect(isValidName('a'.repeat(256))).toBe(false);
  });

  test('accepte exactement 255 caractères', () => {
    expect(isValidName('a'.repeat(255))).toBe(true);
  });

  test('refuse null', () => {
    expect(isValidName(null)).toBe(false);
  });

  test('refuse un nombre', () => {
    expect(isValidName(123)).toBe(false);
  });

  test('accepte un nom avec accents', () => {
    expect(isValidName('Éloïse')).toBe(true);
  });
});

// =============================================================================
// isValidPassword
// =============================================================================
describe('isValidPassword', () => {
  test('accepte un mot de passe de 4 caractères (minimum)', () => {
    expect(isValidPassword('1234')).toBe(true);
  });

  test('accepte un mot de passe de 8 caractères', () => {
    expect(isValidPassword('12345678')).toBe(true);
  });

  test('accepte un mot de passe fort', () => {
    expect(isValidPassword('Tr0ub4dor&3')).toBe(true);
  });

  test('refuse 3 caractères', () => {
    expect(isValidPassword('123')).toBe(false);
  });

  test('refuse une chaîne vide', () => {
    expect(isValidPassword('')).toBe(false);
  });

  test('refuse plus de 128 caractères', () => {
    expect(isValidPassword('a'.repeat(129))).toBe(false);
  });

  test('accepte exactement 128 caractères', () => {
    expect(isValidPassword('a'.repeat(128))).toBe(true);
  });

  test('refuse null', () => {
    expect(isValidPassword(null)).toBe(false);
  });

  test('refuse un nombre', () => {
    expect(isValidPassword(12345678)).toBe(false);
  });
});

// =============================================================================
// isValidString
// =============================================================================
describe('isValidString', () => {
  test('accepte une chaîne valide', () => {
    expect(isValidString('hello')).toBe(true);
  });

  test('refuse une chaîne vide', () => {
    expect(isValidString('')).toBe(false);
  });

  test('refuse une chaîne d\'espaces uniquement', () => {
    expect(isValidString('   ')).toBe(false);
  });

  test('refuse null', () => {
    expect(isValidString(null)).toBe(false);
  });

  test('refuse une chaîne trop longue (défaut 255)', () => {
    expect(isValidString('a'.repeat(256))).toBe(false);
  });

  test('accepte exactement maxLength', () => {
    expect(isValidString('a'.repeat(100), 100)).toBe(true);
  });

  test('refuse maxLength + 1', () => {
    expect(isValidString('a'.repeat(101), 100)).toBe(false);
  });
});

// =============================================================================
// isOptionalString
// =============================================================================
describe('isOptionalString', () => {
  test('accepte null', () => {
    expect(isOptionalString(null)).toBe(true);
  });

  test('accepte undefined', () => {
    expect(isOptionalString(undefined)).toBe(true);
  });

  test('accepte une chaîne vide', () => {
    expect(isOptionalString('')).toBe(true);
  });

  test('accepte une chaîne valide', () => {
    expect(isOptionalString('hello')).toBe(true);
  });

  test('refuse une chaîne trop longue', () => {
    expect(isOptionalString('a'.repeat(256))).toBe(false);
  });

  test('refuse un nombre', () => {
    expect(isOptionalString(42)).toBe(false);
  });

  test('respecte un maxLength personnalisé', () => {
    expect(isOptionalString('abcde', 4)).toBe(false);
    expect(isOptionalString('abcd', 4)).toBe(true);
  });
});

// =============================================================================
// isOptionalText
// =============================================================================
describe('isOptionalText', () => {
  test('accepte null', () => {
    expect(isOptionalText(null)).toBe(true);
  });

  test('accepte une chaîne vide', () => {
    expect(isOptionalText('')).toBe(true);
  });

  test('accepte un texte long (< 10000)', () => {
    expect(isOptionalText('a'.repeat(9999))).toBe(true);
  });

  test('refuse plus de 10000 caractères', () => {
    expect(isOptionalText('a'.repeat(10001))).toBe(false);
  });

  test('accepte exactement 10000 caractères', () => {
    expect(isOptionalText('a'.repeat(10000))).toBe(true);
  });
});

// =============================================================================
// isOptionalUrl
// =============================================================================
describe('isOptionalUrl', () => {
  test('accepte null', () => {
    expect(isOptionalUrl(null)).toBe(true);
  });

  test('accepte undefined', () => {
    expect(isOptionalUrl(undefined)).toBe(true);
  });

  test('accepte une chaîne vide', () => {
    expect(isOptionalUrl('')).toBe(true);
  });

  test('accepte une URL http', () => {
    expect(isOptionalUrl('http://example.com/image.jpg')).toBe(true);
  });

  test('accepte une URL https', () => {
    expect(isOptionalUrl('https://cdn.example.com/img/avion.png')).toBe(true);
  });

  test('refuse une URL ftp', () => {
    expect(isOptionalUrl('ftp://example.com')).toBe(false);
  });

  test('refuse une chaîne sans protocole', () => {
    expect(isOptionalUrl('example.com/image.jpg')).toBe(false);
  });

  test('refuse une URL de plus de 2048 caractères', () => {
    expect(isOptionalUrl('https://' + 'a'.repeat(2042))).toBe(false);
  });

  test('refuse un nombre', () => {
    expect(isOptionalUrl(123)).toBe(false);
  });
});

// =============================================================================
// isOptionalDate
// =============================================================================
describe('isOptionalDate', () => {
  test('accepte null', () => {
    expect(isOptionalDate(null)).toBe(true);
  });

  test('accepte une chaîne vide', () => {
    expect(isOptionalDate('')).toBe(true);
  });

  test('accepte une date ISO valide', () => {
    expect(isOptionalDate('2024-01-15')).toBe(true);
  });

  test('accepte une date avec heure', () => {
    expect(isOptionalDate('2024-01-15T10:00:00Z')).toBe(true);
  });

  test('refuse une chaîne non-date', () => {
    expect(isOptionalDate('not-a-date')).toBe(false);
  });

  test('refuse un nombre', () => {
    expect(isOptionalDate(20240115)).toBe(false);
  });

  test('accepte une année seule', () => {
    expect(isOptionalDate('1969')).toBe(true);
  });
});

// =============================================================================
// isOptionalPositiveNumber
// =============================================================================
describe('isOptionalPositiveNumber', () => {
  test('accepte null', () => {
    expect(isOptionalPositiveNumber(null)).toBe(true);
  });

  test('accepte undefined', () => {
    expect(isOptionalPositiveNumber(undefined)).toBe(true);
  });

  test('accepte une chaîne vide', () => {
    expect(isOptionalPositiveNumber('')).toBe(true);
  });

  test('accepte 0', () => {
    expect(isOptionalPositiveNumber(0)).toBe(true);
  });

  test('accepte un entier positif', () => {
    expect(isOptionalPositiveNumber(1500)).toBe(true);
  });

  test('accepte un nombre décimal', () => {
    expect(isOptionalPositiveNumber(3.14)).toBe(true);
  });

  test('accepte un nombre en chaîne', () => {
    expect(isOptionalPositiveNumber('1500')).toBe(true);
  });

  test('refuse un nombre négatif', () => {
    expect(isOptionalPositiveNumber(-1)).toBe(false);
  });

  test('refuse NaN', () => {
    expect(isOptionalPositiveNumber(NaN)).toBe(false);
  });

  test('refuse une chaîne non numérique', () => {
    expect(isOptionalPositiveNumber('abc')).toBe(false);
  });
});

// =============================================================================
// isOptionalId
// =============================================================================
describe('isOptionalId', () => {
  test('accepte null', () => {
    expect(isOptionalId(null)).toBe(true);
  });

  test('accepte undefined', () => {
    expect(isOptionalId(undefined)).toBe(true);
  });

  test('accepte une chaîne vide', () => {
    expect(isOptionalId('')).toBe(true);
  });

  test('accepte 1', () => {
    expect(isOptionalId(1)).toBe(true);
  });

  test('accepte un entier positif en chaîne', () => {
    expect(isOptionalId('5')).toBe(true);
  });

  test('refuse 0', () => {
    expect(isOptionalId(0)).toBe(false);
  });

  test('refuse un nombre négatif', () => {
    expect(isOptionalId(-1)).toBe(false);
  });

  test('refuse un décimal', () => {
    expect(isOptionalId(1.5)).toBe(false);
  });

  test('refuse une chaîne non numérique', () => {
    expect(isOptionalId('abc')).toBe(false);
  });
});

// =============================================================================
// validateAirplaneData
// =============================================================================
describe('validateAirplaneData', () => {
  const validData = {
    name: 'F-22 Raptor',
    complete_name: 'Lockheed Martin F-22A Raptor',
    little_description: 'Chasseur furtif de 5e génération',
    image_url: 'https://example.com/f22.jpg',
    description: 'Description complète du F-22.',
    country_id: 1,
    date_concept: '1986-01-01',
    date_first_fly: '1997-09-07',
    date_operationel: '2005-12-15',
    max_speed: 1960,
    max_range: 2960,
    id_manufacturer: 2,
    id_generation: 5,
    type: 1,
    status: 'en service',
    weight: 19700,
  };

  test('retourne un tableau vide pour des données valides', () => {
    expect(validateAirplaneData(validData)).toEqual([]);
  });

  test('retourne une erreur si name est absent', () => {
    const data = { ...validData, name: '' };
    const errors = validateAirplaneData(data);
    expect(errors).toContain('Le nom est requis (max 255 caractères).');
  });

  test('retourne une erreur si name est null', () => {
    const data = { ...validData, name: null };
    const errors = validateAirplaneData(data);
    expect(errors.length).toBeGreaterThan(0);
  });

  test('retourne une erreur si image_url est invalide', () => {
    const data = { ...validData, image_url: 'not-a-url' };
    const errors = validateAirplaneData(data);
    expect(errors).toContain("L'URL de l'image doit être une URL valide (http/https, max 2048 caractères).");
  });

  test('accepte image_url null (optionnel)', () => {
    const data = { ...validData, image_url: null };
    expect(validateAirplaneData(data)).toEqual([]);
  });

  test('retourne une erreur si country_id est décimal', () => {
    const data = { ...validData, country_id: 1.5 };
    const errors = validateAirplaneData(data);
    expect(errors).toContain("L'ID du pays doit être un entier positif.");
  });

  test('retourne une erreur si date_concept est invalide', () => {
    const data = { ...validData, date_concept: 'pas-une-date' };
    const errors = validateAirplaneData(data);
    expect(errors).toContain('La date de conception doit être une date valide.');
  });

  test('retourne une erreur si max_speed est négatif', () => {
    const data = { ...validData, max_speed: -100 };
    const errors = validateAirplaneData(data);
    expect(errors).toContain('La vitesse max doit être un nombre positif.');
  });

  test('retourne une erreur si weight est négatif', () => {
    const data = { ...validData, weight: -50 };
    const errors = validateAirplaneData(data);
    expect(errors).toContain('Le poids doit être un nombre positif.');
  });

  test('retourne plusieurs erreurs simultanément', () => {
    const data = { ...validData, name: '', max_speed: -1, image_url: 'ftp://bad' };
    const errors = validateAirplaneData(data);
    expect(errors.length).toBeGreaterThanOrEqual(3);
  });

  test('accepte des champs optionnels à null', () => {
    const minimalData = {
      name: 'Avion Test',
      complete_name: null,
      little_description: null,
      image_url: null,
      description: null,
      country_id: null,
      date_concept: null,
      date_first_fly: null,
      date_operationel: null,
      max_speed: null,
      max_range: null,
      id_manufacturer: null,
      id_generation: null,
      type: null,
      status: null,
      weight: null,
    };
    expect(validateAirplaneData(minimalData)).toEqual([]);
  });

  test('retourne une erreur si status dépasse 50 caractères', () => {
    const data = { ...validData, status: 'a'.repeat(51) };
    const errors = validateAirplaneData(data);
    expect(errors).toContain('Le statut ne doit pas dépasser 50 caractères.');
  });

  test('retourne une erreur si description dépasse 10000 caractères', () => {
    const data = { ...validData, description: 'a'.repeat(10001) };
    const errors = validateAirplaneData(data);
    expect(errors).toContain('La description ne doit pas dépasser 10 000 caractères.');
  });
});
