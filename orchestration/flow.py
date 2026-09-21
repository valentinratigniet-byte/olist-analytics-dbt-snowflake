"""
Orchestration du pipeline dbt avec Prefect.

  dbt deps -> dbt seed -> dbt run -> dbt test -> dbt snapshot

- Retries sur chaque étape (résilience aux erreurs transitoires, ex. Snowflake).
- Logs structurés via le logger Prefect.
- Toute étape en échec fait échouer le flow (sortie non nulle) -> l'ordonnanceur
  le voit et peut alerter.

Lancer :  python orchestration/flow.py
"""
import subprocess
import sys
from pathlib import Path

from prefect import flow, task, get_run_logger

ROOT = Path(__file__).resolve().parent.parent


def _run(cmd):
    """Exécute une commande dbt, relaie la sortie, lève si code de retour non nul."""
    log = get_run_logger()
    result = subprocess.run(cmd, cwd=str(ROOT), capture_output=True, text=True)
    if result.stdout:
        log.info(result.stdout.strip()[-3000:])
    if result.returncode != 0:
        log.error((result.stderr or result.stdout).strip()[-3000:])
        raise RuntimeError(f"Échec : {' '.join(cmd)}")


@task(retries=1, retry_delay_seconds=10)
def dbt_deps():
    _run(["dbt", "deps"])


@task(retries=1, retry_delay_seconds=10)
def dbt_seed():
    _run(["dbt", "seed"])


@task(retries=2, retry_delay_seconds=15)
def dbt_run():
    _run(["dbt", "run"])


@task(retries=1, retry_delay_seconds=10)
def dbt_test():
    _run(["dbt", "test"])


@task(retries=1, retry_delay_seconds=10)
def dbt_snapshot():
    _run(["dbt", "snapshot"])


@flow(name="olist-analytics-elt")
def olist_pipeline():
    dbt_deps()
    dbt_seed()
    dbt_run()
    dbt_test()
    dbt_snapshot()


if __name__ == "__main__":
    olist_pipeline()
