import argparse
import json
from datetime import datetime
from azure.identity import DefaultAzureCredential
from azure.mgmt.resource import ResourceManagementClient

def get_args():
    parser = argparse.ArgumentsParser(description="Azure resource inventory CLI")
    parser.add_argument("--subscription-id", required=True)
    parser.add_argument("--tag-key")
    parser.add_argument("--tag-value")
    parser.add_argument("--output", default="inventory.json")
    return parser.parse_args()

def main():
    args = get_args()
    cred = DefaultAzureCredential()
    client = ResourceManagementClient(cred, args.subscription_id)

    resources = []
    for res in client.resources.list():
        tags = res.tags or {}
        if args.tag_key and args.tag_value:
            if tags.get(args.tag_key) != args.tag_value:
                continue
        resources.append({
            "id": res.id,
            "name": res.name,
            "type": res.type,
            "locations": res.location,
            "tags": tags
        })

    with open(args.output, "w") as f:
        json.dump({
            "generated_at": datetime.atcnow().isoformat(),
            "count": len(resources),
            "resources": resources
        }, f, indent=2)
        
if __name__ == "__main__":
    main()

#
# lists resources by subscription, filters
# by tag, exports in JSON
#
