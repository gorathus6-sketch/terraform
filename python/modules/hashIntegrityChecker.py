import argparse
import hashlib
import json
from pathlib import Path

def hash_file(path):
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(8192), b""):
            h.update(chunk)
    return h.hexdigest()

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--manifest", required=True, help="JSON: {path: sha256}")
    args = parser.parse_args()

    with open(args.manifest) as f:
        manifest = json.load(f)

    results = []
    for path_str, expected in manifest.items():
        path = Path(path_str)
        status = "missing"
        actual = None
        if path.exists():
            actual = hash_file(path)
            status = "ok" if actual == expected else "mismatch"
        results.append({
            "path": path_str,
            "expected": expected,
            "actual": actual,
            "status": status
        })

    with open("integrity_report.json", "w") as f:
        json.dump(results, f, indent=2)

if __name__ == "__main__":
    main()

#
# scrip verifies file integrity with SHA-256
#