$ ->
	Recapper = Backbone.Model.extend()

	$loginWidget = $("#login-widget")
	$("button", $loginWidget).click ->
		$loginWidget.remove()

		id = $("select", $loginWidget).val()
		recapper = new Recapper recappers[id]
		$("#header").attr("src", recapper.get("header"))
