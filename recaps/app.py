import json
import sqlite3
from flask import Flask, Response, request, g
from contextlib import closing

# default configuration junk
DATABASE	= "recaps.db"
DEBUG		= True

app = Flask(__name__)
app.config.from_object(__name__)
app.config.from_envvar("RECAP_SETTINGS", silent=True)

def connect_db():
	return sqlite3.connect(app.config["DATABASE"])

def init_db():
	with closing(connect_db()) as db:
		with app.open_resource("schema.sql", mode="r") as f:
			db.cursor().executescript(f.read())
		db.commit()

@app.before_request
def before_request():
	g.db = connect_db()

@app.teardown_request
def teardown_request(exception):
	db = getattr(g, "db", None)
	if db is not None:
		db.close()

@app.route("/recap-entry", methods=["POST"])
def post_recap_entry():
	entry = json.loads(request.data)
	g.db.execute("insert into posted_entries (recapper, category, subcategory, description) values (?, ?, ?, ?)",
			["beyamor", entry["category"], entry["subcategory"], entry["description"]])
	g.db.commit()
	return "Good jorb"

@app.route("/show-entries")
def show_entries():
	cur = g.db.execute("select recapper, category, subcategory, description from posted_entries order by id desc")
	entries = [dict(recapper=row[0], category=row[1], subcategory=row[2], description=row[3]) for row in cur.fetchall()]
	return str(entries)

if __name__ == "__main__":
	app.run(debug=True)
