CATEGORIES = {
		"Topsauce": "http://farm3.static.flickr.com/2777/4068256421_cf820647b2_o.jpg",
		"Wordtoid": "http://farm3.static.flickr.com/2800/4069011354_b7e15681cd_o.jpg",
		"Contestoid": "http://farm3.static.flickr.com/2708/4068256087_e691dde06e_o.jpg",
		"Communitoid": "http://farm3.static.flickr.com/2615/4069011212_6af1534a1c_o.jpg",
		"Gametoid": "http://farm4.static.flickr.com/3509/4068256301_b326be1ecd_o.jpg",
		"Culturoid": "http://farm3.static.flickr.com/2759/4068256383_1c3511b1fe_o.jpg",
		"Otheroid": "http://farm3.static.flickr.com/2662/4069011026_f9da4eb021_o.jpg",
		"Failtoid": "http://farm3.static.flickr.com/2444/4069011256_1b9fa5905e_o.jpg"
}


def image(src):
	return "[img]%s[/img]" % src

def url(link, contents):
	return "[url={0}]{1}[/url]".format(link, contents)

def entry(data):
	return url(data["link"], "[b]%(subcategory)s[/b] - %(description)s" % data)

def category(name, data):
	result = image(CATEGORIES[name]) + '\n'

	if 'image' in data:
		result += '\n' + image(data['image']) + '\n'

	for entryData in data['entries']:
		result += '\n' + entry(entryData) + '\n'

	return result

def generate(data):
	caps = {
			'header': image(data['recapper']['header']),
			'isms': data['isms'],
			'closingisms': data['closingisms'],
			'fpotd': url(data['fpotd'], "FPotD")
	}

	for categoryName in CATEGORIES:
		caps[categoryName] = category(categoryName, data[categoryName])

	return \
"""
%(header)s

%(isms)s

%(Topsauce)s
%(Wordtoid)s
%(Contestoid)s
%(Communitoid)s
%(Gametoid)s
%(Culturoid)s
%(Otheroid)s
%(Failtoid)s
%(closingisms)s

%(fpotd)s""" % caps
