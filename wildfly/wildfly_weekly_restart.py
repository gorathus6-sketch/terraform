from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.utils.dates import days_ago
from datetime import datetime, timedelta
import pendulum

# use US-Eastern to ensure 4pm ET runs correctly year round

eastern = pendulum.timezone("US/Eastern")

default_args = {
    "owner": "goldman_sachs_ops",
    "depends_on_past": False,
    "email_on_failure": True,
    "email": ["wildfly-support@goldmansachs.com"],
    "retries": 2,
    "retry_delay": timedelta(minutes=5),
}

with DAG(
    dag_id="wildfly_weekly_restart",
    description="Weekly restart of Wildfly 20 for Goldman Sachs client",
    default_args=default_args,
    start_date=days_ago(1),
    schedule_interval="0 16 * * 5", # Friday, 4pm ET

    catchup=False,
    tags=["wildfly", "maintenance", "goldman_sachs"],
    timezone=eastern,
) as dag:
    
    restart_wildfly = BashOperator(
        task_id="restart_wildfly_service",
        bash_command="/usr/bin/python3 /opt/wildfly20/bin/run_restart.py",
        cwd="/opt/wildfly20/bin",
    )

    restart_wildfly