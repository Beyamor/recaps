$ ->
	Recapper = Backbone.Model.extend()

	Entry = Backbone.Model.extend()

	Entries = Backbone.Collection.extend(
		model: Entry
	)

	Category = Backbone.Model.extend(
		constructor: ->
			Backbone.Model.apply this, arguments
			@set("entries", new Entries)
	)

	Recaps = Backbone.Model.extend(
		constructor: ->
			Backbone.Model.apply this, arguments
			topsauce = new Category header: 'http://farm3.static.flickr.com/2777/4068256421_cf820647b2_o.jpg'
			topsauce.get("entries").add new Entry(
				subcategory: "*"
				description: "Some topsauce"
			)
			@set("topsauce", topsauce)
	)

	EntryView = Backbone.View.extend(
		template: _.template(
			'<div class="entry">' +
				'<strong>' +
					'<%= subcategory %> - ' +
				'</strong>' +
				'<%= description %>' +
			'</div>'
		)

		render: ->
			@$el.html(@template(@model.attributes))
			return this
	)

	CategoryView = Backbone.View.extend(
		className: "category"

		render: ->
			@$el.empty()

			$img = $("img")
			$img.attr("src", @header)
			@$el.append $img

			$el = @$el
			@model.get("entries").each (entry) ->
				entryView = new EntryView(
					model: entry
				)

				$el.append(entryView.render().$el)

			return this

	)

	RecapsView = Backbone.View.extend(
		el: $('#recaps')

		render: ->
			@$el.empty()

			topsauceView = new CategoryView(
				header: "http://farm3.static.flickr.com/2777/4068256421_cf820647b2_o.jpg",
				model: @model.get("topsauce")
			)
			@$el.append topsauceView.render().$el

			return this
	)

	$loginWidget = $('#login-widget')
	$loginWidget.remove()
	recapper = null
	for id of recappers
		recapper = recappers[id] if recappers[id].name is "Beyamor"
	recaps = new Recaps
	view = new RecapsView(
			model: recaps
		)
	view.render()

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
