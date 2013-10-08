var CATEGORIES = [
	"Topsaucetoid",
	"Wordtoid",
	"Contestoid",
	"Communitoid",
	"Gametoid",
	"Culturoid",
	"Otheroid",
	"Failtoid"
];

var SUBCATEGORIES = {
	Wordtoid: [
		["A", "Articles"],
		["S", "Series"],
		["M", "Monthly Musings"],
		["P", "Podcasts"]
	],

	Contestoid: [
		["C", "Community Contents"],
		["W", "Winnders/Updates"],
		["E", "Entries"]
	],

	Communitoid: [
		["E", "Events"],
		["F", "Fight Nights"],
		["D", "Destructoid in the Wild"],
		["S", "Stories"],
		["C", "Contemplations"],
		["I", "Introductions"],
		["B", "Birthdays"],
		["R", "RIP"],
		["H", "Houses, cribs, setups"]
	],

	Gametoid: [
		["N", "News"],
		["V", "Videos"],
		["R", "Reviews"],
		["P", "Previews"],
		["T", "Thoughts"],
		["D", "Development"],
		["$", "Deals"]
	],

	Culturoid: [
		["A", "Art"],
		["M", "Music"],
		["F", "Film/TV"],
		["L", "Literature"],
		["S", "Swag"]
	],

	Otheroid: [
		["L", "LOLs"],
		["R", "Random"],
		["V", "Videos"],
		["C", "Could Be Better"],
		["?", "Defies Description"]
	],

	Failtoid: [
		["S", "You Are Slow"],
		["F", "Maybe Fail?"]
	]
};

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

function createSelector(options, onChange) {

	var selector = document.createElement("select");
	for (var optionIndex = 0; optionIndex < options.length; ++optionIndex) {

		var	option		= options[optionIndex],
			optionEl	= document.createElement("option"),
			label, value;

		if (option instanceof Array) {

			label	= option[1];
			value	= option[0];
		}

		else {

			value = label = option;
		}

		optionEl.textContent = label;
		optionEl.setAttribute("value", value);

		selector.appendChild(optionEl);
	}

	if (onChange) {

		selector.onchange = function() {

			var value = selector.options[selector.selectedIndex].text;
			onChange(value);
		};
	}

	return selector;
}

function createTextfield() {

	var text = document.createElement("input");
	text.setAttribute("type", "text");

	return text;
};


if (!document.getElementById("wits-recap-widget")) {

	var widget = document.createElement("div");
	widget.setAttribute("id", "wits-recap-widget");
	setStyle(widget, {
		position: "fixed",
		right: "0px",
		top: "0px"
	});

	var categoriesContainer = document.createElement("div");
	widget.appendChild(categoriesContainer);

	var subcategories = null;

	var categories = createSelector(CATEGORIES, function(value) {

		if (subcategories)
			categoriesContainer.removeChild(subcategories);

		if (value == "Topsaucetoid") {

			subcategories = null;
		}

		else {

			subcategories = createSelector(SUBCATEGORIES[value]);
			setStyle(subcategories, {display: "block"});
			categoriesContainer.appendChild(subcategories);
		}
	});
	setStyle(categories, {display: "block"});
	categoriesContainer.appendChild(categories);

	var description = createTextfield();
	setStyle(description, {display: "block"});
	widget.appendChild(description);

	var closeButton = createButton("cancel", function() {

		document.body.removeChild(widget);
	});
	widget.appendChild(closeButton);

	document.body.appendChild(widget);
}
