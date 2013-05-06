import js.*;
import js.html.*;
import haxe.Timer;
import haxe.*;
import data.*;
using StringTools;
class Expand {
	static inline var FLICKR_KEY = "99dcc3e77bcd8fb489f17e58191f32f7";
	static inline var IMGUR_CLIENT_ID = "cc1f254578d6c52";
	public static var maxWidth(get, null):Int;
	public static var maxHeight(get, null):Int;
	public static var maxArea(get, null):Int;
	public static var buttons:Array<Element> = [];
	public static var toggled(default, null):Bool;
	public static var button(default, null):AnchorElement = null;
	public static var expanded(get, set):Array<String>;
	static function get_expanded() {
		return toggled ? [] : [for(b in buttons) if(untyped b.toggled()) untyped b.url];
	}
	static function set_expanded(e:Array<String>) {
		if(e.length == buttons.length)
			toggle(true);
		else if(e.length <= 0)
			toggle(false);
		for(b in buttons) {
			var t = false;
			for(u in e)
				t = t || untyped b.url == u;
			untyped b.toggle(t, false);
		}
		return e;
	}
	static inline function get_maxWidth():Int {
		return Std.int(Browser.window.innerWidth*0.7);
	}
	static inline function get_maxHeight():Int {
		return Std.int(Browser.window.innerHeight*0.6);
	}
	static inline function get_maxArea():Int {
		return maxWidth * maxHeight;
	}
	public static function init() {
		toggled = Browser.window.location.hash == "#showall";

		var menu = Browser.document.getElementsByClassName("tabmenu")[0];
		var li:LIElement = Browser.document.createLIElement();
		button = Browser.document.createAnchorElement();
		button.href = "javascript:void(0);";
		refresh();
		button.onclick = function(e) {
			toggle(!toggled);
			Reditn.pushState(toggled ? "#showall":null);
		}
		li.appendChild(button);
		if(menu != null)
			menu.appendChild(li);
		for(l in Reditn.links) {
			if(l.nodeName.toLowerCase()!="a")
				continue;
			var urltype = Reditn.getLinkType(l.href);
			if(urltype==LinkType.IMAGE) {
				getImageLink(l.href, l, function(a:Album) {
					var e = l.parentNode.parentNode;
					var div = Browser.document.createDivElement();
					var imgs = [for(i in a) {
						var i = loadImage(i.url);
						div.appendChild(i);
						Reditn.show(i, false);
						i;
					}];
					var img:ImageElement = null;
					var caption = Browser.document.createSpanElement();
					caption.style.fontWeight = "bold";
					caption.style.marginLeft = "10px";
					var currentIndex = 0;
					var prev = null, info = null, next = null;
					if(a.length > 1) {
						prev = Browser.document.createButtonElement();
						prev.innerHTML = "Prev";
						div.appendChild(prev);
						info = Browser.document.createSpanElement();
						info.style.textAlign = "center";
						info.style.paddingLeft = info.style.paddingRight = "5px";
						div.appendChild(info);
						next = Browser.document.createButtonElement();
						next.innerHTML = "Next";
						div.appendChild(next);
					}
					if(a.length > 1 || (a[0].caption != null && a[0].caption.length > 0)) {
						div.appendChild(caption);
						div.appendChild(Browser.document.createBRElement());
					}
					function switchImage(ind:Int) {
						if(ind < 0 || ind >= a.length)
							return;
						var i = a[ind];
						var height = null;
						if(img != null) {
							Reditn.show(img, false);
							height = img.height;
						}
						img = imgs[ind];
						Reditn.show(img, true);
						if(height != null) {
							var ratio = img.width / img.height;
							img.height = height;
							img.width = Std.int(height * ratio);
						}
						div.appendChild(img);
						if(prev != null) {
							var len = Reditn.formatNumber(a.length);
							var curr = Reditn.formatNumber(ind+1);
							info.innerHTML = '$curr of $len';
							prev.disabled = ind <= 0;
							next.disabled = ind >= a.length-1;
						}
						Reditn.show(caption, i.caption != null);
						if(i.caption != null) 
							caption.innerHTML = StringTools.htmlEscape(i.caption);
					}
					switchImage(0);
					if(prev != null) {
						prev.onmousedown = function(_) switchImage(--currentIndex);
						next.onmousedown = function(_) switchImage(++currentIndex);
					}
					e.appendChild(div);
					Reditn.show(div, toggled);
					var li = Browser.document.createElement("li");
					li.className = "reditn-expand";
					var show = showButton(div, li);
					buttons.push(show);
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
			button.innerHTML = '${toggled?"hide":"show"} images (${buttons.length})';
			var np = [];
			var n:Array<AnchorElement> = cast Browser.document.body.getElementsByClassName("next");
			var p:Array<AnchorElement> = cast Browser.document.body.getElementsByClassName("prev");
			for(nl in n)
				np.push(nl);
			for(pl in p)
				np.push(pl);
			for(i in np) {
				if(i.nodeName.toLowerCase() != "a")
					continue;
				if(toggled && i.href.indexOf("#")==-1)
					i.href += "#showall";
				else if(!toggled && i.href.indexOf("#")!=-1)
					i.href = i.href.substr(0, i.href.indexOf("#"));
			}
			Reditn.show(button, buttons.length > 0);
		}
	}
	public static function toggle(t:Bool) {
		toggled = t;
		for(btn in buttons)
			untyped btn.toggle(t, false);
		refresh();
	}
	public static function showImage(url:String, toggled:Bool) {
		for(l in Reditn.links)
			if(l.href == url) {
				var e:Element = cast l.parentNode.parentNode;
				untyped e.getElementsByClassName("toggle")[0].toggle(null, false);
			}
	}
	static function showButton(el:Element, p:Element) {
		var e = Browser.document.createAnchorElement();
		e.style.fontStyle = "italic";
		e.href = "javascript:void(0);";
		e.className="toggle";
		var toggled = Expand.toggled;
		e.innerHTML = toggled ? "hide" : "show";
		untyped e.toggle = function(?t:Bool, st:Bool=true) {
			toggled = t == null ? !toggled : t;
			e.innerHTML = toggled ? "hide" : "show";
			Reditn.show(el, toggled);
			if(st)
				Reditn.pushState();
		}
		untyped e.toggled = function() return toggled;
		e.onclick = function(ev) untyped e.toggle();
		p.appendChild(e);
		return e;
	}
	static inline function image(url:String, ?c:String):Image {
		return {url: url, caption: c};
	}
	static inline function album(url:String, ?c:String):Album {
		return [image(url, c)];
	}
	static function getImageLink(ourl:String, el:Element, cb:Album -> Void) {
		var url = ourl;
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
		if(url.startsWith("i.imgur.com/") && url.split(".").length == 3)
			cb(album('http://${url}.jpg'));
		else if(url.startsWith("imgur.com/a/") || url.startsWith("imgur.com/gallery/")) {
			var id:String = url.split("/")[2];
			var albumType = url.indexOf("gallery") != -1 ? "gallery/album" : "album";
			var req = new haxe.Http('https://api.imgur.com/3/${albumType}/${id}');
			req.setHeader("Authorization", "Client-ID "+IMGUR_CLIENT_ID);
			req.onData = function(ds:String) {
				var d:data.imgur.Album = cast Reditn.getData(haxe.Json.parse(ds));
				var album = [];
				if(d.images_count <= 0)
					album.push(image('http://i.imgur.com/${d.id}.jpg', d.title));
				else
					for(i in d.images)
						album.push(image('http://i.imgur.com/${i.id}.jpg', i.title));
				cb(album);
			};
			#if debug
			req.onError = function(e:String) {
				trace('Error in request to ${req.url} for album with id ${id}: $e');
			};
			#end
			req.request(false);
		} else if(url.startsWith("imgur.com/")) {
			var id = removeSymbols(url.substr(url.indexOf("/")+1));
			cb(if(id.indexOf(",") != -1)
				id.split(",").map(function(nid) return image('http://i.imgur.com/${nid}.jpg'));
			else
				album('http://i.imgur.com/${id}.jpg'));
		} else if(url.startsWith("qkme.me/")) {
			var id = removeSymbols(url.substr(8));
			cb(album('http://i.qkme.me/${id}.jpg'));
		} else if(url.startsWith("quickmeme.com/meme/")) {
			var id = removeSymbols(url.substr(19));
			cb(album('http://i.qkme.me/${id}.jpg'));
		} else if(url.startsWith("m.quickmeme.com/meme/")) {
			var id = removeSymbols(url.substr(21));
			cb(album('http://i.qkme.me/${id}.jpg'));
		} else if(url.startsWith("memecrunch.com/meme/")) {
			var id = url;
			if(id.charAt(id.length-1) != "/")
				id += "/";
			cb(album('http://${id}image.jpg'));
		} else if(url.startsWith("memegenerator.net/instance/")) {
			var id = removeSymbols(url.substr(27));
			cb(album('http://cdn.memegenerator.net/instances/400x/${id}.jpg'));
		} else if(url.startsWith("imgflip.com/i/")) {
			var id = removeSymbols(url.substr(14));
			cb(album('http://i.imgflip.com/${id}.jpg'));
		} else if(ourl.indexOf(".deviantart.com/art/") != -1 || (ourl.indexOf(".deviantart.com/") != -1 && ourl.indexOf("#/d") != -1) || ourl.indexOf("fav.me") != -1) {
			Reditn.getJSONP('http://backend.deviantart.com/oembed?url=${ourl.urlEncode()}&format=jsonp&callback=', function(d) {
				cb(album(d.url, '${d.title} by ${d.author_name}'));
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
				cb(album(largest));
			});
		} else {
			cb(album(ourl));
		}
	}
	public static function preload(url) {
		var link:LinkElement = Browser.document.createLinkElement();
		link.href = url;
		link.rel = "preload";
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
		return if(s.lastIndexOf("?") != -1)
			s.substr(0, s.lastIndexOf("?"));
		else if(s.lastIndexOf("/") != -1)
			s.substr(0, s.lastIndexOf("/"));
		else if(s.lastIndexOf("#") != -1)
			s.substr(0, s.lastIndexOf("#"));
		else
			s;
	}
}
