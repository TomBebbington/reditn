import js.html.*;
import js.Browser;
import data.*;
import haxe.Json;
using StringTools;
class Reditn {
	static inline var year = 31557600;
	static inline var month = 2629800;
	static inline var day = 86400;
	static inline var hour = 3600;
	public static var links:Array<AnchorElement> = null;
	public static var fullPage:Bool = true;
	static function main() {
		if(untyped document.readyState=="complete")
			init();
		else
			Browser.window.onload = function(_) init();
	}
	public static inline function getLinkContainer(l:Element):Element {
		return cast l.parentNode.parentNode.parentNode;
	}
	public static inline function scroll(x:Int, y:Int):Void {
		Browser.window.scrollBy(x - Browser.window.scrollX, y - Browser.window.scrollY);
	}
	static function init() {
		if(Browser.window.location.href.indexOf("reddit.") == -1)
			return;
		fullPage = Browser.document.getElementsByClassName("tabmenu").length > 0;
		links = cast Browser.document.body.getElementsByClassName("title");
		links = [for(l in links) if(l.nodeName.toLowerCase() == "a" && untyped l.parentNode.className != "parent") l];
		wrap(Settings.init);
		wrap(Adblock.init, Settings.ADBLOCK);
		wrap(DuplicateHider.init, Settings.DUPLICATE_HIDER);
		wrap(NSFWFilter.init, Settings.FILTER_NSFW);
		
		wrap(Expand.init, Settings.EXPAND);
		wrap(Keyboard.init, Settings.KEYBOARD);
		wrap(Preview.init, Settings.PREVIEW);
		wrap(SubredditInfo.init, Settings.SUBINFO);
		wrap(UserInfo.init, Settings.USERINFO);
		wrap(UserTagger.init, Settings.USER_TAGGER);
		wrap(SubredditTagger.init, Settings.SUBREDDIT_TAGGER);
		Browser.window.history.replaceState(haxe.Serializer.run(state()), null, Expand.toggled ? "#showall" : null);
		Browser.window.onpopstate = function(e:Dynamic) {
			var s:String = e.state;
			if(s == null)
				return;
			var state:State = haxe.Unserializer.run(s);
			Expand.expanded = state.expanded;
			if(state.allExpanded != Expand.toggled)
				Expand.toggle(state.allExpanded);
		}
	}
	static function state():State {
		return {
			allExpanded: Expand.toggled,
			expanded: Expand.expanded
		};
	}
	public static inline function pushState(?url:String) {
		Browser.window.history.pushState(haxe.Serializer.run(state()), null, url);
	}
	static function wrap(fn:Void->Void, ?id:String) {
		var d = id == null ? null : Settings.data.get(id);
		if(id == null || d)
			try
				fn()
			catch(d:Dynamic) {
				#if debug
					Browser.window.alert('Module $id has failed to load in Reditn due to the following error:\n $d');
				#else
					trace('Module $id has failed to load in Reditn due to the following error:\n $d');
				#end
			}
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
		if(e.className.indexOf("link") != -1)
			links.remove(untyped e.getElementsByClassName("entry")[0].getElementsByTagName("a")[0]);
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
		if(s.startsWith(", "))
			s = s.substr(2);
		while(s.indexOf(", , ") != -1)
			s = s.replace(", , ", ", ");
		return s;
	}
	public static function getLinkType(url:String):LinkType {
		if(url.startsWith("http://"))
			url = url.substr(7);
		else if(url.startsWith("https://"))
			url = url.substr(8);
		if(url.startsWith("www."))
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
		} else if(url.startsWith("xkcd.com/") || url.startsWith("flickr.com/photos/") || (url.indexOf(".deviantart.com/") != -1 && url.indexOf("#/d") != -1) || url.indexOf(".deviantart.com/art") != -1 || (url.startsWith("imgur.com/") && url.indexOf("/blog/") == -1) || url.startsWith("i.imgur.com/") || url.startsWith("qkme.me/") || url.startsWith("m.quickmeme.com/meme/") || url.startsWith("quickmeme.com/meme/") || url.startsWith("memecrunch.com/meme/") || url.startsWith("memegenerator.net/instance/") || url.startsWith("imgflip.com/i/") || url.startsWith("fav.me/")) {
			LinkType.IMAGE;
		} else if(url.startsWith("youtube.com/watch") || url.startsWith("youtu.be/")) {
			LinkType.VIDEO;
		} else {
			LinkType.UNKNOWN;
		};
		return t;
	}
	public static function getData(o:Dynamic):Dynamic {
		while(o.data != null)
			o = o.data;
		return o;
	}
	public static inline function getJSON<T>(url:String, func:T->Void):Void {
		#if plugin
			func(getData(Json.parse(haxe.Http.requestUrl(url))));
		#else
			GM.request({
				method: "GET",
				url: url,
				onload: function(rsp:Dynamic) {
					func(getData(Json.parse(rsp.responseText)));
				}
			});
		#end
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
	public static function fullPopUp(el:Element, y:Float=0) {
		var old:Element = untyped Browser.document.getElementsByClassName("popup")[0];
		if(old != null)
			Reditn.remove(old);
		Browser.document.body.appendChild(el);
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
		if(y != 0)
			el.style.top = '${y-Browser.window.scrollY}px';
		return el;
	}
}