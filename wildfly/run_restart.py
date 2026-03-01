import subprocess
import sys
import datetime

#
# Due to SLA, this must be scheduled as
# 0 16 * * 5 /usr/bin/python3 /opt/wildfly20/bin/run_restart.py
# via Airflow or crontab -e
#

LOGFILE = "/opt/wildfly20/logs/restart.log"
SCRIPT = "/opt/wildfly20/bin/restart_wildfly.sh"

def log(msg):
    with open(LOGFILE, "a") as f:
        f.write(f"{datetime.datetime.now()} - {msg}\n")

def main():
    log("Starting scheduled Wildfly restart job for Goldman Sachs.")

    result = subprocess.run(["/bin/bash", SCRIPT])
    if result.returncode != 0:
        log("Wildfly restart FAILED.")
        sys.exit(1)

    log("Wildfly restart completed successfully.")
    sys.exit(0)

if __name__ == "__main__":
    main()
