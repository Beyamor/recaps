def image(src):
	return "[img]%s[/img]" % src

def generate(data):
	caps = {
			'header': image(data['recapper']['header']),
			'isms': data['isms']
	}
	return \
"""
%(header)s

%(isms)s
""" % caps
