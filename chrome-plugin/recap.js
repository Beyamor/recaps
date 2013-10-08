function setStyle(el, properties) {
	
	var style = "";
	for (property in properties) {

		style = style + property + ":" + properties[property] + ";";
	}

	el.setAttribute("style", style);
};

function createButton(label, onClick) {

	var button = document.createElement("button");
	button.setAttribute("type", "button");
	button.textContent = label;
	button.onclick = onClick;

	return button;
};


if (!document.getElementById("wits-recap-widget")) {

	var widget = document.createElement("div");
	widget.setAttribute("id", "wits-recap-widget");
	setStyle(widget, {
		position: "fixed",
		right: "0px",
		top: "0px"
	});

	closeButton = createButton("cancel", function() {

		document.body.removeChild(widget);
	});
	widget.appendChild(closeButton);

	document.body.appendChild(widget);
}
