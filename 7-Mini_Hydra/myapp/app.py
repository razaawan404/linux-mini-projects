from flask import Flask, request, jsonify

app = Flask(__name__)

# valid credentials
USERNAME = "admin"
PASSWORD = "secret123"

@app.route("/login", methods=["POST"])
def login():
    username = request.form.get("username")
    password = request.form.get("password")

    if username == USERNAME and password == PASSWORD:
        return jsonify({"status": "success", "message": "Welcome admin!"}), 200
    else:
        return jsonify({"status": "fail", "message": "Invalid credentials"}), 401

@app.route("/", methods=["GET"])
def index():
    return "<h1>Login at /login</h1>", 200

if __name__ == "__main__":
    app.run(host="127.0.0.1", port=5000, debug=True)
