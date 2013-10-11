$ ->
	$loginWidget = $('#login-widget')
	$loginWidget.remove()
	recapper = (recapper for recapper in recappers when recapper.name is "Beyamor")[0]

	greetings = ["Hi", "Hello", "Hey", "What's up", "Yo"]
	greeting = greetings[Math.floor(Math.random() * greetings.length)]
	$('#control-panel .greeting').text(greeting + ', ' + recapper.name)
	
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

	$('body').append $('<button>').click( ->
		save true
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

	$('body').append $('<button>').click(->
		save false
		caps.generate(recaps.toJSON())
	).css(
		position: 'fixed'
		top: '50px'
		right: '0px'
	).text('generate')

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
