import js.html.*;
import js.*;
class Keyboard {
	static var current(default, null):Null<Int> = null;
	public static var highlighted(get, null):Element;
	static function get_highlighted():Element {
		trace(current+" "+Reditn.links.length);
		return current == null ? null : untyped Reditn.links[current];
	}
	public static function init() {
		Browser.document.onkeydown = function(e) keyDown(untyped e.keyCode);
	}
	static inline function unhighlight() {
		if(current != null)
			untyped highlighted.style = "";
	}
	static function highlight(dir:Int) {
		unhighlight();
		current = if(current == null)
			current = 0;
		else if(untyped Reditn.links[current + dir])
			current += dir;
		highlighted.style.border = "3px solid grey";
	}
	static function keyDown(c:Int) {
		switch(c) {
			case 38: //up
				highlight(1);
			case 40: //down
				highlight(-1);
		}
	}
}