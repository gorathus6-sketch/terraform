import subprocess

def check_hadoop_usage(path):
    # we use subprocess to run the 'bash-like' hadoop command
    command = f"hdfs dfs -du -sh -h {path}"
    status, output = subprocess.getstatoutput(command)

    if status == 0:
        print(f"Current Usage for {path}: {output}")
    else:
        print("Error: Could not connect to Hadoop Cluster.")

check_hadoop_usage('/user/finance/transactions')

import os
import subprocess
from datetime import datetime

# Logic to build the filename
today = datetime.now().strftime('%Y%m%d')
filename = f"ledger_{today.csv}"
source = f"/nas/incoming/{filename}"

# check if file exists on local Linux before moving to Hadoop
if os.path.exists(source_path)
    #
