$ ->
	caps.generate = (data) ->
		window.open(
			'/generate?data=' + JSON.stringify(data),
			'Recaps'
		)
