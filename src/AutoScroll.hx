import js.Browser.*;
import js.html.*;
using StringTools;
class AutoScroll {
	static var regex = ~/\?count=([0-9]*)&after=([a-z0-9_]*)/;
	public static var next:String = null;
	public static var count:Int = 50;
	static var nextBtn:Element = null;
	static var canLoad = true;
	static var last:Element = null;
	static function getLastId():String {
		var t = document.body.getElementsByClassName("thing");
		return Reditn.getThingId(t[t.length-1]);
	}
	public static function init() {
		if(regex.match(window.location.href))
			count = Std.parseInt(regex.matched(1));
		nextBtn = cast document.body.getElementsByClassName("nextprev")[0];
		refresh();
		last = cast document.body.getElementsByClassName("sitetable")[0];
		window.addEventListener("scroll", function(e) {
			var bottom = window.scrollY + window.innerHeight, h = document.body.offsetHeight;
			if(bottom > h - window.innerHeight && canLoad)
				loadNext();
		});
	}
	static function loadNext() {
		if(nextBtn == null)
			return;
		canLoad = false;
		count += 50;
		Reditn.getText(next, function(data) {
			var temp:Element = document.createDivElement();
			temp.innerHTML = data;
			temp = cast temp.getElementsByClassName("sitetable")[0];
			last.parentNode.appendChild(temp);
			last = temp;
			refresh();
			canLoad = true;
			nextBtn.parentNode.removeChild(nextBtn);
			temp.parentNode.appendChild(nextBtn);
			Reditn.refreshLinks();
			if(Settings.data.get(Settings.EXPAND))
				Expand.refresh(temp);
			Reditn.pushState(next);
		});
	}
	static function refresh() {
		if(nextBtn != null) {
			var root = window.location.href;
			if(root.indexOf("?") != -1)
				root = root.substr(0, root.indexOf("?"));
			if(root.endsWith("/"))
				root = root.substr(0, root.length - 1);
			var hash = if(root.indexOf("#") != -1) {
				root = root.substr(0, root.indexOf("#"));
				window.location.hash;
			} else "";
			var after = getLastId();
			next = '${root}/?count=${count}&after=${after}${hash}';
			for(i in nextBtn.childNodes) {
				var i:AnchorElement = cast i;
				if(i.nodeName.toLowerCase() == "a" && i.rel.indexOf("next") != -1)
					i.href = next; 
			}
		}
	}
}