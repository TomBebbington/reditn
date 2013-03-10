import js.Browser;
import js.html.*;
class Adblock {
	public static function init() {
		removeAll(Browser.document.body.getElementsByClassName("promoted"));
		removeAll(Browser.document.body.getElementsByClassName("goldvertisement"));
		removeTop();
		var sidebarAd = Browser.document.getElementById("ad-frame");
		if(sidebarAd != null)
			remove(sidebarAd);
	}
	static inline function remove(e:Node) {
		if(e != null && e.parentNode != null)
			e.parentNode.removeChild(e);
	}
	static inline function removeAll(a:NodeList) {
		for(i in 0...a.length)
			remove(a[i]);
	}
	static function removeTop() {
		var help = Browser.document.getElementById("spotlight-help");
		if(help != null) {
			var link = help.parentNode.parentNode;
			remove(link);
		}
	}
}