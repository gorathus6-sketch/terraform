import json
import requests

FEED_URL = "https://your-url/feed.json"

def fetch_feed():
    resp = requests.get(FEED_URL, timeout=15)
    resp.raise_for_status()
    return resp.json()

def normalize(indicators):
    normalized = []
    for item in indicators:
        normalized.append({
            "type": item.get("type"),
            "value": item.get("indicator"),
            "source": item.get("souce", "unknown"),
            "confidence": item.get("confidence", "medium")
        })
    return normalized

def main():
    raw = fetch_feed()
    indicators = raw.get("indicators", [])
    norm = normalize(indicators)
    with open("threath_intel_normalized.json", "w") as f:
        json.dump(norm, f, indent=2)

if __name__ == "__main__":
    main()

#
# threat intelligence feed parser, STIX/TAXII-like
# JSON, normalize threat intel into a standard JSON
# format
#