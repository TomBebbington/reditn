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
	if(sidebarAd != null) Reditn.show(sidebarAd,false);
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
		if(Lambda.has(seen,link.href)) Reditn.show(link.parentElement.parentElement.parentElement,false); else seen.push(link.href);
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
	,matchSub: function(s,pos,len) {
		if(len == null) len = -1;
		return this.r.global?(function($this) {
			var $r;
			$this.r.lastIndex = pos;
			$this.r.m = $this.r.exec(len < 0?s:HxOverrides.substr(s,0,pos + len));
			var b = $this.r.m != null;
			if(b) $this.r.s = s;
			$r = b;
			return $r;
		}(this)):(function($this) {
			var $r;
			var b = $this.match(len < 0?HxOverrides.substr(s,pos,null):HxOverrides.substr(s,pos,len));
			if(b) {
				$this.r.s = s;
				$this.r.m.index += pos;
			}
			$r = b;
			return $r;
		}(this));
	}
	,matchedPos: function() {
		if(this.r.m == null) throw "No string matched";
		return { pos : this.r.m.index, len : this.r.m[0].length};
	}
	,matchedRight: function() {
		if(this.r.m == null) throw "No string matched";
		var sz = this.r.m.index + this.r.m[0].length;
		return this.r.s.substr(sz,this.r.s.length - sz);
	}
	,matchedLeft: function() {
		if(this.r.m == null) throw "No string matched";
		return this.r.s.substr(0,this.r.m.index);
	}
	,matched: function(n) {
		return this.r.m != null && n >= 0 && n < this.r.m.length?this.r.m[n]:(function($this) {
			var $r;
			throw "EReg::matched";
			return $r;
		}(this));
	}
	,match: function(s) {
		if(this.r.global) this.r.lastIndex = 0;
		this.r.m = this.r.exec(s);
		this.r.s = s;
		return this.r.m != null;
	}
	,__class__: EReg
}
var Expand = function() { }
$hxClasses["Expand"] = Expand;
Expand.__name__ = ["Expand"];
Expand.init = function() {
	Expand.toggled = js.Browser.window.location.hash == "#showall";
	var menu = js.Browser.document.getElementsByClassName("tabmenu")[0];
	var li = js.Browser.document.createElement("li");
	Expand.button = js.Browser.document.createElement("a");
	Expand.button.href = "javascript:void(0);";
	Expand.refresh();
	Expand.button.onclick = function(e) {
		Expand.toggle(!Expand.toggled);
		js.Browser.window.history.pushState(haxe.Serializer.run(Reditn.state()),null,Expand.toggled?"#showall":"#");
	};
	li.appendChild(Expand.button);
	if(menu != null) menu.appendChild(li);
	var _g = 0, _g1 = Reditn.links;
	while(_g < _g1.length) {
		var l = [_g1[_g]];
		++_g;
		if(l[0].nodeName.toLowerCase() != "a") continue;
		l[0].onchange = (function(l) {
			return function(_) {
				var site = Link.resolve(l[0].href);
				if(site == null) Expand.defaultButton(l[0].parentElement.parentElement.parentElement); else site.method(site.regex,(function(l) {
					return function(data) {
						var e = l[0].parentElement.parentElement.parentElement;
						var exp = js.Browser.document.createElement("div");
						exp.className = "expando";
						exp.style.display = "none";
						Reditn.show(exp,Expand.toggled);
						var name = "selftext";
						if(Reflect.hasField(data,"urls")) {
							var p = data;
							var urls = (function($this) {
								var $r;
								var _g2 = [];
								var $it0 = p.urls.keys();
								while( $it0.hasNext() ) {
									var uk = $it0.next();
									_g2.push("<li><a href=\"" + p.urls.get(uk) + "\">" + uk + "</a></li>");
								}
								$r = _g2;
								return $r;
							}(this));
							var div = js.Browser.document.createElement("div");
							div.className = "usertext";
							exp.appendChild(div);
							var content = js.Browser.document.createElement("div");
							content.appendChild(Reditn.embedMap((function($this) {
								var $r;
								var _g3 = new haxe.ds.StringMap();
								_g3.set("Name",data.name);
								_g3.set("Description",data.description);
								_g3.set("Links",urls.join(""));
								$r = _g3;
								return $r;
							}(this))));
							if(p.album.length > 0) {
								content.appendChild(js.Browser.document.createElement("br"));
								content.appendChild(Reditn.embedAlbum(p.album));
							}
							div.appendChild(content);
						} else if(Reflect.hasField(data,"price")) {
							var i = data;
							var div = js.Browser.document.createElement("div");
							div.className = "usertext";
							exp.appendChild(div);
							var cont = js.Browser.document.createElement("div");
							cont.appendChild(Reditn.embedMap((function($this) {
								var $r;
								var _g2 = new haxe.ds.StringMap();
								_g2.set("Category",StringTools.htmlEscape(i.category));
								_g2.set("Location",StringTools.htmlEscape(i.location));
								_g2.set("Price",StringTools.htmlEscape(i.price));
								_g2.set("Description",i.description);
								$r = _g2;
								return $r;
							}(this))));
							cont.appendChild(Reditn.embedAlbum(i.images));
							div.appendChild(cont);
							name = "item";
						} else if(Reflect.hasField(data,"subscribers")) {
							var s = data;
							var div = js.Browser.document.createElement("div");
							div.className = "usertext";
							exp.appendChild(div);
							var content = Reditn.embedMap((function($this) {
								var $r;
								var _g2 = new haxe.ds.StringMap();
								_g2.set("Age",Reditn.age(s.created_utc));
								_g2.set("Subscribers",Reditn.formatNumber(s.subscribers));
								_g2.set("Active users",Reditn.formatNumber(s.accounts_active));
								_g2.set("Description",parser.Markdown.parse(s.description));
								$r = _g2;
								return $r;
							}(this)));
							div.appendChild(content);
						} else if(Reflect.hasField(data,"content")) {
							var a = data;
							var div = js.Browser.document.createElement("div");
							div.className = "usertext";
							exp.appendChild(div);
							var head = null;
							var content = js.Browser.document.createElement("div");
							var inner = js.Browser.document.createElement("span");
							inner.innerHTML = a.content;
							content.appendChild(inner);
							if(a.images.length > 0) {
								content.appendChild(js.Browser.document.createElement("br"));
								content.appendChild(Reditn.embedAlbum(a.images));
							}
							content.className = "md";
							div.appendChild(content);
						} else if(js.Boot.__instanceof(data,Array) && Reflect.hasField(data[0],"url")) {
							var a = data;
							var div = Reditn.embedAlbum(a);
							exp.appendChild(div);
							name = "image";
						} else if(Reflect.hasField(data,"developers")) {
							var r = data;
							var div = js.Browser.document.createElement("div");
							div.className = "usertext";
							var cont = js.Browser.document.createElement("div");
							var inner = js.Browser.document.createElement("span");
							inner.innerHTML = "" + Std.string(data.description) + "<br><a href=\"" + Std.string(data.url) + "\"><b>Clone repo</b></a><br>";
							if(r.album != null && r.album.length > 0) inner.appendChild(Reditn.embedAlbum(r.album));
							cont.appendChild(inner);
							cont.className = "md";
							div.appendChild(cont);
							exp.appendChild(div);
						} else Expand.defaultButton(e);
						var s = Expand.createButton(e,name,l[0].href);
						var pn = s.parentElement;
						var _g2 = 0, _g3 = pn.getElementsByClassName("expando");
						while(_g2 < _g3.length) {
							var ep = _g3[_g2];
							++_g2;
							pn.removeChild(ep);
						}
						pn.appendChild(exp);
					};
				})(l));
				Expand.refresh();
			};
		})(l);
		l[0].onchange(null);
	}
}
Expand.defaultButton = function(cont) {
	var one = false;
	var _g = 0, _g1 = cont.getElementsByClassName("expando-button");
	while(_g < _g1.length) {
		var be = _g1[_g];
		++_g;
		if(one) be.parentNode.removeChild(be); else {
			if(be != null) {
				var b = Expand.adaptButton(be);
				b.toggle(Expand.toggled,false);
				Expand.buttons.push(b);
			}
			one = true;
		}
	}
}
Expand.adaptButton = function(exp) {
	var url = (js.Boot.__cast(exp.parentElement.getElementsByTagName("a")[0] , HTMLAnchorElement)).href;
	return { toggled : function() {
		return exp.className.indexOf("expanded") != -1;
	}, toggle : function(v,ps) {
		var c = exp.className.indexOf("expanded") != -1;
		if(v != c) exp.onclick(null);
		Expand.queue++;
		var check = function() {
			if(exp.parentElement.getElementsByClassName("error").length > 0) {
				exp.onclick(null);
				exp.onclick(null);
			} else Expand.queue--;
		};
		haxe.Timer.delay(function() {
			check();
		},Expand.queue * 1000);
		if(ps) js.Browser.window.history.pushState(haxe.Serializer.run(Reditn.state()),null,null);
	}, url : url, element : exp};
}
Expand.createButton = function(e,extra,url) {
	var d = js.Browser.document.createElement("div");
	var cn = "expando-button " + extra + " ";
	d.className = "" + cn + " collapsed";
	var isToggled = false;
	var btn = { toggled : function() {
		return isToggled;
	}, toggle : function(v,ps) {
		isToggled = v;
		d.className = cn + (isToggled?"expanded":"collapsed");
		var entry = d.parentElement;
		var expandos = entry.getElementsByClassName("expando");
		var _g = 0;
		while(_g < expandos.length) {
			var e1 = expandos[_g];
			++_g;
			Reditn.show(e1,v);
		}
		if(ps) js.Browser.window.history.pushState(haxe.Serializer.run(Reditn.state()),null,null);
	}, url : url, element : d};
	d.onclick = function(_) {
		btn.toggle(!isToggled,true);
	};
	var tagline = e.getElementsByClassName("tagline")[0];
	tagline.parentNode.insertBefore(d,tagline);
	Expand.buttons.push(btn);
	if(Expand.toggled) btn.toggle(true,false);
	return d;
}
Expand.refresh = function() {
	if(Expand.button != null) {
		Expand.button.innerHTML = "" + (Expand.toggled?"hide":"show") + " all";
		var nps = js.Browser.document.body.getElementsByClassName("nextprev");
		var _g = 0;
		while(_g < nps.length) {
			var np = nps[_g];
			++_g;
			var np1 = (function($this) {
				var $r;
				var _g1 = [];
				{
					var _g2 = 0, _g3 = np.getElementsByTagName("a");
					while(_g2 < _g3.length) {
						var l = _g3[_g2];
						++_g2;
						_g1.push(l);
					}
				}
				$r = _g1;
				return $r;
			}(this));
			var _g2 = 0;
			while(_g2 < np1.length) {
				var i = np1[_g2];
				++_g2;
				if(i.nodeName.toLowerCase() != "a") continue;
				if(Expand.toggled && i.href.indexOf("#") == -1) i.href += "#showall"; else if(!Expand.toggled && i.href.indexOf("#") != -1) i.href = HxOverrides.substr(i.href,0,i.href.indexOf("#"));
			}
		}
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
Expand.initResize = function(i) {
	var drx = 0.0, dry = 0.0, rt = 0.0, ow = 0, oh = 0;
	var drag = false;
	i.addEventListener("mousedown",function(ev) {
		if(!ev.altKey && !ev.ctrlKey && !ev.metaKey) {
			drag = true;
			var cr = i.getBoundingClientRect();
			var relx = ev.clientX - cr.left, rely = ev.clientY - cr.top;
			var ev1 = ev;
			drx = i.offsetWidth / relx;
			dry = i.offsetHeight / rely;
			rt = i.offsetWidth / i.offsetHeight;
			ev1.preventDefault();
		}
	});
	i.addEventListener("mousemove",function(ev) {
		if(drag) {
			var cr = i.getBoundingClientRect();
			var relx = ev.clientX - cr.left, rely = ev.clientY - cr.top;
			var nw = relx * drx;
			var nwh = nw / rt;
			var nh = rely * dry;
			var nhw = nh * rt;
			i.width = (nwh > nh || nw > nhw?nw:nhw) | 0;
			i.height = (nwh > nh || nw > nhw?nwh:nh) | 0;
			ev.preventDefault();
		}
	});
	i.addEventListener("dblclick",function(e) {
		i.width = i.naturalWidth;
		i.height = i.naturalHeight;
	});
	i.addEventListener("mouseup",function(e) {
		drag = false;
		e.preventDefault();
	});
	i.addEventListener("mouseout",function(e) {
		drag = false;
		e.preventDefault();
	});
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
Keyboard.init = function() {
	js.Browser.document.onkeydown = function(e) {
		Keyboard.keyDown(e.keyCode);
	};
}
Keyboard.unhighlight = function() {
	if((Reditn.links[Keyboard.current] != null?Reditn.links[Keyboard.current].parentElement.parentElement.parentElement:null) != null) (Reditn.links[Keyboard.current] != null?Reditn.links[Keyboard.current].parentElement.parentElement.parentElement:null).style.border = "";
}
Keyboard.highlight = function(dir) {
	Keyboard.unhighlight();
	if(Keyboard.current != null && Keyboard.current + dir < Reditn.links.length) Keyboard.current += dir; else dir = 0;
	if(Keyboard.current == null || (Reditn.links[Keyboard.current] != null?Reditn.links[Keyboard.current].parentElement.parentElement.parentElement:null) == null) Keyboard.current = 0;
	(Reditn.links[Keyboard.current] != null?Reditn.links[Keyboard.current].parentElement.parentElement.parentElement:null).style.border = "3px solid grey";
	(Reditn.links[Keyboard.current] != null?Reditn.links[Keyboard.current].parentElement.parentElement.parentElement:null).scrollIntoViewIfNeeded(true);
}
Keyboard.show = function(s) {
	if(s == null) s = true;
	var btn = (Reditn.links[Keyboard.current] != null?Reditn.links[Keyboard.current].parentElement.parentElement.parentElement:null).getElementsByClassName("expando-button")[0];
	var _g = 0, _g1 = Expand.buttons;
	while(_g < _g1.length) {
		var b = _g1[_g];
		++_g;
		if(b.element == btn) {
			b.toggle(s,true);
			(Reditn.links[Keyboard.current] != null?Reditn.links[Keyboard.current].parentElement.parentElement.parentElement:null).scrollIntoViewIfNeeded(true);
			break;
		}
	}
}
Keyboard.keyDown = function(c) {
	Keyboard.keys.push(c);
	while(Keyboard.keys.length > Keyboard.konami.length) HxOverrides.remove(Keyboard.keys,Keyboard.keys[0]);
	var isKon = Keyboard.keys.length >= Keyboard.konami.length;
	var _g1 = 0, _g = Keyboard.keys.length;
	while(_g1 < _g) {
		var i = _g1++;
		if(Keyboard.keys[i] != Keyboard.konami[i]) {
			isKon = false;
			break;
		}
	}
	if(isKon) Konami.run();
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
	default:
	}
}
var Konami = function() { }
$hxClasses["Konami"] = Konami;
Konami.__name__ = ["Konami"];
Konami.translate = function(p) {
	var pos = 0;
	while(Konami.filter.matchSub(p,pos)) {
		var mp = Konami.filter.matchedPos();
		var word = Konami.words[Std.random(Konami.words.length)];
		console.log(word);
		pos = mp.pos + word.length;
		p = Konami.filter.matchedLeft() + word + Konami.filter.matchedRight();
	}
	return p;
}
Konami.run = function() {
	js.Browser.document.title = "Dubbit - the back page of the wubbanet";
	var _g = 0, _g1 = Reditn.links;
	while(_g < _g1.length) {
		var l = _g1[_g];
		++_g;
		l.innerHTML = Konami.translate(l.innerHTML);
	}
	var _g = 0, _g1 = js.Browser.document.body.getElementsByClassName("author");
	while(_g < _g1.length) {
		var a = _g1[_g];
		++_g;
		var a1 = a;
		a1.innerHTML = "dubstep";
	}
	var _g = 0, _g1 = js.Browser.document.body.getElementsByClassName("subreddit");
	while(_g < _g1.length) {
		var s = _g1[_g];
		++_g;
		var s1 = s;
		s1.innerHTML = "people with brains";
	}
	var _g = 0, _g1 = js.Browser.document.body.getElementsByClassName("score");
	while(_g < _g1.length) {
		var s = _g1[_g];
		++_g;
		var s1 = s;
		s1.innerHTML = "-&infin;";
	}
	var _g = 0, _g1 = js.Browser.document.body.getElementsByTagName("p");
	while(_g < _g1.length) {
		var p = _g1[_g];
		++_g;
		var p1 = p;
		if(p1.className == "parent") continue;
		p1.innerHTML = Konami.translate(p1.innerHTML);
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
var Reditn = function() { }
$hxClasses["Reditn"] = Reditn;
$hxExpose(Reditn, "Reditn");
Reditn.__name__ = ["Reditn"];
Reditn.main = function() {
	var _g = js.Browser;
	switch(_g.document.readyState) {
	case "complete":
		Reditn.init();
		break;
	default:
		js.Browser.window.onload = function(_) {
			Reditn.init();
		};
	}
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
				var l = [_g2[_g1]];
				++_g1;
				if(l[0].nodeName.toLowerCase() == "a" && l[0].parentElement.className != "parent") _g.push((function($this) {
					var $r;
					Reditn.expandURL(l[0].href,(function(l) {
						return function(url) {
							l[0].href = url;
							if(l[0].onchange != null) l[0].onchange(null);
						};
					})(l));
					$r = l[0];
					return $r;
				}($this)));
			}
		}
		$r = _g;
		return $r;
	}(this));
	Reditn.wrap(Settings.init);
	Reditn.wrap(Adblock.init,"adblock");
	Reditn.wrap(DuplicateHider.init,"dup-hider");
	Reditn.wrap(NSFWFilter.init,"nsfw-filter");
	Style.init();
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
		if(state.allExpanded != Expand.toggled) Expand.toggle(state.allExpanded);
		var _g1 = 0, _g2 = Expand.buttons;
		while(_g1 < _g2.length) {
			var btn = _g2[_g1];
			++_g1;
			var ex = state.expanded;
			if(ex.exists(btn.url)) btn.toggle(ex.get(btn.url),false);
		}
	};
}
Reditn.state = function() {
	var exp = new haxe.ds.StringMap();
	var _g = 0, _g1 = Expand.buttons;
	while(_g < _g1.length) {
		var btn = _g1[_g];
		++_g;
		if(btn.toggled() != Expand.toggled) exp.set(btn.url,btn.toggled());
	}
	return { allExpanded : Expand.toggled, expanded : exp};
}
Reditn.wrap = function(fn,id) {
	var d = id == null?null:Settings.data.get(id);
	if(id == null || d) fn();
}
Reditn.formatNumber = function(n) {
	return !Math.isFinite(n)?Std.string(n):(function($this) {
		var $r;
		var s = Std.string(Math.abs(n));
		var ad = s.indexOf(".") != -1?(function($this) {
			var $r;
			var t = HxOverrides.substr(s,s.indexOf("."),null);
			s = HxOverrides.substr(s,0,s.indexOf("."));
			$r = t;
			return $r;
		}($this)):"";
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
		$r = (n < 0?"-" + s:s) + ad;
		return $r;
	}(this));
}
Reditn.formatPrice = function(n) {
	var first = Reditn.formatNumber(n | 0);
	var last = Std.string(n);
	last = last.indexOf(".") == -1?".":HxOverrides.substr(last,last.indexOf("."),null);
	while(last.length < 3) last += "0";
	return "" + first + last;
}
Reditn.show = function(e,shown) {
	e.style.display = shown?"":"none";
	if(e.className.indexOf("link") != -1 && !shown) {
		var en = e.getElementsByClassName("entry")[0];
		HxOverrides.remove(Reditn.links,en.getElementsByTagName("a")[0]);
	}
}
Reditn.age = function(t) {
	if(t < 86400) return "less than a day";
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
Reditn.expandURL = function(ourl,cb) {
	var url = Link.trimURL(ourl);
	if(url.indexOf("/") == -1) cb(ourl); else {
		url = HxOverrides.substr(url,0,url.indexOf("/"));
		switch(url) {
		case "0rz.tw":case "1link.in":case "1url.com":case "2.gp":case "2big.at":case "2tu.us":case "3.ly":case "307.to":case "4ms.me":case "4sq.com":case "4url.cc":case "6url.com":case "7.ly":case "a.gg":case "a.nf":case "aa.cx":case "abcurl.net":case "ad.vu":case "adf.ly":case "adjix.com":case "afx.cc":case "all.fuseurl.com":case "alturl.com":case "amzn.to":case "ar.gy":case "arst.ch":case "atu.ca":case "azc.cc":case "b23.ru":case "b2l.me":case "bacn.me":case "bcool.bz":case "binged.it":case "bit.ly":case "bizj.us":case "bloat.me":case "bravo.ly":case "bsa.ly":case "budurl.com":case "canurl.com":case "chilp.it":case "chzb.gr":case "cl.lk":case "cl.ly":case "clck.ru":case "cli.gs":case "cliccami.info":case "clickthru.ca":case "clop.in":case "conta.cc":case "cort.as":case "cot.ag":case "crks.me":case "ctvr.us":case "cutt.us":case "dai.ly":case "decenturl.com":case "dfl8.me":case "digbig.com":case "digg.com":case "disq.us":case "dld.bz":case "dlvr.it":case "do.my":case "doiop.com":case "dopen.us":case "easyuri.com":case "easyurl.net":case "eepurl.com":case "eweri.com":case "fa.by":case "fav.me":case "fb.me":case "fbshare.me":case "ff.im":case "fff.to":case "fire.to":case "firsturl.de":case "firsturl.net":case "flic.kr":case "flq.us":case "fly2.ws":case "fon.gs":case "freak.to":case "fuseurl.com":case "fuzzy.to":case "fwd4.me":case "fwib.net":case "g.ro.lt":case "gizmo.do":case "gl.am":case "go.9nl.com":case "go.ign.com":case "go.usa.gov":case "goo.gl":case "goshrink.com":case "gurl.es":case "hex.io":case "hiderefer.com":case "hmm.ph":case "href.in":case "hsblinks.com":case "htxt.it":case "huff.to":case "hulu.com":case "hurl.me":case "hurl.ws":case "icanhaz.com":case "idek.net":case "ilix.in":case "is.gd":case "its.my":case "ix.lt":case "j.mp":case "jijr.com":case "kl.am":case "klck.me":case "korta.nu":case "krunchd.com":case "l9k.net":case "lat.ms":case "liip.to":case "liltext.com":case "linkbee.com":case "linkbun.ch":case "liurl.cn":case "ln-s.net":case "ln-s.ru":case "lnk.gd":case "lnk.ms":case "lnkd.in":case "lnkurl.com":case "lru.jp":case "lt.tl":case "lurl.no":case "macte.ch":case "mash.to":case "merky.de":case "migre.me":case "miniurl.com":case "minurl.fr":case "mke.me":case "moby.to":case "moourl.com":case "mrte.ch":case "myloc.me":case "myurl.in":case "n.pr":case "nbc.co":case "nblo.gs":case "nn.nf":case "not.my":case "notlong.com":case "nsfw.in":case "nutshellurl.com":case "nxy.in":case "nyti.ms":case "o-x.fr":case "oc1.us":case "om.ly":case "omf.gd":case "omoikane.net":case "on.cnn.com":case "on.mktw.net":case "onforb.es":case "orz.se":case "ow.ly":case "ping.fm":case "pli.gs":case "pnt.me":case "politi.co":case "post.ly":case "pp.gg":case "profile.to":case "ptiturl.com":case "pub.vitrue.com":case "qlnk.net":case "qte.me":case "qu.tc":case "qy.fi":case "r.im":case "rb6.me":case "read.bi":case "readthis.ca":case "reallytinyurl.com":case "redir.ec":case "redirects.ca":case "redirx.com":case "retwt.me":case "ri.ms":case "rickroll.it":case "riz.gd":case "rt.nu":case "ru.ly":case "rubyurl.com":case "rurl.org":case "rww.tw":case "s4c.in":case "s7y.us":case "safe.mn":case "sameurl.com":case "sdut.us":case "shar.es":case "shink.de":case "shorl.com":case "short.ie":case "short.to":case "shortlinks.co.uk":case "shorturl.com":case "shout.to":case "show.my":case "shrinkify.com":case "shrinkr.com":case "shrt.fr":case "shrt.st":case "shrten.com":case "shrunkin.com":case "simurl.com":case "slate.me":case "smallr.com":case "smsh.me":case "smurl.name":case "sn.im":case "snipr.com":case "snipurl.com":case "snurl.com":case "sp2.ro":case "spedr.com":case "srnk.net":case "srs.li":case "starturl.com":case "su.pr":case "surl.co.uk":case "surl.hu":case "t.cn":case "t.co":case "t.lh.com":case "ta.gd":case "tbd.ly":case "tcrn.ch":case "tgr.me":case "tgr.ph":case "tighturl.com":case "tiniuri.com":case "tiny.cc":case "tiny.ly":case "tiny.pl":case "tinylink.in":case "tinyuri.ca":case "tinyurl.com":case "tk.":case "tl.gd":case "tmi.me":case "tnij.org":case "tnw.to":case "tny.com":case "to.":case "to.ly":case "togoto.us":case "totc.us":case "toysr.us":case "tpm.ly":case "tr.im":case "tra.kz":case "trunc.it":case "twhub.com":case "twirl.at":case "twitclicks.com":case "twitterurl.net":case "twitterurl.org":case "twiturl.de":case "twurl.cc":case "twurl.nl":case "u.mavrev.com":case "u.nu":case "u76.org":case "ub0.cc":case "ulu.lu":case "updating.me":case "ur1.ca":case "url.az":case "url.co.uk":case "url.ie":case "url360.me":case "url4.eu":case "urlborg.com":case "urlbrief.com":case "urlcover.com":case "urlcut.com":case "urlenco.de":case "urli.nl":case "urls.im":case "urlshorteningservicefortwitter.com":case "urlx.ie":case "urlzen.com":case "usat.ly":case "use.my":case "vb.ly":case "vgn.am":case "vl.am":case "vm.lc":case "w55.de":case "wapo.st":case "wapurl.co.uk":case "wipi.es":case "wp.me":case "x.vu":case "xr.com":case "xrl.in":case "xrl.us":case "xurl.es":case "xurl.jp":case "y.ahoo.it":case "yatuc.com":case "ye.pe":case "yep.it":case "yfrog.com":case "yhoo.it":case "yiyd.com":case "youtu.be":case "yuarel.com":case "z0p.de":case "zi.ma":case "zi.mu":case "zipmyurl.com":case "zud.me":case "zurl.ws":case "zz.gd":case "zzang.kr":case "r.ebay.com":
			var surl = StringTools.urlEncode(ourl);
			Reditn.getJSON("http://api.longurl.org/v2/expand?url=" + surl + "&format=json&User-Agent=Reditn",function(data) {
				cb(Reflect.field(data,"long-url"));
			});
			break;
		default:
			cb(ourl);
		}
	}
}
Reditn.embedAlbum = function(a) {
	var span = js.Browser.document.createElement("span");
	span.style.textAlign = "center";
	span.className = "expando";
	var imgs = (function($this) {
		var $r;
		var _g = [];
		{
			var _g1 = 0;
			while(_g1 < a.length) {
				var im = a[_g1];
				++_g1;
				_g.push((function($this) {
					var $r;
					var i = Expand.loadImage(im.url);
					i.title = (im.caption != null?im.caption + " ":"") + (im.author != null?"by " + im.author:"");
					span.appendChild(i);
					Reditn.show(i,false);
					$r = i;
					return $r;
				}($this)));
			}
		}
		$r = _g;
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
		span.appendChild(prev);
		info = js.Browser.document.createElement("span");
		info.style.textAlign = "center";
		info.style.paddingLeft = info.style.paddingRight = "5px";
		span.appendChild(info);
		next = js.Browser.document.createElement("button");
		next.innerHTML = "Next";
		span.appendChild(next);
	}
	if(a.length > 1 || a[0].caption != null && a[0].caption.length > 0) {
		span.appendChild(caption);
		span.appendChild(js.Browser.document.createElement("br"));
	}
	var switchImage = function(ind) {
		if(ind < 0 || ind >= a.length) return;
		var i = a[ind];
		var height = null;
		if(img != null) {
			Reditn.show(img,false);
			height = Std.parseInt(img.style.height);
		}
		img = imgs[ind];
		img.style.display = "block";
		if(height != null) {
			var ratio = img.width / img.height;
			img.style.height = height + "px";
			img.style.width = (height * ratio | 0) + "px";
		}
		span.appendChild(img);
		if(prev != null) {
			var len = Reditn.formatNumber(a.length);
			var curr = Reditn.formatNumber(ind + 1);
			info.innerHTML = "" + curr + " of " + len;
			prev.disabled = ind <= 0;
			next.disabled = ind >= a.length - 1;
		}
		Reditn.show(caption,i.caption != null);
		if(i.caption != null) {
			caption.innerHTML = StringTools.htmlEscape(i.caption);
			if(i.author != null) caption.innerHTML += " <em>by " + i.author + "</em>";
		}
	};
	switchImage(0);
	if(prev != null) {
		prev.onmousedown = function(_) {
			switchImage(--currentIndex);
		};
		next.onmousedown = function(_) {
			switchImage(++currentIndex);
		};
	}
	return span;
}
Reditn.getData = function(o) {
	while(o.data != null) o = o.data;
	while(o.response != null) o = o.response;
	return o;
}
Reditn.getText = function(url,func,auth,type,postData) {
	var h = new haxe.Http(url);
	if(auth != null) h.setHeader("Authorization",auth);
	if(type != null) h.setHeader("Content-Type",type);
	h.setHeader("User-Agent","Reditn - the basic reddit plugin");
	h.onData = func;
	if(postData != null) h.setPostData(postData);
	h.request(postData != null);
}
Reditn.embedMap = function(m) {
	var e = js.Browser.document.createElement("dl");
	var $it0 = m.keys();
	while( $it0.hasNext() ) {
		var k = $it0.next();
		if(m.get(k) != null && m.get(k).length > 0) {
			var keye = js.Browser.document.createElement("dt");
			keye.innerHTML = k;
			e.appendChild(keye);
			var keyv = js.Browser.document.createElement("dd");
			keyv.innerHTML = m.get(k);
			e.appendChild(keyv);
		}
	}
	e.className = "md reditn-table";
	return e;
}
Reditn.getJSON = function(url,func,auth,type,postData) {
	if(type == null) type = "application/json";
	Reditn.getText(url,function(data) {
		if(StringTools.startsWith(data,"jsonFlickrApi(") && StringTools.endsWith(data,")")) data = data.substring(14,data.length - 1);
		func(Reditn.getData(haxe.Json.parse(data)));
	},auth,type,postData);
}
Reditn.getXML = function(url,func,auth,type,postData) {
	if(type == null) type = "application/json";
	Reditn.getText(url,function(data) {
		func(Reditn.getData(Xml.parse(data)));
	},auth,type,postData);
}
Reditn.popUp = function(bs,el,x,y) {
	if(y == null) y = 0;
	if(x == null) x = 0;
	js.Browser.document.body.appendChild(el);
	el.className = "popup";
	el.style.position = "absolute";
	el.style.width = (js.Browser.window.innerWidth * 0.25 | 0) + "px";
	el.style.left = "" + x + "px";
	el.style.top = "" + (y - 30) + "px";
	bs.onmouseout = el.onblur = function(e) {
		el.parentElement.removeChild(el);
		bs.mouseover = false;
	};
	return el;
}
Reditn.fullPopUp = function(el,y) {
	if(y == null) y = 0;
	var old = js.Browser.document.getElementsByClassName("popup")[0];
	if(old != null) old.parentElement.removeChild(old);
	js.Browser.document.body.appendChild(el);
	var close = js.Browser.document.createElement("a");
	close.style.position = "absolute";
	close.style.right = close.style.top = "5px";
	close.innerHTML = "<b>Close</b>";
	close.href = "javascript:void(0);";
	close.onclick = el.onblur = function(e) {
		el.parentElement.removeChild(el);
	};
	el.appendChild(close);
	el.className = "popup";
	if(y != 0) el.style.top = "" + (y - js.Browser.window.scrollY) + "px";
	return el;
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
StringTools.startsWith = function(s,start) {
	return s.length >= start.length && HxOverrides.substr(s,0,start.length) == start;
}
StringTools.endsWith = function(s,end) {
	var elen = end.length;
	var slen = s.length;
	return slen >= elen && HxOverrides.substr(s,slen - elen,elen) == end;
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
var haxe = {}
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
	,setPostData: function(data) {
		this.postData = data;
		return this;
	}
	,setHeader: function(header,value) {
		this.headers.set(header,value);
		return this;
	}
	,__class__: haxe.Http
}
var IMap = function() { }
$hxClasses["IMap"] = IMap;
IMap.__name__ = ["IMap"];
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
Std.random = function(x) {
	return x <= 0?0:Math.floor(Math.random() * x);
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
js.Boot.__cast = function(o,t) {
	if(js.Boot.__instanceof(o,t)) return o; else throw "Cannot cast " + Std.string(o) + " to " + Std.string(t);
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
var parser = {}
parser.MediaWiki = function() { }
$hxClasses["parser.MediaWiki"] = parser.MediaWiki;
parser.MediaWiki.__name__ = ["parser","MediaWiki"];
parser.MediaWiki.parse = function(s,base) {
	var _g = 0, _g1 = parser.MediaWiki.regex;
	while(_g < _g1.length) {
		var r = _g1[_g];
		++_g;
		var i = 0;
		while(r.from.match(s) && i++ < 64) {
			s = r.from.replace(s,r.to);
			var p = r.from.matchedPos();
		}
	}
	s = StringTools.replace(s,"$BASE",base);
	if(StringTools.startsWith(s,"<br>")) s = HxOverrides.substr(s,4,null);
	if(s.split("{{").length < s.split("}}").length) s = HxOverrides.substr(s,s.indexOf("}}") + 2,null);
	return s;
}
parser.MediaWiki.trimTo = function(h,s) {
	console.log("Trimming...");
	s = StringTools.trim(StringTools.replace(s,"_"," "));
	var pos = { pos : 0, len : 0}, level = null;
	while(parser.MediaWiki.sections.matchSub(h,pos.pos + pos.len)) {
		pos = parser.MediaWiki.sections.matchedPos();
		if(StringTools.trim(parser.MediaWiki.sections.matched(2)) == StringTools.trim(s)) {
			level = parser.MediaWiki.sections.matched(1).length;
			break;
		}
	}
	if(level != null) {
		h = HxOverrides.substr(h,pos.pos + pos.len,null);
		h = HxOverrides.substr(h,0,h.indexOf("<h" + level + ">"));
	}
	return h;
}
parser.MediaWiki.getAlbum = function(s) {
	var a = [];
	while(parser.MediaWiki.IMAGES.match(s)) {
		var p = parser.MediaWiki.IMAGES.matchedPos();
		s = HxOverrides.substr(s,p.pos + p.len,null);
		var name = parser.MediaWiki.IMAGES.matched(2) + "." + parser.MediaWiki.IMAGES.matched(3);
		if(StringTools.startsWith(name,"File:")) name = HxOverrides.substr(name,5,null);
		a.push({ url : name, caption : null, author : null});
	}
	return a;
}
js.Browser = function() { }
$hxClasses["js.Browser"] = js.Browser;
js.Browser.__name__ = ["js","Browser"];
js.Browser.getLocalStorage = function() {
	try {
		var s = js.Browser.window.localStorage;
		s.getItem("");
		return s;
	} catch( e ) {
		return null;
	}
}
js.Browser.createXMLHttpRequest = function() {
	if(typeof XMLHttpRequest != "undefined") return new XMLHttpRequest();
	if(typeof ActiveXObject != "undefined") return new ActiveXObject("Microsoft.XMLHTTP");
	throw "Unable to create XMLHttpRequest object.";
}
parser.Markdown = function() { }
$hxClasses["parser.Markdown"] = parser.Markdown;
parser.Markdown.__name__ = ["parser","Markdown"];
parser.Markdown.parse = function(s) {
	while(parser.Markdown.header.match(s)) {
		var pos = parser.Markdown.header.matchedPos(), len = 1 + parser.Markdown.header.matched(1).length;
		if(len > 6) len = 6;
		s = parser.Markdown.header.matchedLeft() + ("<h" + len + ">" + parser.Markdown.header.matched(2) + "</h" + len + ">") + parser.Markdown.header.matchedRight();
	}
	var _g = 0, _g1 = parser.Markdown.regex;
	while(_g < _g1.length) {
		var r = _g1[_g];
		++_g;
		while(r.from.match(s)) s = r.from.replace(s,r.to);
	}
	return s;
}
var Xml = function() {
};
$hxClasses["Xml"] = Xml;
Xml.__name__ = ["Xml"];
Xml.parse = function(str) {
	return haxe.xml.Parser.parse(str);
}
Xml.createElement = function(name) {
	var r = new Xml();
	r.nodeType = Xml.Element;
	r._children = new Array();
	r._attributes = new haxe.ds.StringMap();
	r.set_nodeName(name);
	return r;
}
Xml.createPCData = function(data) {
	var r = new Xml();
	r.nodeType = Xml.PCData;
	r.set_nodeValue(data);
	return r;
}
Xml.createCData = function(data) {
	var r = new Xml();
	r.nodeType = Xml.CData;
	r.set_nodeValue(data);
	return r;
}
Xml.createComment = function(data) {
	var r = new Xml();
	r.nodeType = Xml.Comment;
	r.set_nodeValue(data);
	return r;
}
Xml.createDocType = function(data) {
	var r = new Xml();
	r.nodeType = Xml.DocType;
	r.set_nodeValue(data);
	return r;
}
Xml.createProcessingInstruction = function(data) {
	var r = new Xml();
	r.nodeType = Xml.ProcessingInstruction;
	r.set_nodeValue(data);
	return r;
}
Xml.createDocument = function() {
	var r = new Xml();
	r.nodeType = Xml.Document;
	r._children = new Array();
	return r;
}
Xml.prototype = {
	addChild: function(x) {
		if(this._children == null) throw "bad nodetype";
		if(x._parent != null) HxOverrides.remove(x._parent._children,x);
		x._parent = this;
		this._children.push(x);
	}
	,exists: function(att) {
		if(this.nodeType != Xml.Element) throw "bad nodeType";
		return this._attributes.exists(att);
	}
	,set: function(att,value) {
		if(this.nodeType != Xml.Element) throw "bad nodeType";
		this._attributes.set(att,value);
	}
	,set_nodeValue: function(v) {
		if(this.nodeType == Xml.Element || this.nodeType == Xml.Document) throw "bad nodeType";
		return this._nodeValue = v;
	}
	,set_nodeName: function(n) {
		if(this.nodeType != Xml.Element) throw "bad nodeType";
		return this._nodeName = n;
	}
	,get_nodeName: function() {
		if(this.nodeType != Xml.Element) throw "bad nodeType";
		return this._nodeName;
	}
	,__class__: Xml
}
haxe.xml = {}
haxe.xml.Parser = function() { }
$hxClasses["haxe.xml.Parser"] = haxe.xml.Parser;
haxe.xml.Parser.__name__ = ["haxe","xml","Parser"];
haxe.xml.Parser.parse = function(str) {
	var doc = Xml.createDocument();
	haxe.xml.Parser.doParse(str,0,doc);
	return doc;
}
haxe.xml.Parser.doParse = function(str,p,parent) {
	if(p == null) p = 0;
	var xml = null;
	var state = 1;
	var next = 1;
	var aname = null;
	var start = 0;
	var nsubs = 0;
	var nbrackets = 0;
	var c = str.charCodeAt(p);
	var buf = new StringBuf();
	while(!(c != c)) {
		switch(state) {
		case 0:
			switch(c) {
			case 10:case 13:case 9:case 32:
				break;
			default:
				state = next;
				continue;
			}
			break;
		case 1:
			switch(c) {
			case 60:
				state = 0;
				next = 2;
				break;
			default:
				start = p;
				state = 13;
				continue;
			}
			break;
		case 13:
			if(c == 60) {
				var child = Xml.createPCData(buf.b + HxOverrides.substr(str,start,p - start));
				buf = new StringBuf();
				parent.addChild(child);
				nsubs++;
				state = 0;
				next = 2;
			} else if(c == 38) {
				buf.addSub(str,start,p - start);
				state = 18;
				next = 13;
				start = p + 1;
			}
			break;
		case 17:
			if(c == 93 && str.charCodeAt(p + 1) == 93 && str.charCodeAt(p + 2) == 62) {
				var child = Xml.createCData(HxOverrides.substr(str,start,p - start));
				parent.addChild(child);
				nsubs++;
				p += 2;
				state = 1;
			}
			break;
		case 2:
			switch(c) {
			case 33:
				if(str.charCodeAt(p + 1) == 91) {
					p += 2;
					if(HxOverrides.substr(str,p,6).toUpperCase() != "CDATA[") throw "Expected <![CDATA[";
					p += 5;
					state = 17;
					start = p + 1;
				} else if(str.charCodeAt(p + 1) == 68 || str.charCodeAt(p + 1) == 100) {
					if(HxOverrides.substr(str,p + 2,6).toUpperCase() != "OCTYPE") throw "Expected <!DOCTYPE";
					p += 8;
					state = 16;
					start = p + 1;
				} else if(str.charCodeAt(p + 1) != 45 || str.charCodeAt(p + 2) != 45) throw "Expected <!--"; else {
					p += 2;
					state = 15;
					start = p + 1;
				}
				break;
			case 63:
				state = 14;
				start = p;
				break;
			case 47:
				if(parent == null) throw "Expected node name";
				start = p + 1;
				state = 0;
				next = 10;
				break;
			default:
				state = 3;
				start = p;
				continue;
			}
			break;
		case 3:
			if(!(c >= 97 && c <= 122 || c >= 65 && c <= 90 || c >= 48 && c <= 57 || c == 58 || c == 46 || c == 95 || c == 45)) {
				if(p == start) throw "Expected node name";
				xml = Xml.createElement(HxOverrides.substr(str,start,p - start));
				parent.addChild(xml);
				state = 0;
				next = 4;
				continue;
			}
			break;
		case 4:
			switch(c) {
			case 47:
				state = 11;
				nsubs++;
				break;
			case 62:
				state = 9;
				nsubs++;
				break;
			default:
				state = 5;
				start = p;
				continue;
			}
			break;
		case 5:
			if(!(c >= 97 && c <= 122 || c >= 65 && c <= 90 || c >= 48 && c <= 57 || c == 58 || c == 46 || c == 95 || c == 45)) {
				var tmp;
				if(start == p) throw "Expected attribute name";
				tmp = HxOverrides.substr(str,start,p - start);
				aname = tmp;
				if(xml.exists(aname)) throw "Duplicate attribute";
				state = 0;
				next = 6;
				continue;
			}
			break;
		case 6:
			switch(c) {
			case 61:
				state = 0;
				next = 7;
				break;
			default:
				throw "Expected =";
			}
			break;
		case 7:
			switch(c) {
			case 34:case 39:
				state = 8;
				start = p;
				break;
			default:
				throw "Expected \"";
			}
			break;
		case 8:
			if(c == str.charCodeAt(start)) {
				var val = HxOverrides.substr(str,start + 1,p - start - 1);
				xml.set(aname,val);
				state = 0;
				next = 4;
			}
			break;
		case 9:
			p = haxe.xml.Parser.doParse(str,p,xml);
			start = p;
			state = 1;
			break;
		case 11:
			switch(c) {
			case 62:
				state = 1;
				break;
			default:
				throw "Expected >";
			}
			break;
		case 12:
			switch(c) {
			case 62:
				if(nsubs == 0) parent.addChild(Xml.createPCData(""));
				return p;
			default:
				throw "Expected >";
			}
			break;
		case 10:
			if(!(c >= 97 && c <= 122 || c >= 65 && c <= 90 || c >= 48 && c <= 57 || c == 58 || c == 46 || c == 95 || c == 45)) {
				if(start == p) throw "Expected node name";
				var v = HxOverrides.substr(str,start,p - start);
				if(v != parent.get_nodeName()) throw "Expected </" + parent.get_nodeName() + ">";
				state = 0;
				next = 12;
				continue;
			}
			break;
		case 15:
			if(c == 45 && str.charCodeAt(p + 1) == 45 && str.charCodeAt(p + 2) == 62) {
				parent.addChild(Xml.createComment(HxOverrides.substr(str,start,p - start)));
				p += 2;
				state = 1;
			}
			break;
		case 16:
			if(c == 91) nbrackets++; else if(c == 93) nbrackets--; else if(c == 62 && nbrackets == 0) {
				parent.addChild(Xml.createDocType(HxOverrides.substr(str,start,p - start)));
				state = 1;
			}
			break;
		case 14:
			if(c == 63 && str.charCodeAt(p + 1) == 62) {
				p++;
				var str1 = HxOverrides.substr(str,start + 1,p - start - 2);
				parent.addChild(Xml.createProcessingInstruction(str1));
				state = 1;
			}
			break;
		case 18:
			if(c == 59) {
				var s = HxOverrides.substr(str,start,p - start);
				if(s.charCodeAt(0) == 35) {
					var i = s.charCodeAt(1) == 120?Std.parseInt("0" + HxOverrides.substr(s,1,s.length - 1)):Std.parseInt(HxOverrides.substr(s,1,s.length - 1));
					buf.b += Std.string(String.fromCharCode(i));
				} else if(!haxe.xml.Parser.escapes.exists(s)) buf.b += Std.string("&" + s + ";"); else buf.b += Std.string(haxe.xml.Parser.escapes.get(s));
				start = p + 1;
				state = next;
			}
			break;
		}
		c = str.charCodeAt(++p);
	}
	if(state == 1) {
		start = p;
		state = 13;
	}
	if(state == 13) {
		if(p != start || nsubs == 0) parent.addChild(Xml.createPCData(buf.b + HxOverrides.substr(str,start,p - start)));
		return p;
	}
	throw "Unexpected end";
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
var Link = function() { }
$hxClasses["Link"] = Link;
Link.__name__ = ["Link"];
Link.resolve = function(url) {
	url = Link.trimURL(url);
	var _g = 0, _g1 = Link.sites;
	while(_g < _g1.length) {
		var s = _g1[_g];
		++_g;
		try {
			if(s.regex.match(url) && s.regex.matchedPos().len == url.length) return s;
		} catch( d ) {
			console.log("Error " + Std.string(d) + " whilst processing regex " + Std.string(s.regex));
		}
	}
	return null;
}
Link.trimURL = function(url) {
	if(StringTools.startsWith(url,"http://")) url = HxOverrides.substr(url,7,null); else if(StringTools.startsWith(url,"https://")) url = HxOverrides.substr(url,8,null);
	if(StringTools.startsWith(url,"www.")) url = HxOverrides.substr(url,4,null); else if(StringTools.startsWith(url,"m.")) url = HxOverrides.substr(url,2,null);
	if(url.indexOf("&") != -1) url = HxOverrides.substr(url,0,url.indexOf("&"));
	if(url.indexOf("?") != -1 && !StringTools.startsWith(url,"facebook.com/")) url = HxOverrides.substr(url,0,url.indexOf("?"));
	if(url.indexOf("#") != -1 && url.indexOf("/wiki/") == -1) url = HxOverrides.substr(url,0,url.indexOf("#"));
	if(StringTools.endsWith(url,"/")) url = HxOverrides.substr(url,0,url.length - 1);
	return url;
}
Link.filterHTML = function(h) {
	var _g = 0, _g1 = Link.HTML_FILTERS;
	while(_g < _g1.length) {
		var f = _g1[_g];
		++_g;
		while(f.match(h)) h = f.replace(h,"");
	}
	var _g = 0, _g1 = Link.HTML_CLEANERS;
	while(_g < _g1.length) {
		var c = _g1[_g];
		++_g;
		h = c.from.replace(h,c.to);
	}
	if(StringTools.startsWith(h,"<br>") || StringTools.startsWith(h,"<br />")) h = HxOverrides.substr(h,h.indexOf(">") + 1,null);
	if(StringTools.endsWith(h,"<br>")) h = HxOverrides.substr(h,0,h.length - 4);
	return h;
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
	var t = null;
	box.onfocus = function(_) {
		t = new haxe.Timer(100);
		t.run = function() {
			preview.innerHTML = parser.Markdown.parse(box.value);
		};
	};
	box.onblur = function(_) {
		t.stop();
		t = null;
	};
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
	js.Browser.getLocalStorage().setItem("reditn",Settings.optimisedData());
}
Settings.init = function() {
	var dt = js.Browser.getLocalStorage().getItem("reditn");
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
	if(old != null) old.parentElement.removeChild(old);
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
var Style = function() { }
$hxClasses["Style"] = Style;
Style.__name__ = ["Style"];
Style.init = function() {
	var s = js.Browser.document.createElement("style");
	s.innerHTML = ".expando-button.image.collapsed{\n\tbackground-image:url(\"https://raw.github.com/TopHattedCoder/reditn/master/src/sprites.png\");\n\tbackground-position:-24px -0px;\n\tbackground-repeat:no-repeat\n}\n.expando-button.image.collapsed:hover {\n\tbackground-image:url(\"https://raw.github.com/TopHattedCoder/reditn/master/src/sprites.png\");\n\tbackground-position:-0px -0px;\n\tbackground-repeat:no-repeat\n}\n.expando-button.image.expanded {\n\tbackground-image:url(\"https://raw.github.com/TopHattedCoder/reditn/master/src/sprites.png\");\n\tbackground-position:-72px -0px;\n\tbackground-repeat:no-repeat\n}\n.expando-button.image.expanded:hover {\n\tbackground-image:url(\"https://raw.github.com/TopHattedCoder/reditn/master/src/sprites.png\");\n\tbackground-position:-48px -0px;\n\tbackground-repeat:no-repeat\n}\n.expando-button.item.collapsed{\n\tbackground-image:url(\"https://raw.github.com/TopHattedCoder/reditn/master/src/sprites.png\");\n\tbackground-position:-24px -23px;\n\tbackground-repeat:no-repeat\n}\n.expando-button.item.collapsed:hover {\n\tbackground-image:url(\"https://raw.github.com/TopHattedCoder/reditn/master/src/sprites.png\");\n\tbackground-position:-0px -23px;\n\tbackground-repeat:no-repeat\n}\n.expando-button.item.expanded {\n\tbackground-image:url(\"https://raw.github.com/TopHattedCoder/reditn/master/src/sprites.png\");\n\tbackground-position:-72px -23px;\n\tbackground-repeat:no-repeat\n}\n.expando-button.item.expanded:hover {\n\tbackground-image:url(\"https://raw.github.com/TopHattedCoder/reditn/master/src/sprites.png\");\n\tbackground-position:-48px -23px;\n\tbackground-repeat:no-repeat\n}\ndl.reditn-table  {\n\tfloat: left;\n\twidth: 100%;\n\tpadding: 0;\n}\n.reditn-table dt {\n\tclear: left;\n\tfloat: left;\n\twidth: 16%;\n\tfont-weight: bold;\n\ttext-align: right;\n}\n.reditn-table dd {\n\tfloat: left;\n\ttext-align: left;\n}";
	js.Browser.document.head.appendChild(s);
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
		var title = d.display_name, subs = Reditn.formatNumber(d.subscribers), users = Reditn.formatNumber(d.accounts_active), desc = parser.Markdown.parse(d.public_description), age = Reditn.age(d.created_utc);
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
			div.parentElement.removeChild(div);
		};
		div.appendChild(box);
		Reditn.fullPopUp(div,link.offsetTop + link.offsetHeight);
		box.focus();
	};
	a.parentElement.insertBefore(tag,a.nextSibling);
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
			div.parentElement.removeChild(div);
		};
		div.appendChild(box);
		Reditn.fullPopUp(div,link.offsetTop + link.offsetHeight);
		box.focus();
	};
	a.parentElement.insertBefore(tag,a.nextSibling);
}
var XmlType = $hxClasses["XmlType"] = { __ename__ : ["XmlType"], __constructs__ : [] }
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
haxe.Timer.delay = function(f,time_ms) {
	var t = new haxe.Timer(time_ms);
	t.run = function() {
		t.stop();
		f();
	};
	return t;
}
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
function $iterator(o) { if( o instanceof Array ) return function() { return HxOverrides.iter(o); }; return typeof(o.iterator) == 'function' ? $bind(o,o.iterator) : o.iterator; };
var $_;
function $bind(o,m) { var f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; return f; };
if(Array.prototype.indexOf) HxOverrides.remove = function(a,o) {
	var i = a.indexOf(o);
	if(i == -1) return false;
	a.splice(i,1);
	return true;
}; else null;
if(typeof(JSON) != "undefined") haxe.Json = JSON;
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
Xml.Element = "element";
Xml.PCData = "pcdata";
Xml.CData = "cdata";
Xml.Comment = "comment";
Xml.DocType = "doctype";
Xml.ProcessingInstruction = "processingInstruction";
Xml.Document = "document";
Expand.buttons = [];
Expand.queue = 0;
Keyboard.keys = [];
Keyboard.konami = [38,38,40,40,37,39,37,39,66,65];
Konami.words = ["wubba","mcwubber","dubba","dadubber"];
Konami.filter = new EReg("[a-zA-Z]*","");
Reditn.fullPage = true;
parser.MediaWiki.regex = [{ from : new EReg("\\[\\[Category:([^\\]]*)\\]\\]",""), to : ""},{ from : new EReg("\\[\\[([^\\]\\|\n]*)\\]\\]",""), to : "<a href=\"$BASE/wiki/$1\">$1</a>"},{ from : new EReg("\\[\\[([^\\]\n]*)\\|([^\\]\\|\n]*)\\]\\]",""), to : "<a href=\"$BASE/wiki/$1\">$2</a>"},{ from : new EReg("<gallery>(.|\n|\n\r)*</gallery>",""), to : ""},{ from : new EReg("\\[\\[File:([^\\]]*)\\]\\]",""), to : ""},{ from : new EReg("(=*) ?(References|Gallery) ?\\1.*\\1?",""), to : ""},{ from : new EReg("{{spaced ndash}}",""), to : " - "},{ from : new EReg("\\{\\{convert\\|([0-9]*)\\|([^\\|]*)([^\\}]*)\\}\\}",""), to : "$1 $2"},{ from : new EReg("\\{\\{([^\\}]*)\\}\\}",""), to : ""},{ from : new EReg("\\{\\|(.|\n|\n\r)*\\|\\}",""), to : ""},{ from : new EReg("\\[([^ \\[\\]]*) ([^\\[\\]]*)\\]",""), to : ""},{ from : new EReg("'''([^']*)'''",""), to : "<b>$1</b>"},{ from : new EReg("''([^']*)''",""), to : "<em>$1</em>"},{ from : new EReg("======([^=]*)======",""), to : "<h6>$1</h6>"},{ from : new EReg("=====([^=]*)=====",""), to : "<h5>$1</h5>"},{ from : new EReg("====([^=]*)====",""), to : "<h4>$1</h4>"},{ from : new EReg("===([^=]*)===",""), to : "<h3>$1</h3>"},{ from : new EReg("==([^=]*)==",""), to : "<h2>$1</h2>"},{ from : new EReg("\n\\* ?([^\n]*)",""), to : "<li>$1</li>"},{ from : new EReg("<ref>[^<>]*</ref>",""), to : ""},{ from : new EReg("\n\r?\n\r?",""), to : "<br>"},{ from : new EReg("\n",""), to : ""},{ from : new EReg("<br><br>",""), to : "<br>"},{ from : new EReg("<!--Interwiki links-->.*",""), to : ""},{ from : new EReg("\\[\\]",""), to : ""}];
parser.MediaWiki.sections = new EReg("'=(=*)([^=]*)=\\\\1\n\r?(.|\n|\n\r)*(\\\\1)?'","");
parser.MediaWiki.IMAGES = new EReg("(File:|img=|Image:)([^\\.\\|\\]\\}\\{\\[<>=]*)\\.(gif|jpg|jpeg|bmp|png|webp|svg|raw)(\\|([^\\)]*))?","");
js.Browser.window = typeof window != "undefined" ? window : null;
js.Browser.document = typeof window != "undefined" ? window.document : null;
parser.Markdown.images = new EReg("!\\[([^\\]\\(]*)]\\(([^\\)]*)\\)","");
parser.Markdown.regex = [{ from : new EReg("(\\*\\*|__)([^\\1\n]*?)\\1",""), to : "<b>$2</b>"},{ from : new EReg("(\\*|_)([^\\1\n]*?)\\1",""), to : "<em>$2</em>"},{ from : new EReg("^[\\*|+|-] (.*)$","m"), to : "<ul><li>$1</li></ul>"},{ from : new EReg("</ul><ul>",""), to : ""},{ from : new EReg("\n> ([^\n\r]*)",""), to : "<blockquote>$1</blockquote>"},{ from : new EReg("</blockquote>\n?\r?<blockquote>$",""), to : ""},{ from : new EReg("~~([^~]*?)~~",""), to : "<del>$1</del>"},{ from : new EReg("\\^([^\\^]+)",""), to : "<sup>$1</sup>"},{ from : new EReg(":\"([^:\"]*?)\":",""), to : "<q>$1</q>"},{ from : parser.Markdown.images, to : ""},{ from : new EReg("\\[([^\\]\\(]*)]\\(([^\\)]*)\\)",""), to : "<a href=\"$2\">$1</a>"},{ from : new EReg("!\\[([^\\]\\(]*)]\\(([^\\)]*)\\)",""), to : ""},{ from : new EReg("(.*)\n\r?(==+)\n",""), to : "<h2>$1</h2>"},{ from : new EReg("(.*)\n\r?((-|#)+)\n",""), to : "<h3>$1</h3>"},{ from : new EReg("(```*)([^`]+)\\1","m"), to : "<code>$2</code>"},{ from : new EReg("<pre>(.*)\n\n(.*)</pre>",""), to : "<pre>$1\n$2</pre>"},{ from : new EReg("\n\n+",""), to : "<br>\n"}];
parser.Markdown.header = new EReg("^([#|=]+)([^#=]+)\\1?$","m");
haxe.xml.Parser.escapes = (function($this) {
	var $r;
	var h = new haxe.ds.StringMap();
	h.set("lt","<");
	h.set("gt",">");
	h.set("amp","&");
	h.set("quot","\"");
	h.set("apos","'");
	h.set("nbsp",String.fromCharCode(160));
	$r = h;
	return $r;
}(this));
Link.HTML_IMG = new EReg("<img .*?src=\"([^\"]*)\"/?>","");
Link.sites = [{ regex : new EReg(".*\\.(jpeg|gif|jpg|bmp|png|webp)","i"), method : function(e,cb) {
	cb([{ url : "http://" + e.matched(0), caption : null, author : null}]);
}},{ regex : new EReg("i?\\.?imgur.com/(a|gallery)/([^/]*)",""), method : function(e,cb1) {
	var id = e.matched(2);
	var albumType = (function($this) {
		var $r;
		var _g = e.matched(1).toLowerCase();
		$r = (function($this) {
			var $r;
			switch(_g) {
			case "a":
				$r = "album";
				break;
			case "gallery":
				$r = "gallery/album";
				break;
			default:
				$r = "album";
			}
			return $r;
		}($this));
		return $r;
	}(this));
	Reditn.getJSON("https://api.imgur.com/3/" + albumType + "/" + id,function(data) {
		var album = [];
		if(data.images_count <= 0) album.push({ url : "http://i.imgur.com/" + data.id + ".jpg", caption : data.title, author : data.account_url}); else {
			var _g1 = 0, _g2 = data.images;
			while(_g1 < _g2.length) {
				var i = _g2[_g1];
				++_g1;
				album.push({ url : "http://i.imgur.com/" + i.id + ".jpg", caption : i.title, author : data.account_url});
			}
		}
		cb1(album);
	},"Client-ID " + "cc1f254578d6c52");
}},{ regex : new EReg("imgur\\.com/(r/[^/]*/)?([a-zA-Z0-9,]*)",""), method : function(e,cb) {
	var id = e.matched(1) == null || e.matched(1).indexOf("/") != -1?e.matched(2):e.matched(1);
	var ids = id.split(",");
	cb((function($this) {
		var $r;
		var _g = [];
		{
			var _g1 = 0;
			while(_g1 < ids.length) {
				var id1 = ids[_g1];
				++_g1;
				_g.push({ url : "http://i.imgur.com/" + id1 + ".jpg", caption : null, author : null});
			}
		}
		$r = _g;
		return $r;
	}(this)));
}},{ regex : new EReg("(qkme\\.me|quickmeme\\.com/meme|m\\.quickmeme.com/meme)/([^/]*)",""), method : function(e,cb) {
	cb([{ url : "http://i.qkme.me/" + e.matched(2) + ".jpg", caption : null, author : null}]);
}},{ regex : new EReg("memecrunch.com/meme/([^/]*)/([^/]*)",""), method : function(e,cb) {
	cb([{ url : "http://" + e.matched(0) + "/image.png", caption : null, author : null}]);
}},{ regex : new EReg("memegenerator\\.net/instance/([^/]*)",""), method : function(e,cb) {
	cb([{ url : "http://cdn.memegenerator.net/instances/400x/" + e.matched(1) + ".jpg", caption : null, author : null}]);
}},{ regex : new EReg("imgflip\\.com/i/([^/]*)",""), method : function(e,cb) {
	cb([{ url : "http://i.imgflip.com/" + e.matched(1) + ".jpg", caption : null, author : null}]);
}},{ regex : new EReg("what-if.xkcd.com/([0-9]*)",""), method : function(e,cb) {
}},{ regex : new EReg("xkcd.com/([0-9]*)",""), method : function(e,cb2) {
	Reditn.getJSON("http://www.xkcd.com/" + e.matched(1) + "/info.0.json",function(data) {
		cb2([{ url : data.img, caption : data.title, author : null}]);
	});
}},{ regex : new EReg("explosm.net/comics/([0-9]*)",""), method : function(e1,cb3) {
	Reditn.getText("http://www." + e1.matched(0),function(txt) {
		var rg = new EReg("\"http://www\\.explosm\\.net/db/files/Comics/([^\"]*)\"","");
		if(rg.match(txt)) cb3([{ url : rg.matched(0).substring(1,rg.matched(0).length - 1), caption : null, author : null}]); else throw "" + Std.string(rg) + " not matched by " + e1.matched(0) + " in " + txt;
	},null,null,null);
}},{ regex : new EReg("livememe.com/([^/]*)",""), method : function(e,cb) {
	cb([{ url : "http://livememe.com/" + e.matched(1) + ".jpg", caption : null, author : null}]);
}},{ regex : new EReg("(([^\\.]*\\.)?deviantart\\.com/art|fav\\.me)/.*",""), method : function(e,cb4) {
	Reditn.getJSON("http://backend.deviantart.com/oembed?url=" + StringTools.urlEncode(e.matched(0)) + "&format=json",function(e1) {
		cb4([{ url : e1.url, caption : e1.title, author : e1.author_name}]);
	});
}},{ regex : new EReg("flickr\\.com/photos/.*",""), method : function(e,cb5) {
	Reditn.getJSON("http://www.flickr.com/services/oembed/?url=http://www." + StringTools.urlEncode(e.matched(0)) + "&format=json",function(e1) {
		cb5([{ url : e1.url, caption : e1.title, author : e1.author_name}]);
	});
}},{ regex : new EReg("ebay\\.([a-zA-Z\\.]*)/itm(/[^/]*)?/([0-9]*)",""), method : function(e,cb6) {
	var domain = e.matched(1);
	var id = e.matched(3);
	var url = "http://open.api.ebay.com/shopping?callname=GetSingleItem&responseencoding=JSON&appid=" + "ThomasDa-1e6c-4d29-a156-85557acee70b" + "&siteid=0&version=515&ItemID=" + id + "&IncludeSelector=TextDescription";
	Reditn.getJSON(url,function(data) {
		var imgs = data.Item.PictureURL;
		var nalbum = imgs.map(function(i) {
			return { url : i, caption : null, author : null};
		});
		cb6({ title : data.Item.Title, category : data.Item.PrimaryCategoryName, location : data.Item.Location + ", " + data.Item.Country, description : Link.filterHTML(data.Item.Description), images : nalbum, price : Reditn.formatPrice(data.Item.ConvertedCurrentPrice.Value) + " " + data.Item.ConvertedCurrentPrice.CurrencyID});
	});
}},{ regex : new EReg("([^\\.]*\\.wordpress\\.com|wp\\.me|techcrunch\\.com|news\\.blogs\\.cnn\\.com|snoopdogg\\.com|usainbolt\\.com|katiecouric\\.com|rollingstones\\.com|variety\\.com|bbcamerica\\.com)/(.*)?",""), method : function(e,cb7) {
	var url = "http://" + e.matched(0);
	Reditn.getJSON("http://public-api.wordpress.com/oembed/?url=" + StringTools.urlEncode(url) + "&for=Reditn",function(data) {
		var imgs = [];
		if(data.thumbnail_url != null) imgs.push({ caption : null, url : data.thumbnail_url, author : null});
		cb7({ author : data.author_name, content : Link.filterHTML(data.html), images : imgs});
	});
}},{ regex : new EReg("(.*)/wiki/([^#]*)(#.*)?",""), method : function(e,cb8) {
	var aroot = "http://" + e.matched(1), title = e.matched(2), to = e.matched(3);
	if(to != null) to = StringTools.trim(HxOverrides.substr(to,1,null));
	if(to != null && to.length == 0) to = null;
	var urlroot = aroot;
	if(!StringTools.endsWith(urlroot,".wikia.com")) urlroot += "/w";
	var getWikiPage = (function($this) {
		var $r;
		var getWikiPage1 = null;
		getWikiPage1 = function(name) {
			Reditn.getJSON("" + urlroot + "/api.php?format=json&prop=revisions&action=query&titles=" + name + "&rvprop=content",function(data) {
				var pages = data.query.pages;
				var _g = 0, _g1 = Reflect.fields(pages);
				while(_g < _g1.length) {
					var p = _g1[_g];
					++_g;
					var page = [Reflect.field(pages,p)];
					var cont = [Reflect.field(page[0].revisions[0],"*")];
					if(StringTools.startsWith(cont[0],"#REDIRECT [[")) {
						getWikiPage1(cont[0].substring(12,cont[0].lastIndexOf("]]")));
						return;
					}
					var images = [parser.MediaWiki.getAlbum(cont[0])];
					if(to != null) cont[0] = parser.MediaWiki.trimTo(cont[0],to);
					cont[0] = parser.MediaWiki.parse(cont[0],aroot);
					if(images[0].length > 0) {
						var nimages = [[]];
						var _g2 = 0;
						while(_g2 < images[0].length) {
							var i1 = [images[0][_g2]];
							++_g2;
							Reditn.getJSON("" + urlroot + "/api.php?action=query&titles=" + StringTools.urlEncode(i1[0].url) + "&prop=imageinfo&iiprop=url&format=json",(function(i1,nimages,images,cont,page) {
								return function(data1) {
									var pages1 = data1.query.pages;
									var _g3 = 0, _g4 = Reflect.fields(pages1);
									while(_g3 < _g4.length) {
										var p1 = _g4[_g3];
										++_g3;
										var page1 = Reflect.field(pages1,p1);
										if(page1 != null && page1.imageinfo != null) {
											var url = page1.imageinfo[0].url;
											nimages[0].push({ url : url, caption : i1[0].caption, author : null});
										} else {
											console.log("Error whilst processing " + Std.string(page1) + " for " + i1[0].url);
											HxOverrides.remove(images[0],i1[0]);
										}
									}
									if(nimages[0].length >= images[0].length) cb8({ title : page[0].title, content : cont[0], author : null, images : nimages[0]});
								};
							})(i1,nimages,images,cont,page));
						}
					} else cb8({ title : page[0].title, content : cont[0], author : null, images : null});
				}
			});
		};
		$r = getWikiPage1;
		return $r;
	}(this));
	getWikiPage(title);
}},{ regex : new EReg("github\\.com/([^/]*)/([^/]*)",""), method : function(e,cb9) {
	var author = e.matched(1), repo = e.matched(2);
	Reditn.getJSON("https://api.github.com/repos/" + author + "/" + repo + "/readme?client_id=" + "39d85b9ac427f1176763" + "&client_secret=" + "5117570b83363ca0c71a196edc5b348af150c25d",function(data) {
		if(data.content == null) return;
		var c = data.content;
		c = StringTools.replace(c,"\n","");
		c = StringTools.trim(c);
		c = js.Browser.window.atob(c);
		var imgs = parser.Markdown.images;
		var album = [];
		var tc = c;
		while(imgs.match(tc)) {
			var url = imgs.matched(2);
			if(url.indexOf(".") == url.lastIndexOf(".")) {
				if(StringTools.startsWith(url,"/")) url = HxOverrides.substr(url,1,null);
				url = "https://github.com/" + author + "/" + repo + "/raw/master/" + url;
			}
			album.push({ url : url, caption : imgs.matched(1), author : author});
			tc = HxOverrides.substr(tc,imgs.matchedPos().pos + imgs.matchedPos().len,null);
		}
		cb9({ name : repo, developers : [author], description : parser.Markdown.parse(c), url : "git://github.com/" + author + "/" + repo + ".git", album : album});
	});
}},{ regex : new EReg("sourceforge.net/projects/([a-zA-Z-]*)",""), method : function(e,cb10) {
	Reditn.getJSON("http://sourceforge.net/api/project/name/" + e.matched(1) + "/json",function(data) {
		data = data.Project;
		var devs = data.developers;
		cb10({ name : data.name, description : data.description, developers : (function($this) {
			var $r;
			var _g = [];
			{
				var _g1 = 0;
				while(_g1 < devs.length) {
					var d = devs[_g1];
					++_g1;
					_g.push(d.name);
				}
			}
			$r = _g;
			return $r;
		}(this)), url : (function($this) {
			var $r;
			var u = Reflect.field(data,"download-page");
			{
				var _g1 = 0, _g2 = Reflect.fields(data);
				while(_g1 < _g2.length) {
					var f = _g2[_g1];
					++_g1;
					if(StringTools.endsWith(f,"Repository")) {
						var type = HxOverrides.substr(f,0,f.length - 10).toLowerCase();
						var loc = Reflect.field(data,f).location;
						u = StringTools.replace(loc,"http:","" + type + ":");
					}
				}
			}
			$r = u;
			return $r;
		}(this)), album : []});
	});
}},{ regex : new EReg("(digitaltrends\\.com|webupd8\\.org|doctorwho\\.tv)/.*",""), method : function(e,cb11) {
	Reditn.getText("http://www." + e.matched(0),function(txt) {
		var t = new EReg("<title>(.*)</title>","");
		if(t.match(txt)) {
			var cont = txt;
			cont = HxOverrides.substr(cont,cont.indexOf("<article"),null);
			cont = HxOverrides.substr(cont,cont.indexOf(">") + 1,null);
			cont = HxOverrides.substr(cont,0,cont.indexOf("</article>"));
			cont = Link.filterHTML(cont);
			cb11({ title : t.matched(1), content : cont, author : null, images : []});
		}
	},null,null,null);
}},{ regex : new EReg("([^\\.]*)\\.tumblr\\.com/(post|image)/([0-9]*)",""), method : function(e,cb12) {
	var author = e.matched(1), id = e.matched(3);
	console.log(author + ", " + id);
	Reditn.getJSON("http://api.tumblr.com/v2/blog/" + author + ".tumblr.com/posts/json?api_key=" + "k6pU8NIG57YiPAtXFD5s9DGegNPBZIpMahvbK4d794JreYIyYE" + "&id=" + id,function(data) {
		var post = data.posts[0];
		cb12((function($this) {
			var $r;
			switch(post.type) {
			case "text":
				$r = (function($this) {
					var $r;
					var images = [];
					while(Link.HTML_IMG.match(post.body)) {
						images.push({ url : Link.HTML_IMG.matched(1), caption : null, author : data.blog.name});
						post.body = Link.HTML_IMG.replace(post.body,"");
					}
					post.body = Link.filterHTML(post.body);
					$r = { title : post.title, content : post.body, author : data.blog.name, images : images};
					return $r;
				}($this));
				break;
			case "quote":
				$r = { title : null, content : Std.string(post.text) + "<br/><b>" + Std.string(post.source) + "</b>", author : data.blog.name, images : []};
				break;
			case "photo":
				$r = (function($this) {
					var $r;
					var ps = post.photos;
					$r = (function($this) {
						var $r;
						var _g = [];
						{
							var _g1 = 0;
							while(_g1 < ps.length) {
								var p = ps[_g1];
								++_g1;
								_g.push({ url : p.original_size.url, caption : p.caption, author : data.blog.name});
							}
						}
						$r = _g;
						return $r;
					}($this));
					return $r;
				}($this));
				break;
			default:
				$r = null;
			}
			return $r;
		}(this)));
	});
}},{ regex : new EReg(".*\\.tumblr\\.com",""), method : function(e,cb13) {
	Reditn.getJSON("http://api.tumblr.com/v2/blog/" + StringTools.urlEncode(e.matched(0)) + "/info?api_key=" + "k6pU8NIG57YiPAtXFD5s9DGegNPBZIpMahvbK4d794JreYIyYE",function(data) {
		cb13({ urls : new haxe.ds.StringMap(), name : data.blog.title, description : Link.filterHTML(data.blog.description), album : []});
	});
}},{ regex : new EReg("twitter.com/.*/status/([0-9]*)",""), method : function(e,cb14) {
	Reditn.getJSON("https://api.twitter.com/1/statuses/oembed.json?id=" + e.matched(2),function(data) {
		cb14({ title : null, author : data.author_name, content : Link.filterHTML(data.html), images : []});
	});
}},{ regex : new EReg("amazon\\.[a-z\\.]*/gp/product/([0-9A-Z]*)",""), method : function(e,cb) {
	var id = e.matched(1);
	Reditn.getXML("http://webservices.amazon.com/onca/xml?AWSAccessKeyId=" + "AKIAJMR3XPXGBMZJE6IA" + "&Service=AWSECommerceService&Operation=ItemLookup&ItemId=" + id,function(data) {
		console.log(data);
	});
}},{ regex : new EReg("plus\\.google\\.com/([0-9]*)/posts/([a-zA-Z]*)",""), method : function(e2,cb15) {
	var pid = e2.matched(1), id2 = e2.matched(2), num = 0, title1 = new EReg("<b>([^>]*)</b><br />","");
	var nextPage = (function($this) {
		var $r;
		var nextPage1 = null;
		nextPage1 = function(tk) {
			tk = tk == null?"":"&requestToken=" + tk;
			if(num > 8) return;
			Reditn.getJSON("https://www.googleapis.com/plus/v1/people/" + pid + "/activities/public?fields=items(id%2Curl)%2CnextPageToken&key=" + "AIzaSyC-LFpB6Y-kC6re81ohFnPIvO4hbJYGS3o" + tk,function(data) {
				var items = data.items, url = e2.matched(0);
				var _g = 0;
				while(_g < items.length) {
					var i = items[_g];
					++_g;
					if(i.url.indexOf(id2) != -1) {
						Reditn.getJSON("https://www.googleapis.com/plus/v1/activities/" + Std.string(i.id) + "?fields=actor%2FdisplayName%2Cannotation%2Cobject(actor%2Cattachments%2Ccontent%2Cid%2CobjectType%2CoriginalContent%2Curl)&key=" + "AIzaSyC-LFpB6Y-kC6re81ohFnPIvO4hbJYGS3o",function(data1) {
							var type = data1.object.objectType, name = data1.actor.actorName, cont = data1.object.content;
							title1.match(cont);
							switch(type) {
							case "note":
								var titl = title1.matched(1);
								cont = title1.replace(cont,"");
								cont = Link.filterHTML(cont);
								cb15({ title : titl, author : name, content : cont, images : []});
								break;
							default:
								console.log(data1);
								var att = data1.object.attachments;
								cb15((function($this) {
									var $r;
									var _g1 = [];
									{
										var _g2 = 0;
										while(_g2 < att.length) {
											var a = att[_g2];
											++_g2;
											_g1.push({ url : a.image.url, caption : a.content.length == 0?data1.object.content:a.content, author : null});
										}
									}
									$r = _g1;
									return $r;
								}(this)));
							}
						});
						return;
					}
				}
				if(data.items.length != 0) nextPage1(data.requestToken);
			});
		};
		$r = nextPage1;
		return $r;
	}(this));
	nextPage();
}},{ regex : new EReg("facebook.com/photo\\.php\\?v=([0-9]*)",""), method : function(e,cb) {
	var id = e.matched(1);
	cb([{ caption : null, url : "http://graph.facebook.com/${id}/picture?type=small&access_token=" + "CAAFdBpahq7IBAFZBcSH9UOZAaREy2V3hSd2e0D9liaI48X5xavt3lI8rwdXd6YTizhZAip1D3cY4XriGV7FxZAH7HmFe3Khnj7sFATZAKiKZAHx5qJwLcRHwc2ZBH7ePQw5T7eZBUeRZBM7A5YymTPxjrCAAFdBpahq7IBAFZBcSH9UOZAaREy2V3hSd2e0D9liaI48X5xavt3lI8rwdXd6YTizhZAip1D3cY4XriGV7FxZAH7HmFe3Khnj7sFATZAKiKZAHx5qJwLcRHwc2ZBH7ePQw5T7eZBUeRZBM7A5YymTPxjrf", author : null}]);
}},{ regex : new EReg("facebook\\.com/([a-zA-Z0-9]*)",""), method : function(e,cb) {
	var id = e.matched(1);
	cb({ album : [{ url : "https://graph.facebook.com/" + id + "/picture?type=large", caption : null, author : null}], urls : new haxe.ds.StringMap()});
}},{ regex : new EReg("plus\\.google.com/u?/?[0-9]*/([0-9]*)(/about)?",""), method : function(e,cb16) {
	var id = e.matched(1);
	Reditn.getJSON("https://www.googleapis.com/plus/v1/people/" + id + "?key=" + "AIzaSyC-LFpB6Y-kC6re81ohFnPIvO4hbJYGS3o",function(data) {
		var urls = data.urls;
		var aurls = new haxe.ds.StringMap();
		if(urls != null) {
			var _g = 0;
			while(_g < urls.length) {
				var u = urls[_g];
				++_g;
				var key = u.label, value = u.value;
				aurls.set(key,value);
			}
		}
		if(data.urls != null && data.displayName != null && data.aboutMe != null) cb16({ urls : aurls, name : data.displayName, description : data.aboutMe, album : [{ url : data.image.url, caption : null, author : data.displayName}]});
	});
}},{ regex : new EReg("reddit\\.com/r/([a-zA-Z0-9]*)",""), method : function(e,cb17) {
	console.log(e.matched(1));
	Reditn.getJSON("http://www." + e.matched(0) + "/about.json",function(s) {
		cb17(s);
	});
}},{ regex : new EReg("gamejolt.com/games/[^/]*/[^/]*/([0-9]*)",""), method : function(e,cb) {
	var id = e.matched(1);
	Reditn.getJSON("http://gamejolt.com/service/games/" + id + "?format=json",function(data) {
		console.log(data);
	});
}}];
Link.HTML_FILTERS = [Link.HTML_IMG,new EReg("<meta[^>]*/>","g"),new EReg("<(h1|header)[^>]*>.*</\\1>","g"),new EReg("<table([^>]*)>(.|\n|\n\r)*</table>","gm"),new EReg("<div class=\"(seperator|ga-ads)\"[^>]*>(.|\n|\n\r)*</div>","g"),new EReg("<([^>]*)( [^>]*)?></\\1>","g"),new EReg("<script[^>/]*/>","g"),new EReg("<script[^>/]*></script>","g"),new EReg("style ?= ?\"[^\"]*\"","g")];
Link.HTML_CLEANERS = [{ from : new EReg("<blockquote class=\"twitter-tweet\">(.*)</blockquote>","g"), to : "$1"},{ from : new EReg("(!|\\.|,|\\?)(^ \n\t\r)","g"), to : "$1 $2"},{ from : new EReg("(!|\\.|,|\\?)( *)","g"), to : "$1 "},{ from : new EReg("(<br></br>|<br/>|<br />)(<br></br>|<br/>|<br />)","g"), to : "<br/>"}];
Settings.DESC = (function($this) {
	var $r;
	var _g = new haxe.ds.StringMap();
	_g.set("adblock","Block advertisements and sponsors");
	_g.set("userinfo","Show information about a user upon hover");
	_g.set("subinfo","Show information about a subreddit upon hover");
	_g.set("expand","Allow expansion of images, articles, etc");
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
