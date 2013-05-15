import js.*;
import js.html.*;
import haxe.Timer;
import haxe.*;
import data.*;
using StringTools;
class Expand {
	public static var maxWidth(get, null):Int;
	public static var maxHeight(get, null):Int;
	public static var maxArea(get, null):Int;
	public static var buttons:Array<Button> = [];
	public static var toggled(default, null):Bool;
	public static var button(default, null):AnchorElement = null;
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
			Reditn.pushState(toggled ? "#showall":"#");
		}
		li.appendChild(button);
		if(menu != null)
			menu.appendChild(li);
		for(l in Reditn.links) {
			if(l.nodeName.toLowerCase()!="a")
				continue;
			l.onchange = function(_) {
				var site = Link.resolve(l.href);
				if(site == null)
					defaultButton(Reditn.getLinkContainer(l));
				else
					site.method(site.regex, function(data:Dynamic) {
						var e = Reditn.getLinkContainer(l);
						var exp = Browser.document.createDivElement();
						exp.className = "expando";
						exp.style.display = "none";
						Reditn.show(exp, toggled);
						var name = "selftext";
						if(Reflect.hasField(data, "price")) {
							var i:ShopItem = data;
							var div = Browser.document.createDivElement();
							div.className = "usertext";
							exp.appendChild(div);
							var head = null;
							var cont = Browser.document.createDivElement();
							var inner = Browser.document.createSpanElement();
							inner.innerHTML = //'<h2>${StringTools.htmlEscape(i.title)}</h2><br>' + 
							'<b>Category:</b> ${StringTools.htmlEscape(i.category)}<br>' + 
							'<b>Location:</b> ${StringTools.htmlEscape(i.location)}<br>' + 
							'<b>Price:</b> ${StringTools.htmlEscape(i.price)}<br>' +
							'<p>${i.description}</p>';
							cont.appendChild(inner);
							cont.className = "md";
							cont.appendChild(Reditn.embedAlbum(i.images));
							div.appendChild(cont);
							name = "item";
						} else if(Reflect.hasField(data, "content")) { // article
							var a:Article = data;
							var div = Browser.document.createDivElement();
							div.className = "usertext";
							exp.appendChild(div);
							var head = null;
							var content = Browser.document.createDivElement();
							var inner = Browser.document.createSpanElement();
							inner.innerHTML = a.content;
							content.appendChild(inner);
							if(a.images.length > 0) {
								content.appendChild(Browser.document.createBRElement());
								content.appendChild(Reditn.embedAlbum(a.images));
							}
							content.className = "md";
							div.appendChild(content);
						} else if(Std.is(data, Array) && Reflect.hasField(untyped data[0], "url")) {
							var a:Album = data;
							var div = Reditn.embedAlbum(a);
							exp.appendChild(div);
							name = "image";
						} else if(Reflect.hasField(data, "developers")) {
							var r:Repo = data;
							trace('Repository: $r');
							var div = js.Browser.document.createDivElement();
							div.className = "usertext";
							var cont = Browser.document.createDivElement();
							var inner = Browser.document.createSpanElement();
							inner.innerHTML = '${data.description}<br><a href="${data.url}"><b>Clone repo</b></a><br>';
							if(r.album != null && r.album.length > 0)
								inner.appendChild(Reditn.embedAlbum(r.album));
							cont.appendChild(inner);
							cont.className = "md";
							div.appendChild(cont);
							exp.appendChild(div);
						} else
							defaultButton(e);
						var s = createButton(e, name, l.href);
						var pn:Element = s.parentElement;
						for(ep in pn.getElementsByClassName("expando"))
							pn.removeChild(ep);
						pn.appendChild(exp);
					});
				refresh();
			};
			l.onchange(null);
		}
	}
	static inline function defaultButton(cont:Element):Void {
		var one = false;
		for(be in cont.getElementsByClassName("expando-button")) {
			if(one)
				be.parentNode.removeChild(be);
			else {
				if(be != null)
					buttons.push(adaptButton(cast be));
				one = true;
			}
		}
	}
	static function adaptButton(exp:DivElement):Button {
		return {
			toggled: function():Bool {
				return exp.className.indexOf("expanded") != -1;
			},
			toggle: function(v) {
				var c = exp.className.indexOf("expanded") != -1;
				if(v != c)
					exp.onclick(null);
			},
			url: cast(exp.parentElement.getElementsByTagName("a")[0], js.html.AnchorElement).href,
			element: exp
		};
	}
	static function createButton(e:Element, extra:String, url:String):DivElement {
		var d = js.Browser.document.createDivElement();
		var cn = 'expando-button $extra ';
		d.className = '$cn collapsed';
		var isToggled = false;
		var btn = {
			toggled: function():Bool {
				return isToggled;
			},
			toggle: function(v) {
				isToggled = v;
				d.className = cn + (isToggled ? "expanded" : "collapsed");
				var entry:Element = d.parentElement;
				var expandos:Array<Element> = cast entry.getElementsByClassName("expando");
				for(e in expandos)
					Reditn.show(e, v);
			},
			url: url,
			element: d
		};
		d.onclick = function(_) {
			btn.toggle(!isToggled);
		}
		var tagline:Element = untyped e.getElementsByClassName("tagline")[0];
		tagline.parentNode.insertBefore(d, tagline);
		buttons.push(btn);

		if(Expand.toggled)
			btn.toggle(true);
		return d;
	}
	public static function refresh() {
		if(button != null) {
			button.innerHTML = '${toggled?"hide":"show"} all';
			var nextprev:Element = cast js.Browser.document.body.getElementsByClassName("nextprev")[0];
			nextprev.getElementsByTagName("a");
			var np:Array<js.html.AnchorElement> = [];
			for(link in nextprev.getElementsByTagName("a"))
				np.push(cast link);
			for(i in np) {
				if(i.nodeName.toLowerCase() != "a")
					continue;
				if(toggled && i.href.indexOf("#") == -1)
					i.href += "#showall";
				else if(!toggled && i.href.indexOf("#") != -1)
					i.href = i.href.substr(0, i.href.indexOf("#"));
			}
			Reditn.show(button, buttons.length > 0);
		}
	}
	public static function toggle(t:Bool) {
		toggled = t;
		for(btn in buttons)
			btn.toggle(t);
		refresh();
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
}