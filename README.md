# olist_analytics — Pipeline ELT S3 → Snowflake → dbt

[![dbt CI](https://github.com/valentinratigniet-byte/olist-analytics-dbt-snowflake/actions/workflows/dbt-ci.yml/badge.svg)](https://github.com/valentinratigniet-byte/olist-analytics-dbt-snowflake/actions/workflows/dbt-ci.yml)

Reproduction pas-à-pas d'une formation vidéo (« Cours complet DBT | Projet ELT complet », Le Decodeur, 2h04) sur le dataset réel **Olist Brazilian E-Commerce** (Kaggle, ~100 000 commandes). Connecté à un vrai compte Snowflake d'essai, pas une simulation.

## Stack

Amazon S3 (stockage brut) → Snowflake (entrepôt) → dbt-core 1.12 + dbt-snowflake (transformation).

## Architecture

| Couche | Matérialisation | Rôle |
|---|---|---|
| `staging` | vue | Renommage, typage strict des 8 tables RAW |
| `intermediate` | éphémère | Jointures, agrégations, logique métier |
| `marts` | table | Modèle en étoile (`dim_`/`fct_`), dont `fct_order_items` en incrémental |

## Résultats

- 16 modèles dbt, 8 sources RAW
- 25/25 tests dbt (génériques + singulier) PASS
- 1 snapshot SCD2 (`orders_snapshot`, historisation du statut de commande)
- CI GitHub Actions : `dbt deps && dbt seed && dbt build && dbt snapshot` à chaque push sur `main`

## Lancer le projet

```bash
python -m venv venv
venv\Scripts\activate
pip install dbt-snowflake
dbt deps
dbt seed
dbt build
dbt snapshot
dbt docs generate && dbt docs serve
```

Nécessite un `~/.dbt/profiles.yml` avec les identifiants Snowflake (non versionné — voir `dbt_project.yml` pour le nom de profil attendu).

## Orchestration (Prefect)

`orchestration/flow.py` enchaîne `dbt deps → seed → run → test → snapshot` avec retries et logs structurés — même pattern que [projet-10-pipeline-elt](https://github.com/valentinratigniet-byte/projet-10-pipeline-elt).

```bash
pip install -r requirements.txt
python orchestration/flow.py
```

### Resources
- [dbt docs](https://docs.getdbt.com/docs/introduction)
- Vidéo source : [Cours complet DBT | Projet ELT complet](https://www.youtube.com/watch?v=NT9WII_rHdE) — Le Decodeur
- Code de référence : [github.com/JulienSERE99/Pipeline-ELT-Transformation](https://github.com/JulienSERE99/Pipeline-ELT-Transformation)
