'use strict';

// Recherche plein texte : variante « préfixe » de la saisie.
//
// websearch_to_tsquery ne fait que des correspondances exactes de lexèmes :
// « mirage » trouve le Mirage, « mira » ne trouve rien. Pendant la frappe, le
// dernier mot est presque toujours incomplet ; on construit donc, en plus,
// une tsquery où ce dernier mot est un préfixe (« mira » → « mira:* »), que la
// route combine en OU avec la requête d'origine.
//
// La tsquery est assemblée à partir de jetons alphanumériques uniquement :
// aucun opérateur de l'utilisateur (&, |, !, :, parenthèses) n'y entre, donc
// to_tsquery ne peut ni échouer ni être détournée. Les jetons suivent le
// découpage du parseur PostgreSQL : « F-16 » donne « f » et « 16 », lexèmes
// que la configuration 'simple' indexe aussi.

const TOKEN = /[\p{L}\p{N}]+/gu;
// Syntaxe websearch explicite : phrase entre guillemets, exclusion (-mot) ou
// alternative (or). Le préfixe pourrait alors réintroduire un terme exclu.
const WEBSEARCH_SYNTAX = /"|(^|\s)-\S|\sor\s/i;

/**
 * @param {string} raw saisie déjà nettoyée (trim, longueur bornée)
 * @returns {string|null} tsquery « a & b & c:* », ou null si inutile
 */
function prefixTsquery(raw) {
  if (typeof raw !== 'string' || WEBSEARCH_SYNTAX.test(raw)) return null;
  const tokens = raw.toLowerCase().match(TOKEN);
  if (!tokens) return null;
  const last = tokens.pop();
  return [...tokens, `${last}:*`].join(' & ');
}

module.exports = { prefixTsquery };
