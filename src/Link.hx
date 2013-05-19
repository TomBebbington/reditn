import data.*;
import parser.*;
using StringTools;
class Link {
	public static inline var FLICKR_KEY = "99dcc3e77bcd8fb489f17e58191f32f7";
	public static inline var TUMBLR_KEY = "k6pU8NIG57YiPAtXFD5s9DGegNPBZIpMahvbK4d794JreYIyYE";
	public static inline var IMGUR_KEY = "cc1f254578d6c52";
	public static inline var GOOGLE_API_KEY = "AIzaSyC-LFpB6Y-kC6re81ohFnPIvO4hbJYGS3o";
	public static inline var EBAY_API_KEY = "ThomasDa-1e6c-4d29-a156-85557acee70b";
	public static inline var GITHUB_KEY = "39d85b9ac427f1176763";
	public static inline var GITHUB_KEYS = "5117570b83363ca0c71a196edc5b348af150c25d";
	public static inline var AMAZON_KEY = "AKIAJMR3XPXGBMZJE6IA";
	public static inline var FACEBOOK_KEY = "CAAFdBpahq7IBAFZBcSH9UOZAaREy2V3hSd2e0D9liaI48X5xavt3lI8rwdXd6YTizhZAip1D3cY4XriGV7FxZAH7HmFe3Khnj7sFATZAKiKZAHx5qJwLcRHwc2ZBH7ePQw5T7eZBUeRZBM7A5YymTPxjrCAAFdBpahq7IBAFZBcSH9UOZAaREy2V3hSd2e0D9liaI48X5xavt3lI8rwdXd6YTizhZAip1D3cY4XriGV7FxZAH7HmFe3Khnj7sFATZAKiKZAHx5qJwLcRHwc2ZBH7ePQw5T7eZBUeRZBM7A5YymTPxjrf";
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
					caption: null,
					author: null
				}]);
			}
		},
		{
			regex: ~/imgur.com\/(a|gallery)\/([^\/]*)/,
			method: function(e, cb) {
				var id = e.matched(2);
				var albumType = switch(e.matched(1).toLowerCase()) {
					case "a": "album";
					case "gallery": "gallery/album";
					default: "album";
				};
				Reditn.getJSON('https://api.imgur.com/3/${albumType}/${id}', function(data:data.imgur.Album) {
					var album = [];
					if(data.images_count <= 0)
						album.push({
							url: 'http://i.imgur.com/${data.id}.jpg',
							caption: data.title,
							author: data.account_url
						});
					else
						for(i in data.images)
							album.push({
								url: 'http://i.imgur.com/${i.id}.jpg',
								caption: i.title,
								author: data.account_url
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
					caption: null,
					author: null
				}]);
			}
		},
		{
			regex: ~/(qkme\.me|quickmeme\.com\/meme|m\.quickmeme.com\/meme)\/([^\/]*)/,
			method: function(e, cb) {
				cb([{
					url: 'http://i.qkme.me/${e.matched(2)}.jpg',
					caption: null,
					author: null
				}]);
			}
		},
		{
			regex: ~/memecrunch.com\/meme\/([^\/]*)\/([^\/]*)/,
			method: function(e, cb) {
				cb([{
					url: 'http://${e.matched(0)}/image.png',
					caption: null,
					author: null
				}]);
			}
		},
		{
			regex: ~/memegenerator\.net\/instance\/([^\/]*)/,
			method: function(e, cb) {
				cb([{
					url: 'http://cdn.memegenerator.net/instances/400x/${e.matched(1)}.jpg',
					caption: null,
					author: null
				}]);
			}
		},
		{
			regex: ~/imgflip\.com\/i\/([^\/]*)/,
			method: function(e, cb) {
				cb([{
					url: 'http://i.imgflip.com/${e.matched(1)}.jpg',
					caption: null,
					author: null
				}]);
			}
		},
		{
			regex: ~/what-if.xkcd.com\/([0-9]*)/,
			method: function(e, cb) {
				
			}
		},
		{
			regex: ~/xkcd.com\/([0-9]*)/,
			method: function(e, cb) {
				Reditn.getJSON('http://www.xkcd.com/${e.matched(1)}/info.0.json', function(data:Dynamic) {
					cb([{
						url: data.img, 
						caption: data.title,
						author: null
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
							caption: null,
							author: null
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
					caption: null,
					author: null
				}]);
			}
		},
		{
			regex: ~/(([^\.]*\.)?deviantart\.com\/art|fav\.me)\/.*/,
			method: function(e, cb) {
				Reditn.getJSON('http://backend.deviantart.com/oembed?url=${e.matched(0).urlEncode()}&format=json', function(e:OEmbed) {
					cb([{
						url: e.url,
						caption: e.title,
						author: e.author_name
					}]);
				});
			}
		},
		{
			regex: ~/flickr\.com\/photos\/.*/,
			method: function(e, cb) {
				Reditn.getJSON('http://www.flickr.com/services/oembed/?url=http://www.${StringTools.urlEncode(e.matched(0))}&format=json', function(e:OEmbed) {
					cb([{
						url: e.url,
						caption: e.title,
						author: e.author_name
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
					var nalbum = imgs.map(function(i) return { url: i, caption: null , author: null});
					cb({title: data.Item.Title, category: data.Item.PrimaryCategoryName, location: data.Item.Location + ", " + data.Item.Country, description: filterHTML(data.Item.Description), images: nalbum, price: Reditn.formatPrice(data.Item.ConvertedCurrentPrice.Value) + " " + data.Item.ConvertedCurrentPrice.CurrencyID});
				});
			}
		},
		{
			regex: ~/([^\.]*\.wordpress\.com|wp\.me|techcrunch\.com|news\.blogs\.cnn\.com|snoopdogg\.com|usainbolt\.com|katiecouric\.com|rollingstones\.com|variety\.com|bbcamerica\.com)\/(.*)?/,
			method: function(e, cb) {
				var url = "http://"+e.matched(0);
				Reditn.getJSON('http://public-api.wordpress.com/oembed/?url=${url.urlEncode()}&for=Reditn', function(data:data.OEmbed) {
					var imgs:Album = [];
					if(data.thumbnail_url != null)
						imgs.push({caption: null, url: data.thumbnail_url, author: null});
					cb({
						author: data.author_name,
						content: filterHTML(data.html),
						images: imgs
					});
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
							var images = parser.MediaWiki.getAlbum(cont);
							if(to != null)
								cont = parser.MediaWiki.trimTo(cont, to);
							cont = parser.MediaWiki.parse(cont, urlroot);
							if(images.length > 0) {
								var nimages = [];
								for(i in images)
									Reditn.getJSON('http://${urlroot}/api.php?action=query&titles=${StringTools.urlEncode(i.url)}&prop=imageinfo&iiprop=url&format=json', function(data) {
										var pages:Dynamic = data.query.pages;
										for(p in Reflect.fields(pages)) {
											var page = Reflect.field(pages, p);
											if(page != null && page.imageinfo != null) {
												var url = untyped page.imageinfo[0].url;
												nimages.push({url: url, caption: i.caption, author: null});
											} else {
												trace('Error whilst processing $page for ${i.url}');
												images.remove(i);
											}
										}
										if(nimages.length >= images.length)
											cb({title: page.title, content: cont, author: null, images: nimages});
									});
							} else 
								cb({title: page.title, content: cont, author: null, images: null});
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
						album.push({ url: url, caption: imgs.matched(1), author: ${author}});
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
			regex: ~/(digitaltrends\.com|webupd8\.org|doctorwho\.tv)\/.*/,
			method: function(e, cb) {
				Reditn.getText('http://www.${e.matched(0)}', function(txt) {
					var t = ~/<title>(.*)<\/title>/;
					if(t.match(txt)) {
						var cont = txt;
						cont = cont.substr(cont.indexOf("<article"));
						cont = cont.substr(cont.indexOf(">")+1);
						cont = cont.substr(0, cont.indexOf("</article>"));
						cont = filterHTML(cont);
						cb({
							title: t.matched(1),
							content: cont,
							author: null,
							images: []
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
								caption: null,
								author: data.blog.name
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
									caption: p.caption,
									author: data.blog.name
								};
							}];
						default: null;
					});
				});
			}
		},
		{
			regex: ~/.*\.tumblr\.com/,
			method: function(e, cb) {
				Reditn.getJSON('http://api.tumblr.com/v2/blog/${e.matched(0).urlEncode()}/info?api_key=${TUMBLR_KEY}', function(data) {
					cb({
						urls: new Map<String, String>(),
						name: data.blog.title,
						description: filterHTML(data.blog.description),
						album: []
					});
				});
			}
		},
		{
			regex: ~/twitter.com\/.*\/status\/([0-9]*)/,
			method: function(e, cb) {
				Reditn.getJSON('https://api.twitter.com/1/statuses/oembed.json?id=${e.matched(2)}', function(data:OEmbed) {
					cb({
						title: null,
						author: data.author_name,
						content: filterHTML(data.html),
						images: []
					});
				});
			}
		},
		{
			regex: ~/amazon\.[a-z\.]*\/gp\/product\/([0-9A-Z]*)/,
			method: function(e, cb) {
				var id = e.matched(1);
				Reditn.getXML('http://webservices.amazon.com/onca/xml?AWSAccessKeyId=${AMAZON_KEY}&Service=AWSECommerceService&Operation=ItemLookup&ItemId=${id}', function(data) {
					trace(data); // does it even lift?
				});
			}
		},
		{
			regex: ~/plus\.google\.com\/([0-9]*)\/posts\/([a-zA-Z]*)/,
			method: function(e, cb) {
				var pid = e.matched(1), id = e.matched(2), num = 0, title = ~/<b>([^>]*)<\/b><br \/>/;
				function nextPage(?tk:String) {
					tk = tk == null ? "" : '&requestToken=${tk}';
					if(num > 8)
						return;
					Reditn.getJSON('https://www.googleapis.com/plus/v1/people/${pid}/activities/public?fields=items(id%2Curl)%2CnextPageToken&key=${GOOGLE_API_KEY}${tk}', function(data) {
						var items:Array<Dynamic> = data.items, url = e.matched(0);
						for(i in items)
							if(i.url.indexOf(id) != -1) {
								Reditn.getJSON('https://www.googleapis.com/plus/v1/activities/${i.id}?fields=actor%2FdisplayName%2Cannotation%2Cobject(actor%2Cattachments%2Ccontent%2Cid%2CobjectType%2CoriginalContent%2Curl)&key=${GOOGLE_API_KEY}', function(data) {
									var type:String = data.object.objectType, name:String = data.actor.actorName, cont:String = data.object.content;
									title.match(cont);
									switch(type) {
										case "note":
											var titl = title.matched(1);
											cont = title.replace(cont, "");
											cont = filterHTML(cont);
											cb({title: titl, author: name, content: cont, images: []});
										default:
											trace(data);
											var att:Array<Dynamic> = data.object.attachments;
											cb([for(a in att) 
												{url: a.image.url, caption: a.content.length == 0 ? data.object.content : a.content, author: null}]);
									}
								});
								return;
							}
						if(data.items.length != 0)
							nextPage(data.requestToken);
					});
				}
				nextPage();
			}
		},
		{
			regex: ~/facebook.com\/photo\.php\?v=([0-9]*)/,
			method: function(e, cb) {
				var id = e.matched(1);
				/*
				Reditn.getJSON('https://graph.facebook.com/${id}?access_token=${FACEBOOK_KEY}', function(data) {
					trace(data);
					cb([{
						caption: data.name,
						url: data.source,http://graph.facebook.com/{ID of object}/picture?type=large
						author: data.from.name
					}]);
				});	*/
				cb([{ caption: null, url: "http://graph.facebook.com/${id}/picture?type=small&access_token="+FACEBOOK_KEY, author: null}]);
			}
		},
		{
			regex: ~/facebook\.com\/([a-zA-Z0-9]*)/,
			method: function(e, cb) {
				var id = e.matched(1);
				cb({
					album: [{url: "https://graph.facebook.com/"+id+"/picture?type=large", caption: null, author: null}],
					urls: new Map<String, String>()
				});
			}
		},
		{
			regex: ~/plus\.google.com\/u?\/?[0-9]*\/([0-9]*)(\/about)?/,
			method: function(e, cb) {
				var id = e.matched(1);
				Reditn.getJSON('https://www.googleapis.com/plus/v1/people/${id}?key=${GOOGLE_API_KEY}', function(data) {
					var urls:Array<Dynamic> = data.urls;
					var aurls = new Map<String, String>();
					if(urls != null)
						for(u in urls)
							aurls.set(u.label, u.value);
					if(data.urls != null && data.displayName != null && data.aboutMe != null)
						cb({
							urls: aurls,
							name: data.displayName,
							description: data.aboutMe,
							album: [{url: data.image.url, caption: null, author: data.displayName}]
						});
				});
			}
		},
		{
			regex: ~/reddit\.com\/r\/([a-zA-Z0-9]*)/,
			method: function(e, cb) {
				trace(e.matched(1));
				Reditn.getJSON('http://www.${e.matched(0)}/about.json', function(s:data.Subreddit) cb(s));
			}
		},
		{
			regex: ~/gamejolt.com\/games\/[^\/]*\/[^\/]*\/([0-9]*)/,
			method: function(e, cb) {
				var id = e.matched(1);
				Reditn.getJSON('http://gamejolt.com/service/games/${id}?format=json', function(data) {
					trace(data);
				});
			}
		}
	];
	public static function resolve(url:String) {
		url = trimURL(url);
		for(s in sites)
			try {
				if(s.regex.match(url) && s.regex.matchedPos().len == url.length)
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
		else if(url.startsWith("m."))
			url = url.substr(2);
		if(url.indexOf("&") != -1)
			url = url.substr(0, url.indexOf("&"));
		if(url.indexOf("?") != -1 && !url.startsWith("facebook.com/"))
			url = url.substr(0, url.indexOf("?"));
		if(url.indexOf("#") != -1 && url.indexOf("/wiki/") == -1)
			url = url.substr(0, url.indexOf("#"));
		if(url.endsWith("/"))
			url = url.substr(0, url.length-1);
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
		~/style ?= ?"[^"]*"/g
	];
	static var HTML_CLEANERS:Array<parser.Entry> = [
		{ from: ~/<blockquote class="twitter-tweet">(.*)<\/blockquote>/g, to: "$1"},
		{ from: ~/(!|\.|,|\?)(^ \n\t\r)/g, to: "$1 $2" },
		{ from: ~/(!|\.|,|\?)( *)/g, to: "$1 "},
		{ from: ~/(<br><\/br>|<br\/>|<br \/>)(<br><\/br>|<br\/>|<br \/>)/g, to: "<br/>"}
	];
	static function filterHTML(h:String):String {
		for(f in HTML_FILTERS)
			while(f.match(h))
				h = f.replace(h, "");
		for(c in HTML_CLEANERS)
			h = c.from.replace(h, c.to);
		if(h.startsWith("<br>") || h.startsWith("<br />"))
			h = h.substr(h.indexOf(">")+1);
		if(h.endsWith("<br>"))
			h = h.substr(0, h.length-4);
		return h;
	}
}