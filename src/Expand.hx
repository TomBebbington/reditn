import js.*;
import js.html.*;
import haxe.Timer;
import haxe.*;
class Expand {
	public static var expandInfo:ExpandInfo = {maxWidth:0, maxHeight:0};
	public static var expandButtons:Array<Element> = [];

	public static function init() {
		expandInfo.maxWidth = Std.int(try {
			Math.abs(Browser.window.innerWidth - untyped Browser.document.body.getElementsByClassName("side")[0].offsetWidth); // just in case something goes horrible wrong...
		} catch(e:Dynamic) {
			Browser.window.innerWidth*0.7;
		});
		expandInfo.maxHeight = Std.int(Browser.window.innerHeight*0.5);


		var links = Browser.document.body.getElementsByClassName("title");
		for(i in 0...links.length) {
			var l:AnchorElement = untyped links[i];
			if(l.nodeName.toLowerCase()!="a")
				continue;
			var urltype = Reditn.getLinkType(l.href);
			if(urltype==LinkType.IMAGE) {
				getImageLink(l.href, l, function(url, l) {
					preload(url);
					var e = getEntry(l);
					var img = loadImage(url);
					var div = Browser.document.createElement("div");
					div.appendChild(img);
					var show = showButton(div);
					expandButtons.push(show);
					var li = Browser.document.createElement("li");
					li.appendChild(show);
					var btns = untyped e.getElementsByClassName("buttons")[0];
					if(btns != null)
						btns.insertBefore(li, btns.childNodes[0]);
					else {
						throw "Bad DOM";
					}
				});
			} else {
				preload(l.href);
			}
		}
	}
	static function showButton(el:Element) {
		var e = Browser.document.createSpanElement();
		e.innerHTML = "<b>show</b>";
		untyped e.toggled = false;
		e.onmousedown = function(ev) {
			untyped e.toggled = !e.toggled;
			e.innerHTML = untyped e.toggled ? "<b>hide</b>" : "<b>show</b>";
			if(untyped e.toggled) {
				e.parentNode.parentNode.appendChild(el);
			} else if(el.parentNode != null)
				el.parentNode.removeChild(el);
		}
		e.style.cursor = "pointer";
		return e;
	}
	static inline function getEntry(l:Element) {
		return l.parentNode.parentNode;
	}
	static function getImageLink(ourl:String, el:Element, cb:String -> Element->Void) {
		var url = ourl;
		if(url.substr(0, 7) == "http://")
			url = url.substr(7);
		else if(url.substr(0, 8) == "https://")
			url = url.substr(8);
		if(url.substr(0, 4) == "www.")
			url = url.substr(4);
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
		} else if(url.indexOf(".deviantart.com/art/")!=-1) {
			/*var s = Http.requestUrl("http://backend.deviantart.com/oembed?url="+encodeURI(url)+"&format=jsonp&callback=?",
			function(data){
				cb(data.url, el);
			});*/
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
			if(img.width > expandInfo.maxWidth) {
				var rt = img.height / img.width;
				img.width = expandInfo.maxWidth;
				img.height = Std.int(img.width * rt);
			}
			if(img.height > expandInfo.maxHeight) {
				var rt = img.width / img.height;
				img.height = expandInfo.maxHeight;
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
	public static function initResize(e:Element):Void {
		var drag:Dynamic = null;
		e.onmousedown = function(ev) {
			var ev:MouseEvent = cast ev;
			drag = {rtx:e.offsetWidth/ev.clientX, rty:e.offsetHeight/ev.clientY, rt: e.offsetWidth/e.offsetHeight};
			ev.preventDefault();
		}
		e.onmousemove = function(ev) {
			var ev:MouseEvent = cast ev;
			if(drag != null) {
				var nw = ev.clientX * drag.rtx;
				var nwh = nw / drag.rt;
				var nh = ev.clientY * drag.rty;
				var nhw = nh * drag.rt;
				if(nwh > nh) {
					e.setAttribute("width", Std.string(nw));
					e.setAttribute("height", Std.string(nwh));
				} else {
					e.setAttribute("width", Std.string(nhw));
					e.setAttribute("height", Std.string(nh));
				}
			}
			ev.preventDefault();
		}
		e.onmouseup = e.onmouseout = function(ev) {
			drag = null;
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
