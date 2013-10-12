$ ->
	caps.generate = (data) ->
		data = JSON.stringify(data)
		$form = $('<form method="post" action="/generate" target="_blank">' +
				'<input type="hidden" name="data">' +
			'</form>')
		$('input', $form).val(data)
		$form.submit()
