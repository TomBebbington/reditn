class Style {
	public static function init() {
		var s = ext.Browser.document.createLinkElement();
		s.type = "text/css";
		s.rel = "stylesheet";
		ext.Resource.get("data/reditn-default.css", function(url) s.href = url);
		ext.Browser.document.head.appendChild(s);
	}
}