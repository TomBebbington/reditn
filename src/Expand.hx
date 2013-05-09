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
			Reditn.pushState(toggled ? "#showall":null);
		}
		li.appendChild(button);
		if(menu != null)
			menu.appendChild(li);
		for(l in Reditn.links) {
			if(l.nodeName.toLowerCase()!="a")
				continue;
			l.onchange = function(_) {
				Reditn.getLinkType(l.href, function(urltype) {
					switch(urltype) {
						case SHOP_ITEM:
							getItem(l.href, function(i:ShopItem) {
								var e = Reditn.getLinkContainer(l);
								var expando = Browser.document.createDivElement();
								expando.className = "expando";
								expando.style.display = "none";
								var div = Browser.document.createDivElement();
								div.className = "usertext";
								expando.appendChild(div);
								var head = null;
								var contentBlock = Browser.document.createDivElement();
								var inner = Browser.document.createSpanElement();
								inner.innerHTML = '<h3>${StringTools.htmlEscape(i.title)}</h3><br>' + 
								'<b>Category:</b> ${StringTools.htmlEscape(i.category)}<br>' + 
								'<b>Location:</b> ${StringTools.htmlEscape(i.location)}<br>' + 
								'<b>Price:</b> ${StringTools.htmlEscape(i.price)}<br>' +
								'<p>${StringTools.htmlEscape(i.description)}</p>';
								contentBlock.appendChild(inner);
								contentBlock.className = "md";
								if(i.images != null && i.images.length > 0) {
									var album = Reditn.embedAlbum(i.images);
									album.style.float = "right";
									contentBlock.appendChild(album);
								}
								div.appendChild(contentBlock);
								var s = makeSelfButton(e, "item", l.href);
								var pn:Element = cast s.parentNode;
								for(exp in pn.getElementsByClassName("expando")) {
									pn.removeChild(exp);
								}
								pn.appendChild(expando);
								Reditn.show(expando, toggled);
							});
						case ARTICLE:
							getArticle(l.href, function(a:Article) {
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
							getImage(l.href, function(a:Album) {
								var e = Reditn.getLinkContainer(l);
								var div = Reditn.embedAlbum(a);
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
				});
			};
			l.onchange(null);
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
	static function getArticle(ourl:String, cb:Article -> Void) {
		var url = Reditn.trimURL(ourl);
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
			var username = Reditn.removeSymbols(url.substr(12));
			var id = Reditn.removeSymbols(url.substr(url.indexOf("/status/") + 8));
			Reditn.getJSON('https://api.twitter.com/1.1/statuses/show.json?id=${id}', function(data) {
				data.text;
				cb({title: null, content: StringTools.htmlEscape(data.text), author:'@${username}'});
			});
		} else if(url.indexOf(".tumblr.com/post/") != -1) {
			var author = url.substr(0, url.indexOf("."));
			var id = Reditn.removeSymbols(url.substr(url.indexOf(".")+17));
			Reditn.getJSON('http://api.tumblr.com/v2/blog/${author}.tumblr.com/posts/json?api_key=${Reditn.TUMBLR_KEY}&id=${id}', function(data:Dynamic) {
				var post = data.posts[0];
				cb(if(post.type == "text")
					{title: post.title, content: post.body, author: data.blog.name};
				else if(data.type == "quote")
					{title: null, content: '${post.text}<br/><b>${post.source}</b>', author: data.blog.name};
				else if(data.type == "link")
					{title: post.title, content: '<a href="${post.url}">${post.description}</a>', author: data.blog.name}
				else
					null
				);
			});
		} else if(url.indexOf(".wordpress.com/") != -1 || url.indexOf("/wordpress/") != -1) {
			var site = StringTools.htmlEscape(url.substr(0, url.indexOf("/")));
			var slug = url.substr(url.indexOf("/")+1);
			if(slug.charAt(slug.length-1) == "/")
				slug = slug.substr(0, slug.length-1);
			slug = slug.substr(slug.lastIndexOf("/")+1);
			slug = StringTools.htmlEscape(Reditn.removeSymbols(slug));
			var url = 'http://public-api.wordpress.com/rest/v1/sites/${site}/posts/slug:${slug}';
			Reditn.getJSON(url, function(data) {
				cb({title: data.title, content: data.content, author: data.author.name});
			});
		} else if(url.indexOf(".blogger.") != -1 || url.indexOf(".blogspot.") != -1) {
			var site = StringTools.htmlEscape(url.substr(0, url.indexOf("/")));
			var slug = url.substr(url.indexOf("/")+1);
			if(slug.charAt(slug.length-1) == "/")
				slug = slug.substr(0, slug.length-1);
			slug = slug.substr(slug.lastIndexOf("/")+1);
			slug = StringTools.htmlEscape(Reditn.removeSymbols(slug));
			if(slug.endsWith(".html"))
				slug = slug.substr(0, slug.length-5);
			var url = 'https://www.googleapis.com/blogger/v2/blogs/${site}/posts/${slug}&key=${Reditn.GOOGLE_API_KEY}';
			Reditn.getJSON(url, function(data) {
				cb({title: data.title, content: data.content, author: data.author.displayName});
			});
		}
	}
	static function getItem(url:String, cb:ShopItem -> Void) {
		var url = Reditn.trimURL(url);
		if(url.indexOf("ebay.com/") != -1) {
			var id = if(url.indexOf("item=") != -1)
				Reditn.removeSymbols(url.substr(url.indexOf("item=") + 5));
			else {
				var chopped = url.split("/");
				var nid = null;
				for(c in chopped) {
					var rsc = Reditn.removeSymbols(c);
					if(Std.string(Std.parseInt(rsc)) == rsc) {
						nid = rsc;
						break;
					}
				}
				nid;
			};
			var url = 'http://open.api.ebay.com/shopping?callname=GetSingleItem&responseencoding=JSON&appid=${Reditn.EBAY_API_KEY}&siteid=0&version=515&ItemID=${id}&IncludeSelector=TextDescription';
			Reditn.getJSON(url, function(data) {
				var imgs:Array<String> = data.Item.PictureURL;
				var nalbum = imgs.map(function(i) return image(i));
				cb({title: data.Item.Title, category: data.Item.PrimaryCategoryName, location: data.Item.Location + ", " + data.Item.Country, description: data.Item.Description, images: nalbum, price: Reditn.formatNumber(data.Item.ConvertedCurrentPrice.Value) + " " + data.Item.ConvertedCurrentPrice.CurrencyID});
			});
		}
	}
	static function getImage(ourl:String, cb:Album -> Void) {
		var url = Reditn.trimURL(ourl);
		if((url.startsWith("i.imgur.com/") && url.split(".").length == 3) || url.indexOf("media.tumblr.com/") != -1)
			cb(album(ourl));
		else if(url.startsWith("imgur.com/a/") || url.startsWith("imgur.com/gallery/")) {
			var id:String = url.split("/")[2];
			var albumType = url.indexOf("gallery") != -1 ? "gallery/album" : "album";
			var req = new haxe.Http('https://api.imgur.com/3/${albumType}/${id}');
			req.setHeader("Authorization", 'Client-ID ${Reditn.IMGUR_CLIENT_ID}');
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
			req.request(false);
		} else if(url.startsWith("imgur.com/")) {
			var id = Reditn.removeSymbols(url.substr(url.indexOf("/")+1));
			cb(if(id.indexOf(",") != -1)
				id.split(",").map(function(nid) return image('http://i.imgur.com/${nid}.jpg'));
			else
				album('http://i.imgur.com/${id}.jpg'));
		} else if(url.startsWith("qkme.me/")) {
			var id = Reditn.removeSymbols(url.substr(8));
			cb(album('http://i.qkme.me/${id}.jpg'));
		} else if(url.startsWith("quickmeme.com/meme/")) {
			var id = Reditn.removeSymbols(url.substr(19));
			cb(album('http://i.qkme.me/${id}.jpg'));
		} else if(url.startsWith("m.quickmeme.com/meme/")) {
			var id = Reditn.removeSymbols(url.substr(21));
			cb(album('http://i.qkme.me/${id}.jpg'));
		} else if(url.startsWith("memecrunch.com/meme/")) {
			var id = url;
			if(id.charAt(id.length-1) != "/")
				id += "/";
			cb(album('http://${id}image.jpg'));
		} else if(url.startsWith("memegenerator.net/instance/")) {
			var id = Reditn.removeSymbols(url.substr(27));
			cb(album('http://cdn.memegenerator.net/instances/400x/${id}.jpg'));
		} else if(url.startsWith("imgflip.com/i/")) {
			var id = Reditn.removeSymbols(url.substr(14));
			cb(album('http://i.imgflip.com/${id}.jpg'));
		} else if(url.startsWith("xkcd.com/")) {
			var id = Reditn.removeSymbols(url.substr(9));
			Reditn.getJSON('http://xkcd.com/${id}/info.0.json', function(data:Dynamic) {
				cb(album(data.img, data.title));
			});
		} else if(url.startsWith("explosm.net/comics/")) {
			var id = Reditn.removeSymbols(url.substr(19));
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
			var id = Reditn.removeSymbols(url.substr(13));
			cb(album('http://livememe.com/${id}.jpg'));
		} else if(url.startsWith("deviantart.com/art/") || ourl.indexOf(".deviantart.com/art/") != -1 || (ourl.indexOf(".deviantart.com/") != -1 && ourl.indexOf("#/d") != -1) || ourl.indexOf("fav.me") != -1) {
			Reditn.getJSON('http://backend.deviantart.com/oembed?url=${ourl.urlEncode()}&format=json', function(d) {
				cb(album(d.url, '${d.title} by ${d.author_name}'));
			});
		} else if(url.indexOf(".tumblr.com/") != -1) {
			var author = url.substr(0, url.indexOf("."));
			var parts = url.substr(author.length+12).split("/");
			var id = Reditn.removeSymbols(parts[1]);
			Reditn.getJSON('http://api.tumblr.com/v2/blog/${author}.tumblr.com/posts/json?api_key=${Reditn.TUMBLR_KEY}&id=${id}', function(data:Dynamic) {
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
			Reditn.getJSON('http://api.flickr.com/services/rest/?method=flickr.photos.getSizes&api_key=${Reditn.FLICKR_KEY}&photo_id=${id}&format=json', function(d) {
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
}