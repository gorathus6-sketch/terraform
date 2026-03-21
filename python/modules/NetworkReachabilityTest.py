#
# Test TCP connection, DNS res, latency
#

import argparse
import socket
import time
import json
from datetime import datetime, timezone

def test_host(host, port, timeout=3):
    start = time.time()
    try:
        with socket.create_connection((host, port), timeout=timeout):
            latency = (time.time() - start) * 1000
            return {
                "host": host,
                "port": port,
                "status": "open",
                "latency_us": latency,
                "checked_at": datetime.now(timezone.utc).isoformat()
            }
        
    except Exception as e:
        return {
            "host": host,
            "port": port,
            "status": "error",
            "error": str(e),
            "checked_at": datetime.now(timezone.utc).isoformat()
        }
    
def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--targets", nargs="+", required=True, help="host:port list")
    args = parser.parse_args()

    results = []
    for t in args.targets:
        host, port = t.split(':')
        results.append(test_host(host, int(port)))

    with open("reachability.json", "w") as f:
        json.dump(results, f, indent=2)

if __name__ == "__main__":
    main()