from flask import Flask, jsonify, request

app = Flask(__name__)

# -------------------------------------------------------------------
# DEMO DATA (simulé en mémoire)
# -------------------------------------------------------------------
items = [
    {"id": 1, "name": "Cours DevOps", "price": 50},
    {"id": 2, "name": "Cours Python", "price": 40}
]

# -------------------------------------------------------------------
# ROUTE PRINCIPALE
# -------------------------------------------------------------------
@app.route("/")
def index():
    return jsonify({
        "env": "dev",
        "message": "Hello from ECS Fargate!",
        "service": "yam-edu-sample-api"
    })

# -------------------------------------------------------------------
# HEALTH CHECK
# -------------------------------------------------------------------
@app.route("/health")
def health():
    return jsonify({"status": "healthy"}), 200

# -------------------------------------------------------------------
# GET ALL ITEMS
# -------------------------------------------------------------------
@app.route("/items", methods=["GET"])
def get_items():
    return jsonify(items)

# -------------------------------------------------------------------
# GET ITEM BY ID
# -------------------------------------------------------------------
@app.route("/items/<int:item_id>", methods=["GET"])
def get_item(item_id):
    for item in items:
        if item["id"] == item_id:
            return jsonify(item)
    return jsonify({"error": "Item not found"}), 404

# -------------------------------------------------------------------
# CREATE ITEM
# -------------------------------------------------------------------
@app.route("/items", methods=["POST"])
def add_item():
    data = request.json
    new_item = {
        "id": len(items) + 1,
        "name": data.get("name"),
        "price": data.get("price")
    }
    items.append(new_item)
    return jsonify(new_item), 201

# -------------------------------------------------------------------
# UPDATE ITEM
# -------------------------------------------------------------------
@app.route("/items/<int:item_id>", methods=["PUT"])
def update_item(item_id):
    data = request.json
    for item in items:
        if item["id"] == item_id:
            item["name"] = data.get("name", item["name"])
            item["price"] = data.get("price", item["price"])
            return jsonify(item)
    return jsonify({"error": "Item not found"}), 404

# -------------------------------------------------------------------
# DELETE ITEM
# -------------------------------------------------------------------
@app.route("/items/<int:item_id>", methods=["DELETE"])
def delete_item(item_id):
    global items
    items = [item for item in items if item["id"] != item_id]
    return jsonify({"message": "Item deleted"}), 200


# -------------------------------------------------------------------
# RUN LOCAL
# -------------------------------------------------------------------
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)

