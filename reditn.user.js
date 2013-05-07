// ==UserScript==
// @name			Reditn
// @namespace		http://userscripts.org/user/tophattedcoder/
// @description		Reddit tweaks and enhancements.
// @downloadURL		https://github.com/TopHattedCoder/reditn/raw/master/reditn.user.js
// @include			reddit.com
// @include			reddit.com/*
// @include			*.reddit.com
// @include			*.reddit.com/*
// @version			1.5.7
// @grant			none
// ==/UserScript==

(function () { "use strict";
var $hxClasses = {},$estr = function() { return js.Boot.__string_rec(this,''); };
var Adblock = function() { }
$hxClasses["Adblock"] = Adblock;
Adblock.__name__ = ["Adblock"];
Adblock.init = function() {
	Adblock.hideAll(js.Browser.document.body.getElementsByClassName("promoted"));
	Adblock.hideAll(js.Browser.document.body.getElementsByClassName("infobar"));
	Adblock.hideAll(js.Browser.document.body.getElementsByClassName("goldvertisement"));
	var help = js.Browser.document.getElementById("spotlight-help");
	if(help != null) {
		var link = help.parentNode.parentNode;
		Reditn.show(link,false);
	}
	var sidebarAd = js.Browser.document.getElementById("ad-frame");
	if(sidebarAd != null) {
		sidebarAd.style.display = "none";
		if(sidebarAd.className.indexOf("link") != -1) HxOverrides.remove(Reditn.links,sidebarAd.getElementsByClassName("entry")[0].getElementsByTagName("a")[0]);
	}
}
Adblock.hideAll = function(a) {
	var _g1 = 0, _g = a.length;
	while(_g1 < _g) {
		var i = _g1++;
		Reditn.show(a[i],false);
	}
}
var DuplicateHider = function() { }
$hxClasses["DuplicateHider"] = DuplicateHider;
DuplicateHider.__name__ = ["DuplicateHider"];
DuplicateHider.init = function() {
	var seen = [];
	var _g = 0, _g1 = Reditn.links;
	while(_g < _g1.length) {
		var link = _g1[_g];
		++_g;
		if(link.nodeName.toLowerCase() != "a") continue;
		if(Lambda.has(seen,link.href)) Reditn.show(link.parentNode.parentNode.parentNode,false); else seen.push(link.href);
	}
}
var EReg = function(r,opt) {
	opt = opt.split("u").join("");
	this.r = new RegExp(r,opt);
};
$hxClasses["EReg"] = EReg;
EReg.__name__ = ["EReg"];
EReg.prototype = {
	replace: function(s,by) {
		return s.replace(this.r,by);
	}
	,__class__: EReg
}
var Expand = function() { }
$hxClasses["Expand"] = Expand;
Expand.__name__ = ["Expand"];
Expand.get_expanded = function() {
	return Expand.toggled?[]:(function($this) {
		var $r;
		var _g = [];
		{
			var _g1 = 0, _g2 = Expand.buttons;
			while(_g1 < _g2.length) {
				var b = _g2[_g1];
				++_g1;
				if(b.toggled()) _g.push(b.url);
			}
		}
		$r = _g;
		return $r;
	}(this));
}
Expand.set_expanded = function(e) {
	if(e.length == Expand.buttons.length) Expand.toggle(true); else if(e.length <= 0) Expand.toggle(false);
	var _g = 0, _g1 = Expand.buttons;
	while(_g < _g1.length) {
		var b = _g1[_g];
		++_g;
		var t = false;
		var _g2 = 0;
		while(_g2 < e.length) {
			var u = e[_g2];
			++_g2;
			t = t || b.url == u;
		}
		b.toggle(t,false);
	}
	return e;
}
Expand.init = function() {
	Expand.toggled = js.Browser.window.location.hash == "#showall";
	var menu = js.Browser.document.getElementsByClassName("tabmenu")[0];
	var li = js.Browser.document.createElement("li");
	Expand.button = js.Browser.document.createElement("a");
	Expand.button.href = "javascript:void(0);";
	Expand.refresh();
	Expand.button.onclick = function(e) {
		Expand.toggle(!Expand.toggled);
		js.Browser.window.history.pushState(haxe.Serializer.run(Reditn.state()),null,Expand.toggled?"#showall":null);
	};
	li.appendChild(Expand.button);
	if(menu != null) menu.appendChild(li);
	var _g = 0, _g1 = Reditn.links;
	while(_g < _g1.length) {
		var l = [_g1[_g]];
		++_g;
		if(l[0].nodeName.toLowerCase() != "a") continue;
		var urltype = Reditn.getLinkType(l[0].href);
		if(urltype == data.LinkType.IMAGE) Expand.getImageLink(l[0].href,l[0],(function(l) {
			return function(a) {
				var e = l[0].parentNode.parentNode;
				var div = js.Browser.document.createElement("div");
				var imgs = (function($this) {
					var $r;
					var _g2 = [];
					{
						var _g3 = 0;
						while(_g3 < a.length) {
							var i = a[_g3];
							++_g3;
							_g2.push((function($this) {
								var $r;
								var i1 = Expand.loadImage(i.url);
								div.appendChild(i1);
								{
									i1.style.display = "none";
									if(i1.className.indexOf("link") != -1) HxOverrides.remove(Reditn.links,i1.getElementsByClassName("entry")[0].getElementsByTagName("a")[0]);
								}
								$r = i1;
								return $r;
							}($this)));
						}
					}
					$r = _g2;
					return $r;
				}(this));
				var img = null;
				var caption = js.Browser.document.createElement("span");
				caption.style.fontWeight = "bold";
				caption.style.marginLeft = "10px";
				var currentIndex = 0;
				var prev = null, info = null, next = null;
				if(a.length > 1) {
					prev = js.Browser.document.createElement("button");
					prev.innerHTML = "Prev";
					div.appendChild(prev);
					info = js.Browser.document.createElement("span");
					info.style.textAlign = "center";
					info.style.paddingLeft = info.style.paddingRight = "5px";
					div.appendChild(info);
					next = js.Browser.document.createElement("button");
					next.innerHTML = "Next";
					div.appendChild(next);
				}
				if(a.length > 1 || a[0].caption != null && a[0].caption.length > 0) {
					div.appendChild(caption);
					div.appendChild(js.Browser.document.createElement("br"));
				}
				var switchImage = (function() {
					return function(ind) {
						if(ind < 0 || ind >= a.length) return;
						var i = a[ind];
						var height = null;
						if(img != null) {
							img.style.display = "none";
							if(img.className.indexOf("link") != -1) HxOverrides.remove(Reditn.links,img.getElementsByClassName("entry")[0].getElementsByTagName("a")[0]);
							height = img.height;
						}
						img = imgs[ind];
						img.style.display = "";
						if(img.className.indexOf("link") != -1) HxOverrides.remove(Reditn.links,img.getElementsByClassName("entry")[0].getElementsByTagName("a")[0]);
						if(height != null) {
							var ratio = img.width / img.height;
							img.height = height;
							img.width = height * ratio | 0;
						}
						div.appendChild(img);
						if(prev != null) {
							var len = Reditn.formatNumber(a.length);
							var curr = Reditn.formatNumber(ind + 1);
							info.innerHTML = "" + curr + " of " + len;
							prev.disabled = ind <= 0;
							next.disabled = ind >= a.length - 1;
						}
						caption.style.display = i.caption != null?"":"none";
						if(caption.className.indexOf("link") != -1) HxOverrides.remove(Reditn.links,caption.getElementsByClassName("entry")[0].getElementsByTagName("a")[0]);
						if(i.caption != null) caption.innerHTML = StringTools.htmlEscape(i.caption);
					};
				})();
				switchImage(0);
				if(prev != null) {
					prev.onmousedown = (function() {
						return function(_) {
							switchImage(--currentIndex);
						};
					})();
					next.onmousedown = (function() {
						return function(_) {
							switchImage(++currentIndex);
						};
					})();
				}
				e.appendChild(div);
				div.style.display = Expand.toggled?"":"none";
				if(div.className.indexOf("link") != -1) HxOverrides.remove(Reditn.links,div.getElementsByClassName("entry")[0].getElementsByTagName("a")[0]);
				var li1 = js.Browser.document.createElement("li");
				li1.className = "reditn-expand";
				var show = Expand.showButton(div,li1);
				Expand.buttons.push(show);
				var btns = e.getElementsByClassName("buttons")[0];
				if(btns != null) btns.insertBefore(li1,btns.childNodes[0]); else throw "Bad DOM";
				Expand.refresh();
			};
		})(l)); else Expand.preload(l[0].href);
	}
}
Expand.refresh = function() {
	if(Expand.button != null) {
		Expand.button.innerHTML = "" + (Expand.toggled?"hide":"show") + " images (" + Expand.buttons.length + ")";
		var np = [];
		var n = js.Browser.document.body.getElementsByClassName("next");
		var p = js.Browser.document.body.getElementsByClassName("prev");
		var _g = 0;
		while(_g < n.length) {
			var nl = n[_g];
			++_g;
			np.push(nl);
		}
		var _g = 0;
		while(_g < p.length) {
			var pl = p[_g];
			++_g;
			np.push(pl);
		}
		var _g = 0;
		while(_g < np.length) {
			var i = np[_g];
			++_g;
			if(i.nodeName.toLowerCase() != "a") continue;
			if(Expand.toggled && i.href.indexOf("#") == -1) i.href += "#showall"; else if(!Expand.toggled && i.href.indexOf("#") != -1) i.href = HxOverrides.substr(i.href,0,i.href.indexOf("#"));
		}
		Reditn.show(Expand.button,Expand.buttons.length > 0);
	}
}
Expand.toggle = function(t) {
	Expand.toggled = t;
	var _g = 0, _g1 = Expand.buttons;
	while(_g < _g1.length) {
		var btn = _g1[_g];
		++_g;
		btn.toggle(t,false);
	}
	Expand.refresh();
}
Expand.showButton = function(el,p) {
	var e = js.Browser.document.createElement("a");
	e.style.fontStyle = "italic";
	e.href = "javascript:void(0);";
	e.className = "toggle";
	var toggled = Expand.toggled;
	e.innerHTML = toggled?"hide":"show";
	e.toggle = function(t,st) {
		if(st == null) st = true;
		toggled = t == null?!toggled:t;
		e.innerHTML = toggled?"hide":"show";
		el.style.display = toggled?"":"none";
		if(el.className.indexOf("link") != -1) HxOverrides.remove(Reditn.links,el.getElementsByClassName("entry")[0].getElementsByTagName("a")[0]);
		if(st) js.Browser.window.history.pushState(haxe.Serializer.run(Reditn.state()),null,null);
	};
	e.toggled = function() {
		return toggled;
	};
	e.onclick = function(ev) {
		e.toggle();
	};
	p.appendChild(e);
	return e;
}
Expand.album = function(url,c) {
	return [{ url : url, caption : c}];
}
Expand.getImageLink = function(ourl,el,cb) {
	var url = ourl;
	if(StringTools.startsWith(url,"http://")) url = HxOverrides.substr(url,7,null); else if(StringTools.startsWith(url,"https://")) url = HxOverrides.substr(url,8,null);
	if(StringTools.startsWith(url,"www.")) url = HxOverrides.substr(url,4,null);
	if(url.indexOf("&") != -1) url = HxOverrides.substr(url,0,url.indexOf("&"));
	if(url.indexOf("?") != -1) url = HxOverrides.substr(url,0,url.indexOf("?"));
	if(StringTools.startsWith(url,"i.imgur.com/") && url.split(".").length == 3) cb([{ url : "http://" + url + ".jpg", caption : null}]); else if(StringTools.startsWith(url,"imgur.com/a/") || StringTools.startsWith(url,"imgur.com/gallery/")) {
		var id = url.split("/")[2];
		var albumType = url.indexOf("gallery") != -1?"gallery/album":"album";
		var req = new haxe.Http("https://api.imgur.com/3/" + albumType + "/" + id);
		req.setHeader("Authorization","Client-ID " + "cc1f254578d6c52");
		req.onData = function(ds) {
			var d = Reditn.getData(haxe.Json.parse(ds));
			var album = [];
			if(d.images_count <= 0) album.push({ url : "http://i.imgur.com/" + d.id + ".jpg", caption : d.title}); else {
				var _g = 0, _g1 = d.images;
				while(_g < _g1.length) {
					var i = _g1[_g];
					++_g;
					album.push({ url : "http://i.imgur.com/" + i.id + ".jpg", caption : i.title});
				}
			}
			cb(album);
		};
		req.request(false);
	} else if(StringTools.startsWith(url,"imgur.com/")) {
		var id = Expand.removeSymbols(HxOverrides.substr(url,url.indexOf("/") + 1,null));
		cb(id.indexOf(",") != -1?id.split(",").map(function(nid) {
			return { url : "http://i.imgur.com/" + nid + ".jpg", caption : null};
		}):[{ url : "http://i.imgur.com/" + id + ".jpg", caption : null}]);
	} else if(StringTools.startsWith(url,"qkme.me/")) {
		var id = Expand.removeSymbols(HxOverrides.substr(url,8,null));
		cb([{ url : "http://i.qkme.me/" + id + ".jpg", caption : null}]);
	} else if(StringTools.startsWith(url,"quickmeme.com/meme/")) {
		var id = Expand.removeSymbols(HxOverrides.substr(url,19,null));
		cb([{ url : "http://i.qkme.me/" + id + ".jpg", caption : null}]);
	} else if(StringTools.startsWith(url,"m.quickmeme.com/meme/")) {
		var id = Expand.removeSymbols(HxOverrides.substr(url,21,null));
		cb([{ url : "http://i.qkme.me/" + id + ".jpg", caption : null}]);
	} else if(StringTools.startsWith(url,"memecrunch.com/meme/")) {
		var id = url;
		if(id.charAt(id.length - 1) != "/") id += "/";
		cb([{ url : "http://" + id + "image.jpg", caption : null}]);
	} else if(StringTools.startsWith(url,"memegenerator.net/instance/")) {
		var id = Expand.removeSymbols(HxOverrides.substr(url,27,null));
		cb([{ url : "http://cdn.memegenerator.net/instances/400x/" + id + ".jpg", caption : null}]);
	} else if(StringTools.startsWith(url,"imgflip.com/i/")) {
		var id = Expand.removeSymbols(HxOverrides.substr(url,14,null));
		cb([{ url : "http://i.imgflip.com/" + id + ".jpg", caption : null}]);
	} else if(StringTools.startsWith(url,"xkcd.com/")) {
		var id = Expand.removeSymbols(HxOverrides.substr(url,9,null));
		Reditn.getJSON("http://xkcd.com/" + id + "/info.0.json",function(data) {
			cb(Expand.album(data.img,data.title));
		});
	} else if(StringTools.startsWith(url,"livememe.com/")) {
		var id = Expand.removeSymbols(HxOverrides.substr(url,13,null));
		cb([{ url : "http://livememe.com/" + id + ".jpg", caption : null}]);
	} else if(ourl.indexOf(".deviantart.com/art/") != -1 || ourl.indexOf(".deviantart.com/") != -1 && ourl.indexOf("#/d") != -1 || ourl.indexOf("fav.me") != -1) Reditn.getJSON("http://backend.deviantart.com/oembed?url=" + StringTools.urlEncode(ourl) + "&format=json",function(d) {
		cb([{ url : d.url, caption : "" + d.title + " by " + d.author_name}]);
	}); else if(StringTools.startsWith(url,"flickr.com/photos/")) {
		var id = HxOverrides.substr(url,18,null);
		id = HxOverrides.substr(id,id.indexOf("/") + 1,null);
		id = HxOverrides.substr(id,0,id.indexOf("/"));
		Reditn.getJSON("http://api.flickr.com/services/rest/?method=flickr.photos.getSizes&api_key=" + "99dcc3e77bcd8fb489f17e58191f32f7" + "&photo_id=" + id + "&format=json",function(d) {
			if(d.sizes == null || d.sizes.size == null) return;
			var sizes = d.sizes.size;
			var largest = null;
			var largestSize = 0;
			var _g = 0;
			while(_g < sizes.length) {
				var s = sizes[_g];
				++_g;
				var size = Std.parseInt(s.width) * Std.parseInt(s.height);
				if(largest == null || size >= largestSize && size <= (js.Browser.window.innerWidth * 0.7 | 0) * (js.Browser.window.innerHeight * 0.6 | 0)) {
					largest = s.source;
					largestSize = size;
				}
			}
			if(largest == null) largest = sizes[0].source;
			cb([{ url : largest, caption : null}]);
		});
	} else cb([{ url : ourl, caption : null}]);
}
Expand.preload = function(url) {
	var link = js.Browser.document.createElement("link");
	link.href = url;
	link.rel = "preload";
	js.Browser.document.head.appendChild(link);
}
Expand.loadImage = function(url) {
	var img = js.Browser.document.createElement("img");
	img.src = url;
	img.className = "resize";
	Expand.initResize(img);
	var autosize = function() {
		if(img.width > (js.Browser.window.innerWidth * 0.7 | 0)) {
			var rt = img.height / img.width;
			img.width = js.Browser.window.innerWidth * 0.7 | 0;
			img.height = img.width * rt | 0;
		}
		if(img.height > (js.Browser.window.innerHeight * 0.6 | 0)) {
			var rt = img.width / img.height;
			img.height = js.Browser.window.innerHeight * 0.6 | 0;
			img.width = img.height * rt | 0;
		}
	};
	var t = new haxe.Timer(30);
	t.run = function() {
		if(img.width > 0 && img.height > 0) {
			t.stop();
			autosize();
		}
	};
	return img;
}
Expand.initResize = function(e) {
	var drx = 0.0, dry = 0.0, rt = 1.0;
	var drag = false;
	e.onmousedown = function(ev) {
		drag = true;
		var ev1 = ev;
		drx = e.offsetWidth / ev1.clientX;
		dry = e.offsetHeight / ev1.clientY;
		rt = e.offsetWidth / e.offsetHeight;
		ev1.preventDefault();
	};
	e.onmousemove = function(ev) {
		var ev1 = ev;
		if(drag) {
			var nw = ev1.clientX * drx;
			var nwh = nw / rt;
			var nh = ev1.clientY * dry;
			var nhw = nh * rt;
			e.width = (nwh > nh?nw:nhw) | 0;
			e.height = (nwh > nh?nwh:nh) | 0;
		}
		ev1.preventDefault();
	};
	e.onmouseup = e.onmouseout = function(ev) {
		drag = false;
		ev.preventDefault();
	};
}
Expand.removeSymbols = function(s) {
	return s.lastIndexOf("?") != -1?HxOverrides.substr(s,0,s.lastIndexOf("?")):s.lastIndexOf("/") != -1?HxOverrides.substr(s,0,s.lastIndexOf("/")):s.lastIndexOf("#") != -1?HxOverrides.substr(s,0,s.lastIndexOf("#")):s;
}
var GM = function() { }
$hxClasses["GM"] = GM;
$hxExpose(GM, "GM");
GM.__name__ = ["GM"];
GM.request = function(data) {
	GM_xmlhttpRequest(data);
}
var HxOverrides = function() { }
$hxClasses["HxOverrides"] = HxOverrides;
HxOverrides.__name__ = ["HxOverrides"];
HxOverrides.dateStr = function(date) {
	var m = date.getMonth() + 1;
	var d = date.getDate();
	var h = date.getHours();
	var mi = date.getMinutes();
	var s = date.getSeconds();
	return date.getFullYear() + "-" + (m < 10?"0" + m:"" + m) + "-" + (d < 10?"0" + d:"" + d) + " " + (h < 10?"0" + h:"" + h) + ":" + (mi < 10?"0" + mi:"" + mi) + ":" + (s < 10?"0" + s:"" + s);
}
HxOverrides.strDate = function(s) {
	switch(s.length) {
	case 8:
		var k = s.split(":");
		var d = new Date();
		d.setTime(0);
		d.setUTCHours(k[0]);
		d.setUTCMinutes(k[1]);
		d.setUTCSeconds(k[2]);
		return d;
	case 10:
		var k = s.split("-");
		return new Date(k[0],k[1] - 1,k[2],0,0,0);
	case 19:
		var k = s.split(" ");
		var y = k[0].split("-");
		var t = k[1].split(":");
		return new Date(y[0],y[1] - 1,y[2],t[0],t[1],t[2]);
	default:
		throw "Invalid date format : " + s;
	}
}
HxOverrides.cca = function(s,index) {
	var x = s.charCodeAt(index);
	if(x != x) return undefined;
	return x;
}
HxOverrides.substr = function(s,pos,len) {
	if(pos != null && pos != 0 && len != null && len < 0) return "";
	if(len == null) len = s.length;
	if(pos < 0) {
		pos = s.length + pos;
		if(pos < 0) pos = 0;
	} else if(len < 0) len = s.length + len - pos;
	return s.substr(pos,len);
}
HxOverrides.remove = function(a,obj) {
	var i = 0;
	var l = a.length;
	while(i < l) {
		if(a[i] == obj) {
			a.splice(i,1);
			return true;
		}
		i++;
	}
	return false;
}
HxOverrides.iter = function(a) {
	return { cur : 0, arr : a, hasNext : function() {
		return this.cur < this.arr.length;
	}, next : function() {
		return this.arr[this.cur++];
	}};
}
var Keyboard = function() { }
$hxClasses["Keyboard"] = Keyboard;
Keyboard.__name__ = ["Keyboard"];
Keyboard.get_highlighted = function() {
	return Keyboard.current == null?null:Reditn.links[Keyboard.current].parentNode.parentNode.parentNode;
}
Keyboard.init = function() {
	js.Browser.document.onkeydown = function(e) {
		Keyboard.keyDown(e.keyCode);
	};
}
Keyboard.unhighlight = function() {
	var h = Keyboard.get_highlighted();
	if(h != null) h.style.border = "";
}
Keyboard.highlight = function(dir) {
	Keyboard.unhighlight();
	if(Keyboard.current != null && Reditn.links[Keyboard.current + dir]) Keyboard.current += dir; else dir = 0;
	if(Keyboard.current == null) Keyboard.current = 0;
	var h = Keyboard.get_highlighted();
	h.style.border = "3px solid grey";
	h.scrollIntoView(true);
	h.focus();
}
Keyboard.show = function(s) {
	if(s == null) s = true;
	var h = Keyboard.get_highlighted();
	var tg = h.getElementsByClassName("toggle")[0];
	if(tg.toggle != null) tg.toggle(s); else {
		var btn = h.getElementsByClassName("expando-button")[0];
		if(btn != null && (s?btn.className.indexOf("expanded") == -1:btn.className.indexOf("expanded") != -1)) btn.onclick(null);
	}
	h.scrollIntoView(true);
	h.focus();
}
Keyboard.keyDown = function(c) {
	switch(c) {
	case 39:
		Keyboard.show(true);
		break;
	case 37:
		Keyboard.show(false);
		break;
	case 38:
		Keyboard.highlight(-1);
		break;
	case 40:
		Keyboard.highlight(1);
		break;
	}
}
var Lambda = function() { }
$hxClasses["Lambda"] = Lambda;
Lambda.__name__ = ["Lambda"];
Lambda.has = function(it,elt) {
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		if(x == elt) return true;
	}
	return false;
}
var List = function() {
	this.length = 0;
};
$hxClasses["List"] = List;
List.__name__ = ["List"];
List.prototype = {
	iterator: function() {
		return { h : this.h, hasNext : function() {
			return this.h != null;
		}, next : function() {
			if(this.h == null) return null;
			var x = this.h[0];
			this.h = this.h[1];
			return x;
		}};
	}
	,add: function(item) {
		var x = [item];
		if(this.h == null) this.h = x; else this.q[1] = x;
		this.q = x;
		this.length++;
	}
	,__class__: List
}
var IMap = function() { }
$hxClasses["IMap"] = IMap;
IMap.__name__ = ["IMap"];
var Markdown = function() { }
$hxClasses["Markdown"] = Markdown;
Markdown.__name__ = ["Markdown"];
Markdown.parse = function(s) {
	var _g = 0, _g1 = Markdown.regex;
	while(_g < _g1.length) {
		var r = _g1[_g];
		++_g;
		s = r.from.replace(s,r.to);
	}
	return StringTools.trim(s);
}
var NSFWFilter = function() { }
$hxClasses["NSFWFilter"] = NSFWFilter;
NSFWFilter.__name__ = ["NSFWFilter"];
NSFWFilter.init = function() {
	var ns = js.Browser.document.body.getElementsByClassName("nsfw-stamp");
	var _g = 0;
	while(_g < ns.length) {
		var n = ns[_g];
		++_g;
		if(n.nodeName.toLowerCase() != "li") continue;
		Reditn.show(n.parentNode.parentNode.parentNode,false);
	}
}
var Preview = function() { }
$hxClasses["Preview"] = Preview;
Preview.__name__ = ["Preview"];
Preview.init = function() {
	var ts = js.Browser.document.body.getElementsByClassName("usertext-edit");
	var _g = 0;
	while(_g < ts.length) {
		var t = ts[_g];
		++_g;
		Preview.preview(t);
	}
}
Preview.preview = function(e) {
	var box = e.getElementsByTagName("textarea")[0];
	if(box == null) return;
	var preview = js.Browser.document.createElement("div");
	e.appendChild(preview);
	preview.className = "md";
	box.onchange = function(e1) {
		preview.innerHTML = Markdown.parse(box.value);
	};
}
var Reditn = function() { }
$hxClasses["Reditn"] = Reditn;
Reditn.__name__ = ["Reditn"];
Reditn.main = function() {
	if(document.readyState == "complete") Reditn.init(); else js.Browser.window.onload = function(_) {
		Reditn.init();
	};
}
Reditn.init = function() {
	if(js.Browser.window.location.href.indexOf("reddit.") == -1) return;
	Reditn.fullPage = js.Browser.document.getElementsByClassName("tabmenu").length > 0;
	Reditn.links = js.Browser.document.body.getElementsByClassName("title");
	Reditn.links = (function($this) {
		var $r;
		var _g = [];
		{
			var _g1 = 0, _g2 = Reditn.links;
			while(_g1 < _g2.length) {
				var l = _g2[_g1];
				++_g1;
				if(l.nodeName.toLowerCase() == "a" && l.parentNode.className != "parent") _g.push(l);
			}
		}
		$r = _g;
		return $r;
	}(this));
	Reditn.wrap(Settings.init);
	Reditn.wrap(Adblock.init,"adblock");
	Reditn.wrap(DuplicateHider.init,"dup-hider");
	Reditn.wrap(NSFWFilter.init,"nsfw-filter");
	Reditn.wrap(Expand.init,"expand");
	Reditn.wrap(Keyboard.init,"keys");
	Reditn.wrap(Preview.init,"preview");
	Reditn.wrap(SubredditInfo.init,"subinfo");
	Reditn.wrap(UserInfo.init,"userinfo");
	Reditn.wrap(UserTagger.init,"user-tag");
	Reditn.wrap(SubredditTagger.init,"sub-tag");
	js.Browser.window.history.replaceState(haxe.Serializer.run(Reditn.state()),null,Expand.toggled?"#showall":null);
	js.Browser.window.onpopstate = function(e) {
		var s = e.state;
		if(s == null) return;
		var state = haxe.Unserializer.run(s);
		Expand.set_expanded(state.expanded);
		if(state.allExpanded != Expand.toggled) Expand.toggle(state.allExpanded);
	};
}
Reditn.state = function() {
	return { allExpanded : Expand.toggled, expanded : Expand.get_expanded()};
}
Reditn.wrap = function(fn,id) {
	var d = id == null?null:Settings.data.get(id);
	if(id == null || d) try {
		fn();
	} catch( d1 ) {
		console.log("Module " + id + " has failed to load in Reditn due to the following error:\n " + Std.string(d1));
	}
}
Reditn.formatNumber = function(n) {
	return !Math.isFinite(n)?Std.string(n):(function($this) {
		var $r;
		var s = Std.string(Math.abs(n));
		if(s.length >= 3) {
			var ns = "";
			var _g1 = 0, _g = s.length;
			while(_g1 < _g) {
				var i = _g1++;
				ns += s.charAt(i);
				if((s.length - (i + 1)) % 3 == 0 && i < s.length - 1) ns += ",";
			}
			s = ns;
		}
		$r = n < 0?"-" + s:s;
		return $r;
	}(this));
}
Reditn.show = function(e,shown) {
	e.style.display = shown?"":"none";
	if(e.className.indexOf("link") != -1) HxOverrides.remove(Reditn.links,e.getElementsByClassName("entry")[0].getElementsByTagName("a")[0]);
}
Reditn.age = function(t) {
	t = haxe.Timer.stamp() - t;
	var days = t / 86400 % 30.4375 | 0;
	var months = t / 2629800 % 12 | 0;
	var years = t / 2629800 / 12 | 0;
	var s = "";
	if(years > 0) s += "" + years + " year" + (years <= 1?"":"s");
	if(months > 0) s += ", " + months + " month" + (months <= 1?"":"s");
	s += ", " + days + " day" + (days <= 1?"":"s");
	if(StringTools.startsWith(s,", ")) s = HxOverrides.substr(s,2,null);
	while(s.indexOf(", , ") != -1) s = StringTools.replace(s,", , ",", ");
	return s;
}
Reditn.getLinkType = function(url) {
	if(StringTools.startsWith(url,"http://")) url = HxOverrides.substr(url,7,null); else if(StringTools.startsWith(url,"https://")) url = HxOverrides.substr(url,8,null);
	if(StringTools.startsWith(url,"www.")) url = HxOverrides.substr(url,4,null);
	var t = HxOverrides.substr(url,0,13) == "reddit.com/r/" && url.indexOf("/comments/") != -1?data.LinkType.TEXT:url.lastIndexOf(".") != url.indexOf(".") && HxOverrides.substr(url,url.lastIndexOf("."),null).length <= 4?(function($this) {
		var $r;
		var ext = HxOverrides.substr(url,url.lastIndexOf(".") + 1,null).toLowerCase();
		$r = (function($this) {
			var $r;
			switch(ext) {
			case "gif":case "jpg":case "jpeg":case "bmp":case "png":case "webp":case "svg":case "ico":case "tiff":case "raw":
				$r = data.LinkType.IMAGE;
				break;
			case "mpg":case "webm":case "avi":case "mp4":case "flv":case "swf":
				$r = data.LinkType.VIDEO;
				break;
			case "mp3":case "wav":case "midi":
				$r = data.LinkType.AUDIO;
				break;
			default:
				$r = data.LinkType.UNKNOWN;
			}
			return $r;
		}($this));
		return $r;
	}(this)):StringTools.startsWith(url,"xkcd.com/") || StringTools.startsWith(url,"flickr.com/photos/") || url.indexOf(".deviantart.com/") != -1 && url.indexOf("#/d") != -1 || url.indexOf(".deviantart.com/art") != -1 || StringTools.startsWith(url,"imgur.com/") && url.indexOf("/blog/") == -1 || StringTools.startsWith(url,"i.imgur.com/") || StringTools.startsWith(url,"qkme.me/") || StringTools.startsWith(url,"m.quickmeme.com/meme/") || StringTools.startsWith(url,"quickmeme.com/meme/") || StringTools.startsWith(url,"memecrunch.com/meme/") || StringTools.startsWith(url,"memegenerator.net/instance/") || StringTools.startsWith(url,"imgflip.com/i/") || StringTools.startsWith(url,"fav.me/") || StringTools.startsWith(url,"livememe.com/")?data.LinkType.IMAGE:StringTools.startsWith(url,"youtube.com/watch") || StringTools.startsWith(url,"youtu.be/")?data.LinkType.VIDEO:data.LinkType.UNKNOWN;
	return t;
}
Reditn.getData = function(o) {
	while(o.data != null) o = o.data;
	return o;
}
Reditn.getJSON = function(url,func) {
	GM.request({ method : "GET", url : url, onload : function(rsp) {
		func(Reditn.getData(haxe.Json.parse(rsp.responseText)));
	}});
}
Reditn.popUp = function(bs,el,x,y) {
	if(y == null) y = 0;
	if(x == null) x = 0;
	js.Browser.document.body.appendChild(el);
	el.className = "popup";
	el.style.position = "absolute";
	el.style.width = (js.Browser.window.innerWidth * 0.25 | 0) + "px";
	el.style.left = "" + x + "px";
	el.style.top = "" + y + "px";
	bs.onmouseout = el.onblur = function(e) {
		el.parentNode.removeChild(el);
		bs.mouseover = false;
	};
	return el;
}
Reditn.fullPopUp = function(el,y) {
	if(y == null) y = 0;
	var old = js.Browser.document.getElementsByClassName("popup")[0];
	if(old != null) old.parentNode.removeChild(old);
	js.Browser.document.body.appendChild(el);
	var close = js.Browser.document.createElement("a");
	close.style.position = "absolute";
	close.style.right = close.style.top = "5px";
	close.innerHTML = "<b>Close</b>";
	close.href = "javascript:void(0);";
	close.onclick = el.onblur = function(e) {
		el.parentNode.removeChild(el);
	};
	el.appendChild(close);
	el.className = "popup";
	if(y != 0) el.style.top = "" + (y - js.Browser.window.scrollY) + "px";
	return el;
}
var Reflect = function() { }
$hxClasses["Reflect"] = Reflect;
Reflect.__name__ = ["Reflect"];
Reflect.hasField = function(o,field) {
	return Object.prototype.hasOwnProperty.call(o,field);
}
Reflect.field = function(o,field) {
	var v = null;
	try {
		v = o[field];
	} catch( e ) {
	}
	return v;
}
Reflect.fields = function(o) {
	var a = [];
	if(o != null) {
		var hasOwnProperty = Object.prototype.hasOwnProperty;
		for( var f in o ) {
		if(f != "__id__" && hasOwnProperty.call(o,f)) a.push(f);
		}
	}
	return a;
}
Reflect.isFunction = function(f) {
	return typeof(f) == "function" && !(f.__name__ || f.__ename__);
}
Reflect.deleteField = function(o,field) {
	if(!Reflect.hasField(o,field)) return false;
	delete(o[field]);
	return true;
}
var haxe = {}
haxe.ds = {}
haxe.ds.StringMap = function() {
	this.h = { };
};
$hxClasses["haxe.ds.StringMap"] = haxe.ds.StringMap;
haxe.ds.StringMap.__name__ = ["haxe","ds","StringMap"];
haxe.ds.StringMap.__interfaces__ = [IMap];
haxe.ds.StringMap.prototype = {
	keys: function() {
		var a = [];
		for( var key in this.h ) {
		if(this.h.hasOwnProperty(key)) a.push(key.substr(1));
		}
		return HxOverrides.iter(a);
	}
	,exists: function(key) {
		return this.h.hasOwnProperty("$" + key);
	}
	,get: function(key) {
		return this.h["$" + key];
	}
	,set: function(key,value) {
		this.h["$" + key] = value;
	}
	,__class__: haxe.ds.StringMap
}
var Settings = function() { }
$hxClasses["Settings"] = Settings;
Settings.__name__ = ["Settings"];
Settings.optimisedData = function() {
	var e = new haxe.ds.StringMap();
	var $it0 = Settings.data.keys();
	while( $it0.hasNext() ) {
		var k = $it0.next();
		var v = Settings.data.get(k);
		if(Settings.DEFAULTS.get(k) != v) {
			var value = v;
			e.set(k,value);
		}
	}
	return haxe.Serializer.run(e);
}
Settings.save = function() {
	haxe.Serializer.USE_CACHE = false;
	js.Browser.window.localStorage.setItem("reditn",Settings.optimisedData());
}
Settings.init = function() {
	var dt = js.Browser.window.localStorage.getItem("reditn");
	if(dt != null) Settings.data = (function($this) {
		var $r;
		try {
			$r = haxe.Unserializer.run(dt);
		} catch( e ) {
			$r = Settings.data;
		}
		return $r;
	}(this));
	Settings.fixMissing();
	var h = js.Browser.document.getElementById("header-bottom-right");
	var prefs = h.getElementsByTagName("ul")[0];
	var d = js.Browser.document.createElement("a");
	d.innerHTML = "reditn";
	d.className = "pref-lang";
	d.href = "javascript:void(0);";
	d.onclick = function(e) {
		Settings.settingsPopUp();
	};
	if(prefs == null) h.appendChild(d); else h.insertBefore(d,prefs);
	var sep = js.Browser.document.createElement("span");
	sep.innerHTML = " | ";
	sep.className = "seperator";
	sep.style.fontWeight = "none";
	h.insertBefore(sep,prefs);
}
Settings.settingsPopUp = function() {
	var old = js.Browser.document.getElementById("reditn-config");
	if(old != null) old.parentNode.removeChild(old);
	var e = js.Browser.document.createElement("div");
	var h = js.Browser.document.createElement("h1");
	h.innerHTML = "Reditn settings";
	e.appendChild(h);
	Reditn.fullPopUp(e);
	var form = js.Browser.document.createElement("form");
	form.id = "reditn-config";
	form.action = "javascript:void(0);";
	form.onchange = function(ev) {
		var a = form.childNodes;
		var _g = 0;
		while(_g < a.length) {
			var i = a[_g];
			++_g;
			if(i.type == "button") continue;
			if(i.nodeName.toLowerCase() != "input") continue;
			var i1 = i;
			var val = (function($this) {
				var $r;
				var _g1 = i1.type.toLowerCase();
				$r = (function($this) {
					var $r;
					switch(_g1) {
					case "checkbox":
						$r = i1.checked;
						break;
					default:
						$r = i1.value;
					}
					return $r;
				}($this));
				return $r;
			}(this));
			Settings.data.set(i1.name,val);
		}
		Settings.save();
	};
	var delb = js.Browser.document.createElement("input");
	delb.type = "button";
	delb.value = "Restore default settings";
	delb.onclick = function(_) {
		Settings.fixMissing(true);
		Settings.save();
		Settings.settingsPopUp();
	};
	form.appendChild(delb);
	var $export = Settings.makeButton("Export settings to text",function() {
		js.Browser.window.alert(js.Browser.window.btoa(Settings.optimisedData()));
	});
	form.appendChild($export);
	var importbtn = Settings.makeButton("Import settings",function() {
		Settings.data = haxe.Unserializer.run(js.Browser.window.atob(js.Browser.window.prompt("Settings to import",js.Browser.window.btoa(Settings.optimisedData()))));
		Settings.fixMissing();
		Settings.save();
		Settings.settingsPopUp();
	});
	form.appendChild(importbtn);
	form.appendChild(js.Browser.document.createElement("br"));
	var $it0 = Settings.data.keys();
	while( $it0.hasNext() ) {
		var k = $it0.next();
		var d = Settings.data.get(k);
		if(!js.Boot.__instanceof(d,haxe.ds.StringMap) && Settings.DESC.exists(k)) {
			var l = Settings.DESC.get(k);
			var label = js.Browser.document.createElement("label");
			label.setAttribute("for",k);
			label.style.position = "absolute";
			label.style.width = "46%";
			label.style.textAlign = "right";
			label.innerHTML = "" + l + " ";
			form.appendChild(label);
			var input = js.Browser.document.createElement("input");
			input.style.position = "absolute";
			input.style.left = "54%";
			input.style.textAlign = "left";
			input.style.width = "46%";
			input.name = k;
			form.appendChild(input);
			form.appendChild(js.Browser.document.createElement("br"));
			input.type = js.Boot.__instanceof(d,Bool)?"checkbox":js.Boot.__instanceof(d,String)?"text":js.Boot.__instanceof(d,Date)?"datetime":js.Boot.__instanceof(d,Int)?"number":null;
			if(js.Boot.__instanceof(d,Bool)) input.checked = Settings.data.get(k); else input.value = Settings.data.get(k);
		}
	}
	var note = js.Browser.document.createElement("div");
	note.style.fontWeight = "bold";
	note.innerHTML = "Close this dialog and refresh the page to see your changes in effect. Changes will be saved automatically.";
	form.appendChild(note);
	e.appendChild(form);
}
Settings.makeButton = function(t,fn) {
	var b = js.Browser.document.createElement("input");
	b.type = "button";
	b.value = t;
	b.onclick = fn;
	return b;
}
Settings.fixMissing = function(all) {
	if(all == null) all = false;
	var $it0 = Settings.DEFAULTS.keys();
	while( $it0.hasNext() ) {
		var k = $it0.next();
		if(all || !Settings.data.exists(k)) Settings.data.set(k,js.Boot.__instanceof(Settings.DEFAULTS.get(k),haxe.ds.StringMap)?new haxe.ds.StringMap():Settings.DEFAULTS.get(k));
	}
}
var Std = function() { }
$hxClasses["Std"] = Std;
Std.__name__ = ["Std"];
Std.string = function(s) {
	return js.Boot.__string_rec(s,"");
}
Std.parseInt = function(x) {
	var v = parseInt(x,10);
	if(v == 0 && (HxOverrides.cca(x,1) == 120 || HxOverrides.cca(x,1) == 88)) v = parseInt(x);
	if(isNaN(v)) return null;
	return v;
}
Std.parseFloat = function(x) {
	return parseFloat(x);
}
var StringBuf = function() {
	this.b = "";
};
$hxClasses["StringBuf"] = StringBuf;
StringBuf.__name__ = ["StringBuf"];
StringBuf.prototype = {
	addSub: function(s,pos,len) {
		this.b += len == null?HxOverrides.substr(s,pos,null):HxOverrides.substr(s,pos,len);
	}
	,__class__: StringBuf
}
var StringTools = function() { }
$hxClasses["StringTools"] = StringTools;
StringTools.__name__ = ["StringTools"];
StringTools.urlEncode = function(s) {
	return encodeURIComponent(s);
}
StringTools.urlDecode = function(s) {
	return decodeURIComponent(s.split("+").join(" "));
}
StringTools.htmlEscape = function(s,quotes) {
	s = s.split("&").join("&amp;").split("<").join("&lt;").split(">").join("&gt;");
	return quotes?s.split("\"").join("&quot;").split("'").join("&#039;"):s;
}
StringTools.htmlUnescape = function(s) {
	return s.split("&gt;").join(">").split("&lt;").join("<").split("&quot;").join("\"").split("&#039;").join("'").split("&amp;").join("&");
}
StringTools.startsWith = function(s,start) {
	return s.length >= start.length && HxOverrides.substr(s,0,start.length) == start;
}
StringTools.isSpace = function(s,pos) {
	var c = HxOverrides.cca(s,pos);
	return c > 8 && c < 14 || c == 32;
}
StringTools.ltrim = function(s) {
	var l = s.length;
	var r = 0;
	while(r < l && StringTools.isSpace(s,r)) r++;
	if(r > 0) return HxOverrides.substr(s,r,l - r); else return s;
}
StringTools.rtrim = function(s) {
	var l = s.length;
	var r = 0;
	while(r < l && StringTools.isSpace(s,l - r - 1)) r++;
	if(r > 0) return HxOverrides.substr(s,0,l - r); else return s;
}
StringTools.trim = function(s) {
	return StringTools.ltrim(StringTools.rtrim(s));
}
StringTools.replace = function(s,sub,by) {
	return s.split(sub).join(by);
}
var SubredditInfo = function() { }
$hxClasses["SubredditInfo"] = SubredditInfo;
SubredditInfo.__name__ = ["SubredditInfo"];
SubredditInfo.init = function() {
	var subs = js.Browser.document.body.getElementsByClassName("subreddit");
	var _g = 0;
	while(_g < subs.length) {
		var i = subs[_g];
		++_g;
		i.onmouseover = SubredditInfo._onMouseOverSubreddit;
	}
}
SubredditInfo._onMouseOverSubreddit = function(e) {
	var e1 = e.target;
	var name = e1.innerHTML;
	var div = js.Browser.document.createElement("div");
	Reditn.popUp(e1,div,e1.offsetLeft + e1.offsetWidth,e1.offsetTop);
	Reditn.getJSON("/r/" + name + "/about.json",function(d) {
		var title = d.display_name, subs = Reditn.formatNumber(d.subscribers), users = Reditn.formatNumber(d.accounts_active), desc = d.description_html != null?StringTools.htmlUnescape(d.description_html):d.public_description != null?Markdown.parse(d.public_description):Markdown.parse(d.description), age = Reditn.age(d.created_utc);
		var html = "<b>Name:</b> " + name + " <br>";
		var ts = Settings.data.get("sub-tags");
		if(ts.exists(name)) html += "<b>Tag:</b> " + ts.get(name) + "<br>";
		html += "<b>Subscribers:</b> " + subs + " <br>";
		html += "<b>Active Users:</b> " + users + " <br>";
		html += "<b>Description:</b> " + desc + " <br>";
		html += "<b>Age:</b> " + age + " <br>";
		div.innerHTML = html;
	});
}
var SubredditTagger = function() { }
$hxClasses["SubredditTagger"] = SubredditTagger;
SubredditTagger.__name__ = ["SubredditTagger"];
SubredditTagger.init = function() {
	var d = js.Browser.document.body.getElementsByClassName("subreddit");
	var _g = 0;
	while(_g < d.length) {
		var s = d[_g];
		++_g;
		SubredditTagger.getTag(s);
	}
}
SubredditTagger.getTag = function(a) {
	var tagline = a.parentNode;
	var tag = js.Browser.document.createElement("span");
	var sub = StringTools.trim(a.innerHTML);
	var currentTag = Settings.data.get("sub-tags").exists(sub)?Settings.data.get("sub-tags").get(sub):null;
	tag.className = "flair";
	var tagName = js.Browser.document.createElement("span");
	tagName.innerHTML = currentTag == null?"":StringTools.htmlEscape(currentTag) + " ";
	tag.appendChild(tagName);
	var link = js.Browser.document.createElement("a");
	link.href = "javascript:void(0);";
	link.innerHTML = "[+]";
	tag.appendChild(link);
	link.onclick = function(e) {
		var div = js.Browser.document.createElement("div");
		var label = js.Browser.document.createElement("label");
		label.setAttribute("for","tag-change");
		label.innerHTML = "Tag for " + sub + " ";
		div.appendChild(label);
		var box = js.Browser.document.createElement("input");
		box.name = "tag-change";
		box.value = currentTag;
		box.style.width = "100%";
		box.onchange = function(ev) {
			Settings.data.get("sub-tags").set(sub,box.value);
			tagName.innerHTML = StringTools.htmlEscape(box.value) + " ";
			Settings.save();
			div.parentNode.removeChild(div);
		};
		div.appendChild(box);
		Reditn.fullPopUp(div,link.offsetTop + link.offsetHeight);
		box.focus();
	};
	a.parentNode.insertBefore(tag,a.nextSibling);
}
var ValueType = $hxClasses["ValueType"] = { __ename__ : ["ValueType"], __constructs__ : ["TNull","TInt","TFloat","TBool","TObject","TFunction","TClass","TEnum","TUnknown"] }
ValueType.TNull = ["TNull",0];
ValueType.TNull.toString = $estr;
ValueType.TNull.__enum__ = ValueType;
ValueType.TInt = ["TInt",1];
ValueType.TInt.toString = $estr;
ValueType.TInt.__enum__ = ValueType;
ValueType.TFloat = ["TFloat",2];
ValueType.TFloat.toString = $estr;
ValueType.TFloat.__enum__ = ValueType;
ValueType.TBool = ["TBool",3];
ValueType.TBool.toString = $estr;
ValueType.TBool.__enum__ = ValueType;
ValueType.TObject = ["TObject",4];
ValueType.TObject.toString = $estr;
ValueType.TObject.__enum__ = ValueType;
ValueType.TFunction = ["TFunction",5];
ValueType.TFunction.toString = $estr;
ValueType.TFunction.__enum__ = ValueType;
ValueType.TClass = function(c) { var $x = ["TClass",6,c]; $x.__enum__ = ValueType; $x.toString = $estr; return $x; }
ValueType.TEnum = function(e) { var $x = ["TEnum",7,e]; $x.__enum__ = ValueType; $x.toString = $estr; return $x; }
ValueType.TUnknown = ["TUnknown",8];
ValueType.TUnknown.toString = $estr;
ValueType.TUnknown.__enum__ = ValueType;
var Type = function() { }
$hxClasses["Type"] = Type;
Type.__name__ = ["Type"];
Type.getClassName = function(c) {
	var a = c.__name__;
	return a.join(".");
}
Type.getEnumName = function(e) {
	var a = e.__ename__;
	return a.join(".");
}
Type.resolveClass = function(name) {
	var cl = $hxClasses[name];
	if(cl == null || !cl.__name__) return null;
	return cl;
}
Type.resolveEnum = function(name) {
	var e = $hxClasses[name];
	if(e == null || !e.__ename__) return null;
	return e;
}
Type.createEmptyInstance = function(cl) {
	function empty() {}; empty.prototype = cl.prototype;
	return new empty();
}
Type.createEnum = function(e,constr,params) {
	var f = Reflect.field(e,constr);
	if(f == null) throw "No such constructor " + constr;
	if(Reflect.isFunction(f)) {
		if(params == null) throw "Constructor " + constr + " need parameters";
		return f.apply(e,params);
	}
	if(params != null && params.length != 0) throw "Constructor " + constr + " does not need parameters";
	return f;
}
Type.getEnumConstructs = function(e) {
	var a = e.__constructs__;
	return a.slice();
}
Type["typeof"] = function(v) {
	var _g = typeof(v);
	switch(_g) {
	case "boolean":
		return ValueType.TBool;
	case "string":
		return ValueType.TClass(String);
	case "number":
		if(Math.ceil(v) == v % 2147483648.0) return ValueType.TInt;
		return ValueType.TFloat;
	case "object":
		if(v == null) return ValueType.TNull;
		var e = v.__enum__;
		if(e != null) return ValueType.TEnum(e);
		var c = v.__class__;
		if(c != null) return ValueType.TClass(c);
		return ValueType.TObject;
	case "function":
		if(v.__name__ || v.__ename__) return ValueType.TObject;
		return ValueType.TFunction;
	case "undefined":
		return ValueType.TNull;
	default:
		return ValueType.TUnknown;
	}
}
var UserInfo = function() { }
$hxClasses["UserInfo"] = UserInfo;
UserInfo.__name__ = ["UserInfo"];
UserInfo.init = function() {
	var users = js.Browser.document.body.getElementsByClassName("author");
	var _g = 0;
	while(_g < users.length) {
		var i = users[_g];
		++_g;
		i.onmouseover = UserInfo._onMouseOverUser;
	}
}
UserInfo._onMouseOverUser = function(e) {
	var e1 = e.target;
	var user = e1.innerHTML;
	user = HxOverrides.substr(user,user.lastIndexOf("/") + 1,null);
	var div = js.Browser.document.createElement("div");
	Reditn.popUp(e1,div,e1.offsetLeft + e1.offsetWidth,e1.offsetTop);
	Reditn.getJSON("/user/" + user + "/about.json",function(i) {
		var name = i.name, age = Reditn.age(i.created_utc), linkKarma = Reditn.formatNumber(i.link_karma), commentKarma = Reditn.formatNumber(i.comment_karma);
		var html = "<b>User:</b> " + name + "<br>";
		var ts = Settings.data.get("user-tags");
		if(ts.exists(name)) html += "<b>Tag:</b> " + ts.get(name) + "<br>";
		html += "<b>Account age:</b> " + age + "<br>";
		html += "<b>Karma:</b> " + linkKarma + " link karma, " + commentKarma + " comment karma";
		if(i.is_mod) html += "<br><b>Moderator</b>";
		if(i.is_gold) html += "<br><b>Gold</b>";
		div.innerHTML = html;
	});
}
var UserTagger = function() { }
$hxClasses["UserTagger"] = UserTagger;
UserTagger.__name__ = ["UserTagger"];
UserTagger.init = function() {
	var authors = js.Browser.document.body.getElementsByClassName("author");
	var _g = 0;
	while(_g < authors.length) {
		var a = authors[_g];
		++_g;
		UserTagger.getTag(a);
	}
}
UserTagger.getTag = function(a) {
	var tagline = a.parentNode;
	var tag = js.Browser.document.createElement("span");
	var user = StringTools.trim(a.innerHTML);
	var currentTag = Settings.data.get("user-tags").exists(user)?Settings.data.get("user-tags").get(user):null;
	tag.className = "flair";
	var tagName = js.Browser.document.createElement("span");
	tagName.innerHTML = currentTag == null?"":StringTools.htmlEscape(currentTag) + " ";
	tag.appendChild(tagName);
	var link = js.Browser.document.createElement("a");
	link.href = "javascript:void(0);";
	link.innerHTML = "[+]";
	tag.appendChild(link);
	link.onclick = function(e) {
		var div = js.Browser.document.createElement("div");
		var label = js.Browser.document.createElement("label");
		label.setAttribute("for","tag-change");
		label.innerHTML = "Tag for " + user + " ";
		div.appendChild(label);
		var box = js.Browser.document.createElement("input");
		box.name = "tag-change";
		box.value = currentTag;
		box.style.width = "100%";
		box.onchange = function(ev) {
			Settings.data.get("user-tags").set(user,box.value);
			tagName.innerHTML = StringTools.htmlEscape(box.value) + " ";
			Settings.save();
			div.parentNode.removeChild(div);
		};
		div.appendChild(box);
		Reditn.fullPopUp(div,link.offsetTop + link.offsetHeight);
		box.focus();
	};
	a.parentNode.insertBefore(tag,a.nextSibling);
}
var data = {}
data.LinkType = $hxClasses["data.LinkType"] = { __ename__ : ["data","LinkType"], __constructs__ : ["IMAGE","VIDEO","AUDIO","TEXT","UNKNOWN"] }
data.LinkType.IMAGE = ["IMAGE",0];
data.LinkType.IMAGE.toString = $estr;
data.LinkType.IMAGE.__enum__ = data.LinkType;
data.LinkType.VIDEO = ["VIDEO",1];
data.LinkType.VIDEO.toString = $estr;
data.LinkType.VIDEO.__enum__ = data.LinkType;
data.LinkType.AUDIO = ["AUDIO",2];
data.LinkType.AUDIO.toString = $estr;
data.LinkType.AUDIO.__enum__ = data.LinkType;
data.LinkType.TEXT = ["TEXT",3];
data.LinkType.TEXT.toString = $estr;
data.LinkType.TEXT.__enum__ = data.LinkType;
data.LinkType.UNKNOWN = ["UNKNOWN",4];
data.LinkType.UNKNOWN.toString = $estr;
data.LinkType.UNKNOWN.__enum__ = data.LinkType;
haxe.Http = function(url) {
	this.url = url;
	this.headers = new haxe.ds.StringMap();
	this.params = new haxe.ds.StringMap();
	this.async = true;
};
$hxClasses["haxe.Http"] = haxe.Http;
haxe.Http.__name__ = ["haxe","Http"];
haxe.Http.prototype = {
	onStatus: function(status) {
	}
	,onError: function(msg) {
	}
	,onData: function(data) {
	}
	,request: function(post) {
		var me = this;
		me.responseData = null;
		var r = js.Browser.createXMLHttpRequest();
		var onreadystatechange = function(_) {
			if(r.readyState != 4) return;
			var s = (function($this) {
				var $r;
				try {
					$r = r.status;
				} catch( e ) {
					$r = null;
				}
				return $r;
			}(this));
			if(s == undefined) s = null;
			if(s != null) me.onStatus(s);
			if(s != null && s >= 200 && s < 400) me.onData(me.responseData = r.responseText); else if(s == null) me.onError("Failed to connect or resolve host"); else switch(s) {
			case 12029:
				me.onError("Failed to connect to host");
				break;
			case 12007:
				me.onError("Unknown host");
				break;
			default:
				me.responseData = r.responseText;
				me.onError("Http Error #" + r.status);
			}
		};
		if(this.async) r.onreadystatechange = onreadystatechange;
		var uri = this.postData;
		if(uri != null) post = true; else {
			var $it0 = this.params.keys();
			while( $it0.hasNext() ) {
				var p = $it0.next();
				if(uri == null) uri = ""; else uri += "&";
				uri += StringTools.urlEncode(p) + "=" + StringTools.urlEncode(this.params.get(p));
			}
		}
		try {
			if(post) r.open("POST",this.url,this.async); else if(uri != null) {
				var question = this.url.split("?").length <= 1;
				r.open("GET",this.url + (question?"?":"&") + uri,this.async);
				uri = null;
			} else r.open("GET",this.url,this.async);
		} catch( e ) {
			this.onError(e.toString());
			return;
		}
		if(this.headers.get("Content-Type") == null && post && this.postData == null) r.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
		var $it1 = this.headers.keys();
		while( $it1.hasNext() ) {
			var h = $it1.next();
			r.setRequestHeader(h,this.headers.get(h));
		}
		r.send(uri);
		if(!this.async) onreadystatechange(null);
	}
	,setHeader: function(header,value) {
		this.headers.set(header,value);
		return this;
	}
	,__class__: haxe.Http
}
haxe.Json = function() {
};
$hxClasses["haxe.Json"] = haxe.Json;
haxe.Json.__name__ = ["haxe","Json"];
haxe.Json.parse = function(text) {
	return new haxe.Json().doParse(text);
}
haxe.Json.prototype = {
	parseNumber: function(c) {
		var start = this.pos - 1;
		var minus = c == 45, digit = !minus, zero = c == 48;
		var point = false, e = false, pm = false, end = false;
		while(true) {
			c = this.str.charCodeAt(this.pos++);
			switch(c) {
			case 48:
				if(zero && !point) this.invalidNumber(start);
				if(minus) {
					minus = false;
					zero = true;
				}
				digit = true;
				break;
			case 49:case 50:case 51:case 52:case 53:case 54:case 55:case 56:case 57:
				if(zero && !point) this.invalidNumber(start);
				if(minus) minus = false;
				digit = true;
				zero = false;
				break;
			case 46:
				if(minus || point) this.invalidNumber(start);
				digit = false;
				point = true;
				break;
			case 101:case 69:
				if(minus || zero || e) this.invalidNumber(start);
				digit = false;
				e = true;
				break;
			case 43:case 45:
				if(!e || pm) this.invalidNumber(start);
				digit = false;
				pm = true;
				break;
			default:
				if(!digit) this.invalidNumber(start);
				this.pos--;
				end = true;
			}
			if(end) break;
		}
		var f = Std.parseFloat(HxOverrides.substr(this.str,start,this.pos - start));
		var i = f | 0;
		return i == f?i:f;
	}
	,invalidNumber: function(start) {
		throw "Invalid number at position " + start + ": " + HxOverrides.substr(this.str,start,this.pos - start);
	}
	,parseString: function() {
		var start = this.pos;
		var buf = new StringBuf();
		while(true) {
			var c = this.str.charCodeAt(this.pos++);
			if(c == 34) break;
			if(c == 92) {
				buf.addSub(this.str,start,this.pos - start - 1);
				c = this.str.charCodeAt(this.pos++);
				switch(c) {
				case 114:
					buf.b += "\r";
					break;
				case 110:
					buf.b += "\n";
					break;
				case 116:
					buf.b += "\t";
					break;
				case 98:
					buf.b += "";
					break;
				case 102:
					buf.b += "";
					break;
				case 47:case 92:case 34:
					buf.b += String.fromCharCode(c);
					break;
				case 117:
					var uc = Std.parseInt("0x" + HxOverrides.substr(this.str,this.pos,4));
					this.pos += 4;
					buf.b += String.fromCharCode(uc);
					break;
				default:
					throw "Invalid escape sequence \\" + String.fromCharCode(c) + " at position " + (this.pos - 1);
				}
				start = this.pos;
			} else if(c != c) throw "Unclosed string";
		}
		buf.addSub(this.str,start,this.pos - start - 1);
		return buf.b;
	}
	,parseRec: function() {
		while(true) {
			var c = this.str.charCodeAt(this.pos++);
			switch(c) {
			case 32:case 13:case 10:case 9:
				break;
			case 123:
				var obj = { }, field = null, comma = null;
				while(true) {
					var c1 = this.str.charCodeAt(this.pos++);
					switch(c1) {
					case 32:case 13:case 10:case 9:
						break;
					case 125:
						if(field != null || comma == false) this.invalidChar();
						return obj;
					case 58:
						if(field == null) this.invalidChar();
						obj[field] = this.parseRec();
						field = null;
						comma = true;
						break;
					case 44:
						if(comma) comma = false; else this.invalidChar();
						break;
					case 34:
						if(comma) this.invalidChar();
						field = this.parseString();
						break;
					default:
						this.invalidChar();
					}
				}
				break;
			case 91:
				var arr = [], comma = null;
				while(true) {
					var c1 = this.str.charCodeAt(this.pos++);
					switch(c1) {
					case 32:case 13:case 10:case 9:
						break;
					case 93:
						if(comma == false) this.invalidChar();
						return arr;
					case 44:
						if(comma) comma = false; else this.invalidChar();
						break;
					default:
						if(comma) this.invalidChar();
						this.pos--;
						arr.push(this.parseRec());
						comma = true;
					}
				}
				break;
			case 116:
				var save = this.pos;
				if(this.str.charCodeAt(this.pos++) != 114 || this.str.charCodeAt(this.pos++) != 117 || this.str.charCodeAt(this.pos++) != 101) {
					this.pos = save;
					this.invalidChar();
				}
				return true;
			case 102:
				var save = this.pos;
				if(this.str.charCodeAt(this.pos++) != 97 || this.str.charCodeAt(this.pos++) != 108 || this.str.charCodeAt(this.pos++) != 115 || this.str.charCodeAt(this.pos++) != 101) {
					this.pos = save;
					this.invalidChar();
				}
				return false;
			case 110:
				var save = this.pos;
				if(this.str.charCodeAt(this.pos++) != 117 || this.str.charCodeAt(this.pos++) != 108 || this.str.charCodeAt(this.pos++) != 108) {
					this.pos = save;
					this.invalidChar();
				}
				return null;
			case 34:
				return this.parseString();
			case 48:case 49:case 50:case 51:case 52:case 53:case 54:case 55:case 56:case 57:case 45:
				return this.parseNumber(c);
			default:
				this.invalidChar();
			}
		}
	}
	,invalidChar: function() {
		this.pos--;
		throw "Invalid char " + this.str.charCodeAt(this.pos) + " at position " + this.pos;
	}
	,doParse: function(str) {
		this.str = str;
		this.pos = 0;
		return this.parseRec();
	}
	,__class__: haxe.Json
}
haxe.Serializer = function() {
	this.buf = new StringBuf();
	this.cache = new Array();
	this.useCache = haxe.Serializer.USE_CACHE;
	this.useEnumIndex = haxe.Serializer.USE_ENUM_INDEX;
	this.shash = new haxe.ds.StringMap();
	this.scount = 0;
};
$hxClasses["haxe.Serializer"] = haxe.Serializer;
haxe.Serializer.__name__ = ["haxe","Serializer"];
haxe.Serializer.run = function(v) {
	var s = new haxe.Serializer();
	s.serialize(v);
	return s.toString();
}
haxe.Serializer.prototype = {
	serialize: function(v) {
		var _g = Type["typeof"](v);
		var $e = (_g);
		switch( $e[1] ) {
		case 0:
			this.buf.b += "n";
			break;
		case 1:
			if(v == 0) {
				this.buf.b += "z";
				return;
			}
			this.buf.b += "i";
			this.buf.b += Std.string(v);
			break;
		case 2:
			if(Math.isNaN(v)) this.buf.b += "k"; else if(!Math.isFinite(v)) this.buf.b += Std.string(v < 0?"m":"p"); else {
				this.buf.b += "d";
				this.buf.b += Std.string(v);
			}
			break;
		case 3:
			this.buf.b += Std.string(v?"t":"f");
			break;
		case 6:
			var _g_eTClass_0 = $e[2];
			if(_g_eTClass_0 == String) {
				this.serializeString(v);
				return;
			}
			if(this.useCache && this.serializeRef(v)) return;
			switch(_g_eTClass_0) {
			case Array:
				var ucount = 0;
				this.buf.b += "a";
				var l = v.length;
				var _g1 = 0;
				while(_g1 < l) {
					var i = _g1++;
					if(v[i] == null) ucount++; else {
						if(ucount > 0) {
							if(ucount == 1) this.buf.b += "n"; else {
								this.buf.b += "u";
								this.buf.b += Std.string(ucount);
							}
							ucount = 0;
						}
						this.serialize(v[i]);
					}
				}
				if(ucount > 0) {
					if(ucount == 1) this.buf.b += "n"; else {
						this.buf.b += "u";
						this.buf.b += Std.string(ucount);
					}
				}
				this.buf.b += "h";
				break;
			case List:
				this.buf.b += "l";
				var v1 = v;
				var $it0 = v1.iterator();
				while( $it0.hasNext() ) {
					var i = $it0.next();
					this.serialize(i);
				}
				this.buf.b += "h";
				break;
			case Date:
				var d = v;
				this.buf.b += "v";
				this.buf.b += Std.string(HxOverrides.dateStr(d));
				break;
			case haxe.ds.StringMap:
				this.buf.b += "b";
				var v1 = v;
				var $it1 = v1.keys();
				while( $it1.hasNext() ) {
					var k = $it1.next();
					this.serializeString(k);
					this.serialize(v1.get(k));
				}
				this.buf.b += "h";
				break;
			case haxe.ds.IntMap:
				this.buf.b += "q";
				var v1 = v;
				var $it2 = v1.keys();
				while( $it2.hasNext() ) {
					var k = $it2.next();
					this.buf.b += ":";
					this.buf.b += Std.string(k);
					this.serialize(v1.get(k));
				}
				this.buf.b += "h";
				break;
			case haxe.ds.ObjectMap:
				this.buf.b += "M";
				var v1 = v;
				var $it3 = v1.keys();
				while( $it3.hasNext() ) {
					var k = $it3.next();
					var id = Reflect.field(k,"__id__");
					Reflect.deleteField(k,"__id__");
					this.serialize(k);
					k.__id__ = id;
					this.serialize(v1.h[k.__id__]);
				}
				this.buf.b += "h";
				break;
			case haxe.io.Bytes:
				var v1 = v;
				var i = 0;
				var max = v1.length - 2;
				var charsBuf = new StringBuf();
				var b64 = haxe.Serializer.BASE64;
				while(i < max) {
					var b1 = v1.b[i++];
					var b2 = v1.b[i++];
					var b3 = v1.b[i++];
					charsBuf.b += Std.string(b64.charAt(b1 >> 2));
					charsBuf.b += Std.string(b64.charAt((b1 << 4 | b2 >> 4) & 63));
					charsBuf.b += Std.string(b64.charAt((b2 << 2 | b3 >> 6) & 63));
					charsBuf.b += Std.string(b64.charAt(b3 & 63));
				}
				if(i == max) {
					var b1 = v1.b[i++];
					var b2 = v1.b[i++];
					charsBuf.b += Std.string(b64.charAt(b1 >> 2));
					charsBuf.b += Std.string(b64.charAt((b1 << 4 | b2 >> 4) & 63));
					charsBuf.b += Std.string(b64.charAt(b2 << 2 & 63));
				} else if(i == max + 1) {
					var b1 = v1.b[i++];
					charsBuf.b += Std.string(b64.charAt(b1 >> 2));
					charsBuf.b += Std.string(b64.charAt(b1 << 4 & 63));
				}
				var chars = charsBuf.b;
				this.buf.b += "s";
				this.buf.b += Std.string(chars.length);
				this.buf.b += ":";
				this.buf.b += Std.string(chars);
				break;
			default:
				this.cache.pop();
				if(v.hxSerialize != null) {
					this.buf.b += "C";
					this.serializeString(Type.getClassName(_g_eTClass_0));
					this.cache.push(v);
					v.hxSerialize(this);
					this.buf.b += "g";
				} else {
					this.buf.b += "c";
					this.serializeString(Type.getClassName(_g_eTClass_0));
					this.cache.push(v);
					this.serializeFields(v);
				}
			}
			break;
		case 4:
			if(this.useCache && this.serializeRef(v)) return;
			this.buf.b += "o";
			this.serializeFields(v);
			break;
		case 7:
			var _g_eTEnum_0 = $e[2];
			if(this.useCache && this.serializeRef(v)) return;
			this.cache.pop();
			this.buf.b += Std.string(this.useEnumIndex?"j":"w");
			this.serializeString(Type.getEnumName(_g_eTEnum_0));
			if(this.useEnumIndex) {
				this.buf.b += ":";
				this.buf.b += Std.string(v[1]);
			} else this.serializeString(v[0]);
			this.buf.b += ":";
			var l = v.length;
			this.buf.b += Std.string(l - 2);
			var _g1 = 2;
			while(_g1 < l) {
				var i = _g1++;
				this.serialize(v[i]);
			}
			this.cache.push(v);
			break;
		case 5:
			throw "Cannot serialize function";
			break;
		default:
			throw "Cannot serialize " + Std.string(v);
		}
	}
	,serializeFields: function(v) {
		var _g = 0, _g1 = Reflect.fields(v);
		while(_g < _g1.length) {
			var f = _g1[_g];
			++_g;
			this.serializeString(f);
			this.serialize(Reflect.field(v,f));
		}
		this.buf.b += "g";
	}
	,serializeRef: function(v) {
		var vt = typeof(v);
		var _g1 = 0, _g = this.cache.length;
		while(_g1 < _g) {
			var i = _g1++;
			var ci = this.cache[i];
			if(typeof(ci) == vt && ci == v) {
				this.buf.b += "r";
				this.buf.b += Std.string(i);
				return true;
			}
		}
		this.cache.push(v);
		return false;
	}
	,serializeString: function(s) {
		var x = this.shash.get(s);
		if(x != null) {
			this.buf.b += "R";
			this.buf.b += Std.string(x);
			return;
		}
		this.shash.set(s,this.scount++);
		this.buf.b += "y";
		s = StringTools.urlEncode(s);
		this.buf.b += Std.string(s.length);
		this.buf.b += ":";
		this.buf.b += Std.string(s);
	}
	,toString: function() {
		return this.buf.b;
	}
	,__class__: haxe.Serializer
}
haxe.Timer = function(time_ms) {
	var me = this;
	this.id = setInterval(function() {
		me.run();
	},time_ms);
};
$hxClasses["haxe.Timer"] = haxe.Timer;
haxe.Timer.__name__ = ["haxe","Timer"];
haxe.Timer.stamp = function() {
	return new Date().getTime() / 1000;
}
haxe.Timer.prototype = {
	run: function() {
		console.log("run");
	}
	,stop: function() {
		if(this.id == null) return;
		clearInterval(this.id);
		this.id = null;
	}
	,__class__: haxe.Timer
}
haxe.Unserializer = function(buf) {
	this.buf = buf;
	this.length = buf.length;
	this.pos = 0;
	this.scache = new Array();
	this.cache = new Array();
	var r = haxe.Unserializer.DEFAULT_RESOLVER;
	if(r == null) {
		r = Type;
		haxe.Unserializer.DEFAULT_RESOLVER = r;
	}
	this.setResolver(r);
};
$hxClasses["haxe.Unserializer"] = haxe.Unserializer;
haxe.Unserializer.__name__ = ["haxe","Unserializer"];
haxe.Unserializer.initCodes = function() {
	var codes = new Array();
	var _g1 = 0, _g = haxe.Unserializer.BASE64.length;
	while(_g1 < _g) {
		var i = _g1++;
		codes[haxe.Unserializer.BASE64.charCodeAt(i)] = i;
	}
	return codes;
}
haxe.Unserializer.run = function(v) {
	return new haxe.Unserializer(v).unserialize();
}
haxe.Unserializer.prototype = {
	unserialize: function() {
		var _g = this.buf.charCodeAt(this.pos++);
		switch(_g) {
		case 110:
			return null;
		case 116:
			return true;
		case 102:
			return false;
		case 122:
			return 0;
		case 105:
			return this.readDigits();
		case 100:
			var p1 = this.pos;
			while(true) {
				var c = this.buf.charCodeAt(this.pos);
				if(c >= 43 && c < 58 || c == 101 || c == 69) this.pos++; else break;
			}
			return Std.parseFloat(HxOverrides.substr(this.buf,p1,this.pos - p1));
		case 121:
			var len = this.readDigits();
			if(this.buf.charCodeAt(this.pos++) != 58 || this.length - this.pos < len) throw "Invalid string length";
			var s = HxOverrides.substr(this.buf,this.pos,len);
			this.pos += len;
			s = StringTools.urlDecode(s);
			this.scache.push(s);
			return s;
		case 107:
			return Math.NaN;
		case 109:
			return Math.NEGATIVE_INFINITY;
		case 112:
			return Math.POSITIVE_INFINITY;
		case 97:
			var buf = this.buf;
			var a = new Array();
			this.cache.push(a);
			while(true) {
				var c = this.buf.charCodeAt(this.pos);
				if(c == 104) {
					this.pos++;
					break;
				}
				if(c == 117) {
					this.pos++;
					var n = this.readDigits();
					a[a.length + n - 1] = null;
				} else a.push(this.unserialize());
			}
			return a;
		case 111:
			var o = { };
			this.cache.push(o);
			this.unserializeObject(o);
			return o;
		case 114:
			var n = this.readDigits();
			if(n < 0 || n >= this.cache.length) throw "Invalid reference";
			return this.cache[n];
		case 82:
			var n = this.readDigits();
			if(n < 0 || n >= this.scache.length) throw "Invalid string reference";
			return this.scache[n];
		case 120:
			throw this.unserialize();
			break;
		case 99:
			var name = this.unserialize();
			var cl = this.resolver.resolveClass(name);
			if(cl == null) throw "Class not found " + name;
			var o = Type.createEmptyInstance(cl);
			this.cache.push(o);
			this.unserializeObject(o);
			return o;
		case 119:
			var name = this.unserialize();
			var edecl = this.resolver.resolveEnum(name);
			if(edecl == null) throw "Enum not found " + name;
			var e = this.unserializeEnum(edecl,this.unserialize());
			this.cache.push(e);
			return e;
		case 106:
			var name = this.unserialize();
			var edecl = this.resolver.resolveEnum(name);
			if(edecl == null) throw "Enum not found " + name;
			this.pos++;
			var index = this.readDigits();
			var tag = Type.getEnumConstructs(edecl)[index];
			if(tag == null) throw "Unknown enum index " + name + "@" + index;
			var e = this.unserializeEnum(edecl,tag);
			this.cache.push(e);
			return e;
		case 108:
			var l = new List();
			this.cache.push(l);
			var buf = this.buf;
			while(this.buf.charCodeAt(this.pos) != 104) l.add(this.unserialize());
			this.pos++;
			return l;
		case 98:
			var h = new haxe.ds.StringMap();
			this.cache.push(h);
			var buf = this.buf;
			while(this.buf.charCodeAt(this.pos) != 104) {
				var s = this.unserialize();
				h.set(s,this.unserialize());
			}
			this.pos++;
			return h;
		case 113:
			var h = new haxe.ds.IntMap();
			this.cache.push(h);
			var buf = this.buf;
			var c = this.buf.charCodeAt(this.pos++);
			while(c == 58) {
				var i = this.readDigits();
				h.set(i,this.unserialize());
				c = this.buf.charCodeAt(this.pos++);
			}
			if(c != 104) throw "Invalid IntMap format";
			return h;
		case 77:
			var h = new haxe.ds.ObjectMap();
			this.cache.push(h);
			var buf = this.buf;
			while(this.buf.charCodeAt(this.pos) != 104) {
				var s = this.unserialize();
				h.set(s,this.unserialize());
			}
			this.pos++;
			return h;
		case 118:
			var d = HxOverrides.strDate(HxOverrides.substr(this.buf,this.pos,19));
			this.cache.push(d);
			this.pos += 19;
			return d;
		case 115:
			var len = this.readDigits();
			var buf = this.buf;
			if(this.buf.charCodeAt(this.pos++) != 58 || this.length - this.pos < len) throw "Invalid bytes length";
			var codes = haxe.Unserializer.CODES;
			if(codes == null) {
				codes = haxe.Unserializer.initCodes();
				haxe.Unserializer.CODES = codes;
			}
			var i = this.pos;
			var rest = len & 3;
			var size = (len >> 2) * 3 + (rest >= 2?rest - 1:0);
			var max = i + (len - rest);
			var bytes = haxe.io.Bytes.alloc(size);
			var bpos = 0;
			while(i < max) {
				var c1 = codes[buf.charCodeAt(i++)];
				var c2 = codes[buf.charCodeAt(i++)];
				bytes.b[bpos++] = (c1 << 2 | c2 >> 4) & 255;
				var c3 = codes[buf.charCodeAt(i++)];
				bytes.b[bpos++] = (c2 << 4 | c3 >> 2) & 255;
				var c4 = codes[buf.charCodeAt(i++)];
				bytes.b[bpos++] = (c3 << 6 | c4) & 255;
			}
			if(rest >= 2) {
				var c1 = codes[buf.charCodeAt(i++)];
				var c2 = codes[buf.charCodeAt(i++)];
				bytes.b[bpos++] = (c1 << 2 | c2 >> 4) & 255;
				if(rest == 3) {
					var c3 = codes[buf.charCodeAt(i++)];
					bytes.b[bpos++] = (c2 << 4 | c3 >> 2) & 255;
				}
			}
			this.pos += len;
			this.cache.push(bytes);
			return bytes;
		case 67:
			var name = this.unserialize();
			var cl = this.resolver.resolveClass(name);
			if(cl == null) throw "Class not found " + name;
			var o = Type.createEmptyInstance(cl);
			this.cache.push(o);
			o.hxUnserialize(this);
			if(this.buf.charCodeAt(this.pos++) != 103) throw "Invalid custom data";
			return o;
		default:
		}
		this.pos--;
		throw "Invalid char " + this.buf.charAt(this.pos) + " at position " + this.pos;
	}
	,unserializeEnum: function(edecl,tag) {
		if(this.buf.charCodeAt(this.pos++) != 58) throw "Invalid enum format";
		var nargs = this.readDigits();
		if(nargs == 0) return Type.createEnum(edecl,tag);
		var args = new Array();
		while(nargs-- > 0) args.push(this.unserialize());
		return Type.createEnum(edecl,tag,args);
	}
	,unserializeObject: function(o) {
		while(true) {
			if(this.pos >= this.length) throw "Invalid object";
			if(this.buf.charCodeAt(this.pos) == 103) break;
			var k = this.unserialize();
			if(!js.Boot.__instanceof(k,String)) throw "Invalid object key";
			var v = this.unserialize();
			o[k] = v;
		}
		this.pos++;
	}
	,readDigits: function() {
		var k = 0;
		var s = false;
		var fpos = this.pos;
		while(true) {
			var c = this.buf.charCodeAt(this.pos);
			if(c != c) break;
			if(c == 45) {
				if(this.pos != fpos) break;
				s = true;
				this.pos++;
				continue;
			}
			if(c < 48 || c > 57) break;
			k = k * 10 + (c - 48);
			this.pos++;
		}
		if(s) k *= -1;
		return k;
	}
	,setResolver: function(r) {
		if(r == null) this.resolver = { resolveClass : function(_) {
			return null;
		}, resolveEnum : function(_) {
			return null;
		}}; else this.resolver = r;
	}
	,__class__: haxe.Unserializer
}
haxe.ds.IntMap = function() {
	this.h = { };
};
$hxClasses["haxe.ds.IntMap"] = haxe.ds.IntMap;
haxe.ds.IntMap.__name__ = ["haxe","ds","IntMap"];
haxe.ds.IntMap.__interfaces__ = [IMap];
haxe.ds.IntMap.prototype = {
	keys: function() {
		var a = [];
		for( var key in this.h ) {
		if(this.h.hasOwnProperty(key)) a.push(key | 0);
		}
		return HxOverrides.iter(a);
	}
	,get: function(key) {
		return this.h[key];
	}
	,set: function(key,value) {
		this.h[key] = value;
	}
	,__class__: haxe.ds.IntMap
}
haxe.ds.ObjectMap = function() {
	this.h = { };
	this.h.__keys__ = { };
};
$hxClasses["haxe.ds.ObjectMap"] = haxe.ds.ObjectMap;
haxe.ds.ObjectMap.__name__ = ["haxe","ds","ObjectMap"];
haxe.ds.ObjectMap.__interfaces__ = [IMap];
haxe.ds.ObjectMap.prototype = {
	keys: function() {
		var a = [];
		for( var key in this.h.__keys__ ) {
		if(this.h.hasOwnProperty(key)) a.push(this.h.__keys__[key]);
		}
		return HxOverrides.iter(a);
	}
	,set: function(key,value) {
		var id = key.__id__ != null?key.__id__:key.__id__ = ++haxe.ds.ObjectMap.count;
		this.h[id] = value;
		this.h.__keys__[id] = key;
	}
	,__class__: haxe.ds.ObjectMap
}
haxe.io = {}
haxe.io.Bytes = function(length,b) {
	this.length = length;
	this.b = b;
};
$hxClasses["haxe.io.Bytes"] = haxe.io.Bytes;
haxe.io.Bytes.__name__ = ["haxe","io","Bytes"];
haxe.io.Bytes.alloc = function(length) {
	var a = new Array();
	var _g = 0;
	while(_g < length) {
		var i = _g++;
		a.push(0);
	}
	return new haxe.io.Bytes(length,a);
}
haxe.io.Bytes.prototype = {
	__class__: haxe.io.Bytes
}
var js = {}
js.Boot = function() { }
$hxClasses["js.Boot"] = js.Boot;
js.Boot.__name__ = ["js","Boot"];
js.Boot.__string_rec = function(o,s) {
	if(o == null) return "null";
	if(s.length >= 5) return "<...>";
	var t = typeof(o);
	if(t == "function" && (o.__name__ || o.__ename__)) t = "object";
	switch(t) {
	case "object":
		if(o instanceof Array) {
			if(o.__enum__) {
				if(o.length == 2) return o[0];
				var str = o[0] + "(";
				s += "\t";
				var _g1 = 2, _g = o.length;
				while(_g1 < _g) {
					var i = _g1++;
					if(i != 2) str += "," + js.Boot.__string_rec(o[i],s); else str += js.Boot.__string_rec(o[i],s);
				}
				return str + ")";
			}
			var l = o.length;
			var i;
			var str = "[";
			s += "\t";
			var _g = 0;
			while(_g < l) {
				var i1 = _g++;
				str += (i1 > 0?",":"") + js.Boot.__string_rec(o[i1],s);
			}
			str += "]";
			return str;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( e ) {
			return "???";
		}
		if(tostr != null && tostr != Object.toString) {
			var s2 = o.toString();
			if(s2 != "[object Object]") return s2;
		}
		var k = null;
		var str = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		for( var k in o ) { ;
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str.length != 2) str += ", \n";
		str += s + k + " : " + js.Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str += "\n" + s + "}";
		return str;
	case "function":
		return "<function>";
	case "string":
		return o;
	default:
		return String(o);
	}
}
js.Boot.__interfLoop = function(cc,cl) {
	if(cc == null) return false;
	if(cc == cl) return true;
	var intf = cc.__interfaces__;
	if(intf != null) {
		var _g1 = 0, _g = intf.length;
		while(_g1 < _g) {
			var i = _g1++;
			var i1 = intf[i];
			if(i1 == cl || js.Boot.__interfLoop(i1,cl)) return true;
		}
	}
	return js.Boot.__interfLoop(cc.__super__,cl);
}
js.Boot.__instanceof = function(o,cl) {
	try {
		if(o instanceof cl) {
			if(cl == Array) return o.__enum__ == null;
			return true;
		}
		if(js.Boot.__interfLoop(o.__class__,cl)) return true;
	} catch( e ) {
		if(cl == null) return false;
	}
	switch(cl) {
	case Int:
		return Math.ceil(o%2147483648.0) === o;
	case Float:
		return typeof(o) == "number";
	case Bool:
		return o === true || o === false;
	case String:
		return typeof(o) == "string";
	case Dynamic:
		return true;
	default:
		if(o == null) return false;
		if(cl == Class && o.__name__ != null) return true; else null;
		if(cl == Enum && o.__ename__ != null) return true; else null;
		return o.__enum__ == cl;
	}
}
js.Browser = function() { }
$hxClasses["js.Browser"] = js.Browser;
js.Browser.__name__ = ["js","Browser"];
js.Browser.createXMLHttpRequest = function() {
	if(typeof XMLHttpRequest != "undefined") return new XMLHttpRequest();
	if(typeof ActiveXObject != "undefined") return new ActiveXObject("Microsoft.XMLHTTP");
	throw "Unable to create XMLHttpRequest object.";
}
function $iterator(o) { if( o instanceof Array ) return function() { return HxOverrides.iter(o); }; return typeof(o.iterator) == 'function' ? $bind(o,o.iterator) : o.iterator; };
var $_;
function $bind(o,m) { var f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; return f; };
if(Array.prototype.indexOf) HxOverrides.remove = function(a,o) {
	var i = a.indexOf(o);
	if(i == -1) return false;
	a.splice(i,1);
	return true;
}; else null;
Math.__name__ = ["Math"];
Math.NaN = Number.NaN;
Math.NEGATIVE_INFINITY = Number.NEGATIVE_INFINITY;
Math.POSITIVE_INFINITY = Number.POSITIVE_INFINITY;
$hxClasses.Math = Math;
Math.isFinite = function(i) {
	return isFinite(i);
};
Math.isNaN = function(i) {
	return isNaN(i);
};
String.prototype.__class__ = $hxClasses.String = String;
String.__name__ = ["String"];
Array.prototype.__class__ = $hxClasses.Array = Array;
Array.__name__ = ["Array"];
Date.prototype.__class__ = $hxClasses.Date = Date;
Date.__name__ = ["Date"];
var Int = $hxClasses.Int = { __name__ : ["Int"]};
var Dynamic = $hxClasses.Dynamic = { __name__ : ["Dynamic"]};
var Float = $hxClasses.Float = Number;
Float.__name__ = ["Float"];
var Bool = $hxClasses.Bool = Boolean;
Bool.__ename__ = ["Bool"];
var Class = $hxClasses.Class = { __name__ : ["Class"]};
var Enum = { };
if(typeof(JSON) != "undefined") haxe.Json = JSON;
Expand.buttons = [];
Markdown.regex = [{ from : new EReg("\\x3E ([^\n]+)","g"), to : "<blockquote>$1</blockquote>"},{ from : new EReg("___([^___]+)___","g"), to : "<b><i>$1</i></b>"},{ from : new EReg("\\*\\*([^\\*\\*|\\*]+)\\*\\*","g"), to : "<b>$1</b>"},{ from : new EReg("__([^__|_]+)__","g"), to : "<b>$1</b>"},{ from : new EReg("\\*([^\\*|\\*\\*]+)\\*","g"), to : "<i>$1</i>"},{ from : new EReg("_([^_|__]+)_","g"), to : "<i>$1</i>"},{ from : new EReg("\\[([^\\]]+)\\]\\(([^\\)]+)\\)","g"), to : "<a href=\"$2\">$1</a>"},{ from : new EReg("(.*?)\n\\x3D=*","g"), to : "<h2>$1</h2>"},{ from : new EReg("(.*?)\n\\x2D-*","g"), to : "<h3>$1</h3>"},{ from : new EReg("\\x23\\x23\\x23\\x23\\x23\\x23([^\n]+)\n","g"), to : "<h6>$1</h6>"},{ from : new EReg("\\x23\\x23\\x23\\x23\\x23([^\n]+)\n","g"), to : "<h5>$1/h5>"},{ from : new EReg("\\x23\\x23\\x23\\x23([^\n]+)\n","g"), to : "<h4>$1</h4>"},{ from : new EReg("\\x23\\x23\\x23([^\n]+)\n","g"), to : "<h3>$1</h3>"},{ from : new EReg("\\x23\\x23([^\n]+)\n","g"), to : "<h2>$1</h2>"},{ from : new EReg("\\x23([^\n]+)\n","g"), to : "<h1>$1</h1>"},{ from : new EReg("\n?([^\n]+)\n\n","g"), to : "<p>$1</p>"},{ from : new EReg("\n?([^\n]+)\n","g"), to : "$1 "},{ from : new EReg("\n[\\+\\*\\-] ([^\n]+)","g"), to : "<li><p>$1</p></li>"},{ from : new EReg("\n[0-9]*[.\\):]([^\n]+)","g"), to : "<li><p>$1</p></li>"},{ from : new EReg("\\x3Cli\\x3E([^\n+]+)\\x3C/li\\x3E",""), to : "<ul><li>$1</li></ul>"}];
Reditn.fullPage = true;
Settings.DESC = (function($this) {
	var $r;
	var _g = new haxe.ds.StringMap();
	_g.set("adblock","Block advertisements and sponsors");
	_g.set("userinfo","Show information about a user upon hover");
	_g.set("subinfo","Show information about a subreddit upon hover");
	_g.set("expand","Allow expansion of images");
	_g.set("dup-hider","Hide duplicate links");
	_g.set("user-tag","Tag users");
	_g.set("sub-tag","Tag subreddits");
	_g.set("preview","Preview comments and posts");
	_g.set("keys","Keyboard shortcuts");
	_g.set("nsfw-filter","Hide NSFW content");
	$r = _g;
	return $r;
}(this));
Settings.DEFAULTS = (function($this) {
	var $r;
	var _g = new haxe.ds.StringMap();
	_g.set("adblock",true);
	_g.set("userinfo",true);
	_g.set("subinfo",true);
	_g.set("expand",true);
	_g.set("dup-hider",true);
	_g.set("user-tag",true);
	_g.set("sub-tag",true);
	_g.set("preview",true);
	_g.set("keys",true);
	_g.set("nsfw-filter",true);
	_g.set("user-tags",new haxe.ds.StringMap());
	_g.set("sub-tags",new haxe.ds.StringMap());
	$r = _g;
	return $r;
}(this));
Settings.data = new haxe.ds.StringMap();
haxe.Serializer.USE_CACHE = false;
haxe.Serializer.USE_ENUM_INDEX = false;
haxe.Serializer.BASE64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789%:";
haxe.Unserializer.DEFAULT_RESOLVER = Type;
haxe.Unserializer.BASE64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789%:";
haxe.ds.ObjectMap.count = 0;
js.Browser.window = typeof window != "undefined" ? window : null;
js.Browser.document = typeof window != "undefined" ? window.document : null;
Reditn.main();
function $hxExpose(src, path) {
	var o = typeof window != "undefined" ? window : exports;
	var parts = path.split(".");
	for(var ii = 0; ii < parts.length-1; ++ii) {
		var p = parts[ii];
		if(typeof o[p] == "undefined") o[p] = {};
		o = o[p];
	}
	o[parts[parts.length-1]] = src;
}
})();
