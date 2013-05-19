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
						if(Reflect.hasField(data, "urls")) { // profile
							var p:data.Profile = data;
							var urls = [for(uk in p.urls.keys()) '<li><a href="${p.urls.get(uk)}">${uk}</a></li>'];
							var div = Browser.document.createDivElement();
							div.className = "usertext";
							exp.appendChild(div);
							var content = Browser.document.createDivElement();
							content.appendChild(Reditn.embedMap([
								"Name" => data.name,
								"Description" => data.description,
								"Links" => urls.join("")
							]));
							if(p.album.length > 0) {
								content.appendChild(Browser.document.createBRElement());
								content.appendChild(Reditn.embedAlbum(p.album));
							}
							div.appendChild(content);
						} else if(Reflect.hasField(data, "price")) {
							var i:ShopItem = data;
							var div = Browser.document.createDivElement();
							div.className = "usertext";
							exp.appendChild(div);
							var cont = Browser.document.createDivElement();
							cont.appendChild(Reditn.embedMap([
								"Category" => i.category.htmlEscape(),
								"Location" => i.location.htmlEscape(),
								"Price" => i.price.htmlEscape(),
								"Description" => i.description
							]));
							cont.appendChild(Reditn.embedAlbum(i.images));
							div.appendChild(cont);
							name = "item";
						} else if(Reflect.hasField(data, "subscribers")) { // subreddit
							var s:data.Subreddit = data;
							var div = Browser.document.createDivElement();
							div.className = "usertext";
							exp.appendChild(div);
							var content = Reditn.embedMap([
								"Age" => Reditn.age(s.created_utc),
								"Subscribers" => Reditn.formatNumber(s.subscribers),
								"Active users" => Reditn.formatNumber(s.accounts_active),
								"Description" => parser.Markdown.parse(s.description)
							]);
							div.appendChild(content);
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
				if(be != null) {
					var b = adaptButton(cast be);
					b.toggle(Expand.toggled, false);
					buttons.push(b);
				}

				one = true;
			}
		}
	}
	static var queue:Int = 0;
	static inline function delay():Int {
		return queue * 1000;
	}
	static function adaptButton(exp:DivElement):Button {
		var url = cast(exp.parentElement.getElementsByTagName("a")[0], js.html.AnchorElement).href;
		return {
			toggled: function():Bool {
				return exp.className.indexOf("expanded") != -1;
			},
			toggle: function(v, ps) {
				var c = exp.className.indexOf("expanded") != -1;
				if(v != c)
					exp.onclick(null);
				queue++;
				function check() {
					if(exp.parentElement.getElementsByClassName("error").length > 0) {
						exp.onclick(null);
						exp.onclick(null);
					} else
						queue--;
				}
				Timer.delay(function() check(), delay());
				if(ps)
					Reditn.pushState();
			},
			url: url,
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
			toggle: function(v, ps) {
				isToggled = v;
				d.className = cn + (isToggled ? "expanded" : "collapsed");
				var entry:Element = d.parentElement;
				var expandos:Array<Element> = cast entry.getElementsByClassName("expando");
				for(e in expandos)
					Reditn.show(e, v);
				if(ps)
					Reditn.pushState();
			},
			url: url,
			element: d
		};
		d.onclick = function(_) {
			btn.toggle(!isToggled, true);
		}
		var tagline:Element = untyped e.getElementsByClassName("tagline")[0];
		tagline.parentNode.insertBefore(d, tagline);
		buttons.push(btn);
		if(Expand.toggled)
			btn.toggle(true, false);
		return d;
	}
	public static function refresh() {
		if(button != null) {
			button.innerHTML = '${toggled?"hide":"show"} all';
			var nps:Array<Element> = cast Browser.document.body.getElementsByClassName("nextprev");
			for(np in nps) {
				var np:Array<AnchorElement> = [for(l in np.getElementsByTagName("a")) cast l];
				for(i in np) {
					if(i.nodeName.toLowerCase() != "a")
						continue;
					if(toggled && i.href.indexOf("#") == -1)
						i.href += "#showall";
					else if(!toggled && i.href.indexOf("#") != -1)
						i.href = i.href.substr(0, i.href.indexOf("#"));
				}
			}
		}
	}
	public static function toggle(t:Bool) {
		toggled = t;
		for(btn in buttons)
			btn.toggle(t, false);
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
	public static function initResize(i:ImageElement):Void {
		var drx = 0.0, dry = 0.0, rt = 0.0, ow = 0, oh = 0;
		var drag = false;
		i.addEventListener("mousedown", function(ev:MouseEvent) {
			if(!ev.altKey && !ev.ctrlKey && !ev.metaKey) {
				drag = true;
				var cr = i.getBoundingClientRect();
				var relx = ev.clientX - cr.left, rely = ev.clientY - cr.top;
				var ev:MouseEvent = cast ev;
				drx = i.offsetWidth / relx;
				dry = i.offsetHeight / rely;
				rt = i.offsetWidth / i.offsetHeight;
				ev.preventDefault();
			}
		});
		i.addEventListener("mousemove", function(ev:MouseEvent) {
			if(drag) {
				var cr = i.getBoundingClientRect();
				var relx = ev.clientX - cr.left, rely = ev.clientY - cr.top;
				var nw = relx * drx;
				var nwh = nw / rt;
				var nh = rely * dry;
				var nhw = nh * rt;
				i.width = Std.int(nwh > nh || nw > nhw ? nw : nhw);
				i.height = Std.int(nwh > nh|| nw > nhw ? nwh : nh);
				ev.preventDefault();
			}
		});
		i.addEventListener("dblclick", function(e:MouseEvent) {
			i.width = i.naturalWidth;
			i.height = i.naturalHeight;
		});
		i.addEventListener("mouseup", function(e:MouseEvent) {
			drag = false;
			e.preventDefault();
		});
		i.addEventListener("mouseout", function(e:MouseEvent) {
			drag = false;
			e.preventDefault();
		});
	}
}