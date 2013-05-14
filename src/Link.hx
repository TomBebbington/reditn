import data.*;
using StringTools;
class Link {
	public static inline var FLICKR_KEY = "99dcc3e77bcd8fb489f17e58191f32f7";
	public static inline var TUMBLR_KEY = "k6pU8NIG57YiPAtXFD5s9DGegNPBZIpMahvbK4d794JreYIyYE";
	public static inline var IMGUR_KEY = "cc1f254578d6c52";
	public static inline var GOOGLE_API_KEY = "95f055321ea256d1d8828674c62105ea3931ae08";
	public static inline var EBAY_API_KEY = "ThomasDa-1e6c-4d29-a156-85557acee70b";
	public static inline var GITHUB_KEY = "39d85b9ac427f1176763";
	public static inline var GITHUB_KEYS = "5117570b83363ca0c71a196edc5b348af150c25d";
	static var LINK = ~/[src|href]="(\/([^\/]*))*?([^\/]*)"/;
	static var HTML_IMG = ~/<img .*?src="([^"]*)"\/?>/;
	static function noRel(html:String):String {
		return LINK.replace(html, "$1, $2");
	}
	static var sites:Array<Site> = [
		{
			regex: ~/.*\.(jpeg|gif|jpg|bmp|png)/,
			method: function(e, cb) {
				cb([{
					url: 'http://${e.matched(0)}',
					caption: null
				}]);
			}
		},
		{
			regex: ~/imgur.com\/(a|gallery)\/([^\/]*)/,
			method: function(e, cb) {
				var id = e.matched(2);
				var albumType = switch(e.matched(1)) {
					case "a": "album";
					case "gallery": "gallery/album";
					default: "album";
				};
				Reditn.getJSON('https://api.imgur.com/3/${albumType}/${id}', function(data:data.imgur.Album) {
					var album = [];
					if(data.images_count <= 0)
						album.push({
							url: 'http://i.imgur.com/${data.id}.jpg',
							caption: data.title
						});
					else
						for(i in data.images)
							album.push({
								url: 'http://i.imgur.com/${i.id}.jpg',
								caption: i.title
							});
					cb(album);
				}, 'Client-ID ${IMGUR_KEY}');
			}
		},
		{
			regex: ~/imgur\.com\/(r\/[^\/]*\/)?([a-zA-Z0-9]*)/,
			method: function(e, cb) {
				var id = e.matched(1) == null || e.matched(1).indexOf("/") != -1 ? e.matched(2) : e.matched(1);
				cb([{
					url: 'http://i.imgur.com/${id}.jpg',
					caption: null
				}]);
			}
		},
		{
			regex: ~/(qkme\.me|quickmeme\.com\/meme|m\.quickmeme.com\/meme)\/([^\/]*)/,
			method: function(e, cb) {
				cb([{
					url: 'http://i.qkme.me/${e.matched(2)}.jpg',
					caption: null
				}]);
			}
		},
		{
			regex: ~/memecrunch.com\/meme\/([^\/]*)\/([^\/]*)/,
			method: function(e, cb) {
				cb([{
					url: 'http://${e.matched(0)}/image.png',
					caption: null
				}]);
			}
		},
		{
			regex: ~/memegenerator\.net\/instance\/([^\/]*)/,
			method: function(e, cb) {
				cb([{
					url: 'http://cdn.memegenerator.net/instances/400x/${e.matched(1)}.jpg',
					caption: null
				}]);
			}
		},
		{
			regex: ~/imgflip\.com\/i\/([^\/]*)/,
			method: function(e, cb) {
				cb([{
					url: 'http://i.imgflip.com/${e.matched(1)}.jpg',
					caption: null
				}]);
			}
		},
		{
			regex: ~/xkcd.com\/([0-9]*)/,
			method: function(e, cb) {
				Reditn.getJSON('http://xkcd.com/${e.matched(1)}/info.0.json', function(data:Dynamic) {
					cb([{
						url: data.img, 
						caption: data.title
					}]);
				});
			}
		},
		{
			regex: ~/explosm.net\/comics\/([0-9]*)/,
			method: function(e, cb) {
				Reditn.getText('http://www.${e.matched(0)}', function(txt) {
					var rg = ~/"http:\/\/www\.explosm\.net\/db\/files\/Comics\/([^"]*)"/;
					if(rg.match(txt)) {
						cb([{
							url: rg.matched(0).substring(1, rg.matched(0).length-1),
							caption: null
						}]);
					}
					else
						throw '$rg not matched by ${e.matched(0)} in $txt';
				});
			}
		},
		{
			regex: ~/livememe.com\/([^\/]*)/,
			method: function(e, cb) {
				cb([{
					url: 'http://livememe.com/${e.matched(1)}.jpg',
					caption: null
				}]);
			}
		},
		{
			regex: ~/(([^\.]*\.)?deviantart\.com\/art|fav\.me)\/.*/,
			method: function(e, cb) {
				Reditn.getJSON('http://backend.deviantart.com/oembed?url=${e.matched(0).urlEncode()}&format=json', function(d) {
					cb([{
						url: d.url,
						caption: '${d.title} by ${d.author_name}'
					}]);
				});
			}
		},
		{
			regex: ~/flickr\.com(\/[^\/]*)*?\/([0-9@]*)\//,
			method: function(e, cb) {
				Reditn.getJSON('http://api.flickr.com/services/rest/?method=flickr.photos.getSizes&api_key=${FLICKR_KEY}&photo_id=${e.matched(2)}&format=json', function(d) {
					if(d.sizes == null || d.sizes.size == null)
						return;
					var sizes:Array<Dynamic> = d.sizes.size;
					var largest:String = sizes[sizes.length-1].source;
					cb([{
						url: largest,
						caption: null
					}]);
				});
			}
		},
		{
			regex: ~/ebay\.([a-zA-Z\.]*)\/itm(\/[^\/]*)?\/([0-9]*)/,
			method: function(e, cb) {
				var domain = e.matched(1);
				var id:String = e.matched(3);
				var url = 'http://open.api.ebay.com/shopping?callname=GetSingleItem&responseencoding=JSON&appid=${EBAY_API_KEY}&siteid=0&version=515&ItemID=${id}&IncludeSelector=TextDescription';
				Reditn.getJSON(url, function(data) {
					var imgs:Array<String> = data.Item.PictureURL;
					var nalbum = imgs.map(function(i) return { url: i, caption: null });
					cb({title: data.Item.Title, category: data.Item.PrimaryCategoryName, location: data.Item.Location + ", " + data.Item.Country, description: filterHTML(data.Item.Description), images: nalbum, price: Reditn.formatPrice(data.Item.ConvertedCurrentPrice.Value) + " " + data.Item.ConvertedCurrentPrice.CurrencyID});
				});
			}
		},
		{
			regex: ~/([^\.]*\.wordpress\.com)\/[0-9\/]*([^\/]*)\/?/,
			method: function(e, cb) {
				var url = 'http://public-api.wordpress.com/rest/v1/sites/${e.matched(1).htmlEscape()}/posts/slug:${e.matched(2).htmlEscape()}';
				Reditn.getJSON(url, function(data) {
					var att = data.attachments;
					cb({title: StringTools.htmlUnescape(data.title), content: filterHTML(data.content), author: data.author.name, images: 
					try [
						for(f in Reflect.fields(att)) {
							var img = Reflect.field(att, f);
							if(img.mime_type.startsWith("image/"))
								{url: img.URL, caption: null};
						}
					] catch(e:Dynamic) []});
				});
			}
		},
		{
			regex: ~/(.*)\/wiki\/([^#]*)(#.*)?/,
			method: function(e, cb) {
				var urlroot = e.matched(1), title = e.matched(2), to = e.matched(3);
				if(to != null)
					to = StringTools.trim(to.substr(1));
				if(to != null && to.length == 0)
					to = null;
				if(!urlroot.endsWith(".wikia.com"))
					urlroot += "/w";
				function getWikiPage(name:String) {
					Reditn.getJSON('http://${urlroot}/api.php?format=json&prop=revisions&action=query&titles=${name}&rvprop=content', function(data) {
						var pages:Dynamic = data.query.pages;
						for(p in Reflect.fields(pages)) {
							var page = Reflect.field(pages, p);
							var cont:String = Reflect.field(untyped page.revisions[0], "*");
							if(cont.startsWith("#REDIRECT [[")) {
								getWikiPage(cont.substring(12, cont.lastIndexOf("]]")));
								return;
							}
							cont = parser.MediaWiki.parse(cont, urlroot);
							if(to != null)
								cont = parser.MediaWiki.trimTo(cont, to);
							Reditn.getJSON('http://${urlroot}/api.php?format=json&action=query&prop=images&titles=${StringTools.htmlEscape(name)}', function(data) {
								var pages = data.query.pages;
								for(p in Reflect.fields(pages)) {
									var page = Reflect.field(pages, p);
									var images:Array<Dynamic> = page.images;
									var album:Album = [];
									if(images != null && images.length > 0) {
										var left:Int = images == null ? 0 : images.length;
										for(img in images) {
											Reditn.getJSON('http://${urlroot}/api.php?action=query&titles=${StringTools.urlEncode(img.title)}&prop=imageinfo&iiprop=url&format=json', function(data) {
												var pages:Dynamic = data.query.pages;
												for(p in Reflect.fields(pages)) {
													var page = Reflect.field(pages, p);
													if(page != null && page.pageinfo != null && page.imageinfo.length >= 1) {
														var url = untyped page.imageinfo[0].url;
														album.push({url: url, caption: null});
													}
												}
												if(--left <= 0)
													cb({title: page.title, content: cont, author: null, images: album});
											});
										}
									} else
										cb({title: page.title, content: cont, author: null, images: []});
								}
							});
						}
					});
				}
				getWikiPage(title);
			}
		},
		{
			regex: ~/github\.com\/([^\/]*)\/([^\/]*)/,
			method: function(e, cb) {
				var author = e.matched(1), repo = e.matched(2);
				Reditn.getJSON('https://api.github.com/repos/${author}/${repo}/readme?client_id=${GITHUB_KEY}&client_secret=${GITHUB_KEYS}', function(data) {
					if(data.content == null)
						return;
					var c:String = data.content;
					c = c.replace("\n", "");
					c = StringTools.trim(c);
					c = js.Browser.window.atob(c);
					var imgs:EReg = parser.Markdown.images;
					var album:Album = [];
					var tc = c;
					while(imgs.match(tc)) {
						var url = imgs.matched(2);
						if(url.indexOf(".") == url.lastIndexOf(".")) {
							if(url.startsWith("/"))
								url = url.substr(1);
							url = 'https://github.com/${author}/${repo}/raw/master/${url}';
						}
						album.push({ url: url, caption: imgs.matched(1)});
						tc = tc.substr(imgs.matchedPos().pos + imgs.matchedPos().len);
					}
					cb({
						name: repo,
						developers: [author],
						description: parser.Markdown.parse(c),
						url: 'git://github.com/${author}/${repo}.git',
						album: album
					});
				});
			}
		},
		{
			regex: ~/sourceforge.net\/projects\/([a-zA-Z-]*)/,
			method: function(e, cb) {
				Reditn.getJSON('http://sourceforge.net/api/project/name/${e.matched(1)}/json', function(data:Dynamic) {
					data = data.Project;
					var devs:Array<Dynamic> = data.developers;
					cb({
						name: data.name,
						description: data.description,
						developers: [for(d in devs) d.name],
						url: {
							var u = Reflect.field(data, "download-page");
							for(f in Reflect.fields(data))
								if(f.endsWith("Repository")) {
									var type = f.substr(0, f.length - 10).toLowerCase();
									var loc:String = Reflect.field(data, f).location;
									u = loc.replace("http:", '${type}:');
								}
							u;
						},
						album: []
					});
				});
			}
		},
		{
			regex: ~/(digitaltrends\.com|webupd8\.org)\/.*/,
			method: function(e, cb) {
				Reditn.getText('http://${e.matched(0)}', function(txt) {
					var t = ~/<title>(.*)<\/title>/;
					if(t.match(txt)) {
						var cont = txt;
						cont = cont.substr(cont.indexOf("<article"));
						cont = cont.substr(cont.indexOf(">")+1);
						cont = cont.substr(0, cont.indexOf("</article>"));
						var images = [];
						while(HTML_IMG.match(cont)) {
							images.push({
								url: HTML_IMG.matched(1),
								caption: null
							});
							cont = HTML_IMG.replace(cont, "");
						}
						cont = filterHTML(cont);
						cb({
							title: t.matched(1),
							content: cont,
							author: null,
							images: images
						});
					}
				});
			}
		},
		{
			regex: ~/([^\.]*)\.tumblr\.com\/(post|image)\/([0-9]*)/,
			method: function(e, cb) {
				var author = e.matched(1), id = e.matched(3);
				Reditn.getJSON('http://api.tumblr.com/v2/blog/${author}.tumblr.com/posts/json?api_key=${TUMBLR_KEY}&id=${id}', function(data) {
					var post:Dynamic = untyped data.posts[0];
					cb(switch(post.type) {
						case "text":
						var images = [];
						while(HTML_IMG.match(post.body)) {
							images.push({
								url: HTML_IMG.matched(1),
								caption: null
							});
							post.body = HTML_IMG.replace(post.body, "");
						}
						post.body = filterHTML(post.body);
						{title: post.title, content: post.body, author: data.blog.name, images: images};
						case "quote": {title: null, content: post.text+"<br/><b>"+post.source+"</b>", author: data.blog.name, images: []};
						case "photo":
							var ps:Array<Dynamic> = post.photos;
							[for(p in ps) {
								{
									url: p.original_size.url,
									caption: p.caption
								}
							}];
						default: null;
					});
				});
			}
		}
	];
	public static function resolve(url:String) {
		url = trimURL(url);
		for(s in sites)
			try {
				if(s.regex.match(url))
					return s;
			} catch(d:Dynamic) {
				trace('Error $d whilst processing regex ${s.regex}');
			}
		return null;
	}
	public static function trimURL(url:String) {
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
		if(url.indexOf("#") != -1 && url.indexOf("/wiki/") == -1)
			url = url.substr(0, url.indexOf("#"));
		return url;
	}
	static var HTML_FILTERS:Array<EReg> = [
		HTML_IMG,
		~/<meta[^>]*\/>/g,
		~/<(h1|header)[^>]*>.*<\/\1>/g,
		~/<table([^>]*)>(.|\n|\n\r)*<\/table>/gm,
		~/<div class="(seperator|ga-ads)"[^>]*>(.|\n|\n\r)*<\/div>/g,
		~/<([^>]*)( [^>]*)?><\/\1>/g,
		~/<script[^>\/]*\/>/g,
		~/<script[^>\/]*><\/script>/g,
		~/(<br><\/br>|<br ?\/>)(<br><\/br>|<br ?\/>)/g,
		~/style ?= ?"[^"]*"/g
	];
	static function filterHTML(html:String):String {
		for(f in HTML_FILTERS)
			html = f.replace(html, "");
		return html;
	}
}