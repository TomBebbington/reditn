import js.*;
import js.html.*;
using Lambda;
class DuplicateHider {
	public static function init() {
		var links:Array<AnchorElement> = cast Browser.document.body.getElementsByClassName("title");
		var seen:Array<String> = [];
		for(link in links) {
			if(link.nodeName.toLowerCase() != "a")
				continue;
			if(seen.has(link.href))
				Reditn.hide(cast link.parentNode);
			seen.push(link.href);
		}
	}
}