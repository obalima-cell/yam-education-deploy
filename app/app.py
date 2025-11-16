from flask import Flask, jsonify
import os
app = Flask(__name__)

@app.route("/")
def hello():
    return jsonify({
        "service": "yam-edu-sample-api",
        "message": "Hello from ECS Fargate!",
        "env": os.environ.get("ENV", "dev")
    })

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int(os.environ.get("PORT", 8000)))

@app.get("/health")
def health():
    return {
        "status": "ok",
        "service": "yam-api"
    }
