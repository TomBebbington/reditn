import js.*;
import js.html.*;
import haxe.Timer;
import haxe.*;
using StringTools;
class Expand {
	static inline var FLICKR_KEY = "99dcc3e77bcd8fb489f17e58191f32f7";
	public static var maxWidth(get, null):Int;
	public static var maxHeight(get, null):Int;
	public static var maxArea(get, null):Int;
	public static var expandButtons:Array<Element> = [];
	public static var toggled(default, null):Bool = false;
	public static var button(default, null):AnchorElement = null;
	static inline function get_maxWidth():Int {
		return Std.int(Browser.window.innerWidth*0.6);
	}
	static inline function get_maxHeight():Int {
		return Std.int(Browser.window.innerHeight*0.7);
	}
	static inline function get_maxArea():Int {
		return maxWidth * maxHeight;
	}
	public static function init() {
		var links = Browser.document.body.getElementsByClassName("title");
		toggled = Browser.window.location.hash == "#showall";
		initShowAll();
		for(i in 0...links.length) {
			var l:AnchorElement = untyped links[i];
			if(l.nodeName.toLowerCase()!="a")
				continue;
			var urltype = Reditn.getLinkType(l.href);
			if(urltype==LinkType.IMAGE) {
				getImageLink(l.href, l, function(url, l) {
					var e = l.parentNode.parentNode;
					var img = loadImage(url);
					var div = Browser.document.createElement("div");
					Reditn.show(div, toggled);
					e.appendChild(div);
					div.appendChild(img);
					var li = Browser.document.createElement("li");
					var show = showButton(div, li);
					expandButtons.push(show);
					var btns = untyped e.getElementsByClassName("buttons")[0];
					if(btns != null)
						btns.insertBefore(li, btns.childNodes[0]);
					else {
						throw "Bad DOM";
					}
					refresh();
				});
			} else {
				preload(l.href);
			}
		}
	}
	public static function refresh() {
		if(button != null) {
			button.innerHTML = toggled ? "hide images ("+Expand.expandButtons.length+")" : "show images ("+Expand.expandButtons.length+")";
			button.href = toggled ? "#showall" : "#";
			var np:Array<Element> = cast Browser.document.body.getElementsByClassName("nextprev");
			if(np.length > 0) {
				var c:Array<AnchorElement> = cast np[0].childNodes;
				for(i in c) {
					if(i.nodeName.toLowerCase() != "a")
						continue;
					var i:AnchorElement = cast i;
					if(toggled && i.href.indexOf("#")==-1)
						i.href += "#showall";
					else if(!toggled && i.href.indexOf("#")!=-1)
						i.href = i.href.substr(0, i.href.indexOf("#"));
				}
		}
			Reditn.show(button, Expand.expandButtons.length != 0);
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
				if(untyped btn.toggled != toggled)
					btn.onclick(null);
			}
			refresh();
		};
		li.appendChild(button);
		menu.appendChild(li);
	}
	static function showButton(el:Element, p:Element) {
		var e = Browser.document.createAnchorElement();
		e.style.fontStyle = "italic";
		e.href = "javascript:void(0);";
		e.innerHTML = toggled ? "hide" : "show";
		untyped e.toggled = toggled;
		e.onclick = function(ev) {
			untyped e.toggled = !e.toggled;
			e.innerHTML = untyped e.toggled ? "hide" : "show";
			Reditn.show(el, untyped e.toggled);
		}
		p.appendChild(e);
		return e;
	}
	static function getImageLink(ourl:String, el:Element, cb:String -> Element->Void) {
		var url = ourl;
		if(url.substr(0, 7) == "http://")
			url = url.substr(7);
		else if(url.substr(0, 8) == "https://")
			url = url.substr(8);
		if(url.substr(0, 4) == "www.")
			url = url.substr(4);
		if(url.indexOf("&") != -1)
			url = url.substr(0, url.indexOf("&"));
		if(url.indexOf("?") != -1)
			url = url.substr(0, url.indexOf("?"));
		if(url.substr(0, 12) == "i.imgur.com/" && url.split(".").length == 3)
			cb("http://"+url+".jpg", el);
		else if(url.substr(0, 10) == "imgur.com/") {
			var id = removeSymbols(url.substr(url.indexOf("/")+1));
			cb("http://i.imgur.com/"+id+".jpg", el);
		} else if(url.substr(0, 8) == "qkme.me/") {
			var id = removeSymbols(url.substr(8));
			cb("http://i.qkme.me/"+id+".jpg", el);
		} else if(url.substr(0, 19) == "quickmeme.com/meme/") {
			var id = removeSymbols(url.substr(19));
			cb("http://i.qkme.me/"+id+".jpg", el);
		} else if(url.substr(0, 20) == "memecrunch.com/meme/") {
			var id = url;
			if(id.charAt(id.length-1) != "/")
				id += "/";
			cb("http://"+id+"image.jpg", el);
		} else if(url.substr(0, 27) == "memegenerator.net/instance/") {
			var id = removeSymbols(url.substr(27));
			cb("http://cdn.memegenerator.net/instances/400x/"+id+".jpg", el);
		} else if(ourl.indexOf("deviantart.com/") != -1 || ourl.indexOf("fav.me") != -1) {
			Reditn.getJSONP("http://backend.deviantart.com/oembed?url="+ourl.urlEncode()+"&format=jsonp&callback=", function(d) {
				cb(d.url, el);
			});
		} else if(url.startsWith("flickr.com/photos/")) {
			var id = url.substr(18);
			id = id.substr(id.indexOf("/")+1);
			id = id.substr(0, id.indexOf("/"));
			Reditn.getJSONP('http://api.flickr.com/services/rest/?method=flickr.photos.getSizes&api_key=${FLICKR_KEY}&photo_id=${id}&format=json&jsoncallback=', function(d) {
				if(d.sizes == null || d.sizes.size == null)
					return;
				var sizes:Array<Dynamic> = d.sizes.size;
				var largest:String = null;
				var largestSize:Int = 0;
				for(s in sizes) {
					var size = Std.parseInt(s.width) * Std.parseInt(s.height);
					if(largest == null || (size >= largestSize && size <= maxArea)) {
						largest = s.source;
						largestSize = size;
					}
				}
				if(largest == null)
					largest = sizes[0].source;
				cb(largest, el);
			});
		} else {
			cb(ourl, el);
		}
	}
	public static function preload(url) {
		var link:LinkElement = Browser.document.createLinkElement();
		link.href = url;
		link.rel = Browser.window.navigator.userAgent.toLowerCase().indexOf('chrome') > -1 ? "prefetch" : "preload";
		Browser.document.head.appendChild(link);
	}
	public static function loadImage(url:String):ImageElement {
		var img = Browser.document.createImageElement();
		img.src = url;
		img.className = "resize";
		initResize(img);
		var autosize = function() {
			if(img.width > maxWidth) {
				var rt = img.height / img.width;
				img.width = maxWidth;
				img.height = Std.int(img.width * rt);
			}
			if(img.height > maxHeight) {
				var rt = img.width / img.height;
				img.height = maxHeight;
				img.width = Std.int(img.height * rt);
			}
		}
		var t = new Timer(30);
		t.run = function() {
			if(img.width > 0 && img.height > 0) {
				t.stop();
				autosize();
			}
		}
		return img;
	}
	public static function initResize(e:ImageElement):Void {
		var drx = 0.0, dry = 0.0, rt = 1.0;
		var drag = false;
		e.onmousedown = function(ev) {
			drag = true;
			var ev:MouseEvent = cast ev;
			drx = e.offsetWidth/ev.clientX;
			dry = e.offsetHeight/ev.clientY;
			rt = e.offsetWidth/e.offsetHeight;
			ev.preventDefault();
		}
		e.onmousemove = function(ev) {
			var ev:MouseEvent = cast ev;
			if(drag) {
				var nw = ev.clientX * drx;
				var nwh = nw / rt;
				var nh = ev.clientY * dry;
				var nhw = nh * rt;
				e.width = Std.int(nwh > nh ? nw : nhw);
				e.height = Std.int(nwh > nh ? nwh : nh);
			}
			ev.preventDefault();
		}
		e.onmouseup = e.onmouseout = function(ev) {
			drag = false;
			ev.preventDefault();
		}
	}
	public static function removeSymbols(s:String):String {
		if(s.lastIndexOf("?") != -1)
			s = s.substr(0, s.lastIndexOf("?"));
		if(s.lastIndexOf("/") != -1)
			s = s.substr(0, s.lastIndexOf("/"));
		return s;
	}
}
