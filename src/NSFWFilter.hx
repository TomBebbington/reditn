import js.*;
class NSFWFilter {
	public static function init() {
		var ns = Browser.document.body.getElementsByClassName("nsfw-stamp");
		for(n in ns) {
			if(n.nodeName.toLowerCase() != "li")
				continue;
			Reditn.show(cast n.parentNode.parentNode.parentNode, false);
		}
	}
}