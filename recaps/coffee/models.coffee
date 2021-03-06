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
			subcategory: ""
	)
	caps.Entry = Entry

	Entries = Backbone.Collection.extend(
		model: Entry
	)

	Category = Backbone.Model.extend(
		initialize: ->
			@set("entries", new Entries)

		update: (attributes) ->
			@set("image", attributes.image) if attributes.image
			for entry in attributes.entries
				@get("entries").add new Entry entry
	)

	Recaps = Backbone.Model.extend(
		defaults:
			isms: ""
			closingisms: ""
			fpotd: ""
			receivedEntries: []

		initialize: ->
			for category in CATEGORIES
				categoryModel = new Category category
				@set category.name, categoryModel

		update: (attributes) ->
			for category in CATEGORIES
				categoryAttributes = attributes[category.name]
				categoryModel = new Category category
				categoryModel.update categoryAttributes
				attributes[category.name] = categoryModel

			@set attributes

		addEntries: (entries) ->
			for entry in entries when @get('receivedEntries').indexOf(entry.id) == -1
				@get('receivedEntries').push entry.id
				@get(entry.category).get('entries').add new Entry entry
	)
	caps.Recaps = Recaps

	Saves = Backbone.Model.extend(
		defaults:
			manual: null
			auto: null
	)
	caps.Saves = Saves
