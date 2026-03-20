import json
from datetime import datetime, timezone

#
# ID idle VMs (pseudo-logic, convert to real metrics)
# eg data structure, pull from cloud API
# for actual resources
#

VMS = [
    {"name": "vm1", "last_cpu_activity": "2025-03-01T10:00:00", "avg_cpu": 2.1},
    {"name": "vm2", "last_cpu_activity": "2025-03-18T10:00:00", "avg_cpu": 25.0},
]

def find_idle(threshold_days=7, cpu_threshold=5.0):
    now = datetime.now(timezone.utc)
    idle = []

    for vm in VMS:
        last = datetime.fromisoformat(vm["last_cpu_activity"])
        days = (now - last).days

        if days >= threshold_days and vm["avg_cpu"] <= cpu_threshold:
            idle.append(vm)
    return idle

def main():
    idle = find_idle()

    with open("idle_vms.json", "w") as f:
        json.dump(idle, f, indent=2)

if __name__ == "__main__":
    main()
