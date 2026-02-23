from airflow import DAG
from airflow.operators.bash import BashOperator
from datatime import datetime, timedelta

default_args = {
    "owner": "airflow",
    "depends_on_past": False,
    "retries": 0,
}

with DAG(
    dag_id="diskcheck",
    default_args=default_args,
    description="Checks disk usage and fails if above threshold",
    schedule_interval="0 * * * *",  # hourly

    start_date=datetime(2023, 1, 1),
    catchup=False,
) as dag:
    
    check_disk_usage = BashOperator(
        task_id="check_disk_usage",
        bash_command="/p4848/scheduler/diskcheck.sh",
    )

    check_disk_usage