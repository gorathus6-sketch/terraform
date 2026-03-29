from pydantic import BaseModel
from typing import List, Optional

class PolicyRequest(BaseModel):
    policy: dict

class PolicyAnalysis(BaseModel):
    valid: bool
    wildcard_actions: List[str]
    risky_actions: List[str]
    severity: int
    message: Optional[str] = None
