from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from datetime import datetime
import json, threading
from pathlib import Path
from watchfiles import watch

app = FastAPI(title="Train System Dashboard")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

# ---------------------------------------------------------------------------
# Live-reloading train data from trains.json
# ---------------------------------------------------------------------------
TRAINS_FILE = Path(__file__).parent / "trains.json"
TRAINS: list = []

def load_trains():
    global TRAINS
    try:
        TRAINS = json.loads(TRAINS_FILE.read_text())
        print(f"[{datetime.now().strftime('%H:%M:%S')}] trains.json reloaded — {len(TRAINS)} trains")
    except Exception as e:
        print(f"Failed to load trains.json: {e}")

def watch_trains():
    for _ in watch(TRAINS_FILE):
        load_trains()

load_trains()
threading.Thread(target=watch_trains, daemon=True).start()

# ---------------------------------------------------------------------------
# Mileage Maintenance Milestones
# Each milestone has its own alert_within threshold
# ---------------------------------------------------------------------------
MILESTONES = [
    {"km": 2_000,   "cycle": "2,000 km",   "label": "Visual Inspection",        "detail": "Visual inspection of general train condition.",             "severity": "info",     "alert_within": 200},
    {"km": 13_000,  "cycle": "13,000 km",  "label": "Function Check — Doors",   "detail": "Function checks on Emergency Door and Saloon Door.",        "severity": "info",     "alert_within": 500},
    {"km": 40_000,  "cycle": "40,000 km",  "label": "Extended Systems Check",   "detail": "Function checks on Air-con and Brakes.",                    "severity": "warning",  "alert_within": 1000},
    {"km": 120_000, "cycle": "120,000 km", "label": "Detailed Component Check", "detail": "Greasing, Air Compressor inspection, Filter Cleaning.",      "severity": "warning",  "alert_within": 1000},
    {"km": 360_000, "cycle": "360,000 km", "label": "Full Overhaul",            "detail": "Removal of Bogie and overhaul of major vehicle components.", "severity": "critical", "alert_within": 2000},
]

severity_order = {"critical": 0, "warning": 1, "info": 2}

# Remembers when each (train_id, cycle) alert was first triggered
_alert_first_seen: dict = {}


def get_milestone_alerts(trains):
    """
    Groups all triggered milestones per train into a single alert card.
    If a train hits 2+ milestones at once, they are listed together under one card.
    The card severity is the highest (most critical) among all triggered milestones.
    """
    alerts = []
    alert_id = 1
    active_keys = set()  # track which keys are still active this run

    for train in trains:
        mileage = train["mileage"]
        triggered = []  # all milestones triggered for this train

        for ms in MILESTONES:
            cycle_km = ms["km"]
            next_due = ((mileage // cycle_km) + 1) * cycle_km
            km_remaining = next_due - mileage
            key = f"{train['id']}-{ms['cycle']}-{next_due}"

            if mileage > 0 and mileage % cycle_km == 0:
                active_keys.add(key)
                if key not in _alert_first_seen:
                    _alert_first_seen[key] = datetime.now().strftime("%H:%M")
                triggered.append({
                    "cycle":         ms["cycle"],
                    "label":         ms["label"],
                    "detail":        ms["detail"],
                    "severity":      ms["severity"],
                    "km_remaining":  0,
                    "next_due":      next_due,
                    "status":        "due_now",
                })
            elif 0 < km_remaining <= ms["alert_within"]:
                active_keys.add(key)
                if key not in _alert_first_seen:
                    _alert_first_seen[key] = datetime.now().strftime("%H:%M")
                triggered.append({
                    "cycle":         ms["cycle"],
                    "label":         ms["label"],
                    "detail":        ms["detail"],
                    "severity":      ms["severity"],
                    "km_remaining":  km_remaining,
                    "next_due":      next_due,
                    "status":        "upcoming",
                })

        if not triggered:
            continue

        # Sort triggered milestones by severity then km_remaining
        triggered.sort(key=lambda m: (severity_order[m["severity"]], m["km_remaining"]))

        # Card severity = highest severity among all triggered milestones
        card_severity = triggered[0]["severity"]

        # Smallest km_remaining among triggered (for sorting cards against each other)
        min_km_remaining = triggered[0]["km_remaining"]

        # Build milestone lines: "2,000 km — Visual Inspection"
        milestone_lines = [f"{m['cycle']} — {m['label']}" for m in triggered]

        # Build detail lines for each triggered milestone
        detail_lines = [f"{m['cycle']}: {m['detail']}" for m in triggered]

        # Build message
        if len(triggered) == 1:
            m = triggered[0]
            if m["status"] == "due_now":
                message = f"{train['name']} ({train['id']}) reached {mileage:,} km — {m['label']} due now."
            else:
                message = f"{train['name']} ({train['id']}) has {m['km_remaining']:,} km until {m['cycle']} — {m['label']}."
        else:
            km_lines = ", ".join([f"{m['cycle']} in {m['km_remaining']:,} km" for m in triggered])
            message = f"{train['name']} ({train['id']}): {km_lines}."

        alerts.append({
            "id":              alert_id,
            "severity":        card_severity,
            "train":           train["id"],
            "train_name":      train["name"],
            "milestones":      milestone_lines,   # list of "Xkm — Label" strings
            "details":         detail_lines,      # list of "Xkm: detail" strings
            "message":         message,
            "km_remaining":    min_km_remaining,
            "time":            _alert_first_seen.get(f"{train['id']}-{triggered[0]['cycle']}-{triggered[0]['next_due']}", datetime.now().strftime("%H:%M")),
        })
        alert_id += 1

    # Sort cards: severity first, then km_remaining
    # severity asc (critical first), then time desc (newest first) within each severity
    alerts.sort(key=lambda a: (severity_order[a["severity"]], a["time"]), reverse=False)
    alerts = [a for sev in ["critical","warning","info"] for a in sorted([x for x in alerts if x["severity"]==sev], key=lambda a: a["time"], reverse=True)]

    # Clear timestamps for alerts no longer active so they get fresh time if re-triggered
    for stale_key in list(_alert_first_seen.keys()):
        if stale_key not in active_keys:
            del _alert_first_seen[stale_key]
    return alerts


# ---------------------------------------------------------------------------
# API Endpoints
# ---------------------------------------------------------------------------

@app.get("/api/summary")
async def get_summary():
    alerts = get_milestone_alerts(TRAINS)
    total  = len(TRAINS)
    active = sum(1 for t in TRAINS if t["status"] == "active")
    alert_counts = {"critical": 0, "warning": 0, "info": 0}
    for a in alerts:
        alert_counts[a["severity"]] += 1
    return {
        "total_trains": total,
        "active":       active,
        "maintenance":  total - active,
        "alert_counts": alert_counts,
        "total_alerts": len(alerts),
        "timestamp":    datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
    }


@app.get("/api/trains")
async def get_trains():
    return {"trains": TRAINS}


@app.get("/api/alerts")
async def get_alerts():
    return {"alerts": get_milestone_alerts(TRAINS)}


@app.get("/api/mileage-chart")
async def mileage_chart():
    return {
        "labels":   [t["name"] for t in TRAINS],
        "values":   [t["mileage"] for t in TRAINS],
        "statuses": [t["status"] for t in TRAINS],
    }


if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=False)