launch = (recapper) ->
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
		if manual
			$('#control-panel .manual .save-type').text('saving...')
		else
			$('#control-panel .auto .save-type').text('saving...')

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
	, 5 * 60 * 1000)

	getPostedEntries = ->
		$.ajax(
			type: "GET"
			url: "/recap-entries"
			data:
				recapper: recapper.name
			success: (entries) ->
				recaps.addEntries JSON.parse entries
			error: (e) ->
				alert "Something broke while retrieving entries!\nTell Beyamor you got a #{e.status}"
		)

	setInterval(getPostedEntries, 2 * 1000)
	getPostedEntries()

	$('#control-panel .save').click( ->
		save true
	)

	$('#control-panel .generate').click(->
		save false
		caps.generate(recaps.toJSON())
	)

$ ->
	$loginWidget = $('#login-widget')

	$('button', $loginWidget).click ->
		$loginWidget.remove()

		name = $('select', $loginWidget).val()

		for recapper in recappers when recapper.name is name
			launch recapper
