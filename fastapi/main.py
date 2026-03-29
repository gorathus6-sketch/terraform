from fastapi import FastAPI
from app.models import PolicyRequest, PolicyAnalysis
from app.analyzer import analyze_policy

app = FastAPI(title="IAM Policy Analyzer API")

@app.post("/analyze", response_model=PolicyAnalysis)
def analyze(request: PolicyRequest):
    result = analyze_policy(request.policy)
    return result