import js.*;
import js.html.*;
import data.*;
import parser.*;
class Preview {
	public static function init() {
		var ts:Array<Element> = cast Browser.document.body.getElementsByClassName("usertext-edit");
		for(t in ts)
			preview(t);
	}
	public static function preview(e:Element) {
		var box:TextAreaElement = untyped e.getElementsByTagName("textarea")[0];
		if(box == null)
			return;
		var preview = Browser.document.createDivElement();
		e.appendChild(preview);
		preview.className = "md";
		var t = null;
		box.onfocus = function(_) {
			t = new haxe.Timer(100);
			t.run = function() preview.innerHTML = Markdown.parse(box.value);
		}
		box.onblur = function(_) {
			t.stop();
			t = null;
		}
	}
}