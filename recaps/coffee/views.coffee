$ ->
	CATEGORIES = caps.CATEGORIES

	pageTemplate = (name) -> _.template($("##{name}-template").html())

	Backbone.View.prototype.renderOnModelChange = ->
		@model.on "change", @render, this

	CompleteEntryView = Backbone.View.extend(
		events:
			"click": "startEditing"

		initialize: ->
			@views = @attributes.views
			@renderOnModelChange()
			@render()

		show: ->
			@$el.show()

		hide: ->
			@$el.hide()

		startEditing: ->
			@hide()
			@views.editing.show()

		template: pageTemplate('completed-entry')

		render: ->
			@$el.html(@template @model.attributes)
	)

	EditingEntryView = Backbone.View.extend(
		events:
			'click .confirm': 'finishEditing'
			'click .remove': 'remove'
			'change .description input': 'onDescriptionChange'
			'change .link input': 'onLinkChange'
			'change .subcategory': 'onSubcategoryChange'

		initialize: ->
			@category	= @attributes.category
			@views		= @attributes.views
			@entries	= @attributes.entries
			@render()

			_(this).bindAll 'remove', 'onDescriptionChange', 'onLinkChange', 'onSubcategoryChange'

		onDescriptionChange: ->
			@model.set 'description', @description()

		onLinkChange: ->
			@model.set 'link', @link()

		onSubcategoryChange: ->
			@model.set 'subcategory', @subcategory()

		show: ->
			@$el.show()
			$('.description input', @$el).focus()

		hide: ->
			@$el.hide()

		description: ->
			$(".description input", @$el).val()

		link: ->
			$(".link input", @$el).val()

		subcategory: ->
			$(".subcategory", @$el).val()

		finishEditing: ->
			@hide()
			@views.complete.show()

		remove: ->
			noInput = (@description().length is 0 and @link().length is 0)
			if noInput or confirm('Remove entry?')
				@entries.remove @model

		template: pageTemplate('editing-entry')

		render: ->
			attributesWithSubcategories = _.extend(
				subcategories: @category.subcategories,
				@model.attributes
			)
			@$el.html(@template attributesWithSubcategories)
	)

	EntryView = Backbone.View.extend(
		initialize: ->
			@views = {}

			@views.complete = new CompleteEntryView(
				model: @model
				attributes:
					views: @views
			)
			@views.complete.render()

			@views.editing = new EditingEntryView(
				model: @model
				attributes:
					views: @views
					category: @attributes.category
					entries: @attributes.entries
			)
			@views.editing.render()

			@$el.append(@views.complete.$el).append(@views.editing.$el)

			@views.complete.show()
			@views.editing.hide()

		startEditing: ->
			@views.complete.startEditing()

		render: ->
			@views.editing.render()
			@views.complete.render()
			return this
	)

	CategoryImageView = Backbone.View.extend(
		className: 'category-image'

		events:
			"focusout .editing": "finishEditing"
			"keyup .editing": "onEditingKeyUp"
			"click .edit": "startEditing"
			"click .complete": "startEditing"

		initialize: ->
			@edit = $('<img>')
				.addClass('edit')
				.attr('src', '/static/img/picture32.png')
				.attr('title', 'add an image')
				.hide()

			@editing = $('<input type="text">')
				.addClass('editing')
				.hide()

			@complete = $('<img>')
				.addClass('complete')
				.attr('title', 'change image')
				.hide()

			@$el.append(@edit).append(@editing).append(@complete)

			if @model.get('image')
				@complete.attr("src", @model.get('image')).show()
			else
				@edit.show()

		startEditing: ->
			@edit.hide()
			@complete.hide()
			@editing.val(@model.image).show().focus().select()

		finishEditing: ->
			image = @editing.val()
			@model.set "image", image

			@editing.hide()
			if image and image.length isnt 0
				@complete.attr("src", image)
				@complete.show()
			else
				@edit.show()

		onEditingKeyUp: (e) ->
			@finishEditing() if e.which is 13

		render: ->
			return this
	)

	AddEntryView = Backbone.View.extend(
		className: 'add-entry'

		events:
			"click a": "onClick"

		onClick: ->
			entry = new caps.Entry
			@model.get("entries").add entry

		render: ->
			@$el
				.empty()
				.append($('<a>+</a>').attr('title', 'add a new entry'))
			return this
	)

	CategoryView = Backbone.View.extend(
		className: "category"

		initialize: ->
			@category = @attributes.category

			@entryViews = []
			@model.get("entries").each (entry) => @addEntryView(entry)

			@imageView = new CategoryImageView(
				model: @model
			)

			@addView = new AddEntryView(
				model: @model
			)

			_(this).bindAll 'addEntry', 'removeEntry'
			@model.get('entries').bind 'add', @addEntry
			@model.get('entries').bind 'remove', @removeEntry

		addEntryView: (entry) ->
			entryView = new EntryView(
				model: entry
				attributes:
					category: @category
					entries: @model.get('entries')
			)
			@entryViews.push entryView
			return entryView

		addEntry: (entry) ->
			entryView = @addEntryView(entry)
			@addView.$el.before entryView.$el

			# gotta call this after adding the view
			# so the field can get focus
			entryView.startEditing()

		removeEntry: (entry) ->
			viewToRemove = _(@entryViews).select((v) -> v.model == entry)[0]
			@entryViews = _(@entryViews).without viewToRemove

			viewToRemove.$el.remove()

		render: ->
			@$el.empty()

			$header = $("<img>")
			$header.attr("src", @category.header)
			@$el.append $header

			@imageView.render()
			@$el.append(@imageView.$el)

			for entryView in @entryViews
				entryView.render()
				@$el.append entryView.$el

			@addView.render()
			@$el.append(@addView.$el)

			return this

	)

	RecapsView = Backbone.View.extend(
		el: $('#recaps')

		initialize: ->
			@renderOnModelChange()

		render: ->
			$el = @$el
			$el.empty()
			recaps = @model

			$el.empty()

			$recapperHeader = $('<img>').attr('src', recaps.get('recapper').header)
			$el.append $recapperHeader

			$el.append $('<textarea>').addClass('isms').change(->
				recaps.set 'isms', $(this).val()
			).val(recaps.get 'isms')

			for category in CATEGORIES
				categoryView = new CategoryView(
					model: recaps.get category.name
					attributes:
						category: category
				)
				$el.append categoryView.render().$el

			$el.append $('<textarea>').addClass('closingisms').change(->
				recaps.set 'closingisms', $(this).val()
			).val(recaps.get 'closingisms')

			$fpotd = $('<div>')
				.addClass('fpotd')
				.append('Final post of the day: ')
				.append($('<input type="text">').change(->
					recaps.set 'fpotd', $(this).val()
				).val(recaps.get 'fpotd'))
			$el.append $fpotd


			return this
	)
	
	window.caps.RecapsView = RecapsView

	SavesView = Backbone.View.extend(
		events:
			'click .manual': 'onManualClick'
			'click .auto': 'onAutoClick'

		el: $('#control-panel .saves')

		initialize: ->
			@recaps = @attributes.recaps
			@renderOnModelChange()

		loadSave: (which) ->
			$.ajax
				url: '/save'
				data:
					id: which
				success: (response) =>
					@recaps.update $.parseJSON response
				error: (e) =>
					alert "Something broke while loading a save!\nTell Beyamor you got a #{e.status}"

		onManualClick: ->
			if confirm("Load manual save from #{@model.get('manual').time}?")
				@loadSave(@model.get('manual').id)

		onAutoClick: ->
			if confirm("Load autosave from #{@model.get('auto').time}?")
				@loadSave(@model.get('auto').id)

		template: pageTemplate('saves')

		render: ->
			@$el.html(@template @model.attributes)
	)
	caps.SavesView = SavesView
