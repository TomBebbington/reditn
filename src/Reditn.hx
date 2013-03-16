import js.html.*;
import js.Browser;
using StringTools;
class Reditn {
	static inline var year = 31557600;
	static inline var month = 2629800;
	static inline var day = 86400;
	static inline var hour = 3600;
	static function main() {
		if(untyped document.readyState=="complete")
			init();
		else
			untyped window.onload = function(e) init();
	}
	static function init() {
		Settings.init();
		if(Settings.data.get(Settings.ADBLOCK_ENABLED))
			Adblock.init();
		if(Settings.data.get(Settings.EXPAND_ENABLED))
			Expand.init();
		if(Settings.data.get(Settings.USERINFO_ENABLED))
			UserInfo.init();
		if(Settings.data.get(Settings.SUBINFO_ENABLED))
			SubredditInfo.init();
		if(Settings.data.get(Settings.DUPLICATE_HIDER_ENABLED))
			DuplicateHider.init();
		if(Settings.data.get(Settings.USER_TAGGER_ENABLED))
			UserTagger.init();
		if(Settings.data.get(Settings.SUBREDDIT_TAGGER_ENABLED))
			SubredditTagger.init();
		if(Settings.data.get(Settings.PREVIEW_ENABLED))
			Preview.init();
	}
	public static function formatNumber(n:Int):String {
		return if (!Math.isFinite(n))
			Std.string(n);
		else {
			var s = Std.string(Math.abs(n));
			if (s.length >= 3) {
				var ns = "";
				for(i in 0...s.length) {
					ns += s.charAt(i);
					if((s.length - (i + 1)) % 3 == 0 && i < s.length-1)
						ns += ",";
				}
				s = ns;
			}
			n < 0 ? "-"+s:s;
		}
	}
	static inline function plural(n:Int) {
		return n <= 1 ? "" : "s";
	}
	public static inline function show(e:Element, shown:Bool):Void {
		e.style.display = shown ? "": "none";
	}
	public static inline function remove(e:Element):Void {
		e.parentNode.removeChild(e);
	}
	public static inline function insertAfter(ref:Element, after:Element) {
		after.parentNode.insertBefore(ref, after.nextSibling);
	}
	public static function age(t:Float):String {
		t = haxe.Timer.stamp() - t;
		var days = Std.int((t / day) % (month / day));
		var months = Std.int((t / month) % 12);
		var years = Std.int((t / month)/12);
		var s = "";
		if(years > 0)	
			s += '$years year' + plural(years);
		if(months > 0)
			s += ', $months month' + plural(months);
		s += ', $days day' + plural(days);
		if(s.substr(0, 2) == ", ")
			s = s.substr(2);
		while(s.indexOf(", , ") != -1)
			s = s.replace(", , ", ", ");
		return s;
	}
	public static function getLinkType(url:String):LinkType {
		if(url.substr(0, 7) == "http://")
			url = url.substr(7);
		else if(url.substr(0, 8) == "https://")
			url = url.substr(8);
		if(url.substr(0, 4) == "www.")
			url = url.substr(4);
		var t = if(url.substr(0,13) == "reddit.com/r/" && url.indexOf("/comments/") != -1)
			LinkType.TEXT;
		else if(url.lastIndexOf(".") != url.indexOf(".") && url.substr(url.lastIndexOf(".")).length <= 4) {
			var ext = url.substr(url.lastIndexOf(".")+1).toLowerCase();
			switch(ext) {
				case "gif", "jpg", "jpeg", "bmp", "png", "webp", "svg", "ico", "tiff", "raw":
					LinkType.IMAGE;
				case "mpg", "webm", "avi", "mp4", "flv", "swf":
					LinkType.VIDEO;
				case "mp3", "wav", "midi":
					LinkType.AUDIO;
				default:
					LinkType.UNKNOWN;
			}
		} else if((url.startsWith("flickr.com/photos/") && url.length > 18) || url.indexOf("deviantart.com/") != -1 || (url.substr(0, 10) == "imgur.com/" && url.substr(10,2) != "a/") || url.substr(0, 12) == "i.imgur.com/" || url.substr(0, 8) == "qkme.me/" || url.substr(0,19) == "quickmeme.com/meme/" || url.substr(0, 20) == "memecrunch.com/meme/" || url.substr(0, 27) == "memegenerator.net/instance/" || url.startsWith("fav.me/")) {
			LinkType.IMAGE;
		} else if(url.substr(0, 17) == "youtube.com/watch") {
			LinkType.VIDEO;
		} else {
			LinkType.UNKNOWN;
		};
		return t;
	}
	public static inline function getJSON(url:String, func:Dynamic->Void) {
		func(haxe.Json.parse(haxe.Http.requestUrl(url)));
	}
	public static function getJSONP(url:String, func:Dynamic->Void) {
		var r = Std.int(Math.random()*10000000);
		var id = "temp" + r;
		untyped window[id] = func;
		var sc = Browser.document.createScriptElement();
		sc.type = "text/javascript";
		sc.src = url + id;
		Browser.document.head.appendChild(sc);
	}
	public static function popUp(bs:Element, el:Element, x:Float=0, y:Float=0) {
		Browser.document.body.appendChild(el);
		el.className="popup";
		el.style.position = "absolute";
		el.style.width = Std.int(Browser.window.innerWidth*0.25)+"px";
		el.style.left = '${x}px';
		el.style.top = '${y}px';
		bs.onmouseout = el.onblur =function(e) {
			remove(el);
			untyped bs.mouseover = false;
		}
		return el;
	}
	public static function fullPopUp(el:Element, ?a:Element) {
		var old:Element = untyped Browser.document.getElementsByClassName("popup")[0];
		if(old != null)
			old.parentNode.removeChild(old);
		Browser.document.body.appendChild(el);
		var head = Browser.document.getElementById("header");
		var close = Browser.document.createAnchorElement();
		close.style.position = "absolute";
		close.style.right = close.style.top = "5px";
		close.innerHTML = "<b>Close</b>";
		close.href = "javascript:void(0);";
		close.onclick = el.onblur = function(e) {
			remove(el);
		}
		el.appendChild(close);
		el.className = "popup";
		el.style.top = if(a == null) "50px" else
			a.offsetTop +"px";
		return el;
	}
}