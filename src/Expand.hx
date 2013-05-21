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
			var e:Element = cast Reditn.getLinkContainer(l).getElementsByClassName("entry")[0];
			var btn = Link.createButton(l.href, e, cast e.getElementsByClassName("tagline")[0], cast e.getElementsByClassName("buttons")[0].nextSibling);
			if(btn == null)
				defaultButton(e);
			else {

			}
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
		exp.style.width = exp.style.height = "23px";
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