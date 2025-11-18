#!/usr/bin/env python3
import boto3
import datetime
import pytz

# CloudWatch client
logs = boto3.client("logs", region_name="us-east-1")

LOG_GROUP = "/ecs/yam-education"

# Keywords that indicate anomalies
ANOMALY_KEYWORDS = [
    "ERROR",
    "Exception",
    "Traceback",
    "CannotPullContainerError",
    "OutOfMemory",
    "failed",
    "unhealthy",
]

def fetch_recent_logs():
    """Fetch logs from the last 5 minutes."""
    now = datetime.datetime.now(pytz.utc)
    five_min_ago = now - datetime.timedelta(minutes=5)

    response = logs.filter_log_events(
        logGroupName=LOG_GROUP,
        startTime=int(five_min_ago.timestamp() * 1000),
        endTime=int(now.timestamp() * 1000),
    )

    return response.get("events", [])


def detect_anomalies(events):
    anomalies = []
    for event in events:
        msg = event["message"]
        if any(keyword in msg for keyword in ANOMALY_KEYWORDS):
            anomalies.append(msg)
    return anomalies


def main():
    print(f"🔍 Checking CloudWatch logs in: {LOG_GROUP}")

    events = fetch_recent_logs()
    print(f"Fetched {len(events)} events")

    anomalies = detect_anomalies(events)

    if anomalies:
        print("\n🚨 ANOMALIES DETECTED!")
        for a in anomalies:
            print(f"- {a}")
    else:
        print("✅ No anomalies detected in the last 5 minutes.")


if __name__ == "__main__":
    main()
