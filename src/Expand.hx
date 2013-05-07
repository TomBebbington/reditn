import js.*;
import js.html.*;
import haxe.Timer;
import haxe.*;
import data.*;
using StringTools;
class Expand {
	static inline var FLICKR_KEY = "99dcc3e77bcd8fb489f17e58191f32f7";
	static inline var TUMBLR_KEY = "k6pU8NIG57YiPAtXFD5s9DGegNPBZIpMahvbK4d794JreYIyYE";
	static inline var IMGUR_CLIENT_ID = "cc1f254578d6c52";
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
			Reditn.pushState(toggled ? "#showall":null);
		}
		li.appendChild(button);
		if(menu != null)
			menu.appendChild(li);
		for(l in Reditn.links) {
			if(l.nodeName.toLowerCase()!="a")
				continue;
			var urltype = Reditn.getLinkType(l.href);
			switch(urltype) {
				case ARTICLE:
					getArticle(l.href, l, function(a:Article) {
						var e = Reditn.getLinkContainer(l);
						var expando = Browser.document.createDivElement();
						expando.className = "expando";
						expando.style.display = "none";
						var div = Browser.document.createDivElement();
						div.className = "usertext";
						expando.appendChild(div);
						var head = null;
						var contentBlock = Browser.document.createDivElement();
						contentBlock.innerHTML = (a.title != null ? '<h3>${StringTools.htmlEscape(a.title)} <em>by ${a.author}</em></h3><br>' : "") + a.content;
						contentBlock.className = "md";
						div.appendChild(contentBlock);
						var s = makeSelfButton(e, "selftext", l.href);
						var pn:Element = cast s.parentNode;
						for(exp in pn.getElementsByClassName("expando")) {
							pn.removeChild(exp);
						}
						pn.appendChild(expando);
						Reditn.show(expando, toggled);
					});
				case IMAGE:
					getImageLink(l.href, l, function(a:Album) {
						var e = Reditn.getLinkContainer(l);
						var div = Browser.document.createDivElement();
						div.className = "expando";
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
						var s = makeSelfButton(e, "image", l.href);
						var pn:Element = cast s.parentNode;
						for(exp in pn.getElementsByClassName("expando")) {
							pn.removeChild(exp);
						}
						pn.appendChild(div);
						refresh();
					});
				default: preload(l.href);
			}
		}
	}
	static function makeSelfButton(e:Element, extra:String, url:String):DivElement {
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
				var entry:Element = cast d.parentNode;
				var expando:Element = cast entry.getElementsByClassName("expando")[0];
				Reditn.show(expando, v);
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
		refresh();
		return d;
	}
	public static function refresh() {
		if(button != null) {
			button.innerHTML = '${toggled?"hide":"show"} all (${buttons.length})';
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
			btn.toggle(t);
		refresh();
	}
	static inline function image(url:String, ?c:String):Image {
		return {url: url, caption: c};
	}
	static inline function album(url:String, ?c:String):Album {
		return [image(url, c)];
	}
	static function trimURL(url:String) {
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
		return url;
	}
	static function getArticle(ourl:String, el:Element, cb:Article -> Void) {
		var url = trimURL(ourl);
		if(url.startsWith("cracked.com/")) {
			var authorx = ~/<a[^>]*?class="[^"]*?byline"[^>]*?>([a-zA-Z ]*)<\/a>/;
			Reditn.getText(ourl, function(data:String) {
				if(data.indexOf("<section>") != -1) {
					var body = data.substr(data.indexOf("<section>") + 9);
					body = body.substr(0, body.indexOf("</section>"));
					var title = data.substr(data.indexOf("<title>") + 7);
					title = title.substr(0, title.indexOf("|"));
					if(data.indexOf("rel=\"next\" href=\"") != -1) {
						var temp = data.substr(17 + data.indexOf("rel=\"next\" href=\""));
						temp = temp.substr(0, temp.indexOf("\""));
						Reditn.getText(temp, function(odata:String) {
							var nbody = odata.substr(odata.indexOf("<section>")+9);
							nbody = nbody.substr(0, nbody.indexOf("</section"));
							cb({title: title, content: body + "<br>" + nbody, author: (!authorx.match(data) ? null : authorx.matched(1))});
						});
					} else
						cb({title: title, content: body, author: (!authorx.match(data) ? null : authorx.matched(1))});
				}
			});
		} else if(url.startsWith("twitter.com/") && url.indexOf("/status/") != -1) {
			var username = removeSymbols(url.substr(12));
			var id = removeSymbols(url.substr(url.indexOf("/status/") + 8));
			Reditn.getJSON('https://api.twitter.com/1.1/statuses/show.json?id=${id}', function(data) {
				data.text;
				cb({title: null, content: StringTools.htmlEscape(data.text), author:'@${username}'});
			});
		} else if(url.indexOf(".tumblr.com/post/") != -1) {
			var author = url.substr(0, url.indexOf("."));
			var id = removeSymbols(url.substr(url.indexOf(".")+17));
			Reditn.getJSON('http://api.tumblr.com/v2/blog/${author}.tumblr.com/posts/json?api_key=${TUMBLR_KEY}&id=${id}', function(data:Dynamic) {
				var post = data.posts[0];
				cb(if(post.type == "text")
					{title: post.title, content: post.body, author: data.blog.name};
				else if(data.type == "quote")
					{title: null, content: '${post.text}<br/><b>${post.source}</b>', author: data.blog.name};
				else if(data.type == "link")
					{title: post.title, content: '<a href="${post.url}">${post.description}</a>', author: data.blog.name});
			});
		}
	}
	static function getImageLink(ourl:String, el:Element, cb:Album -> Void) {
		var url = trimURL(ourl);
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
		} else if(url.startsWith("xkcd.com/")) {
			var id = removeSymbols(url.substr(9));
			Reditn.getJSON('http://xkcd.com/${id}/info.0.json', function(data:Dynamic) {
				cb(album(data.img, data.title));
			});
		} else if(url.startsWith("explosm.net/comics/")) {
			var id = removeSymbols(url.substr(19));
			Reditn.getText('http://explosm.net/comics/${id}/', function(text:String) {
				var mt = "\"http://www.explosm.net/db/files/Comics/";
				var i = text.indexOf(mt);
				if(i != -1) {
					var id = text.substr(i + mt.length);
					id = id.substr(0, id.indexOf("\""));
					cb(album(mt.substr(1) + id));
				}
			});
		} else if(url.startsWith("livememe.com/")) {
			var id = removeSymbols(url.substr(13));
			cb(album('http://livememe.com/${id}.jpg'));
		} else if(url.startsWith("deviantart.com/art/") || ourl.indexOf(".deviantart.com/art/") != -1 || (ourl.indexOf(".deviantart.com/") != -1 && ourl.indexOf("#/d") != -1) || ourl.indexOf("fav.me") != -1) {
			Reditn.getJSON('http://backend.deviantart.com/oembed?url=${ourl.urlEncode()}&format=json', function(d) {
				cb(album(d.url, '${d.title} by ${d.author_name}'));
			});
		} else if(url.indexOf(".tumblr.com/image/") != -1) {
			var author = url.substr(0, url.indexOf("."));
			var id = removeSymbols(url.substr(author.length + 18));
			Reditn.getJSON('http://api.tumblr.com/v2/blog/${author}.tumblr.com/posts/json?api_key=${TUMBLR_KEY}&id=${id}', function(data:Dynamic) {
				var post = data.posts[0];
				switch(post.type) {
					case "photo": 
						var ps:Array<Dynamic> = post.photos;
						cb([for(p in ps) {
							image(p.original_size.url, p.caption);
						}]);
					default:
						throw 'Unknown datatype ${post.type}';
				}
			});
		} else if(url.startsWith("flickr.com/photos/")) {
			var id = url.substr(18);
			id = id.substr(id.indexOf("/")+1);
			id = id.substr(0, id.indexOf("/"));
			Reditn.getJSON('http://api.flickr.com/services/rest/?method=flickr.photos.getSizes&api_key=${FLICKR_KEY}&photo_id=${id}&format=json', function(d) {
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
}