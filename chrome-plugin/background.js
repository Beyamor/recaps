/*
 * 	Show the tool on blog pages
 */
function checkForValidUrl(tabId, changeInfo, tab) {

	var	matchExpression	= /^(http:\/\/)?www.destructoid.com\/blogs\/.+/,
		urlMatches	= matchExpression.test(tab.url);

	if (urlMatches) {
		
		chrome.pageAction.show(tabId);
	}
};

chrome.tabs.onUpdated.addListener(checkForValidUrl);

/*
 * 	And then listen for somebody trying to recap
 */
chrome.pageAction.onClicked.addListener(function(tab) {

	chrome.tabs.executeScript({
		code: 'document.body.style.backgroundColor="red"'
	});
});
