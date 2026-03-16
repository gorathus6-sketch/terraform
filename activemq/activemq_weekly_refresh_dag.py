from airflow import DAG
from airflow.operators.bash import BashOperator
from datetime import datetime, timedelta
from pendulum import timezone

local_tz = timezone("America/New_York")

default_args = {
    "owner": "airflow",
    "depands_on_past": False,
    "retries": 1,
    "retry_delay": timedelta(minutes=5),
}

with DAG(
    dag_id="activemq_weekly_refresh",
    description="Weekly stop/start refresh of ActiveMQ 5.17",
    default_args=default_args,
    start_date=datetime(2024, 1, 1, tzinfo=local_tz),
    schedule_intervals="15 16 * * 5", # Fridays at 16:15 ET
    
    catchup=False,
    tags=["activemq", "operations"],
) as dag:
    
    weekly_refresh = BashOperator(
        task_id="weekly_active_refresh",
        bash_command="/opt/vulnerability_matching/apache_activemq_5.17/weekly_activemq_refrsh.sh",
        env={"ENVIRONMENT": "prod"},
    )

    weekly_refresh