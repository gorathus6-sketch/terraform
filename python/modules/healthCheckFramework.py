import json
from datetime import datetime, timezone

def check_disk():
    return {"name": "disk_usage", "status": "ok", "details": "placehold"}

def check_cpu():
    return {"name": "cpu_usage", "status": "ok", "details": "placeholder"}

CHECKS = [check_disk, check_cpu]

def main():
    results = []
    for check in CHECKS:
        try:
            results.append(check())
        except Exception as e:
            results.append({
                "name": check.__name__,
                "status": "error",
                "details": str(e)
            })

    report = {
        "generated_at": datetime.now(timezone.utc).isoformat(),
        "results": results
    }

    with open("health_report.json", "w") as f:
        json.dump(report, f, indent=2)

if __name__ == "__main__":
    main()

#
# Run multiple sytem checks, output JSON
#
#
