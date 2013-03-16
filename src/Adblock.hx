import js.Browser;
import js.html.*;
class Adblock {
	public static function init() {
		hideAll(Browser.document.body.getElementsByClassName("promoted"));
		hideAll(Browser.document.body.getElementsByClassName("goldvertisement"));
		var help = Browser.document.getElementById("spotlight-help");
		if(help != null) {
			var link = help.parentNode.parentNode;
			Reditn.show(cast link, false);
		}
		var sidebarAd = Browser.document.getElementById("ad-frame");
		if(sidebarAd != null)
			Reditn.show(sidebarAd, false);
	}
	static function hideAll(a:NodeList) {
		for(i in 0...a.length)
			Reditn.show(cast a[i], false);
	}
}