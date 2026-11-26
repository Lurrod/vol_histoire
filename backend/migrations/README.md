# Migrations

Scripts destinés aux bases **déjà installées**. Une installation à neuf n'en a
pas besoin : `db_backup/db.sql` puis les fiches contiennent déjà le résultat.

## Les scripts

| Fichier | Contenu | Compatible avec le code précédent |
|---|---|---|
| `001_mise_a_niveau.sql` | Schéma, référentiel, furtivité, crédits photo, corrections de contenu, contraintes `CHECK` | oui |
| `002_securite_sessions.sql` | `users.token_version`, compteur d'échecs de connexion, rotation des refresh tokens (v4.11.1) | oui (additive) |
| `003_jetons_haches.sql` | `email_tokens.token` → `token_hash` (SHA-256), jetons en cours hachés sur place (v4.14.0) | **non** : à jouer au moment du déploiement du code qui l'attend |
| `004_codes_email.sql` | Codes à 6 chiffres au lieu des liens : `email_tokens.attempts` (essais manqués), liens encore ouverts clos | oui (additive) : à jouer **avant** le déploiement, le nouveau code lit `attempts` |
| `005_suivi_migrations.sql` | Table `schema_migrations` : 001 à 005 inscrites (DEVOPS-003) | oui (additive) : à jouer **avant** la fusion du code qui la vérifie |

**Suivi.** Chaque migration s'inscrit dans `schema_migrations` (`INSERT … ON CONFLICT DO NOTHING` à la fin du script) et s'ajoute à `REQUIRED_MIGRATIONS` (`backend/utils/schema-migrations.js` ; un test compare la liste aux fichiers de ce dossier). Au démarrage en production, une migration absente de la table empêche le serveur de démarrer : les tests de fumée du déploiement échouent et le retour arrière se déclenche, au lieu d'un code qui lit une colonne absente. `db_backup/db.sql` inscrit d'emblée toutes les migrations.

En production, les tables appartiennent à `postgres` : jouer les scripts en
`postgres`, par l'entrée standard (`sudo -u postgres psql -d vol_histoire < fichier.sql`),
après une sauvegarde `pg_dump`.

**Tout `UPDATE` d'`airplanes` dans `001` (et dans `zz_backfill_relations.sql`)
porte une garde `IS DISTINCT FROM`** sur les colonnes écrites : un rejeu ne doit
modifier que les lignes réellement différentes, sinon le déclencheur remet
`updated_at` à jour sur toutes les fiches et le `lastmod` du sitemap ment.

## Mise à niveau

Étapes, dans cet ordre. Séquence vérifiée sur une base reconstruite à
l'état de production : **107 → 383 fiches** au passage v4.7.0, puis
**383 → 434** aux lots 25 à 28, **434 → 554** aux lots 29 à 38, puis **554 → 613** aux lots 39 à 43 et **613 → 733** aux lots 44 à 53, **aucun écart** avec une installation neuve sur
les 57 colonnes métier et les 14 tables.

```bash
# 1. Schéma, référentiel, furtivité, crédits photo et contraintes
psql -U vol_user -d vol_histoire -f backend/migrations/001_mise_a_niveau.sql

# 1 bis. Sécurité des sessions et jetons d'email hachés (si pas encore joués)
psql -U vol_user -d vol_histoire -f backend/migrations/002_securite_sessions.sql
psql -U vol_user -d vol_histoire -f backend/migrations/003_jetons_haches.sql

# 2. Fiches absentes de la base (276 au passage v4.7.0, 51 aux lots 25-28)
#    --dry-run liste sans rien écrire
node backend/migrations/charger-fiches.js --dry-run
node backend/migrations/charger-fiches.js

# 3. Filiations — en dernier, une fois tous les appareils présents
psql -U vol_user -d vol_histoire -f backend/db_backup/zz_backfill_relations.sql

# 4. Pages de conflit (contexte, récit, camps, rôle de chaque appareil, dates
#    clés), puis strate 7 de la fiche technique
psql -U vol_user -d vol_histoire -f backend/db_backup/zz_conflits.sql
psql -U vol_user -d vol_histoire -f backend/db_backup/zz_specs_strate7.sql
```

L'étape 1 seule laisse la base au nombre de fiches qu'elle avait : elle porte le
schéma et les corrections, **pas les appareils**.

`charger-fiches.js` lit `backend/.env` pour la connexion, compare le nom de
chaque fiche à ceux déjà en base et ne charge que les manquantes, une
transaction par fiche. Il est **rejouable** : un second passage ne charge rien.
C'est nécessaire, car `airplanes.name` **n'a pas de contrainte d'unicité** —
rejouer une fiche à la main y créerait un doublon silencieux.

## Pourquoi cet ordre

`001` d'abord : les fiches renseignent `image_credit` / `image_licence` dans
leur bloc d'enrichissement. Sans les colonnes, tout le bloc est annulé et les
fiches arrivent sans motorisation ni dimensions. Le fichier apporte aussi les
constructeurs, types et armements que ces fiches référencent.

`zz_backfill_relations.sql` en dernier : il résout `predecessor_id`,
`successor_id` et `rival_id`, ce qui exige que les 733 appareils soient
présents. C'est aussi pour cela qu'il porte un préfixe `zz` — il passe en
dernier dans la boucle d'installation à neuf, qui charge `db_backup/*.sql` par
ordre alphabétique.

`zz_conflits.sql` juste après : il écrit le camp et le rôle de chaque appareil
sur les liaisons appareil-conflit existantes (`airplane_wars`), qu'il ne crée
jamais. Il est généré (`tools/lots/conflits_build.py`, contrôlé en CI) et n'écrit rien au
second passage.

Les `UPDATE` de `001` qui ne trouvent pas leur cible sont sans effet : il peut
être joué avant ou après l'import sans dommage. Tous ces scripts sont
**rejouables**.

## Notes

- Sous Windows, forcer `PGCLIENTENCODING=UTF8` avant les `psql` : sinon les noms
  accentués (`Étendard IV`, `Super Mystère B2`) sont importés corrompus.
- `001` s'interrompt sans rien modifier si la base contient des valeurs hors
  plage au moment de poser les contraintes `CHECK`.
- Le fichier `001_airplanes_search_vector.sql` référencé par un commentaire de
  `db.sql` n'a jamais été versionné ; il n'est pas reconstitué ici.
