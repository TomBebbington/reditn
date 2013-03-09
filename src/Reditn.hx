import js.html.*;
import js.Browser;
class Reditn {
	public static var settings:Map<String, Dynamic> = null;
	static function main() {
		if(untyped document.readyState=="complete")
			init();
		else
			untyped window.onload = function(e) init();
	}
	static function init() {
		var sets = Browser.window.localStorage.getItem("reditn");
		settings = sets == null ? new Map<String, Dynamic>() : haxe.Unserializer.run(sets);

		Adblock.init();
		//Style.init();
		Expand.init();
		UserInfo.init();
		SubredditInfo.init();
		Header.init();
	}
	public static function formatNumber(n:Int):String {
		var s = Std.string(n);
		var ns = "";
		for(i in 0...s.length) {
			ns += s.charAt(i);
			if((s.length-i) % 3 == 0)
				ns += ",";
		}
		return ns;
	}
	public static function getLinkType(url:String):LinkType {
		if(url.substr(0, 7) == "http://")
			url = url.substr(7);
		else if(url.substr(0, 8) == "https://")
			url = url.substr(8);
		if(url.substr(0, 4) == "www.")
			url = url.substr(4);
		return if(url.lastIndexOf(".") != url.indexOf(".")) {
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
		} else if((url.substr(0, 10) == "imgur.com/" && url.substr(10,2) != "a/") || url.substr(0, 12) == "i.imgur.com/" || url.substr(0, 8) == "qkme.me/" || url.substr(0,19) == "quickmeme.com/meme/" || url.substr(0, 20) == "memecrunch.com/meme/" || url.substr(0, 27) == "memegenerator.net/instance/" || url.indexOf("deviantart.com/art/")!=-1) {
			LinkType.IMAGE;
		} else if(url.substr(0, 17) == "youtube.com/watch") {
			LinkType.VIDEO;
		} else {
			LinkType.UNKNOWN;
		}
	}
	public static function saveSettings():Void {
		Browser.window.localStorage.setItem("reditn", haxe.Serializer.run(settings));
	}
	public static inline function getJSON(url:String, func:Dynamic->Void) {
		func(haxe.Json.parse(haxe.Http.requestUrl(url)));
	}
	public static function popUp(bs:Element, el:Element, x:Float=0, y:Float=0) {
		Browser.document.body.appendChild(el);
		el.className="reditnpopup";
		el.innerHTML = el.innerText = "Loading...";
		el.style.position = "absolute";
		el.style.top = y+"px";
		el.style.left = x+"px";
		el.style.padding = "2px";
		el.style.backgroundColor = "#fcfcfc";
		el.style.border = "1px solid black";
		el.style.borderRadius = "4px";
		el.style.maxWidth = (Browser.window.innerWidth*0.4)+"px";
		bs.onmouseout=function(e) {
			el.parentNode.removeChild(el);
			untyped bs.mouseover = false;
		}
		return el;
	}
}