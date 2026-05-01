# TrackOps — Train System Dashboard

A FastAPI-powered operations dashboard for monitoring a train fleet.

## Features
- **Train Count** — total fleet size at a glance
- **Train Status** — active vs. maintenance with live status pills
- **Average Mileage** — fleet-wide average across all trains
- **Alert Summary** — critical / warning / info breakdown with detail list
- **Mileage Chart** — per-train bar chart (color-coded by status)
- **Auto-refresh** every 30 seconds

## Setup

```bash
# 1. Install dependencies
pip install -r requirements.txt

# 2. Run the server
python main.py
# or:
uvicorn main:app --reload

# 3. Open in browser
# http://localhost:8000
```

## API endpoints

| Endpoint | Description |
|---|---|
| `GET /` | Dashboard HTML |
| `GET /api/summary` | KPI summary (totals, avg mileage, alert counts) |
| `GET /api/trains` | Full train list with status & mileage |
| `GET /api/alerts` | All alerts with severity & metadata |
| `GET /api/mileage-chart` | Chart-ready mileage data |

## Connecting real data

Replace the `TRAINS` and `ALERTS` lists in `main.py` with database queries.
Example with SQLAlchemy:

```python
from sqlalchemy.orm import Session

@app.get("/api/trains")
async def get_trains(db: Session = Depends(get_db)):
    trains = db.query(Train).all()
    return {"trains": [t.__dict__ for t in trains]}
```

## Project structure

```
train_dashboard/
├── main.py              # FastAPI app & all API routes
├── requirements.txt
├── templates/
│   └── dashboard.html   # Full dashboard UI (HTML + JS + Chart.js)
└── static/              # Place CSS/JS assets here if needed
```
