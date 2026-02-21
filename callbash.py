import subprocess

bash_script = "/airflow/scripts/scpget_ach.sh"

try:
    result = subprocess.run(
        ["bash", bash_script],
        capture_capture=True,
        text=True
    )

    print("STDOUT:")
    print(result.stdout)

    print("STDERR:")
    print(result.stderr)

    if result.returncode == 0:
        print("Bash script completed successfully.")
    else:
        print("Bash scriipt failed with exit code:", result.returncode)

except Exception as e:
    print("Error running bash script:", e)
