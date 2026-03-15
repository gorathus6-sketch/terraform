import os
import subprocess
from datetime import datetime

def check_hadoop_usage(path):
    # we use subprocess to run the 'bash-like' hadoop command
    command = f"hdfs dfs -du -sh -h {path}"
    status, output = subprocess.getstatoutput(command)

    if status == 0:
        print(f"Current Usage for {path}: {output}")
    else:
        print(f"Error: Could not connect to Hadoop Cluster.")

# Logic to build the filename
today = datetime.now().strftime('%Y%m%d')
filename = f"ledger_{today}.csv"
source_path = f"/nas/incoming/{filename}"
hadoop_destination = f"user/finance/transactions/{filename}"

# check if file exists on local Linux before moving to Hadoop
if os.path.exists(source_path):
    print(f"File found: {source_path}. Starting upload...")

    # invoke the hadoop put command
    put_command = f"hdfs dfs -put {source_path} {hadoop_destination}"
    put_status, put_output = subprocess.getstatusoutput(put_command)

    if put_status == 0:
        print(f"Success: {filename} moved to HDFS")
        # verify the directory after upload
        check_hadoop_usage(f"user/finance/transactions")
    else:
        print(f"Failed to upload to HDFS: {put_output}")
else:
    print(f"File {source_path} not found on local filesystem.")
