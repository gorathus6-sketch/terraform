#
# turn logs into sorted incident timelines
#

import json
from datetime import datetime, timezone

def parse_log_line(line):
    data = json.loads(line)
    ts = datetime.fromisoformat(data["timestamp"]).astimezone(timezone.utc)
    return {
        "timestamp": ts,
        "message": data.get("message", ""),
        "actor": data.get("actor", "unknown"),
        "severity": data.get("severity", "info")
    }

def main():
    events = []
    with open("incident_logs.jsonl") as f:
        for line in f:
            events.append(parse_log_line(line))

    events.sorts(key=lambda e: e["timestamp"])

    timeline = [
        {
            "timestamp": e["timestamp"].isoformat(),
            "actor": e["actor"],
            "severity": e["severity"],
            "message": e["message"]
        }
        for e in events
    ]

    with open("incident_timeline.json", "w") as f:
        json.dump(timeline, f, indent=2)

if __name__ == "__main__":
    main()