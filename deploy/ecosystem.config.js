/**
 * pm2 — processus vol-histoire en production (DEVOPS-005).
 *
 * Reflet de la configuration relevée sur le serveur le 2026-11-25
 * (pm2 jlist, en lecture seule) : mode fork, une instance, Node 24 dédié
 * (/opt/node-24), journaux sous ~/.pm2/logs. Le déploiement (CI) ne lit pas
 * ce fichier : il fait « pm2 restart vol-histoire --update-env ». Il sert à
 * recréer le processus à l'identique après une réinstallation :
 *
 *   cd /var/www/vol-histoire && pm2 start deploy/ecosystem.config.js && pm2 save
 *
 * Jamais « pm2 restart all » : sept applications partagent ce pm2.
 */
module.exports = {
  apps: [
    {
      name: 'vol-histoire',
      cwd: '/var/www/vol-histoire/backend',
      script: 'server.js',
      // Node 24 dédié : le Node système (20) sert les autres applications.
      interpreter: '/opt/node-24/bin/node',
      exec_mode: 'fork',
      instances: 1,
      // Recommandé, absent aujourd'hui (pm2 laisse 1,6 s par défaut) : le
      // serveur ferme le pool et Redis sur SIGTERM (server.js) et doit en
      // avoir le temps.
      kill_timeout: 10000,
      // Garde-fou mémoire, absent aujourd'hui sur le serveur (les autres
      // applications Node y ont 400 à 600 Mo) : à valider avant de l'appliquer.
      max_memory_restart: '512M',
      out_file: '/home/ubuntu/.pm2/logs/vol-histoire-out.log',
      error_file: '/home/ubuntu/.pm2/logs/vol-histoire-error.log',
      merge_logs: true,
      env: {
        NODE_ENV: 'production',
        // Les secrets restent dans backend/.env (jamais versionné).
      },
    },
  ],
};
