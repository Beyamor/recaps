$ ->
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

	Entry = Backbone.Model.extend(
		defaults:
			link: ""
			description: ""
	)

	Entries = Backbone.Collection.extend(
		model: Entry
	)

	Category = Backbone.Model.extend(
		constructor: ->
			Backbone.Model.apply this, arguments
			@set("entries", new Entries)
	)

	window.Recaps = Backbone.Model.extend(
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
