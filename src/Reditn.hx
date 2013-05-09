import js.html.*;
import js.Browser;
import data.*;
import haxe.Json;
using StringTools;
class Reditn {
	public static inline var FLICKR_KEY = "99dcc3e77bcd8fb489f17e58191f32f7";
	public static inline var TUMBLR_KEY = "k6pU8NIG57YiPAtXFD5s9DGegNPBZIpMahvbK4d794JreYIyYE";
	public static inline var IMGUR_CLIENT_ID = "cc1f254578d6c52";
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
		Style.init();
		
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
			if(state.allExpanded != Expand.toggled)
				Expand.toggle(state.allExpanded);
		}
	}
	static function state():State {
		return {
			allExpanded: Expand.toggled
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
	public static function removeSymbols(s:String):String {
		if(s.lastIndexOf("?") != -1)
			s = s.substr(0, s.indexOf("?"));
		if(s.lastIndexOf("/") != -1)
			s = s.substr(0, s.indexOf("/"));
		if(s.lastIndexOf("#") != -1)
			s = s.substr(0, s.indexOf("#"));
		if(s.lastIndexOf(".") != -1)
			s = s.substr(0, s.indexOf("."));
		return s;
	}
	public static function trimURL(url:String) {
		if(url.startsWith("http://"))
			url = url.substr(7);
		else if(url.startsWith("https://"))
			url = url.substr(8);
		if(url.startsWith("www."))
			url = url.substr(4);
		if(url.indexOf("&") != -1)
			url = url.substr(0, url.indexOf("&"));
		if(url.indexOf("?") != -1)
			url = url.substr(0, url.indexOf("?"));
		return url;
	}
	public static function getLinkType(ourl:String, cb:LinkType -> Void):Void {
		var url = trimURL(ourl);
		if(url.startsWith("reddit.com/r/") && url.indexOf("/comments/") != -1)
			cb(LinkType.TEXT);
		else if(url.indexOf(".media.tumblr.com/") != -1)
			cb(LinkType.IMAGE);
		else if(url.indexOf(".tumblr.com/post/") != -1) {
			var author = url.substr(0, url.indexOf("."));
			var id = removeSymbols(url.substr(url.indexOf(".")+17));
			Reditn.getJSON('http://api.tumblr.com/v2/blog/${author}.tumblr.com/posts/json?api_key=${TUMBLR_KEY}&id=${id}', function(data:Dynamic) {
				var post = data.posts[0];
				cb(switch(post.type) {
					case "photo": LinkType.IMAGE;
					case "video": LinkType.VIDEO;
					case _: LinkType.ARTICLE;
				});
			});
		} else if((url.startsWith("twitter.com/") && url.indexOf("/status/") != -1|| url.startsWith("cracked.com/article_")) || url.startsWith("cracked.com/blog/") || url.startsWith("cracked.com/quick-fixes
			/") || (url.indexOf(".wordpress.com/") != -1 && url.lastIndexOf("/") != url.indexOf("/")))
			cb(LinkType.ARTICLE);
		else if(url.startsWith("xkcd.com/") || url.startsWith("flickr.com/photos/") || url.startsWith("deviantart.com/art/") || (url.indexOf(".deviantart.com/") != -1 && url.indexOf("#/d") != -1) || url.indexOf(".deviantart.com/art") != -1 || (url.startsWith("imgur.com/") && url.indexOf("/blog/") == -1) || url.startsWith("i.imgur.com/") || url.startsWith("imgur.com/gallery/") || url.startsWith("qkme.me/") || url.startsWith("m.quickmeme.com/meme/") || url.startsWith("quickmeme.com/meme/") || url.startsWith("memecrunch.com/meme/") || url.startsWith("memegenerator.net/instance/") || url.startsWith("imgflip.com/i/") || url.startsWith("fav.me/") || url.startsWith("livememe.com/") || url.startsWith("explosm.net/comics/") || url.indexOf(".tumblr.com/image/") != -1) {
			cb(LinkType.IMAGE);
		} else if(url.startsWith("youtube.com/watch") || url.startsWith("youtu.be/")) {
			cb(LinkType.VIDEO);
		} else if(url.lastIndexOf(".") != url.indexOf(".") && url.substr(url.lastIndexOf(".")).length <= 4 && url.indexOf("/wiki/index.php?title=") == -1) {
			var ext = url.substr(url.lastIndexOf(".")+1).toLowerCase();
			trace(ext);
			switch(ext) {
				case "gif", "jpg", "jpeg", "bmp", "png", "webp", "svg", "ico", "tiff", "raw":
					cb(LinkType.IMAGE);
				case "mpg", "webm", "avi", "mp4", "flv", "swf":
					cb(LinkType.VIDEO);
				case "mp3", "wav", "midi":
					cb(LinkType.AUDIO);
				default:
			}
		} else {
			cb(LinkType.UNKNOWN);
		}
	}
	public static function getData(o:Dynamic):Dynamic {
		while(o.data != null)
			o = o.data;
		while(o.response != null)
			o = o.response;
		return o;
	}
	public static inline function getText(url:String, func:String->Void):Void {
		#if plugin
			func(haxe.Http.requestUrl(url));
		#else
			GM.request({
				method: "GET",
				url: url,
				onload: function(rsp:Dynamic) {
					func(rsp.responseText);
				}
			});
		#end
	}
	public static inline function getJSON<T>(url:String, func:T->Void):Void {
		getText(url, function(data:String) {
			try {
				func(getData(haxe.Json.parse(data)));
			} catch(e:Dynamic) {
				trace('Error: $e whilst processing $data for $url');
			}
		});
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