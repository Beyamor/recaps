$ ->
	$loginWidget = $('#login-widget')
	$loginWidget.remove()
	recapper = (recapper for recapper in recappers when recapper.name is "Beyamor")[0]

	$('#control-panel .greeting').text(recapper.name)
	
	recaps = new caps.Recaps(
		recapper: recapper
	)

	view = new caps.RecapsView(
			model: recaps
		)
	view.render()
	$('body').append view.$el

	saves = new caps.Saves
	savesView = new caps.SavesView(
		model: saves
		attributes:
			recaps: recaps
	)

	updateSaves = (updatedSaves) ->
		for save in updatedSaves
			save.time = new Date(Date.parse(save.time + ' UTC'))
			if save.manual is "true"
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

	save = (manual) ->
		data =
			recapper: recapper.name
			content: JSON.stringify(recaps.toJSON())
			manual: manual

		$.ajax(
			type: "POST"
			url: "/saves"
			data: data
			success: (response) ->
				updateSaves $.parseJSON(response)
			error: (e) ->
				alert "Something broke while saving!\nTell Beyamor you got a #{e.status}"
		)

	setInterval( ->
		save false
	, 300000)

	$('#control-panel .save').click( ->
		save true
	)

	#$('body').append $("<button>").click( ->
	#	console.log JSON.stringify(recaps.toJSON())
	#).css({
	#	position: "fixed"
	#	top: "25px"
	#	right: "0px"
	#}).text("model")

	$('#control-panel .generate').click(->
		save false
		caps.generate(recaps.toJSON())
	)

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
