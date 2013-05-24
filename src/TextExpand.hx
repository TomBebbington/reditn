import js.html.*;
import js.Browser.*;
class TextExpand {
	public static function init() {
		var posts = document.body.getElementsByClassName("usertext-body");
		for(c in posts) {
			var ac:Element = try cast cast(c, Element).getElementsByClassName("md")[0] catch(e:Dynamic) null;
			if(ac == null)
				continue;
			var links:Array<js.html.AnchorElement> = cast ac.getElementsByTagName("a");
			for(l in links)
				Link.createButton(l.href, l.parentElement, cast l.nextSibling);
		}
	}
}