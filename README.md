# 🚗 Real-Time Vehicle Tracker

A full-stack, real-time vehicle tracking application built with **FastAPI** (Python) on the backend and **Flutter** on the frontend.

---

## 📌 How It Works (Simple Flow)

1. **Backend (FastAPI)**: Generates live mock GPS coordinates (Latitude & Longitude) every second.
2. **Communication (WebSocket)**: Sends continuous location data over a real-time `ws://` connection between server and client.
3. **Frontend (Flutter Web)**: Receives coordinate payloads instantly via `web_socket_channel`.
4. **Live Map (flutter_map)**: Updates the red car icon's position live on OpenStreetMap while drawing a blue path showing route history.

---

## 🛠️ Tech Stack

* **Backend**: Python, FastAPI, Uvicorn, WebSockets
* **Frontend**: Flutter (Web), Provider (State Management), `flutter_map`

---

## 🚀 How to Run Locally

### 1. Start Backend
```bash
cd backend
pip install fastapi uvicorn websockets
python -m uvicorn main:app --reload --port 8000
Backend runs on: http://127.0.0.1:8000

### 2. Start Frontend
flutter pub get
flutter run -d chrome

### Project Structure

vehicle_tracker_app/
├── backend/
│   └── main.py              # FastAPI server & WebSocket route
└── lib/
    ├── models/              # Vehicle data models
    ├── providers/           # WebSocket state management
    └── screens/             # Flutter Map UI screen
