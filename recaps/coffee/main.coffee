$ ->
	$loginWidget = $('#login-widget')
	$loginWidget.remove()
	recapper = null
	for id of recappers
		recapper = recappers[id] if recappers[id].name is "Beyamor"

	recaps = new caps.Recaps(
		recapper: recapper
	)

	view = new caps.RecapsView(
			model: recaps
		)
	view.render()

	$('body').append $('<button>').click( ->
		data =
			recapper: recapper
			recaps: recaps.toJSON()
			type: 'manual'

		$.ajax(
			type: "POST"
			url: "/save"
			data: data
			success: ->
				console.log 'did eet'
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
