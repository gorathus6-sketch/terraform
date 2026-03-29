from fastapi import FastAPI

# 1) create the 'app' instance
app = FastAPI()

# 2) define a 'route' (the URL path)
@app.get("/status")
def get_system_status():
    # 3) return data in JSON format
    return {
        "status": "online",
        "environment": "development",
        "uptime_hours": 24
    }