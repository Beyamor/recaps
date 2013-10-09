$ ->
	CATEGORIES = [{
		name: "Topsauce"
		header: "http://farm3.static.flickr.com/2777/4068256421_cf820647b2_o.jpg"
	}]

	# shout out to http://www.shesek.info/web-development/recursive-backbone-models-tojson
	Backbone.Model.prototype.toJSON = ->
		if (@_isSerializing)
			return this.id || this.cid
		@_isSerializing = true
		json = _.clone @attributes
		_.each(json, (value, name) ->
			if _.isFunction(value.toJSON)
				(json[name] = value.toJSON())
		)
		@_isSerializing = false
		return json

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
			
			for category in CATEGORIES
				categoryModel = new Category
				@set category.name, categoryModel

			@get("Topsauce").get("entries").add new Entry(
				subcategory: "*"
				description: "Some topsauce"
			)

			@set "isms", ""
			@set "closingisms", ""
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

			$img = $("<img>")
			$img.attr("src", @attributes.header)
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
			$el = @$el
			recaps = @model

			$el.empty()

			$recapperHeader = $("<img>").attr("src", recaps.get("recapper").header)
			$el.append $recapperHeader

			$el.append $("<textarea>").change( ->
				recaps.set "isms", $(this).val()
			)

			for category in CATEGORIES
				categoryView = new CategoryView(
					model: recaps.get category.name
					attributes:
						header: category.header
				)
				$el.append categoryView.render().$el

			$el.append $("<textarea>").change( ->
				recaps.set "closingisms", $(this).val()
			)


			return this
	)

	$loginWidget = $('#login-widget')
	$loginWidget.remove()
	recapper = null
	for id of recappers
		recapper = recappers[id] if recappers[id].name is "Beyamor"

	recaps = new Recaps(
		recapper: recapper
	)

	view = new RecapsView(
			model: recaps
		)
	view.render()

	$dumpModel = $("<button>").click( ->
		console.log JSON.stringify(recaps.toJSON())
	).css({
		position: "fixed"
		top: "0px"
		right: "0px"
	}).text("model")
	$("body").append $dumpModel

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
