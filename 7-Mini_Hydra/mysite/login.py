from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route("/login", methods=["POST"])
def login():
    user = request.form.get("user")
    password = request.form.get("pass")

    return jsonify({
        "received_user": user,
        "received_password": password
    })

app.run(host="127.0.0.1", port=9000)
