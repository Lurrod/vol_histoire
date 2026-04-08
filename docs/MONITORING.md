# Monitoring & Alertes — Vol d'Histoire

Guide opérationnel pour configurer la surveillance production. Le code applicatif est instrumenté ; il reste à configurer les règles d'alerte côté UI Sentry et un check uptime externe.

## 1. Sentry — Setup initial

### Installation (déjà fait dans V3.1.0)
- `@sentry/node@^10.47.0` dans `backend/package.json`
- Init conditionnel dans `backend/logger.js` (uniquement si `SENTRY_DSN` défini)
- Forward automatique de `logger.error()` → Sentry avec stack trace
- Flush graceful sur SIGTERM/SIGINT (`server.js`)
- Capture `uncaughtException` + `unhandledRejection`

### Variables d'environnement (à ajouter dans `backend/.env` prod)

```env
SENTRY_DSN=https://xxxxxxxxxxxxxxxx@oXXXXXX.ingest.sentry.io/YYYYYYY
SENTRY_ENVIRONMENT=production
SENTRY_RELEASE=3.3.0
SENTRY_TRACES_SAMPLE_RATE=0.1
# Optionnel : capture aussi les warnings (par défaut errors only)
# SENTRY_CAPTURE_WARN=true
```

Récupérer le DSN : Sentry → Settings → Projects → vol-histoire → Client Keys (DSN)

### Vérification

```bash
# Sur le serveur Kimsufi après deploy V3.3.0+
pm2 logs vol-histoire | grep "Sentry activé"
# → doit afficher : {"level":"info","message":"Sentry activé","env":"production"}
```

Test manuel : déclencher une erreur 500 (ex. `curl https://vol-histoire.titouan-borde.com/api/airplanes/abc`) puis vérifier dans Sentry dashboard que l'event remonte sous 30s.

---

## 2. Règles d'alerte Sentry (à créer dans l'UI)

Sentry → Alerts → Create Alert. Configurer les 4 règles suivantes :

### Règle 1 — 🔴 Spike d'erreurs 5xx (CRITIQUE)
- **Trigger** : `event.count > 10 in 5 minutes`
- **Filter** : `event.type:error environment:production`
- **Action** : Email + (optionnel) webhook Slack
- **Cooldown** : 30 min

### Règle 2 — 🟠 Nouvelle erreur (REGRESSION)
- **Trigger** : `is:unresolved firstSeen:-1h`
- **Filter** : `environment:production level:error`
- **Action** : Email
- **Cooldown** : 1 h

### Règle 3 — 🟡 Erreur récurrente (IGNORÉE → réveil)
- **Trigger** : `is:ignored events.count > 100`
- **Filter** : `environment:production`
- **Action** : Email weekly digest

### Règle 4 — 🔴 Crash uncaughtException (CRITIQUE)
- **Trigger** : `event.message contains "uncaughtException" OR "unhandledRejection"`
- **Filter** : `environment:production`
- **Action** : Email immédiat (pas de cooldown)

---

## 3. Performance Monitoring (optionnel)

Si tu veux activer le tracing des endpoints lents :

```env
SENTRY_TRACES_SAMPLE_RATE=0.1   # 10% des requêtes tracées
```

Puis dans Sentry → Performance, créer une alerte :
- **Trigger** : `transaction.duration > 2000ms (p95)`
- **Filter** : `transaction:GET /api/airplanes`
- **Action** : Email digest hebdomadaire

⚠️ Coût Sentry : les transactions performance comptent dans le quota. À 0.1 sample rate avec 10k req/jour = 1000 transactions/jour ≈ 30k/mois (largement sous le free tier 10k).

Pour rester gratuit : `SENTRY_TRACES_SAMPLE_RATE=0` (errors only).

---

## 4. Uptime Monitoring externe

Sentry ne fait PAS d'uptime check. Utilise un service tiers gratuit :

### Option A — UptimeRobot (recommandé, free tier généreux)
1. https://uptimerobot.com → New Monitor
2. Type : HTTPS
3. URL : `https://vol-histoire.titouan-borde.com/api/health`
4. Interval : 5 min
5. Alert contacts : email + (optionnel) Telegram bot
6. Keyword monitoring : vérifier que body contient `"status":"ok"`

### Option B — BetterStack / Pingdom / StatusCake
Équivalents, choix selon préférence UI.

---

## 5. Logs d'accès Apache

Déjà configurés dans `/etc/apache2/sites-enabled/vol-histoire*.conf` :
- `ErrorLog ${APACHE_LOG_DIR}/vol-histoire_error.log`
- `CustomLog ${APACHE_LOG_DIR}/vol-histoire_access.log combined`

Surveillance manuelle :
```bash
# Erreurs Apache des 24 dernières heures
sudo tail -1000 /var/log/apache2/vol-histoire_error.log | grep -i error

# Top 10 IPs avec le plus de requêtes (détection brute force)
sudo awk '{print $1}' /var/log/apache2/vol-histoire_access.log | sort | uniq -c | sort -rn | head

# Top 20 endpoints les plus appelés
sudo awk '{print $7}' /var/log/apache2/vol-histoire_access.log | sort | uniq -c | sort -rn | head -20

# Codes 4xx/5xx
sudo awk '{print $9}' /var/log/apache2/vol-histoire_access.log | sort | uniq -c
```

Pour automatiser : **logrotate** est déjà actif (Ubuntu default). Pour de l'analyse longue durée → exporter vers Loki/Grafana ou ELK (hors scope MVP).

---

## 6. Métriques applicatives

Actuellement non instrumentées. Si tu veux ajouter Prometheus :

```bash
cd backend && npm install prom-client
```

Puis dans `app.js` :
```js
const promClient = require('prom-client');
const register = new promClient.Registry();
promClient.collectDefaultMetrics({ register });
app.get('/metrics', async (req, res) => {
  res.set('Content-Type', register.contentType);
  res.end(await register.metrics());
});
```

Scraping via Prometheus + Grafana dashboard. **À faire P2** (pas urgent, ~6h).

---

## 7. Runbook incidents

### 🔴 5xx en hausse
1. Sentry → grouper par `transaction` → identifier l'endpoint coupable
2. Si DB down : `ssh ubuntu@... 'sudo systemctl status postgresql'`
3. Si app down : `pm2 logs vol-histoire --err --lines 100`
4. Rollback rapide : `cd /var/www/vol-histoire && git log --oneline -5 && git reset --hard <commit-précédent> && pm2 restart vol-histoire`

### 🟠 Health check KO (`/api/health` 503)
1. Vérifier DB : `sudo -u postgres psql -c "SELECT 1"`
2. Vérifier pool : `pm2 logs vol-histoire | grep -i "pool\|database"`
3. Restart : `pm2 restart vol-histoire`

### 🟡 Latence p95 > 2s
1. Vérifier `/api/stats` (cache invalidé ?) : `curl -w '%{time_total}' .../api/stats`
2. Vérifier indexes DB : `EXPLAIN ANALYZE SELECT ... FROM airplanes WHERE country_id=1`
3. Vérifier load PM2 : `pm2 monit`

### Rate limiting hit (429 fréquents)
1. IP légitime ? → ajuster `max` dans `app.js` rate limiter
2. IP attaque ? → bloquer via Apache `Require not ip x.x.x.x` ou fail2ban
