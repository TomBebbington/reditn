import data.*;
using StringTools;
class Link {
	public static inline var FLICKR_KEY = "99dcc3e77bcd8fb489f17e58191f32f7";
	public static inline var TUMBLR_KEY = "k6pU8NIG57YiPAtXFD5s9DGegNPBZIpMahvbK4d794JreYIyYE";
	public static inline var IMGUR_CLIENT_ID = "cc1f254578d6c52";
	public static inline var GOOGLE_API_KEY = "95f055321ea256d1d8828674c62105ea3931ae08";
	public static inline var EBAY_API_KEY = "ThomasDa-1e6c-4d29-a156-85557acee70b";
	static var sites:Array<Site> = [
		{
			type: LinkType.IMAGE,
			regex: ~/.*\.(jpeg|gif|jpg|bmp|png)/,
			method: function(e, cb) {
				cb([{
					url: 'http://${e.matched(0)}',
					caption: null
				}]);
			}
		},
		{
			type: LinkType.IMAGE,
			regex: ~/imgur\.com\/([a-zA-Z0-9]*)/,
			method: function(e, cb) {
				cb([{
					url: 'http://i.imgur.com/${e.matched(1)}.jpg',
					caption: null
				}]);
			}
		},
		{
			type: data.LinkType.IMAGE,
			regex: ~/imgur.com\/(a|gallery|gallery\/album)\/([^\/]*)/,
			method: function(e, cb) {
				var id = e.matched(2);
				var albumType = e.matched(1);
				var req = new haxe.Http('https://api.imgur.com/3/${albumType}/${id}');
				req.setHeader("Authorization", 'Client-ID ${IMGUR_CLIENT_ID}');
				req.onData = function(ds:String) {
					var d:data.imgur.Album = cast Reditn.getData(haxe.Json.parse(ds));
					var album = [];
					if(d.images_count <= 0)
						album.push({
							url: 'http://i.imgur.com/${d.id}.jpg',
							caption: d.title
						});
					else
						for(i in d.images)
							album.push({
								url: 'http://i.imgur.com/${i.id}.jpg',
								caption: i.title
							});
					cb(album);
				};
				req.request(false);
			}
		},
		{
			type: LinkType.IMAGE,
			regex: ~/(qkme\.me|quickmeme\.com\/meme|m\.quickmeme.com\/meme)\/([^\/]*)/,
			method: function(e, cb) {
				cb([{
					url: 'http://i.qkme.me/${e.matched(2)}.jpg',
					caption: null
				}]);
			}
		},
		{
			type: LinkType.IMAGE,
			regex: ~/memecrunch.com\/meme\/([^\/]*)\/([^\/]*)/,
			method: function(e, cb) {
				cb([{
					url: 'http://${e.matched(0)}/image.png',
					caption: null
				}]);
			}
		},
		{
			type: LinkType.IMAGE,
			regex: ~/memegenerator\.net\/instance\/([^\/]*)/,
			method: function(e, cb) {
				cb([{
					url: 'http://cdn.memegenerator.net/instances/400x/${e.matched(1)}.jpg',
					caption: null
				}]);
			}
		},
		{
			type: LinkType.IMAGE,
			regex: ~/imgflip\.com\/i\/([^\/]*)/,
			method: function(e, cb) {
				cb([{
					url: 'http://i.imgflip.com/${e.matched(1)}.jpg',
					caption: null
				}]);
			}
		},
		{
			type: LinkType.IMAGE,
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
			type: LinkType.IMAGE,
			regex: ~/explosm.net\/comics\/([^\/]*)/,
			method: function(e, cb) {
				Reditn.getText('http://${e.matched(0)}', function(txt) {
					var rg = ~/http:\/\/www\.explosm\.net\/db\/files\/Comics\/[^"]*/;
					rg.match(txt);
					cb([{
						url: rg.matched(0),
						caption: null
					}]);
				});
			}
		},
		{
			type: LinkType.IMAGE,
			regex: ~/livememe.com\/([^\/]*)/,
			method: function(e, cb) {
				cb([{
					url: 'http://livememe.com/${e.matched(1)}.jpg',
					caption: null
				}]);
			}
		},
		{
			type: LinkType.IMAGE,
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
			type: LinkType.IMAGE,
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
			type: LinkType.SHOP_ITEM,
			regex: ~/ebay\.([a-zA-Z\.]*)\/itm(\/[^\/]*)?\/([0-9]*)/,
			method: function(e, cb) {
				var domain = e.matched(1);
				var id:String = e.matched(3);
				var url = 'http://open.api.ebay.com/shopping?callname=GetSingleItem&responseencoding=JSON&appid=${EBAY_API_KEY}&siteid=0&version=515&ItemID=${id}&IncludeSelector=TextDescription';
				Reditn.getJSON(url, function(data) {
					var imgs:Array<String> = data.Item.PictureURL;
					var nalbum = imgs.map(function(i) return { url: i, caption: null });
					cb({title: data.Item.Title, category: data.Item.PrimaryCategoryName, location: data.Item.Location + ", " + data.Item.Country, description: data.Item.Description, images: nalbum, price: Reditn.formatNumber(data.Item.ConvertedCurrentPrice.Value) + " " + data.Item.ConvertedCurrentPrice.CurrencyID});
				});
			}
		},
		{
			type: LinkType.ARTICLE,
			regex: ~/([^\.]*\.wordpress\.com)\/[0-9\/]*([^\/]*)\/?/,
			method: function(e, cb) {
				var url = 'http://public-api.wordpress.com/rest/v1/sites/${e.matched(1).htmlEscape()}/posts/slug:${e.matched(2).htmlEscape()}';
				Reditn.getJSON(url, function(data) {
					var att = data.attachments;
					cb({title: StringTools.htmlUnescape(data.title), content: data.content, author: data.author.name, images: [
						for(f in Reflect.fields(att)) {
							var img = Reflect.field(att, f);
							if(img.mime_type.startsWith("image/"))
								cb([{url: img.URL, caption: null}]);
						}
					]});
				});
			}
		},
		{
			type: LinkType.ARTICLE,
			regex: ~/(.*)\/wiki\/(.*)/,
			method: function(e, cb) {
				var urlroot = e.matched(1), title = e.matched(2);
				if(urlroot.indexOf(".wikia.com/") != -1)
					urlroot += "/w";
				function getWikiPage(name:String) {
					Reditn.getJSON('http://${urlroot}/api.php?format=json&prop=revisions&action=query&titles=${name}&rvprop=content', function(data) {
						trace(data);
						var pages:Dynamic = data.query.pages;
						for(p in Reflect.fields(pages)) {
							var page = Reflect.field(pages, p);
							var cont:String = Reflect.field(untyped page.revisions[0], "*");
							if(cont.startsWith("#REDIRECT [[")) {
								getWikiPage(cont.substring(12, cont.lastIndexOf("]]")));
								return;
							}
							cont = parser.MediaWiki.parse(cont, urlroot);
							Reditn.getJSON('http://${urlroot}/api.php?format=json&action=query&prop=images&titles=${StringTools.htmlEscape(name)}', function(data) {
								var pages = data.query.pages;
								for(p in Reflect.fields(pages)) {
									var page = Reflect.field(pages, p);
									var images:Array<Dynamic> = page.images;
									var album:Album = [];
									var left:Int = images.length;
									if(images != null)
										for(img in images) {
											Reditn.getJSON('http://${urlroot}/api.php?action=query&titles=${StringTools.urlEncode(img.title)}&prop=imageinfo&iiprop=url&format=json', function(data) {
												var pages:Dynamic = data.query.pages;
												for(p in Reflect.fields(pages)) {
													var page = Reflect.field(pages, p);
													if(page != null && page.imageinfo.length >= 1) {
														var url = untyped page.imageinfo[0].url;
														album.push({url: url, caption: null});
													}
												}
												if(--left <= 0)
													cb({title: page.title, content: cont, author: null, images: album});
											});
										}
								}
							});
						}
					});
				}
				getWikiPage(title);
			}
		},
		{
			type: LinkType.UNKNOWN,
			regex: ~/([^\.]*)\.tumblr\.com\/post\/([0-9]*)/,
			method: function(e, cb) {
				var author = e.matched(1), id = e.matched(2);
				Reditn.getJSON('http://api.tumblr.com/v2/blog/${author}.tumblr.com/posts/json?api_key=${TUMBLR_KEY}&id=${id}', function(data) {
					var post:Dynamic = untyped data.posts[0];
					cb(switch(post.type) {
						case "text": 
						var imx = ~/<img .*?src="([^"]*)"\/?>/;
						var images = [];
						while(imx.match(post.body)) {
							images.push({
								url: imx.matched(1),
								caption: null
							});
							post.body = imx.replace(post.body, "");
						}
						{title: post.title, content: post.body, author: data.blog.name, images: images};
						case "quote": {title: null, content: '${post.text}<br/><b>${post.source}</b>', author: data.blog.name, images: []};
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
			if(s.regex.match(url))
				return s;
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
		if(url.indexOf("#") != -1)
			url = url.substr(0, url.indexOf("#"));
		return url;
	}
}