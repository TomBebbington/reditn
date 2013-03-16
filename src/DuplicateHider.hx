import js.*;
import js.html.*;
using Lambda;
class DuplicateHider {
	public static function init() {
		var seen:Array<String> = [];
		for(link in Reditn.links) {
			if(link.nodeName.toLowerCase() != "a")
				continue;
			if(seen.has(link.href))
				Reditn.show(cast link.parentNode, false);
			else
				seen.push(link.href);
		}
	}
}