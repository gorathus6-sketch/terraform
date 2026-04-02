from airflow import DAG
from airflow.providers.standard.operators.bash import BashOperator
from datetime import datetime, timedelta

#
#
# Windows-optimized Airflow DAG template
#
#

default_args = {
    "owner": "windows_ops",
    "depends_on_past": False,
    "email_on_failure": True,
    "email": ["ops-team@empathome.com"],
    "retries": 2,
    "retry_delay": timedelta(minutes=5),
}

with DAG(
    dag_id="windows_ops_automation",
    description="Windows-optimized Airflow DAG orchestrating PowerShell scripts",
    start_date=datetime(2024, 1, 1),
    schedule="0 16 * * 5", # Fridays at 16:00

    catchup=False,
    default_args=default_args,
) as dag:
    
    #
    #
    # example task 1: Disk Health Check
    #
    #

    disk_check = BashOperator(
        task_id="disk_health_check",
        bash_command=(
            'pwsh -NoProfile -ExecutionPolicy Bypass '
            '-File "/opt/airflow/dags/windows_ops/check_disk.ps1" '
            '-Threshold 80'
        )
    )

    #
    #
    # example task 2: windows service restart
    #
    #

    restart_service = BashOperator(
      task_id="restart_service",
      bash_command=(
        'pwsh -NoProfile -ExecutionPolicy Bypass '
        '-File "/opt/airflow/dags/windows_ops/restart_service.ps1" '
        '-ServiceName "Spooler"'
      )
    )

    #
    #
    # Example task 3: full system health check
    #
    #

    system_health = BashOperator(
        task_id="system_health_check",
        bash_command=(
            'pwsh -NoProfile -ExexcutePolicy Bypass '
            '-File "/opt/airflow/dags/windows_ops/system_health_check.ps1"'
        )
    )

    # Task Dependencies

    disk_check >> restart_service >> system_health
