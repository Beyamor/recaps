function checkForValidUrl(tabId, changeInfo, tab) {

	var	matchExpression	= /^(http:\/\/)?www.destructoid.com\/blogs\/.*/,
		urlMatches	= matchExpression.test(tab.url);

	if (urlMatches) {
		
		chrome.pageAction.show(tabId);
	}
};

chrome.tabs.onUpdated.addListener(checkForValidUrl);
