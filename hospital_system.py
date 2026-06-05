import time
import random
import os
import sys
from datetime import datetime

DEVICES = {
    "heart_rate": [f"WARD_A_HR_{i:02d}" for i in range(1, 5)] +
                  [f"WARD_B_HR_{i:02d}" for i in range(1, 5)],
    "temp":       [f"WARD_A_TEMP_{i:02d}" for i in range(1, 6)] +
                  [f"WARD_B_TEMP_{i:02d}" for i in range(1, 6)],
    "water":      ["ICU_WATER_RESERVE", "WARD_A_WATER", "WARD_B_WATER"]
}

LOG_DIR = "active_logs"
PID_FILE = "/tmp/hospital_system.pid"

def get_status(value, sensor_type):
    if sensor_type == "heart_rate":
        if value < 50 or value > 120:
            return "CRITICAL"
        elif value < 60 or value > 100:
            return "WARNING"
        return "NORMAL"
    elif sensor_type == "temp":
        if value < 35.0 or value > 39.5:
            return "CRITICAL"
        elif value < 36.0 or value > 38.0:
            return "WARNING"
        return "NORMAL"
    else:
        return "NORMAL"

def generate_data():
    os.makedirs(LOG_DIR, exist_ok=True)
    while True:
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        with open(f"{LOG_DIR}/heart_rate.log", "a") as f:
            for device in DEVICES["heart_rate"]:
                value = random.randint(40, 130)
                status = get_status(value, "heart_rate")
                f.write(f"{timestamp} {device} {value} {status}\n")
        with open(f"{LOG_DIR}/temperature.log", "a") as f:
            for device in DEVICES["temp"]:
                value = round(random.uniform(34.0, 40.5), 1)
                status = get_status(value, "temp")
                f.write(f"{timestamp} {device} {value} {status}\n")
        with open(f"{LOG_DIR}/water_usage.log", "a") as f:
            for device in DEVICES["water"]:
                value = round(random.uniform(10.0, 100.0), 2)
                f.write(f"{timestamp} {device} {value} NORMAL\n")
        time.sleep(5)

def start():
    if os.path.exists(PID_FILE):
        print("Hospital system is already running.")
        return
    pid = os.fork()
    if pid > 0:
        with open(PID_FILE, "w") as f:
            f.write(str(pid))
        print(f"Hospital system started with PID {pid}")
    else:
        generate_data()

def stop():
    if not os.path.exists(PID_FILE):
        print("Hospital system is not running.")
        return
    with open(PID_FILE, "r") as f:
        pid = int(f.read())
    os.kill(pid, 9)
    os.remove(PID_FILE)
    print(f"Hospital system stopped (PID {pid})")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 hospital_system.py start|stop")
    elif sys.argv[1] == "start":
        start()
    elif sys.argv[1] == "stop":
        stop()
    else:
        print("Unknown command. Use start or stop.")
