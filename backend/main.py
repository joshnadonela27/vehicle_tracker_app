import asyncio
import json
import random
from fastapi import FastAPI, WebSocket
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
def read_root():
    return {"status": "FastAPI Vehicle Tracker Backend is Running!"}

@app.websocket("/ws/vehicle")
async def websocket_endpoint(websocket: WebSocket):
    await websocket.accept()
    print(">>> Client Connected! Starting live coordinate stream... <<<")
    lat, lng = 17.3850, 78.4867
    
    try:
        while True:
            lat += random.uniform(-0.002, 0.002)
            lng += random.uniform(-0.002, 0.002)
            
            # Print to backend terminal
            print(f"Sending coordinates: Lat {lat:.4f}, Lng {lng:.4f}")
            
            payload = json.dumps({"latitude": lat, "longitude": lng})
            await websocket.send_text(payload)
            await asyncio.sleep(1)
    except Exception as e:
        print(f"Client disconnected: {e}")