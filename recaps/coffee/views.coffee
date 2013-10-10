$ ->
	CompleteEntryView = Backbone.View.extend(
		events:
			"click": "startEditing"

		initialize: ->
			@views = @attributes.views
			@model.on "change", @render, this
			@render()

		startEditing: ->
			@views.editing.$el.show()
			@$el.hide()

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
			"focusout": "finishEditing"
			"click .confirm": "finishEditing"

		initialize: ->
			@views = @attributes.views
			@model.on "change", @render, this
			@render()

		finishEditing: ->
			@$el.hide()
			@views.complete.$el.show()

			@model.set "description", $(".description input", @$el).val()
			@model.set "link", $(".link input", @$el).val()

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

			@$el.append(@views.complete.$el).append(@views.editing.$el)

		render: ->
			@views.editing.render()
			@views.complete.render()
			return this
	)

	CategoryView = Backbone.View.extend(
		className: "category"

		renderImage: ->
			$imageContainer = $('<div>')
			@$el.append $imageContainer

			categoryImage = @model.get "image"

			$image = $("<img>").attr("src", categoryImage).hide()
			$addImage = $("<img>").attr("src", '/static/img/picture32.png').hide()
			$imageInput = $('<input type="text">').val(categoryImage).hide()
			$imageContainer.append($image).append($addImage).append($imageInput)

			updateImage = =>
				$imageInput.hide()

				image = $imageInput.val()
				@model.set "image", image

				if image and image.length isnt 0
					$image.attr("src", image).show()
					$addImage.hide()
				else
					$image.hide()
					$addImage.show()

			$imageInput.focusout updateImage
			$imageInput.keyup((e) ->
				updateImage() if e.which is 13
			)

			$addImage.click =>
				$addImage.hide()
				$imageInput.show().focus()

			$image.click =>
				$image.hide()
				$imageInput.show().focus().select()

			if categoryImage
				$image.show()
			else
				$addImage.show()

		render: ->
			@$el.empty()

			$header = $("<img>")
			$header.attr("src", @attributes.header)
			@$el.append $header

			@renderImage()
			
			$el = @$el
			@model.get("entries").each (entry) ->
				entryView = new EntryView(
					model: entry
				)

				$el.append(entryView.render().$el)

			return this

	)

	window.RecapsView = Backbone.View.extend(
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
