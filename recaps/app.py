from flask import Flask, Response, request
app = Flask(__name__)

@app.route("/recap-entry", methods=["POST"])
def post_recap_entry():
	with open("/tmp/recap-entry", "w") as recap_file:
		recap_file.write(request.data)
	return "Got it"

if __name__ == "__main__":
	app.run(debug=True)
