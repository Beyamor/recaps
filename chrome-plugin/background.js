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
 * 	Listen for somebody trying to recap
 */
function checkForClick(recappers) {
	chrome.pageAction.onClicked.addListener(function(tab) {

		chrome.tabs.executeScript(tab.id, {
			code: 'var RECAPPERS=' + recappers + ';'
		}, function() {
			chrome.tabs.executeScript(tab.id, {
				file: "recap.js"
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
