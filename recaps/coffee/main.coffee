$ ->
	$loginWidget = $('#login-widget')
	$loginWidget.remove()
	recapper = (recapper for recapper in recappers when recapper.name is "Beyamor")[0]

	recaps = new caps.Recaps(
		recapper: recapper
	)

	view = new caps.RecapsView(
			model: recaps
		)
	view.render()

	$('body').append $('<button>').click( ->
		data =
			recapper: recapper.name
			content: JSON.stringify(recaps.toJSON())
			manual: true

		$.ajax(
			type: "POST"
			url: "/save"
			data: data
			success: (response) ->
				console.log response
			error: (e) ->
				alert "Something broke while saving!\nTell Beyamor you got a #{e.status}"
		)
	).css({
		position: 'fixed'
		top: '0px'
		right: '0px'
	}).text('save')

	$('body').append $("<button>").click( ->
		console.log JSON.stringify(recaps.toJSON())
	).css({
		position: "fixed"
		top: "25px"
		right: "0px"
	}).text("model")

	#$('button', $loginWidget).click ->
	#	$loginWidget.remove()

	#	id = $('select', $loginWidget).val()
	#	recapper = new Recapper recappers[id]
	#	$('#header').attr('src', recapper.get('header'))

	#	recaps = new Recaps
	#	view = new RecapsView(
	#		model: recaps
	#	)

	#	view.render()
