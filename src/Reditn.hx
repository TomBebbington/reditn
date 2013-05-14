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
		links = [for(l in links) if(l.nodeName.toLowerCase() == "a" && untyped l.parentNode.className != "parent") {
			Reditn.expandURL(l.href, function(url) {
				l.href = url;
				if(l.onchange != null)
					l.onchange(null);
			});
			l;
		}];
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
	static function expandURL(ourl:String, cb:String->Void):Void {
		var url = Link.trimURL(ourl);
		if (url.indexOf("/") == -1)
			cb(ourl);
		else {
			url = url.substr(0, url.indexOf("/"));
			switch(url) {
				case "0rz.tw", "1link.in", "1url.com", "2.gp", "2big.at", "2tu.us", "3.ly", "307.to", "4ms.me", "4sq.com", "4url.cc", "6url.com", "7.ly", "a.gg", "a.nf", "aa.cx", "abcurl.net", "ad.vu", "adf.ly", "adjix.com", "afx.cc", "all.fuseurl.com", "alturl.com", "amzn.to", "ar.gy", "arst.ch", "atu.ca", "azc.cc", "b23.ru", "b2l.me", "bacn.me", "bcool.bz", "binged.it", "bit.ly", "bizj.us", "bloat.me", "bravo.ly", "bsa.ly", "budurl.com", "canurl.com", "chilp.it", "chzb.gr", "cl.lk", "cl.ly", "clck.ru", "cli.gs", "cliccami.info", "clickthru.ca", "clop.in", "conta.cc", "cort.as", "cot.ag", "crks.me", "ctvr.us", "cutt.us", "dai.ly", "decenturl.com", "dfl8.me", "digbig.com", "digg.com", "disq.us", "dld.bz", "dlvr.it", "do.my", "doiop.com", "dopen.us", "easyuri.com", "easyurl.net", "eepurl.com", "eweri.com", "fa.by", "fav.me", "fb.me", "fbshare.me", "ff.im", "fff.to", "fire.to", "firsturl.de", "firsturl.net", "flic.kr", "flq.us", "fly2.ws", "fon.gs", "freak.to", "fuseurl.com", "fuzzy.to", "fwd4.me", "fwib.net", "g.ro.lt", "gizmo.do", "gl.am", "go.9nl.com", "go.ign.com", "go.usa.gov", "goo.gl", "goshrink.com", "gurl.es", "hex.io", "hiderefer.com", "hmm.ph", "href.in", "hsblinks.com", "htxt.it", "huff.to", "hulu.com", "hurl.me", "hurl.ws", "icanhaz.com", "idek.net", "ilix.in", "is.gd", "its.my", "ix.lt", "j.mp", "jijr.com", "kl.am", "klck.me", "korta.nu", "krunchd.com", "l9k.net", "lat.ms", "liip.to", "liltext.com", "linkbee.com", "linkbun.ch", "liurl.cn", "ln-s.net", "ln-s.ru", "lnk.gd", "lnk.ms", "lnkd.in", "lnkurl.com", "lru.jp", "lt.tl", "lurl.no", "macte.ch", "mash.to", "merky.de", "migre.me", "miniurl.com", "minurl.fr", "mke.me", "moby.to", "moourl.com", "mrte.ch", "myloc.me", "myurl.in", "n.pr", "nbc.co", "nblo.gs", "nn.nf", "not.my", "notlong.com", "nsfw.in", "nutshellurl.com", "nxy.in", "nyti.ms", "o-x.fr", "oc1.us", "om.ly", "omf.gd", "omoikane.net", "on.cnn.com", "on.mktw.net", "onforb.es", "orz.se", "ow.ly", "ping.fm", "pli.gs", "pnt.me", "politi.co", "post.ly", "pp.gg", "profile.to", "ptiturl.com", "pub.vitrue.com", "qlnk.net", "qte.me", "qu.tc", "qy.fi", "r.im", "rb6.me", "read.bi", "readthis.ca", "reallytinyurl.com", "redir.ec", "redirects.ca", "redirx.com", "retwt.me", "ri.ms", "rickroll.it", "riz.gd", "rt.nu", "ru.ly", "rubyurl.com", "rurl.org", "rww.tw", "s4c.in", "s7y.us", "safe.mn", "sameurl.com", "sdut.us", "shar.es", "shink.de", "shorl.com", "short.ie", "short.to", "shortlinks.co.uk", "shorturl.com", "shout.to", "show.my", "shrinkify.com", "shrinkr.com", "shrt.fr", "shrt.st", "shrten.com", "shrunkin.com", "simurl.com", "slate.me", "smallr.com", "smsh.me", "smurl.name", "sn.im", "snipr.com", "snipurl.com", "snurl.com", "sp2.ro", "spedr.com", "srnk.net", "srs.li", "starturl.com", "su.pr", "surl.co.uk", "surl.hu", "t.cn", "t.co", "t.lh.com", "ta.gd", "tbd.ly", "tcrn.ch", "tgr.me", "tgr.ph", "tighturl.com", "tiniuri.com", "tiny.cc", "tiny.ly", "tiny.pl", "tinylink.in", "tinyuri.ca", "tinyurl.com", "tk.", "tl.gd", "tmi.me", "tnij.org", "tnw.to", "tny.com", "to.", "to.ly", "togoto.us", "totc.us", "toysr.us", "tpm.ly", "tr.im", "tra.kz", "trunc.it", "twhub.com", "twirl.at", "twitclicks.com", "twitterurl.net", "twitterurl.org", "twiturl.de", "twurl.cc", "twurl.nl", "u.mavrev.com", "u.nu", "u76.org", "ub0.cc", "ulu.lu", "updating.me", "ur1.ca", "url.az", "url.co.uk", "url.ie", "url360.me", "url4.eu", "urlborg.com", "urlbrief.com", "urlcover.com", "urlcut.com", "urlenco.de", "urli.nl", "urls.im", "urlshorteningservicefortwitter.com", "urlx.ie", "urlzen.com", "usat.ly", "use.my", "vb.ly", "vgn.am", "vl.am", "vm.lc", "w55.de", "wapo.st", "wapurl.co.uk", "wipi.es", "wp.me", "x.vu", "xr.com", "xrl.in", "xrl.us", "xurl.es", "xurl.jp", "y.ahoo.it", "yatuc.com", "ye.pe", "yep.it", "yfrog.com", "yhoo.it", "yiyd.com", "youtu.be", "yuarel.com", "z0p.de", "zi.ma", "zi.mu", "zipmyurl.com", "zud.me", "zurl.ws", "zz.gd", "zzang.kr", "r.ebay.com": 
					var surl = StringTools.urlEncode(ourl);
					Reditn.getJSON('http://api.longurl.org/v2/expand?url=${surl}&format=json&User-Agent=Reditn', function(data) {
						cb(Reflect.field(data, "long-url"));
					});
				default: cb(ourl);
			}
		}
	}
	public static function embedAlbum(a:data.Album):SpanElement {
		var span = Browser.document.createSpanElement();
		span.style.textAlign = "center";
		span.className = "expando";
		var imgs = [for(i in a) {
			var i = Expand.loadImage(i.url);
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
			if(i.caption != null) 
				caption.innerHTML = StringTools.htmlEscape(i.caption);
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
			h.onData = func;
			if(postData != null)
				h.setPostData(postData);
			h.request(postData != null);
		#else
			var heads:Dynamic = {
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
	public static function getJSON<T>(url:String, func:T->Void, ?auth:String, type:String="application/json", ?postData:String):Void {
		getText(url, function(data:String) {
			if(data.startsWith("jsonFlickrApi(") && data.endsWith(")"))
				data = data.substring(14, data.length - 1);
			try func(getData(haxe.Json.parse(data))) catch(e:Dynamic) {
				try func(getData(untyped JSON.parse(data))) catch(e:Dynamic) {
					trace('Error getting "${url}" - could not parse ${data}');
				}
			}
		}, auth, type, postData);
	}
	public static function popUp(bs:Element, el:Element, x:Float=0, y:Float=0) {
		Browser.document.body.appendChild(el);
		el.className="popup";
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