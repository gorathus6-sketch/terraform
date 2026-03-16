from airflow import DAG
from airflow.operators.bash import BashOperator
from datetime import datetime, timedelta
from pendulum import timezone

local_tz = timezone("America/New_York")

default_args = {
    "owner": "airflow",
    "depends_on_past": False,
    "retries": 1,
    "retry_delay": timedelta(minutes=5),
}

with DAG(
    dag_id="servicemix_weekly_restart",
    description="Weekly stop/start restart of Apache ServiceMix 6.12",
    default_args=default_args,
    start_date=datetime(2024, 1, 1, tzinfo=local_tz),
    schedule_interval="30 16 * * 5", # Fridays at 16:30 ET

    catchup=False,
    tags=["servicemix", "operations"],
) as dag:
    
    weekly_restart = BashOperator(
        task_id="weekly_servicemix_restart",
        bash_command="/opt/vulnerability_matching/apache_servicemix_6.12/weekly_servicemix_restart.sh",
        env={"ENVIRONMENT" : "prod"},
    )

    weekly_restart