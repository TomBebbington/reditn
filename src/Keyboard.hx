import js.html.*;
import js.*;
class Keyboard {
	public static function init() {
		Browser.document.onkeydown = function(e) keyDown(e.keyDown);
	}
	static function keyDown(c:Int) {
		trace(c);
	}
}