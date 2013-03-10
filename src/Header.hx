import js.*;
import js.html.*;

class Header {
	public static var toggled(default, null):Bool = false;
	public static var button(default, null):AnchorElement = null;
	public static function init() {
		toggled = Browser.window.location.hash == "#showall";
		initShowAll();
	}
	public static inline function refresh() {
		if(button != null) {
			button.innerHTML = toggled ? "hide images ("+Expand.expandButtons.length+")" : "show images ("+Expand.expandButtons.length+")";
			button.href = toggled ? "#showall" : "#";
			var c:Array<AnchorElement> = untyped Browser.document.body.getElementsByClassName("nextprev")[0].childNodes;
			for(i in c) {
				if(i.nodeName.toLowerCase() != "a")
					continue;
				var i:AnchorElement = cast i;
				if(toggled && i.href.indexOf("#")==-1)
					i.href += "#showall";
				else if(!toggled && i.href.indexOf("#")!=-1)
					i.href = i.href.substr(0, i.href.indexOf("#"));
			}
			button.style.visibility = Expand.expandButtons.length == 0 ? "hidden" : "visible";
		}
	}
	static function initShowAll() {
		var menu = Browser.document.getElementsByClassName("tabmenu")[0];
		var li:LIElement = Browser.document.createLIElement();
		button = Browser.document.createAnchorElement();
		refresh();
		button.onclick = function(e) {
			button.className = "selected";
			toggled = !toggled;
			for(btn in Expand.expandButtons) {
				untyped btn.toggled = !toggled;
				btn.onclick(null);
			}
			refresh();
		};
		li.appendChild(button);
		menu.appendChild(li);
	}
}