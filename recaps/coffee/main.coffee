$ ->
	Recapper = Backbone.Model.extend()

	Entry = Backbone.Model.extend()

	Entries = Backbone.Collection.extend(
		model: Entry
	)

	Category = Backbone.Model.extend(
		constructor: ->
			@entries = new Entries
			Backbone.Model.apply this, arguments
	)

	Recaps = Backbone.Collection.extend(
		constructor: ->
			@topsauce = new Category header: "http://farm3.static.flickr.com/2777/4068256421_cf820647b2_o.jpg"
	)

	RecapsView = Backbone.View.extend(
		el: $("#recaps")

		template: _.template(
			"doing eet"
		)

		render: ->
			@$el.html(@template @model.attributes)
			return this
	)

	$loginWidget = $("#login-widget")
	$("button", $loginWidget).click ->
		$loginWidget.remove()

		id = $("select", $loginWidget).val()
		recapper = new Recapper recappers[id]
		$("#header").attr("src", recapper.get("header"))

		recaps = new Recaps
		view = new RecapsView(
			model: recaps
		)

		view.render()
