from flask import Flask, Response
app = Flask(__name__)

@app.route("/recap-entry", methods=["POST"])
def post_recap_entry():
	return "Got it", 200

if __name__ == "__main__":
	app.run(debug=True)
