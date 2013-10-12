/*
 * 	Show the tool on blog pages
 */
function checkForValidUrl(tabId, changeInfo, tab) {

	var	matchExpression	= /^(http:\/\/)?www.destructoid.com\/blogs\/.+/,
		urlMatches	= matchExpression.test(tab.url);

	if (urlMatches || true) {
		
		chrome.pageAction.show(tabId);
	}
};

chrome.tabs.onUpdated.addListener(checkForValidUrl);

/*
 * 	Check for somebody trying to recap
 */
function checkForClick(recappers) {

	// If they click the recap button,
	chrome.pageAction.onClicked.addListener(function(tab) {

		// try to get the default recapper,
		chrome.cookies.get({
			url: "http://recaps.wordsinthesky.com",
			name: "wits-recapper"
		},
		function(recapper) {

			// and supply the content information (recappers, default recapper)
			chrome.tabs.executeScript(tab.id, {
				code: 'var RECAPPERS=' + recappers + ',' + 'defaultRecapper="' + recapper.value + '";'
			}, function() {

				// to our lovingly crafted recap script
				chrome.tabs.executeScript(tab.id, {
					file: "recap.js"
				});
			});
		});
	});
}

/*
* Make a request to get the list of recappers
*/
request = new XMLHttpRequest();
request.onreadystatechange = function() {

	if (request.readyState == 4) {
		if (request.status == 200)
			checkForClick(request.responseText);
		else
			alert("Something broke fetching the recapper list!\nGo tell Beyamor you got a " + request.status);
	}
}
request.open("GET", "http://localhost:5000/recappers", true);
request.send();

/**
* And listen for peeps trying to set the default recapper
*/
chrome.runtime.onMessage.addListener(function(request) {

	if (request.message == 'set-wits-recapper') {
		chrome.cookies.set({
			url: "http://recaps.wordsinthesky.com",
			name: "wits-recapper",
			value: request.recapper
		});
	}
});
