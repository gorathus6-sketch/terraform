import json
import requests
from datetime import datetime, timezone

# you'll normally use azure-monitor-query
# but this shows API usage pattern

WORKSPACE_ID = "changethis"
API_URL = f"https://api.loganalytics.io/v1/workspaces/{WORKSPACE_ID}/query"
ACCESS_TOKEN = "Bearer changethis"
KQL = "AzureActivity | take 50"

def query_logs():
    resp = requests.post(
        API_URL,
        headers={"Authorization": ACCESS_TOKEN},
        json={"query":KQL},
        timeout=15
    )
    resp.raise_for_status()
    return resp.json()

def main():
    data = query_logs()
    ts = datetime.now(timezone.utc).strftime("%Y%m%d_%H%M%S")

    with open(f"logs_{ts}.json", "w") as f:
        json.dump(data, f, indent=2)

if __name__ == "__main__":
    main()

#
# query logs via REST (KQL) and dump results
#