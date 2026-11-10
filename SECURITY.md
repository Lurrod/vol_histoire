# Politique de sécurité

## Signaler une vulnérabilité

Merci de **ne jamais décrire une faille dans un ticket public**.

Utilisez le signalement privé de GitHub : onglet **Security**, puis **Report a vulnerability**
(ou directement <https://github.com/Lurrod/vol_histoire/security/advisories/new>).
Le signalement n'est visible que du mainteneur.

Indiquez si possible :

- la page ou la route concernée (`/api/…`) ;
- les étapes pour reproduire, avec les requêtes envoyées ;
- l'impact estimé (lecture ou modification de données, prise de compte, déni de service…).

## Ce qui est couvert

Le site <https://vol-histoire.titouan-borde.com> et le code de ce dépôt : backend Express, frontend,
scripts de build et chaîne CI/CD.

Ne sont pas concernés : les attaques par déni de service volumétrique, l'ingénierie sociale, et les
résultats d'outils automatiques sans démonstration d'un impact réel.

## Règles de test

- N'utilisez que des comptes que vous avez créés vous-même.
- Ne consultez, ne modifiez et ne supprimez aucune donnée d'un autre utilisateur.
- Limitez le volume de requêtes : le site partage son serveur avec d'autres services.

## Suivi

Le projet est maintenu par une seule personne : un accusé de réception est envoyé dès que possible.
La correction est publiée dans une nouvelle version du site, et le signalement est crédité si vous le
souhaitez.

## Versions prises en charge

Seule la version en production (dernière version de la branche `main`) reçoit des correctifs.
