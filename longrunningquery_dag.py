from airflow import DAG
from airflow.operators.bash import BashOperator
from datetime import datetime, timedelta

default_args = {
    "owner": "airflow",
    "retries": 1,
    "retry_delay": timedelta(minutes=5),
}

with DAG(
    dag_id="check_long_running_queries",
    default_args=default_args,
    schedule_interval="*/10 * * * *", # recurs 10 mins

    start_date=datetime(2024, 1, 1),
    catchup=False,
) as dag:
    
    check_queries = BashOperator(
        task_id="check_long_runnng_queries_taks",
        bash_command="p4848/scheduler/call_longrunningquery.sh",
    )

check_queries