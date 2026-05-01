from fastapi import FastAPI, Request
from fastapi.responses import HTMLResponse
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates
from datetime import datetime
import random

app = FastAPI(title="Train System Dashboard")

app.mount("/static", StaticFiles(directory="static"), name="static")
templates = Jinja2Templates(directory="templates")

# --- Mock Data ---
TRAINS = [
    {"id": "TR-001", "name": "SKLRT-015", "status": "active",   "mileage": 142300, "route": "North Line",   "last_service": "2026-03-15"},
    {"id": "TR-002", "name": "BPLRT-009",   "status": "active",   "mileage": 98750,  "route": "Coast Line",   "last_service": "2026-04-01"},
    {"id": "TR-003", "name": "SKLRT-021",    "status": "maintenance","mileage": 231600, "route": "Mountain Line","last_service": "2026-01-20"},
    {"id": "TR-004", "name": "PGLRT-015",    "status": "active",   "mileage": 55400,  "route": "City Loop",    "last_service": "2026-04-10"},
    {"id": "TR-005", "name": "SKLRT-029",    "status": "active",   "mileage": 187900, "route": "Delta Line",   "last_service": "2026-02-28"},
    {"id": "TR-006", "name": "SKLRT-001",   "status": "maintenance","mileage": 310200, "route": "West Line",   "last_service": "2025-12-05"},
    {"id": "TR-007", "name": "PGLRT-005",    "status": "active",   "mileage": 76100,  "route": "Bay Line",     "last_service": "2026-03-30"},
    {"id": "TR-008", "name": "BPLRT-025",   "status": "active",   "mileage": 120500, "route": "Highland Line","last_service": "2026-04-05"},
]

ALERTS = [
    {"id": 1, "severity": "critical", "message": "TR-006 overdue for scheduled maintenance (150+ days)", "time": "08:14", "train": "TR-006"},
    {"id": 2, "severity": "warning",  "message": "TR-003 pantograph inspection required before next run", "time": "09:32", "train": "TR-003"},
    {"id": 3, "severity": "warning",  "message": "TR-005 brake pad wear reaching 80% threshold",         "time": "10:05", "train": "TR-005"},
    {"id": 4, "severity": "info",     "message": "TR-001 scheduled for routine oil check on 2026-05-03", "time": "11:20", "train": "TR-001"},
    {"id": 5, "severity": "info",     "message": "TR-007 passed safety inspection successfully",         "time": "12:45", "train": "TR-007"},
]

# --- API endpoints ---

@app.get("/", response_class=HTMLResponse)
async def dashboard(request: Request):
    return templates.TemplateResponse(request=request, name="dashboard.html")


@app.get("/api/summary")
async def get_summary():
    total       = len(TRAINS)
    active      = sum(1 for t in TRAINS if t["status"] == "active")
    maintenance = total - active
    avg_mileage = int(sum(t["mileage"] for t in TRAINS) / total)

    alert_counts = {"critical": 0, "warning": 0, "info": 0}
    for a in ALERTS:
        alert_counts[a["severity"]] += 1

    return {
        "total_trains":   total,
        "active":         active,
        "maintenance":    maintenance,
        "avg_mileage":    avg_mileage,
        "alert_counts":   alert_counts,
        "total_alerts":   len(ALERTS),
        "timestamp":      datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
    }


@app.get("/api/trains")
async def get_trains():
    return {"trains": TRAINS}


@app.get("/api/alerts")
async def get_alerts():
    return {"alerts": ALERTS}


@app.get("/api/mileage-chart")
async def mileage_chart():
    return {
        "labels": [t["name"] for t in TRAINS],
        "values": [t["mileage"] for t in TRAINS],
        "statuses": [t["status"] for t in TRAINS],
    }


if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
