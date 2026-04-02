// Résout les imports avec préfixe "node:" (ex: require('node:fs'))
// non supportés nativement par Jest 25
module.exports = (request, options) => {
  const stripped = request.startsWith('node:') ? request.slice(5) : request;
  return options.defaultResolver(stripped, options);
};
