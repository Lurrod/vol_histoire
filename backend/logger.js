'use strict';
const crypto = require('crypto');

// -----------------------------------------------------------------------------
// Logger structuré — remplace les console.error/log éparpillés
// Chaque erreur reçoit un ID unique pour faciliter le support.
// -----------------------------------------------------------------------------

const LEVELS = { error: 0, warn: 1, info: 2, debug: 3 };
const currentLevel = LEVELS[process.env.LOG_LEVEL] ?? LEVELS.info;

function formatEntry(level, message, meta = {}) {
  const entry = {
    timestamp: new Date().toISOString(),
    level,
    message,
    ...meta,
  };
  if (level === 'error') {
    entry.errorId = crypto.randomBytes(4).toString('hex');
  }
  return entry;
}

function log(level, message, meta) {
  if (LEVELS[level] > currentLevel) return;
  const entry = formatEntry(level, message, meta);
  const output = JSON.stringify(entry);
  if (level === 'error' || level === 'warn') {
    console.error(output);
  } else {
    console.log(output);
  }
  return entry;
}

module.exports = {
  error: (message, meta) => log('error', message, meta),
  warn:  (message, meta) => log('warn',  message, meta),
  info:  (message, meta) => log('info',  message, meta),
  debug: (message, meta) => log('debug', message, meta),
};
