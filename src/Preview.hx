import js.*;
import js.html.*;
class Preview {
	public static function init() {
		var ts:Array<Element> = cast Browser.document.body.getElementsByClassName("usertext-edit");
		for(t in ts)
			makePreviewable(t);
	}
	public static function makePreviewable(e:Element) {
		var box:TextAreaElement = untyped e.getElementsByTagName("textarea")[0];
		if(box == null)
			return;
		var preview = Browser.document.createDivElement();
		e.appendChild(preview);
		preview.className = "md";
		box.onchange = function(e) {
			preview.innerHTML = Markdown.parse(box.value);
		}
	}
}