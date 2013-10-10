$ ->
	CATEGORIES = caps.CATEGORIES

	Backbone.View.prototype.renderOnModelChange = ->
		@model.on "change", @render, this

	CompleteEntryView = Backbone.View.extend(
		events:
			"click": "startEditing"

		initialize: ->
			@views = @attributes.views
			@renderOnModelChange()
			@render()

		startEditing: ->
			@$el.hide()
			@views.editing.$el.show()

		template: _.template(
			'<div class="entry">' +
				'<strong>' +
					'<%= subcategory %> - ' +
				'</strong>' +
				'<%= description %>' +
			'</div>'
		)

		render: ->
			@$el.html(@template @model.attributes)
	)

	EditingEntryView = Backbone.View.extend(
		events:
			"click .confirm": "finishEditing"

		initialize: ->
			@views = @attributes.views
			@renderOnModelChange()
			@render()

		finishEditing: ->
			@model.set
				description: $(".description input", @$el).val()
				link: $(".link input", @$el).val()

			@$el.hide()
			@views.complete.$el.show()

		template: _.template(
			'<div class="editing-entry">' +
				'<div class="description">' +
					'Description: <input type="text" value="<%= description %>"/>' +
				'</div>' +
				'<div class="link">' +
					'Link: <input type="text" value="<%= link %>"/>' +
				'</div>' +
				'<button class="confirm">OK</button>' +
			'</div>'
		)

		render: ->
			@$el.html(@template @model.attributes)
	)

	EntryView = Backbone.View.extend(
		initialize: ->
			@views = {}

			@views.complete = new CompleteEntryView(
				model: @model
				attributes:
					views: @views
			)

			@views.editing = new EditingEntryView(
				model: @model
				attributes:
					views: @views
			)

			@views.complete.$el.hide()
			@views.editing.render()

			@$el.append(@views.complete.$el).append(@views.editing.$el)

		render: ->
			@views.editing.render()
			@views.complete.render()
			return this
	)

	CategoryImageView = Backbone.View.extend(
		events:
			"focusout .editing": "finishEditing"
			"keyup .editing": "onEditingKeyUp"
			"click .edit": "startEditing"
			"click .complete": "startEditing"

		initialize: ->
			@edit = $('<img>').addClass('edit').attr('src', '/static/img/picture32.png').hide()
			@editing = $('<input type="text">').addClass('editing').hide()
			@complete = $('<img>').addClass('complete').hide()

			@$el.append(@edit).append(@editing).append(@complete)

			if @model.image
				@complete.attr("src", @model.image).show()
			else
				@edit.show()

		startEditing: ->
			@edit.hide()
			@complete.hide()
			@editing.val(@model.image).show().focus().select()

		finishEditing: ->
			image = @editing.val()
			@model.image = image

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
		events:
			"click": "onClick"

		onClick: ->
			entry = new caps.Entry
			@model.get("entries").add entry

			view = new EntryView(
				model: entry
			)
			@$el.before(view.render().$el)

		render: ->
			@$el.html("+")
			return this
	)

	CategoryView = Backbone.View.extend(
		className: "category"

		initialize: ->
			@imageView = new CategoryImageView(
				model: @model
			)

			@addView = new AddEntryView(
				model: @model
			)

		render: ->
			@$el.empty()

			$header = $("<img>")
			$header.attr("src", @attributes.header)
			@$el.append $header

			@imageView.render()
			@$el.append(@imageView.$el)

			$el = @$el
			@model.get("entries").each (entry) ->
				entryView = new EntryView(
					model: entry
				)

				$el.append(entryView.render().$el)

			@addView.render()
			@$el.append(@addView.$el)

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
						category: category.name
						header: category.header
				)
				$el.append categoryView.render().$el

			$el.append $("<textarea>").change( ->
				recaps.set "closingisms", $(this).val()
			)


			return this
	)
	
	window.caps.RecapsView = RecapsView
