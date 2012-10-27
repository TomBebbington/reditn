// ==UserScript==
// @name        Reditn
// @namespace   http://userscripts.org/user/tophattedcoder/
// @description A collection of reddit tweaks and enhancements.
// @include     reddit.com
// @include     reddit.com/*
// @include		*.reddit.com
// @include		*.reddit.com/*
// @version     1.25
// @grant		none
// ==/UserScript==
(function() {
	var expand_info = {};
	function include(path) {
		var s = document.createElement("script");
		s.setAttribute("src", path);
		s.setAttribute("type", "text/javascript");
		document.head.appendChild(s);
		return s;
	}
	function load_settings() {
		if(window.localStorage) {
			return window.localStorage.reditn ? JSON.parse(window.localStorage.reditn) : {};
		} else {
			include("https://raw.github.com/carhartl/jquery-cookie/master/jquery.cookie.js");
			return $.cookie("reditn") || {};
		}
	}
	var settings = load_settings();
	var offset=3;
	function save_settings() {
		if(window.localStorage)
			localStorage.reditn = JSON.stringify(settings);
		else
			$.cookie("reditn", JSON.stringify(settings), {expires: -1});
	}
	function format_num(n) {
		if (!isFinite(n)) {
			return n;
		}
		var s = ""+n, abs = Math.abs(n), _, i;
		if (abs >= 1000) {
			_  = (""+abs).split(/\./);
			i  = _[0].length % 3 || 3;
			_[0] = s.slice(0,i + (n < 0)) +
			_[0].slice(i).replace(/(\d{3})/g,',$1');
			s = _.join('.');
		}
		return s;
	}
	function type(url) {
		if(url.substr(0, 7) == "http://")
			url = url.substr(7);
		else if(url.substr(0, 8) == "https://")
			url = url.substr(8);
		if(url.substr(0, 4) == "www.")
			url = url.substr(4);
		if(url.lastIndexOf(".") != url.indexOf(".")) {
			var ext = url.substr(url.lastIndexOf(".")+1).toLowerCase();
			if(ext == "gif" || ext == "bmp" || ext == "jpg" || ext == "jpeg" || ext == "png" || ext == "webp" || ext == "svg")
				return "image";
			else if(ext == "mpg" || ext == "webm" || ext == "avi" || ext == "mp4" || ext == "flv" || ext == "swf")
				return "video";
			else if(ext == "mp3" || ext == "wav" || ext == "midi")
				return "music";
		}
		if((url.substr(0, 10) == "imgur.com/" && url.substr(10,2) != "a/") || url.substr(0, 12) == "i.imgur.com/" || url.substr(0, 8) == "qkme.me/" || url.substr(0,19) == "quickmeme.com/meme/" || url.indexOf("deviantart.com/art/")!=-1) {
			return "image";
		} else if(url.substr(0, 17) == "youtube.com/watch") {
			return "video";
		} else {
			return "unknown";
		}
	}
	function image_url(ourl, el, cb) {
		var url = ourl;
		if(url.substr(0, 7) == "http://")
			url = url.substr(7);
		else if(url.substr(0, 8) == "https://")
			url = url.substr(8);
		if(url.substr(0, 4) == "www.")
			url = url.substr(4);
		console.log(url);
		if(url.substr(0, 12) == "i.imgur.com/" && url.split(".").length == 3)
			cb("http://"+url+".jpg", el);
		else if(url.substr(0, 10) == "imgur.com/") {
			var id = url.substr(url.indexOf("/")+1);
			if(id.lastIndexOf("?") != -1)
				id = id.substr(0, id.lastIndexOf("?"));
			if(id.lastIndexOf("/") != -1)
				id = id.substr(0, id.lastIndexOf("/"));
			cb("http://i.imgur.com/"+id+".jpg", el);
		} else if(url.substr(0, 8) == "qkme.me/") {
			var id =url.substr(8);
			if(id.lastIndexOf("?") != -1)
				id = id.substr(0, id.lastIndexOf("?"));
			if(id.lastIndexOf("/") != -1)
				id = id.substr(0, id.lastIndexOf("/"));
			cb("http://i.qkme.me/"+id+".jpg", el);
		} else if(url.substr(0, 19) == "quickmeme.com/meme/") {
			var id =url.substr(19);
			if(id.lastIndexOf("?") != -1)
				id = id.substr(0, id.lastIndexOf("?"));
			if(id.lastIndexOf("/") != -1)
				id = id.substr(0, id.lastIndexOf("/"));
			cb("http://i.qkme.me/"+id+".jpg", el);
		} else if(url.indexOf(".deviantart.com/art/")!=-1) {
			window.jQuery.getJSON("http://backend.deviantart.com/oembed?url="+encodeURI(url)+"&format=jsonp&callback=?",
			function(data){
				console.log(data);
				cb(data.url, el);
			});
		} else {
			cb(ourl, el);
		}
	}
	function preload(url) {
		var link = document.createElement("link");
		link.href = url;
		link.rel = window.navigator.userAgent.toLowerCase().indexOf('chrome') > -1 ? "prefetch" : "preload";
		document.head.appendChild(link);
	}
	function load_img(url) {
		var img = document.createElement("img");
		img.src = url;
		img.class = "resize";
		init_resize(img);
		img.onload = function() {
			if(this.width > expand_info.maxw) {
				var rt = this.height / this.width;
				this.width = expand_info.maxw;
				this.height = this.width * rt;
			}
			if(this.height > expand_info.maxh) {
				var rt = this.width / this.height;
				this.height = expand_info.maxh;
				this.width = this.height * rt;
			}
		}
		return img;
	}
	function init_resize(e) {
		e.drag = null;
		e.onmousedown = function(ev) {
			this.drag = {rtx:this.offsetWidth/ev.clientX, rty:this.offsetHeight/ev.clientY, rt: this.offsetWidth/this.offsetHeight};
			ev.preventDefault();
		}
		e.onmousemove = function(ev) {
			if(this.drag) {
				var nw = ev.clientX * this.drag.rtx;
				var nwh = nw / this.drag.rt;
				var nh = ev.clientY * this.drag.rty;
				var nhw = nh * this.drag.rt;
				if(nwh > nh) {
					this.setAttribute("width", nw);
					this.setAttribute("height", nwh);
				} else {
					this.setAttribute("width", nhw);
					this.setAttribute("height", nh);
				}
			}
			ev.preventDefault();
		}
		e.onmouseup = e.onmouseout = function(ev) {
			this.drag = null;
			ev.preventDefault();
		}
	}
	function pop_up(bs, el, x, y) {
		el.style.position = "absolute";
		el.style.top = y+"px";
		el.style.left = x+"px";
		el.style.padding = "2px";
		el.style.backgroundColor = "#fcfcfc";
		el.style.border = "1px solid black";
		el.style.borderRadius = "4px";
		el.style.maxWidth = (window.innerWidth*0.4)+"px";
		bs.onmouseout=function(e) {
			el.parentNode.removeChild(el);
			bs.mouseover = false;
		}
		document.body.appendChild(el);
		el.className="reditnpopup";
		el.innerHTML = "Loading...";
		return el;
	}
	function on_mouse_over_user(e) {
		var user = this.href;
		user = user.substr(user.lastIndexOf("/")+1);
		var div = document.createElement("div");
		pop_up(this, div, this.offsetLeft + this.offsetWidth + offset, this.offsetTop);
		window.jQuery.getJSON("/user/"+user+"/about.json", {}, function(d){
			d = d.data;
			var html = "<b>User:</b> "+d.name+"<br>";
			var diff = new Date(+new Date() - d.created_utc*1000);
			var years = diff.getFullYear()-1970, months = diff.getMonth(), days = diff.getDate();
			html += "<b>Account age:</b> ";
			if(years > 0) html += years+" years, ";
			if(months > 0) html+=months+" months, ";
			html += days+" days<br>"
			html += "<b>Karma:</b> "+format_num(d.link_karma)+" link karma, "+format_num(d.comment_karma)+" comment karma";
			if(d.is_mod)
				html += "<br><b>Moderator</b>";
			if(d.is_gold)
				html += "<br><b>Gold</b>";
			div.innerHTML = html;
		})
	}
	function on_mouse_over_reddit(e) {
		var reddit = this.href;
		reddit = reddit.substr(reddit.indexOf("/r/")+3);
		reddit = reddit.substr(0, reddit.lastIndexOf("/"));
		var div = document.createElement("div");
		pop_up(this, div, this.offsetLeft + this.offsetWidth + offset, this.offsetTop);
		window.jQuery.getJSON("/r/"+reddit+"/about.json", {}, function(d) {
			d = d.data;
			div.innerHTML = "<b>Title:</b> "+d.title+"<br><b>Subscribers:</b> "+format_num(d.subscribers)+"<br><b>Description:</b> "+d.public_description;
		});
	}
	function init_user_info() {
		var users = document.body.getElementsByClassName("author");
		for(var i=0;i<users.length;i++)
			users[i].onmouseover=on_mouse_over_user;
	}
	function init_reddit_info() {
		var reddits = document.body.getElementsByClassName("subreddit");
		for(var i=0;i<reddits.length;i++)
			reddits[i].onmouseover=on_mouse_over_reddit;
	}
	function show_button(el) {
		var e = document.createElement("span");
		e.innerHTML = "<b>show</b>";
		e.toggled = false;
		e.onmousedown = function(ev) {
			this.toggled = !this.toggled;
			this.innerHTML = this.toggled ? "<b>hide</b>" : "<b>show</b>";
			if(this.toggled) {
				this.parentNode.parentNode.appendChild(el);
			} else if(el.parentNode)
				el.parentNode.removeChild(el);
		}
		e.style.cursor = "pointer";
		return e;
	}
	function get_entry(el) {
		return el.parentNode.parentNode;
	}
	function init_expand() {
		var links = document.body.getElementsByClassName("title");
		for(var i=0;i<links.length;i++) {
			var l = links[i];
			if(l.nodeName.toLowerCase()!="a")
				continue;
			var urltype = type(l.href);
			if(urltype=="image") {
				image_url(l.href, l, function(url, l) {
					preload(url);
					var e = get_entry(l);
					var img = load_img(url);
					var div = document.createElement("div");
					div.appendChild(img);
					var show = show_button(div);
					var li = document.createElement("li");
					li.appendChild(show);
					var btns = e.getElementsByClassName("buttons")[0];
					if(btns)
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
	function remove_all(a) {
		for(var i=0;i<a.length;i++)
			a[i].parentNode.removeChild(a[i]);
	}
	function remove_top() {
		var help = document.getElementById("spotlight-help");
		if(help != null) {
			var link = help.parentNode.parentNode;
			link.parentNode.removeChild(link);
		}
	}
	function init_adblock() {
		remove_all(document.body.getElementsByClassName("promoted"));
		remove_top();
		var sidebar_ad = document.getElementById("ad-frame");
		if(sidebar_ad != null)
			sidebar_ad.parentNode.removeChild(sidebar_ad);
	}
	function init_style() {
		var s = document.createElement("style");
		document.head.appendChild(s);
	}
	function init_header() {
		/*var h = document.getElementById("header-bottom-right");
		var bf = document.getElementById("mail");
		var sep= document.createElement("span");
		sep.className="seperator";
		sep.innerHTML="|";
		h.insertBefore(sep, bf);
		var opt = document.createElement("span");
		opt.style.cursor = "pointer";
		opt.innerHTML = "reditn";
		opt.id = "reditn";
		opt.onmousedown = show_dialog;
		h.insertBefore(opt, sep);*/
		/**Future**/
	}
	function init() {
		if(window.jQuery == null) {
			var s = document.createElement("script");
			s.setAttribute("type", "text/javascript");
			s.setAttribute("src", "https://ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js");
		}
		try {
			expand_info.maxw = (window.innerWidth - document.body.getElementsByClassName("tagline")[0].offsetLeft) - document.body.getElementsByClassName("side")[0].offsetWidth;
		} catch(e) {
			expand_info.maxw = window.innerWidth*0.6;
		}
		expand_info.maxh = window.innerHeight*0.5;
		init_adblock();
		init_style();
		init_expand();
		init_user_info();
		init_reddit_info();
		init_header();
	}
	if(document.readyState === "complete")
		init();
	else
		window.onload = function(e){init()};
})();