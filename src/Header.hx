import js.*;
import js.html.*;

class Header {
	public static function init() {
		if(Expand.expandButtons.length > 0)
			initShowAll();
	}
	static function initShowAll() {
		var menu = Browser.document.getElementsByClassName("tabmenu")[0];
		var li:LIElement = Browser.document.createLIElement();
		var l:AnchorElement = Browser.document.createAnchorElement();
		var toggled = false;
		l.innerHTML = "show images ("+Expand.expandButtons.length+")";
		l.href = "javascript:void(0)";
		l.onclick = function(e) {
			l.className = "selected";
			toggled = !toggled;
			for(btn in Expand.expandButtons) {
				untyped btn.toggled = !toggled;
				btn.onmousedown(null);
			}
			l.innerHTML = toggled ? "hide images ("+Expand.expandButtons.length+")" : "show images ("+Expand.expandButtons.length+")";
		};
		li.appendChild(l);
		menu.appendChild(li);
	}
}