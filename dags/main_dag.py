from airflow import DAG
from airflow.providers.docker.operators.docker import DockerOperator
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
    schedule_interval="@daily",  # Exécuter tous les jours
    catchup=False,
)


# 1️⃣ Scrapping CSV files vers to data folder
scrapping_data = BashOperator(
    task_id="scrapping_data",
    bash_command="""
    docker run --rm -v "$(pwd -W)/data:/app/data" barca-scraper
    """,
    dag=dag,
)

