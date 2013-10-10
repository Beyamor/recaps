$ ->
	CATEGORIES = caps.CATEGORIES

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
			subcategory: "*"
	)
	caps.Entry = Entry

	Entries = Backbone.Collection.extend(
		model: Entry
	)

	Category = Backbone.Model.extend(
		initialize: ->
			@set("entries", new Entries)

		update: (attributes) ->
			for entry in attributes.entries
				@get("entries").add new Entry entry
	)

	Recaps = Backbone.Model.extend(
		initialize: ->
			for category in CATEGORIES
				categoryModel = new Category
				@set category.name, categoryModel

			@set "isms", ""
			@set "closingisms", ""

		update: (attributes) ->
			for category in CATEGORIES
				categoryAttributes = attributes[category.name]
				categoryModel = new Category
				categoryModel.update categoryAttributes
				attributes[category.name] = categoryModel

			@set attributes
	)
	caps.Recaps = Recaps

	Saves = Backbone.Model.extend(
		defaults:
			manual: null
			default: null
	)
	caps.Saves = Saves
