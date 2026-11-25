# Serveur de production — configuration et reconstruction

Relevé en lecture seule le 2026-11-25 (DEVOPS-005). Ce dossier décrit le
serveur pour pouvoir le reconstruire ; le déploiement courant (CI) n'en lit
aucun fichier.

## Ce qui tourne

| Élément | Valeur relevée |
|---|---|
| Hôte | VPS OVH (Ubuntu), partagé avec six autres applications pm2 |
| Code | `/var/www/vol-histoire` (clone git, `main`) ; secrets dans `backend/.env` |
| Node | **24**, installé à part sous `/opt/node-24` (le Node système, 20, sert les autres applications) |
| Processus | pm2 `vol-histoire`, mode fork, 1 instance, interpréteur `/opt/node-24/bin/node`, `backend/server.js`, port 3000 en local |
| Journaux | `~/.pm2/logs/vol-histoire-{out,error}.log` (JSON sur stdout/stderr, `LOG_LEVEL`) — **aucune rotation** au relevé, `out.log` à 33 Mo |
| Mandataire | Apache 2 : port 80 → HTTPS, port 443 → `127.0.0.1:3000` (`apache/`) |
| TLS | Let's Encrypt via certbot (renouvellement automatique) |
| Données | PostgreSQL (tables propriété de `postgres`), Redis facultatif (`REDIS_URL`) |

## Reconstruire

1. Node 24 sous `/opt/node-24` (archive officielle), PostgreSQL, Redis, Apache
   (`a2enmod ssl proxy proxy_http rewrite`), certbot.
2. `git clone` dans `/var/www/vol-histoire`, puis `backend/.env` (modèle :
   `backend/.env.example`).
3. Base : restaurer la dernière sauvegarde `pg_dump`, ou installation neuve
   (`db.sql`, fiches, `timeline_events.sql`, `zz_*` — voir CLAUDE.md), puis
   vérifier que `schema_migrations` liste toutes les migrations : sinon le
   serveur refuse de démarrer en production (DEVOPS-003).
4. `cd backend && PATH=/opt/node-24/bin:$PATH npm ci --omit=dev`
5. `pm2 start deploy/ecosystem.config.js && pm2 save` — jamais
   `pm2 restart all`, jamais un `pm2 start` nu (il partirait sous Node 20).
6. Apache : copier `apache/*.conf` dans `/etc/apache2/sites-available/`,
   `a2ensite`, puis `certbot --apache -d vol-histoire.titouan-borde.com`.
7. Rotation des journaux : `logrotate/vol-histoire` dans `/etc/logrotate.d/`.

## À faire sur le serveur actuel (décision du propriétaire)

- Installer la rotation des journaux (`logrotate/vol-histoire`).
- Ajouter `max_memory_restart` et `kill_timeout` au processus (valeurs de
  `ecosystem.config.js`) lors d'une prochaine maintenance.

## Coupure au déploiement (DEVOPS-004)

Chaque fusion sur `main` redémarre le processus unique (`pm2 restart
vol-histoire`) : le serveur relit les pages HTML, se connecte à Redis et
contrôle les migrations avant d'écouter, d'où **quelques secondes de 502**.
Ce choix est assumé : les tests de fumée de la CI interrogent `/api/health`
jusqu'à six fois à 5 s d'intervalle, et le service worker sert les pages déjà
visitées pendant la coupure.

Pour la supprimer, il faudrait passer en mode cluster (2 instances,
`pm2 reload vol-histoire`), ce qui suppose :
- Redis obligatoire en production (limiteurs et caches partagés entre
  instances) ;
- les tâches de purge (`backend/jobs/cleanup.js`) exécutées une seule fois,
  par exemple sur `NODE_APP_INSTANCE === '0'` ;
- des métriques Prometheus agrégées (chaque instance n'expose que les
  siennes) ;
- le double de mémoire sur un serveur partagé avec six autres applications.
