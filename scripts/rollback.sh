#!/usr/bin/env bash
# Retour arrière MANUEL de la production (à lancer SUR le serveur, dans le
# dossier du dépôt, avec l'utilisateur qui déploie).
#
#   bash scripts/rollback.sh            # revient au commit noté avant le dernier déploiement
#   bash scripts/rollback.sh <sha>      # revient à un commit précis
#   bash scripts/rollback.sh --list     # affiche l'historique des déploiements
#
# Le déploiement GitHub Actions note, avant chaque mise à jour, le commit en
# ligne dans ~/.vol-histoire-deploy/previous_sha et journalise chaque
# déploiement / retour arrière dans ~/.vol-histoire-deploy/history.log. Il
# revient de lui-même au commit précédent si un smoke test échoue ; ce script
# sert quand le problème est découvert plus tard.
#
# Ce que le script NE fait PAS :
#   - annuler une migration SQL : le schéma reste tel quel. Restaurer au besoin
#     la sauvegarde pg_dump prise avant la migration (en postgres, par l'entrée
#     standard) ;
#   - redémarrer autre chose que vol-histoire : le serveur héberge sept
#     applications pm2, jamais « pm2 restart all ».
#
# Tout le travail est dans main(), lue en entier par bash avant exécution :
# le « git reset » qui remplace ce fichier pendant qu'il tourne est sans effet.

main() {
  set -euo pipefail

  local app_dir state_dir target current
  app_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
  state_dir="${HOME}/.vol-histoire-deploy"

  if [ "${1:-}" = "--list" ]; then
    tail -n 20 "${state_dir}/history.log" 2>/dev/null || echo "Aucun historique dans ${state_dir}."
    return 0
  fi

  cd "${app_dir}"
  current="$(git rev-parse HEAD)"

  if [ -n "${1:-}" ]; then
    target="$1"
  elif [ -f "${state_dir}/previous_sha" ]; then
    target="$(cat "${state_dir}/previous_sha")"
  else
    echo "Aucun commit précédent noté (${state_dir}/previous_sha) : préciser le SHA voulu." >&2
    return 1
  fi

  if ! git cat-file -e "${target}^{commit}" 2>/dev/null; then
    echo "Commit inconnu : ${target} (essayer « git fetch origin main » d'abord)." >&2
    return 1
  fi
  target="$(git rev-parse "${target}^{commit}")"

  if [ "${target}" = "${current}" ]; then
    echo "La production est déjà sur ${target} : rien à faire."
    return 0
  fi

  echo "En ligne : $(git log -1 --format='%h %s' "${current}")"
  echo "Cible    : $(git log -1 --format='%h %s' "${target}")"
  if git diff --quiet "${target}" "${current}" -- backend/migrations backend/db_backup/db.sql; then
    echo "Aucune migration ni changement de schéma entre les deux commits."
  else
    echo "ATTENTION : migrations ou schéma modifiés entre les deux commits ; la base ne sera pas restaurée."
  fi
  read -r -p "Revenir à ${target:0:7} ? [o/N] " answer
  case "${answer}" in
    o|O|oui|y|Y) ;;
    *) echo "Abandon."; return 1 ;;
  esac

  if ! git diff --quiet || ! git diff --cached --quiet; then
    git stash push -u -m "auto-stash rollback $(date +%Y-%m-%d_%H:%M:%S)"
  fi
  git reset --hard "${target}"

  cd backend
  # Node 24 dédié (/opt/node-24) ; le Node système (20) sert les autres applications.
  if [ -x /opt/node-24/bin/node ]; then export PATH="/opt/node-24/bin:$PATH"; fi
  npm ci --omit=dev
  pm2 restart vol-histoire --update-env || pm2 start server.js --name vol-histoire --interpreter "$(command -v node)"
  cd ..

  mkdir -p "${state_dir}"
  # previous_sha n'est pas modifié : relancer le script sans argument ne
  # ramènerait donc pas le commit qu'on vient de quitter.
  printf '%s rollback %s -> %s (manuel)\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "${current}" "${target}" >> "${state_dir}/history.log"
  rm -f "${state_dir}/deploying_sha"

  local port
  port="$(grep -E '^PORT=' backend/.env 2>/dev/null | tail -n 1 | cut -d= -f2 || true)"
  port="${port:-3000}"
  for _ in 1 2 3 4 5 6; do
    sleep 2
    if curl -sf "http://127.0.0.1:${port}/api/health" > /dev/null; then
      echo "Production revenue à ${target:0:7}, /api/health répond."
      echo "Penser à faire un revert sur main : le prochain push redéploiera la tête de main."
      return 0
    fi
  done
  echo "/api/health ne répond pas sur le port ${port} : vérifier « pm2 logs vol-histoire »." >&2
  return 1
}

main "$@"
exit $?
