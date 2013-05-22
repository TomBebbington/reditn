import js.html.*;
import js.Browser;
import data.*;
import haxe.Json;
using StringTools;
@:expose class Reditn {
	static inline var USER_AGENT = "Reditn - the basic reddit plugin";
	static inline var year = 31557600;
	static inline var month = 2629800;
	static inline var day = 86400;
	static inline var hour = 3600;
	public static var links:Array<AnchorElement> = null;
	public static var fullPage:Bool = true;
	static function main() {
		switch(Browser.document.readyState) {
			case "complete": init();
			default: Browser.window.onload = function(_) init();
		}
	}
	public static inline function getLinkContainer(l:Element):Element {
		return l.parentElement.parentElement.parentElement;
	}
	public static inline function scroll(x:Int, y:Int):Void {
		Browser.window.scrollBy(x - Browser.window.scrollX, y - Browser.window.scrollY);
	}
	public static function getThingId(e:Node):String {
		var cn:String = untyped e.className;
		for(v in cn.split(" "))
			if(v.startsWith("id-"))
				return v.substr(3);
		return null;
	}
	public static function refreshLinks() {
		links = cast Browser.document.body.getElementsByClassName("title");
		links = [for(l in links) if(l.nodeName.toLowerCase() == "a" && untyped l.parentElement.className != "parent") l ];
	}
	static function init() {
		if(Browser.window.location.href.indexOf("reddit.") == -1)
			return;
		links = [];
		fullPage = Browser.document.getElementsByClassName("tabmenu").length > 0;
		wrap(Settings.init);
		wrap(Adblock.init, Settings.ADBLOCK);
		wrap(DuplicateHider.init, Settings.DUPLICATE_HIDER);
		wrap(NSFWFilter.init, Settings.FILTER_NSFW);
		refreshLinks();
		Style.init();
		wrap(AutoScroll.init, Settings.AUTO_SCROLL);
		wrap(Expand.init, Settings.EXPAND);
		wrap(TextExpand.init, Settings.TEXT_EXPAND);
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
			for(btn in Expand.buttons) {
				var ex = state.expanded;
				if(ex.exists(btn.url))
					btn.toggle(ex.get(btn.url), false);
			}
		}
	}
	static function state():State {
		var exp = new Map();
		for(btn in Expand.buttons){
			if(btn.toggled() != Expand.toggled)
				exp.set(btn.url, btn.toggled());
		}
		return {
			allExpanded: Expand.toggled,
			expanded: exp
		};
	}
	public static inline function pushState(?url:String) {
		Browser.window.history.pushState(haxe.Serializer.run(state()), null, url);
	}
	static function wrap(fn:Void->Void, ?id:String) {
		var d = id == null ? null : Settings.data.get(id);
		if(id == null || d)
			fn();
	}
	public static function formatNumber(n:Float):String {
		return if (!Math.isFinite(n))
			Std.string(n);
		else {
			var s = Std.string(Math.abs(n));
			var ad = s.indexOf(".") != -1 ? {
				var t = s.substr(s.indexOf("."));
				s = s.substr(0, s.indexOf("."));
				t;
			} : "";
			if (s.length >= 3) {
				var ns = "";
				for(i in 0...s.length) {
					ns += s.charAt(i);
					if((s.length - (i + 1)) % 3 == 0 && i < s.length-1)
						ns += ",";
				}
				s = ns;
			}
			(n < 0 ? "-"+s:s)+ad;
		}
	}
	public static function formatPrice(n:Float):String {
		var first = formatNumber(Std.int(n));
		var last = Std.string(n);
		last = last.indexOf(".") == -1 ? "." : last.substr(last.indexOf("."));
		while(last.length < 3)
			last += "0";
		return '${first}${last}';
	}
	static inline function plural(n:Int) {
		return n <= 1 ? "" : "s";
	}
	public static inline function show(e:Element, shown:Bool):Void {
		e.style.display = shown ? "": "none";
		if(e.className.indexOf("link") != -1 && !shown) {
			var en:Element = cast e.getElementsByClassName("entry")[0];
			links.remove(cast en.getElementsByTagName("a")[0]);
		}
	}
	public static inline function remove(e:Element):Void {
		e.parentElement.removeChild(e);
	}
	public static inline function insertAfter(ref:Element, after:Element) {
		after.parentElement.insertBefore(ref, after.nextSibling);
	}
	public static function age(t:Float):String {
		if(t < day)
			return "less than a day";
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
	public static function embedAlbum(a:data.Album):SpanElement {
		var span = Browser.document.createSpanElement();
		span.style.textAlign = "center";
		//span.className = "expando";
		var imgs = [for(im in a) {
			var i = Expand.loadImage(im.url);
			i.title = (im.caption != null ? im.caption + " " : "") + (im.author != null ? 'by ${im.author}' : "");
			span.appendChild(i);
			Reditn.show(cast i, false);
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
			span.appendChild(prev);
			info = Browser.document.createSpanElement();
			info.style.textAlign = "center";
			info.style.paddingLeft = info.style.paddingRight = "5px";
			span.appendChild(info);
			next = Browser.document.createButtonElement();
			next.innerHTML = "Next";
			span.appendChild(next);
		}
		if(a.length > 1 || (a[0].caption != null && a[0].caption.length > 0)) {
			span.appendChild(caption);
			span.appendChild(Browser.document.createBRElement());
		}
		function switchImage(ind:Int) {
			if(ind < 0 || ind >= a.length)
				return;
			var i = a[ind];
			var height = null;
			if(img != null) {
				Reditn.show(img, false);
				height = Std.parseInt(img.style.height);
			}
			img = imgs[ind];
			img.style.display = "block";
			if(height != null) {
				var ratio = img.width / img.height;
				img.style.height = height + "px";
				img.style.width = Std.int(height * ratio) + "px";
			}
			span.appendChild(img);
			if(prev != null) {
				var len = Reditn.formatNumber(a.length);
				var curr = Reditn.formatNumber(ind+1);
				info.innerHTML = '$curr of $len';
				prev.disabled = ind <= 0;
				next.disabled = ind >= a.length-1;
			}
			Reditn.show(caption, i.caption != null);
			if(i.caption != null) {
				caption.innerHTML = StringTools.htmlEscape(i.caption);
				if(i.author != null)
					caption.innerHTML += ' <em>by ${i.author}</em>';
			}
		}
		switchImage(0);
		if(prev != null) {
			prev.onmousedown = function(_) switchImage(--currentIndex);
			next.onmousedown = function(_) switchImage(++currentIndex);
		}
		return span;
	}
	public static function getData(o:Dynamic):Dynamic {
		while(o.data != null)
			o = o.data;
		while(o.response != null)
			o = o.response;
		return o;
	}
	public static inline function getText(url:String, func:String->Void, ?auth:String, ?type:String, ?postData:String):Void {
		#if plugin
			var h = new haxe.Http(url);
			if(auth != null)
				h.setHeader("Authorization", auth);
			if(type != null)
				h.setHeader("Content-Type", type);
			//h.setHeader("User-Agent", USER_AGENT);
			h.onData = func;
			if(postData != null)
				h.setPostData(postData);
			h.request(postData != null);
		#else
			var heads:Dynamic = {
				//"User-Agent": USER_AGENT
			};
			if(auth != null)
				heads.Authorization = auth;
			if(type != null)
				Reflect.setField(heads, "Content-Type", type);
			untyped GM_xmlhttpRequest({
				method: postData != null ? "POST" : "GET",
				headers: heads,
				data: postData,
				url: url,
				onload: function(rsp:Dynamic) {
					func(rsp.responseText);
				}
			});
		#end
	}
	public static function getMonthYear(d:Date):String {
		var month = switch(d.getMonth()) {
			case 0: "January";
			case 1: "February";
			case 2: "March";
			case 3: "April";
			case 4: "May";
			case 5: "June";
			case 6: "July";
			case 7: "August";
			case 8: "September";
			case 9: "October";
			case 10: "November";
			case 11: "December";
			case _: null;
		}, year = Std.string(d.getFullYear());
		return '$month, $year';
	}
	public static function embedMap(m:Map<String, String>):js.html.DListElement {
		var e = js.Browser.document.createDListElement();
		for(k in m.keys()) {
			if(m.get(k) != null && m.get(k).length > 0) {
				var keye = Browser.document.createElement("dt");
				keye.innerHTML = k;
				e.appendChild(keye);
				var keyv = Browser.document.createElement("dd");
				keyv.innerHTML = m.get(k);
				e.appendChild(keyv);
			}
		}
		e.className = "md reditn-table";
		return e;
	}
	public static function getJSON<T>(url:String, func:T->Void, ?auth:String, type:String="application/json", ?postData:String):Void {
		getText(url, function(data:String) {
			if(data.startsWith("jsonFlickrApi(") && data.endsWith(")"))
				data = data.substring(14, data.length - 1);
			func(getData(haxe.Json.parse(data)));
		}, auth, type, postData);
	}
	public static function getXML<T>(url:String, func:T->Void, ?auth:String, type:String="application/json", ?postData:String):Void {
		getText(url, function(data:String) {
			func(getData(Xml.parse(data)));
		}, auth, type, postData);
	}
	public static function popUp(bs:Element, el:Element, x:Float=0, y:Float=0) {
		Browser.document.body.appendChild(el);
		el.className = "popup";
		el.style.position = "absolute";
		el.style.width = Std.int(Browser.window.innerWidth*0.25)+"px";
		el.style.left = '${x}px';
		el.style.top = '${y - 30}px';
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