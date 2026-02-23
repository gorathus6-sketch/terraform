from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime, timedelta
import subprocess

default_args = {
    "owner": "airflow",
    "depends_on_past": False,
    "retries": 1,
    "retry_delay": timedelta(minutes=5),
}

def run_powershell(script_path):
    result = subprocess.run(
        ["powershell.exe", "-File", script_path],
        capture_output=True,
        text=True
    )
    print(result.stdout)
    print(result.stderr)
    if result.returncode != 0:
        raise Exception(f"PowerShell script failed: {script_path}")
    
with DAG(
    dag_id="disk_space_check_windows",
    default_args=default_args,
    description="Runs PowerShell disk usage checks on Windows workers",
    schedule_interval="0 * * * *",
    start_date=datetime(2023, 1, 1),
    catchup=False,
) as dag:

    check_disk_75 = PythonOperator(
        task_id="check_disk_75",
        python_callable=run_powershell,
        op_args=[r"C:\scripts\chk_diskspace_ps.ps1"],
    )

    check_disk_85 = PythonOperator(
        task_id="check_disk_85",
        python_callable=run_powershell,
        op_args=[r"C:\scripts\chk_diskspace_ps85.ps1"],
    )

    check_disk_75 >> check_disk_85