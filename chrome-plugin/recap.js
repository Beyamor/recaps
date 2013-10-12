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

function setAsBlock(el) {

	setStyle(el, {display: "block"});
};

function createButton(label, onClick) {

	var button = document.createElement("button");
	button.setAttribute("type", "button");
	button.textContent = label;
	button.onclick = onClick;

	return button;
};

function createSelector(options, onChange, defaultValue) {

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
		if (value == defaultValue) {
			optionEl.setAttribute('selected', 'selected');
		}

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

function createTextfield(onChange) {

	var text = document.createElement("input");
	text.type = "text";

	if (onChange) {

		var oldValue = text.value;

		setInterval(function() {

			if (oldValue != text.value) {

				oldValue = text.value;
				onChange(text.value);
			}
		}, 100);
	}

	return text;
};

function postJSON(args) {

	var	request	= new XMLHttpRequest(),
		data	= JSON.stringify(args.data);

	request.onreadystatechange = function() {

		if (request.readyState == 4) {

			if (request.status == 200 && args.onSuccess)
				args.onSuccess(request.responseText);

			if (request.status != 200 && args.onFailure)
				args.onFailure(request.status);
		}
	};

	request.open("POST", args.url, true);
	request.send(data);
};


if (!document.getElementById("wits-recap-widget")) {

	var widget = document.createElement("div");
	widget.setAttribute("id", "wits-recap-widget");
	setStyle(widget, {
		position: "fixed",
		right: "0px",
		top: "0px"
	});

	var close = function() { document.body.removeChild(widget); }

	var recappers = createSelector(RECAPPERS, null, defaultRecapper);
	widget.appendChild(recappers);

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
			setAsBlock(subcategories);
			categoriesContainer.appendChild(subcategories);
		}
	});
	setAsBlock(categories);
	categoriesContainer.appendChild(categories);

	// forward declaration so we can close over it
	var confirmButton;

	var description = createTextfield(function(value) {

		confirmButton.disabled = (value.length == 0);
	});
	setAsBlock(description);
	widget.appendChild(description);

	submit = function() {

		var result = {
			recapper: recappers.value,
			description: description.value,
			category: categories.value,
			subcategory: (subcategories? subcategories.value : "*"),
			link: window.location.href
		};

		postJSON({
			//url: "http://localhost:5000/recap-entry",
			url: "http://recaps.wordsinthesky.com/recap-entry",
			data: result,
			onSuccess: function() {
				close();
			},
			onFailure: function(errorCode) {
				alert("Something broke send the entry!\nGo tell Beyamor you got a " + errorCode);
			}
		});

		chrome.runtime.sendMessage({message: 'set-wits-recapper', recapper: recappers.value});
	}

	confirmButton = createButton("Recap", submit);
	confirmButton.disabled = true;
	setAsBlock(confirmButton);
	widget.appendChild(confirmButton);

	var closeButton = createButton("Close", function() {

		if (description.value.length == 0 || confirm("Stop recapping?\n(press cancel to keep recapping)"))
			close();
	});
	setAsBlock(closeButton);
	widget.appendChild(closeButton);

	widget.onkeyup = function(e) {

		if (e.keyCode == 13 && description.length != 0) {

			submit();
		}
	}

	document.body.appendChild(widget);
}
