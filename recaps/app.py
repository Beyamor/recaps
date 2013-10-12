import json
import sqlite3
from flask import Flask, Response, request, g, render_template
from contextlib import closing
from datetime import datetime
from generate import generate

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
	g.db.execute("insert into posted_entries (recapper, category, subcategory, description, url) values (?, ?, ?, ?, ?)",
			[
				entry["recapper"],
				entry["category"],
				entry["subcategory"],
				entry["description"],
				entry["url"]
				])
	g.db.commit()
	return "Good jorb"

@app.route("/recap-entries")
def get_recap_entries():
	cur = g.db.execute("select id, category, subcategory, description, url from posted_entries " +
				"where recapper=? " +
				"order by id desc", [
					request.args['recapper']
				])
	entries = []
	for row in cur.fetchall():
		entries.append({
			"id": row[0],
			"category": row[1],
			"subcategory": row[2],
			"description": row[3],
			"url": row[4]
			})

	return json.dumps(entries)

@app.route("/show-entries")
def show_entries():
	cur = g.db.execute("select recapper, category, subcategory, description, url from posted_entries order by id desc")
	entries = []
	for row in cur.fetchall():
		entries.append({
			"recapper": row[0],
			"category": row[1],
			"subcategory": row[2],
			"description": row[3],
			"url": row[4]
			})

	return str(entries)

@app.route("/")
def get_main():
	cur = g.db.execute("select * from recappers")
	recappers = []
	for row in cur.fetchall():
		recappers.append({
			"name": row[0],
			"header": row[1]
		})
	return render_template("main.html", recappers=recappers)

def recapper_save_data(recapper):
	result = []
	cur = g.db.execute('select id, manual, save_time from recaps where recapper=?', [recapper])
	for row in cur.fetchall():
		result.append({
			'id': row[0],
			'manual': row[1],
			'time': row[2]
			})
	return json.dumps(result)

@app.route('/saves', methods=["GET"])
def get_saves():
	return recapper_save_data(request.args['recapper'])

@app.route("/saves", methods=["POST"])
def save_recaps():
	data = request.form

	# Whatever. Uh. We're going to give 'em one manual and one auto save
	g.db.execute('delete from recaps where recapper=? and manual=?', [
		data['recapper'],
		data['manual']
	])

	g.db.execute('insert into recaps (recapper, content, manual) values (?, ?, ?)', [
		data['recapper'],
		data['content'],
		data['manual']
	])
	g.db.commit()

	return recapper_save_data(data['recapper'])

@app.route('/save', methods=['GET'])
def get_save():
	cur = g.db.execute('select content from recaps where id=?', [
		request.args['id']
	])

	# Yo, remember, that should already be perfectly good JSON
	return cur.fetchone()[0]

@app.route('/generate')
def generate_recaps():
	recaps = generate(json.loads(request.args['data']))
	return render_template('generate.html', recaps=recaps)

@app.route('/recappers')
def recappers():
	cur = g.db.execute("select name from recappers")
	recappers = []
	for row in cur.fetchall():
		recappers.append(row[0])
	
	return json.dumps(recappers)


if __name__ == "__main__":
	app.run(debug=True)
