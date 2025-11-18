import boto3
from datetime import datetime, timedelta, timezone

LOG_GROUP = "/ecs/yam-education"   # ← Ton vrai log group ECS

client = boto3.client("logs")

print("🔎 Checking CloudWatch logs...")

try:
    response = client.filter_log_events(
        logGroupName=LOG_GROUP,
        startTime=int((datetime.now(timezone.utc) - timedelta(minutes=5)).timestamp() * 1000),
        endTime=int(datetime.now(timezone.utc).timestamp() * 1000),
        limit=20
    )

    events = response.get("events", [])

    if not events:
        print("⚠️ No recent logs found.")
    else:
        print(f"✅ Found {len(events)} log events:\n")
        for ev in events:
            ts = datetime.fromtimestamp(ev['timestamp']/1000, tz=timezone.utc).strftime('%Y-%m-%d %H:%M:%S')
            print(f"[{ts}] {ev['message']}")

except Exception as e:
    print(f"❌ Failed to fetch logs: {e}")

