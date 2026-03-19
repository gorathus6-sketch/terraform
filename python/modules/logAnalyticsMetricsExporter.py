import csv
import json
import requests
from datetime import datetime, timezone

API_URL = "https://your-url/api/metrics"

def fetch_metrics():
    resp = requests.get(API_URL, timeout=10)
    resp.raise_for_status()
    return resp.json()

def export_csv(data, path):
    if not data:
        return
    keys = data[0].keys()
    with open(path, "w", newLine="") as f:
        writer = csv.DictWriter(f, fieldnames=keys)
        writer.writeheader()
        writer.writerows(data)

def main():
    metrics = fetch_metrics()
    # ts = datetime.utcnow().strftime("%Y%m%d_%H%M%S") is deprecated
    # Use updated timezone import:
    # ts = datetime.now(timezone.utc).strftime("%Y%m%d_%H%M%S")
    ts = datetime.now(timezone.utc).strftime("%Y%m%d_%H%M%S")
    export_csv(metrics, f"metrics_{ts}.csv")
    with open(f"metrics_{ts}.json", "w") as f:
        json.dump(metrics, f, indent=2)

if __name__ == "__main__":
    main()

#
# Use this script to pull metrics/logs from API
# and export to CSV / JSON
#