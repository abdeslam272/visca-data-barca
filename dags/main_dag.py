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

# 1️⃣ Étape de scrapping — crée les CSV sur le host
scrapping_data = BashOperator(
    task_id="scrapping_data",
    bash_command=(
        'docker run --rm '
        '-v /c/Abdeslam/DOCKER-WORK/visca-data-barca/data:/app/data '
        'barca-scraper'
    ),
    dag=dag,
)

# 2️⃣ Étape de déplacement — crée le dossier si besoin et déplace les CSV
moving_data = BashOperator(
    task_id="moving_data",
    bash_command=(
        'mkdir -p /opt/airflow/dbt/barca_project/seeds && '
        'mv /opt/airflow/data/*.csv /opt/airflow/dbt/barca_project/seeds/'
    ),
    dag=dag,
)

# 3️⃣ Étape de seed DBT
create_table_database = BashOperator(
    task_id="create_table_database",
    bash_command='docker exec barca-dbt bash -c "dbt seed"',
    dag=dag,
)

# 4️⃣ Étape de run DBT
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

# 5️⃣ Ordre d'exécution
scrapping_data >> moving_data >> create_table_database >> dbt_run
