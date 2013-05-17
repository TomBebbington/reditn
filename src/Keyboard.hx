import js.html.*;
import js.*;
import data.*;
class Keyboard {
	static var current(default, null):Int = null;
	public static var highlighted(get, null):Element;
	static inline function get_highlighted():Element {
		return Reditn.links[current] != null ? Reditn.getLinkContainer(Reditn.links[current]) : null;
	}
	public static function init() {
		Browser.document.onkeydown = function(e) keyDown(untyped e.keyCode);
	}
	static function unhighlight() {
		if(highlighted != null)
			highlighted.style.border = "";
	}
	static function highlight(dir:Int) {
		unhighlight();
		if(current != null && current + dir < Reditn.links.length)
			current += dir;
		else
			dir = 0;
		if(current == null)
			current = 0;
		highlighted.style.border = "3px solid grey";
		highlighted.scrollIntoViewIfNeeded(true);
	}
	static function show(s:Bool=true) {
		var btn = highlighted.getElementsByClassName("expando-button")[0];
		for(b in Expand.buttons)
			if(b.element == btn) {
				b.toggle(s);
				break;
			}

	}
	static var keys:Array<Int> = [];
	static var konami:Array<Int> = [38, 38, 40, 40, 37, 39, 37, 39, 66, 65];
	static function keyDown(c:Int) {
		keys.push(c);
		while(keys.length > konami.length)
			keys.remove(keys[0]);
		var isKon = keys.length >= konami.length;
		for(i in 0...keys.length) {
			if(keys[i] != konami[i]) {
				isKon = false;
				break;
			}
		}
		if(isKon)
			Konami.run();
		switch(c) {
			case 39: // right
				show(true);
			case 37: // left
				show(false);
			case 38: //up
				highlight(-1);
			case 40: //down
				highlight(1);
			default:
		}
	}
}