def analyze_policy(policy: dict):
    wildcard_actions = []
    risky_actions = []
    severity = 0

    statements = policy.get("Statement", [])
    if not isinstance(statements, list):
        statements = [statements]

    for stmt in statements:
        actions = stmt.get("Action", [])
        if isinstance(actions, str):
            actions = [actions]

        for action in actions:
            if "*" in action:
                wildcard_actions.append(action)
                severity += 3

    return {
        "valid": True,
        "wildcard_actions": wildcard_actions,
        "risky_actions": risky_actions,
        "severity": severity,
        "message": "Policy analyzed successfully."
    }
