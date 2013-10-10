$ ->
	$loginWidget = $('#login-widget')
	$loginWidget.remove()
	recapper = (recapper for recapper in recappers when recapper.name is "Beyamor")[0]

	
	saves = new caps.Saves
	savesView = new caps.SavesView(
		model: saves
		recapper: recapper.name
	)
	$('body').append savesView.$el

	recaps = new caps.Recaps(
		recapper: recapper
	)

	view = new caps.RecapsView(
			model: recaps
		)
	view.render()
	$('body').append view.$el

	updateSaves = (updatedSaves) ->
		for save in updatedSaves
			if save.manual is "manua"
				saves.set "manual", save
			else
				saves.set "auto", save

	$.ajax
		type: "GET"
		url: "/saves"
		data:
			recapper: recapper.name
		success: (response) ->
			updateSaves $.parseJSON(response)
		error: (e) ->
			alert "Something broke while loading saves!\nTell Beyamor you got a #{e.status}"

	$('body').append $('<button>').click( ->
		data =
			recapper: recapper.name
			content: JSON.stringify(recaps.toJSON())
			manual: true

		$.ajax(
			type: "POST"
			url: "/saves"
			data: data
			success: (response) ->
				updateSaves $.parseJSON(response)
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
