import os
from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.utils.dates import days_ago


default_args = {
    "owner": "airflow",
    "depends_on_past": False,
    "start_date": days_ago(1),
    "retries": 1,
}

dag = DAG(
    "main_dag",
    default_args=default_args,
    schedule_interval="@daily",
    catchup=False,
)

scrapping_data = BashOperator(
    task_id="scrapping_data",
    bash_command='docker run --rm -v /c/Abdeslam/DOCKER-WORK/visca-data-barca/data:/app/data barca-scraper',
    dag=dag,
)

moving_data = BashOperator(
    task_id="moving_data",
    bash_command='mv data/*.csv dbt/barca_project/seeds',
    dag= dag,
)

Create_table_database = BashOperator(
    task_id="moving_data",
    bash_command='docker exec barca-dbt bash -c && dbt seed',
    dag= dag,
)

dbt_models = [
    "match_results",
    "base_attackspeed",
    "base_formations",
    "base_game_stats",
    "base_result",
    "base_shotzones",
    "base_situations",
    "base_timings"
]

dbt_run = BashOperator(
    task_id="dbt_run",
    bash_command=(
        "docker exec barca-dbt bash -c '"
        + " && ".join([f"dbt run --select {model}" for model in dbt_models])
        + "'"
    ),
    dag=dag,
)

# Définir l'ordre d'exécution
scrapping_data >> dbt_run