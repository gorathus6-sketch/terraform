from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)

def test_analyze_policy():
    payload = {
        "policy": {
            "statement": {
                "Action": "s3:*"
            }
        }
    }

    response = client.post("/analyze", json=payload)
    assert response.status_code == 200
    data = response.json()

    assert data("valid") is True
    assert "s3:*" in data["wildcard_actions"]
