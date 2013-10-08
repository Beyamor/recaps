var CATEGORIES = [
	"topsaucetoid",
	"wordtoid",
	"contestoid",
	"communitoid",
	"gametoid",
	"culturoid",
	"otheroid",
	"failtoid"
];

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

function createSelector(options) {

	var selector = document.createElement("select");
	for (var optionIndex = 0; optionIndex < options.length; ++optionIndex) {

		var option = document.createElement("option");
		option.textContent = options[optionIndex];
		option.setAttribute("value", options[optionIndex]);

		selector.appendChild(option);
	}

	return selector;
}


if (!document.getElementById("wits-recap-widget")) {

	var widget = document.createElement("div");
	widget.setAttribute("id", "wits-recap-widget");
	setStyle(widget, {
		position: "fixed",
		right: "0px",
		top: "0px"
	});

	var categories = createSelector(CATEGORIES);
	widget.appendChild(categories);

	var closeButton = createButton("cancel", function() {

		document.body.removeChild(widget);
	});
	widget.appendChild(closeButton);

	document.body.appendChild(widget);
}
