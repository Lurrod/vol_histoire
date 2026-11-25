/**
 * Mailer simulé des suites d'API : aucun email réel en tests. Usage, en tête
 * de fichier de test : jest.mock('../mailer', () => require('./helpers/mailer-mock')());
 */
module.exports = () => ({
  sendVerificationEmail: jest.fn().mockResolvedValue(undefined),
  sendPasswordResetEmail: jest.fn().mockResolvedValue(undefined),
  sendContactEmail: jest.fn().mockResolvedValue(undefined),
  sendEmailChangeConfirmation: jest.fn().mockResolvedValue(undefined),
  sendEmailChangeNotice: jest.fn().mockResolvedValue(undefined),
  sendAccountExistsNotice: jest.fn().mockResolvedValue(undefined),
  sendWelcomeEmail: jest.fn().mockResolvedValue(undefined),
  verifyConnection: jest.fn().mockResolvedValue(undefined),
});
