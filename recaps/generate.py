def image(src):
	return "[img]%s[/img]" % src

def generate(data):
	caps = {}
	caps['header'] = image(data['recapper']['header'])
	return \
"""
%(header)s
""" % caps
