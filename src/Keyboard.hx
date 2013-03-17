import js.html.*;
import js.*;
class Keyboard {
	static var current(default, null):Null<Int> = null;
	public static var highlighted(get, null):Element;
	static function get_highlighted():AnchorElement {
		return current == null ? null : Reditn.links[current];
	}
	public static function init() {
		Browser.document.onkeydown = function(e) keyDown(untyped e.keyCode);
	}
	static function unhighlight() {
		var h = highlighted;
		if(untyped h) {
			var he:Element = cast h.parentNode.parentNode;
			he.style.border = "";
		}
	}
	static function highlight(dir:Int) {
		unhighlight();
		current = if(current != null && untyped Reditn.links[current + dir])
			current += dir;
		else
			dir = 0;
		if(current == null)
			current = 0;
		var h = highlighted;
		var he:Element = cast h.parentNode.parentNode; // the highlighted entry
		if(he.offsetLeft == 0 && he.offsetTop == 0) {
			highlight(dir);
			return;
		}
		he.style.border = "3px solid grey";
		untyped he.parentNode.scrollIntoView(true);
		he.focus();
	}
	static function show(s:Bool=true) {
		var h = highlighted;
		var entry:Element = cast h.parentNode.parentNode;
		var tg:AnchorElement = untyped entry.getElementsByClassName("toggle")[0];
		untyped tg.toggle(s);
		entry.scrollIntoView(true);
		entry.focus();
	}
	static function keyDown(c:Int) {
		switch(c) {
			case 39: // right
				show(true);
			case 37: // left
				show(false);
			case 38: //up
				highlight(-1);
			case 40: //down
				highlight(1);
		}
	}
}