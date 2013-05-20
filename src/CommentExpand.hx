import js.html.*;
import js.Browser.*;
class CommentExpand {
	public static function init() {
		var comments:Array<Element> = cast document.body.getElementsByClassName("comment");
		for(c in comments) {
			var ac:Element = cast c.getElementsByClassName("md")[0];
			var links:Array<js.html.AnchorElement> = cast ac.getElementsByTagName("a");
			for(l in links) {
				var btn = Link.createButton(l.href, l.parentElement);
				l.parentNode.insertBefore(btn, l);
				l.parentNode.removeChild(l);
				btn.parentNode.insertBefore(l, btn);
			}
		}
	}
}