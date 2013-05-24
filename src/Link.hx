
import data.*;
import parser.*;
import js.*;
import js.html.*;
import js.Browser.*;
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
			regex: ~/.*\.(jpeg|gif|jpg|bmp|png|webp)/i,
			method: function(e, cb) {
				cb([{
					url: 'http://${e.matched(0)}',
					caption: null,
					author: null
				}]);
			}
		},
		{
			regex: ~/i?\.?imgur.com\/(a|gallery)\/([^\/]*)(\/.*)?/,
			method: function(e, cb) {
				var id = e.matched(2);
				var albumType = switch(e.matched(1).toLowerCase()) {
					case "a": "album";
					case "gallery": "gallery/album";
					default: "album";
				};
				Reditn.getJSON('https://api.imgur.com/3/${albumType}/${id}', function(d:data.imgur.Album) {
					var album = [];
					if(d.images_count <= 0)
						album.push({
							url: 'http://i.imgur.com/${d.id}.jpg',
							caption: d.title,
							author: d.account_url
						});
					else
						for(i in d.images)
							album.push({
								url: 'http://i.imgur.com/${i.id}.jpg',
								caption: i.title,
								author: d.account_url
							});
					cb(album);
				}, 'Client-ID ${IMGUR_KEY}');
			}
		},
		{
			regex: ~/imgur\.com\/(r\/[^\/]*\/)?([a-zA-Z0-9,]*)/,
			method: function(e, cb) {
				var id = e.matched(1) == null || e.matched(1).indexOf("/") != -1 ? e.matched(2) : e.matched(1);
				var ids = id.split(",");
				cb([for(id in ids) {
					url: 'http://i.imgur.com/${id}.jpg',
					caption: null,
					author: null
				}]);
			}
		},
		{
			regex: ~/(qkme\.me\/3piqes\?id=|qkme\.me\/|quickmeme\.com\/meme\/|m\.quickmeme.com\/meme\/)([^\/]*)/,
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
				Reditn.getJSON('http://www.xkcd.com/${e.matched(1)}/info.0.json', function(d:Dynamic) {
					cb([{
						url: d.img, 
						caption: d.title,
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
				Reditn.getJSON('http://public-api.wordpress.com/oembed/?url=${url.urlEncode()}&for=Reditn', function(d:data.OEmbed) {
					var imgs:Album = [];
					if(d.thumbnail_url != null)
						imgs.push({caption: null, url: d.thumbnail_url, author: null});
					cb({
						author: d.author_name,
						content: filterHTML(d.html),
						images: imgs
					});
				});
			}
		},
		{
			regex: ~/(.*)\/wiki\/([^#]*)(#.*)?/,
			method: function(e, cb) {
				var aroot = 'http://${e.matched(1)}', title = e.matched(2), to = e.matched(3);
				if(to != null)
					to = StringTools.trim(to.substr(1));
				if(to != null && to.length == 0)
					to = null;
				var urlroot = aroot;
				if(!urlroot.endsWith(".wikia.com"))
					urlroot += "/w";
				function getWikiPage(name:String) {
					Reditn.getJSON('${urlroot}/api.php?format=json&prop=revisions&action=query&titles=${name}&rvprop=content', function(d) {
						var pages:Dynamic = d.query.pages;
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
							cont = parser.MediaWiki.parse(cont, aroot);
							if(images.length > 0) {
								var nimages = [];
								for(i in images)
									Reditn.getJSON('${urlroot}/api.php?action=query&titles=${StringTools.urlEncode(i.url)}&prop=imageinfo&iiprop=url&format=json', function(d) {
										var pages:Dynamic = d.query.pages;
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
				Reditn.getJSON('https://api.github.com/repos/${author}/${repo}/readme?client_id=${GITHUB_KEY}&client_secret=${GITHUB_KEYS}', function(d) {
					if(d.content == null)
						return;
					var c:String = d.content;
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
						developers: [for(d in devs) data.name],
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
			regex: ~/([^\.]*)\.tumblr\.com\/(post|image)\/([0-9]*)(\/.*)?/,
			method: function(e, cb) {
				var author = e.matched(1), id = e.matched(3);
				Reditn.getJSON('http://api.tumblr.com/v2/blog/${author}.tumblr.com/posts/json?api_key=${TUMBLR_KEY}&id=${id}', function(d) {
					var post:Dynamic = untyped d.posts[0];
					cb(switch(post.type) {
						case "text":
						var images = [];
						while(HTML_IMG.match(post.body)) {
							images.push({
								url: HTML_IMG.matched(1),
								caption: null,
								author: d.blog.name
							});
							post.body = HTML_IMG.replace(post.body, "");
						}
						post.body = filterHTML(post.body);
						{title: post.title, content: post.body, author: d.blog.name, images: images};
						case "quote": {title: null, content: post.text+"<br/><b>"+post.source+"</b>", author: d.blog.name, images: []};
						case "photo":
							var ps:Array<Dynamic> = post.photos;
							[for(p in ps) {
								{
									url: p.original_size.url,
									caption: p.caption,
									author: d.blog.name
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
				Reditn.getJSON('http://api.tumblr.com/v2/blog/${e.matched(0).urlEncode()}/info?api_key=${TUMBLR_KEY}', function(d) {
					cb({
						urls: new Map<String, String>(),
						name: d.blog.title,
						description: filterHTML(d.blog.description),
						album: []
					});
				});
			}
		},
		{
			regex: ~/twitter.com\/.*\/status\/([0-9]*)/,
			method: function(e, cb) {
				Reditn.getJSON('https://api.twitter.com/1/statuses/oembed.json?id=${e.matched(1)}', function(d:OEmbed) {
					cb({
						title: null,
						author: d.author_name,
						content: filterHTML(d.html),
						images: []
					});
				});
			}
		},
		{
			regex: ~/amazon\.[a-z\.]*\/gp\/product\/([0-9A-Z]*)/,
			method: function(e, cb) {
				var id = e.matched(1);
				Reditn.getXML('http://webservices.amazon.com/onca/xml?AWSAccessKeyId=${AMAZON_KEY}&Service=AWSECommerceService&Operation=ItemLookup&ItemId=${id}', function(d) {
					trace(d); // does it even lift?
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
					Reditn.getJSON('https://www.googleapis.com/plus/v1/people/${pid}/activities/public?fields=items(id%2Curl)%2CnextPageToken&key=${GOOGLE_API_KEY}${tk}', function(d) {
						var items:Array<Dynamic> = d.items, url = e.matched(0);
						for(i in items)
							if(i.url.indexOf(id) != -1) {
								Reditn.getJSON('https://www.googleapis.com/plus/v1/activities/${i.id}?fields=actor%2FdisplayName%2Cannotation%2Cobject(actor%2Cattachments%2Ccontent%2Cid%2CobjectType%2CoriginalContent%2Curl)&key=${GOOGLE_API_KEY}', function(d) {
									var type:String = d.object.objectType, name:String = d.actor.actorName, cont:String = d.object.content;
									title.match(cont);
									switch(type) {
										case "note":
											var titl = title.matched(1);
											cont = title.replace(cont, "");
											cont = filterHTML(cont);
											cb({title: titl, author: name, content: cont, images: []});
										default:
											var att:Array<Dynamic> = d.object.attachments;
											cb([for(a in att) 
												{url: a.image.url, caption: a.content.length == 0 ? d.object.content : a.content, author: null}]);
									}
								});
								return;
							}
						if(d.items.length != 0)
							nextPage(d.requestToken);
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
				Reditn.getJSON('https://graph.facebook.com/${id}?access_token=${FACEBOOK_KEY}', function(d) {
					trace(d);
					cb([{
						caption: d.name,
						url: d.source,http://graph.facebook.com/{ID of object}/picture?type=large
						author: d.from.name
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
				Reditn.getJSON('https://www.googleapis.com/plus/v1/people/${id}?key=${GOOGLE_API_KEY}', function(d) {
					var urls:Array<Dynamic> = d.urls;
					var aurls = new Map<String, String>();
					if(urls != null)
						for(u in urls)
							aurls.set(u.label, u.value);
					if(d.urls != null && d.displayName != null && d.aboutMe != null)
						cb({
							urls: aurls,
							name: d.displayName,
							description: d.aboutMe,
							album: [{url: d.image.url, caption: null, author: d.displayName}]
						});
				});
			}
		},
		{
			regex: ~/reddit\.com\/r\/([a-zA-Z0-9]*)/,
			method: function(e, cb) {
				Reditn.getJSON('http://www.${e.matched(0)}/about.json', function(s:data.Subreddit) cb(s));
			}
		},
		{
			regex: ~/gamejolt.com\/games\/[^\/]*\/[^\/]*\/([0-9]*)/,
			method: function(e, cb) {
				var id = e.matched(1);
				Reditn.getJSON('http://gamejolt.com/service/games/${id}?format=json', function(d) {
					trace(d);
				});
			}
		},
		{
			regex: ~/(0rz\.tw|1link\.in|1url\.com|2\.gp|2big\.at|2tu\.us|3\.ly|307\.to|4ms\.me|4sq\.com|4url\.cc|6url\.com|7\.ly|a\.gg|a\.nf|aa\.cx|abcurl\.net|ad\.vu|adf\.ly|adjix\.com|afx\.cc|all\.fuseurl\.com|alturl\.com|amzn\.to|ar\.gy|arst\.ch|atu\.ca|azc\.cc|b23\.ru|b2l\.me|bacn\.me|bcool\.bz|binged\.it|bit\.ly|bizj\.us|bloat\.me|bravo\.ly|bsa\.ly|budurl\.com|canurl\.com|chilp\.it|chzb\.gr|cl\.lk|cl\.ly|clck\.ru|cli\.gs|cliccami\.info|clickthru\.ca|clop\.in|conta\.cc|cort\.as|cot\.ag|crks\.me|ctvr\.us|cutt\.us|dai\.ly|decenturl\.com|dfl8\.me|digbig\.com|digg\.com|disq\.us|dld\.bz|dlvr\.it|do\.my|doiop\.com|dopen\.us|easyuri\.com|easyurl\.net|eepurl\.com|eweri\.com|fa\.by|fav\.me|fb\.me|fbshare\.me|ff\.im|fff\.to|fire\.to|firsturl\.de|firsturl\.net|flic\.kr|flq\.us|fly2\.ws|fon\.gs|freak\.to|fuseurl\.com|fuzzy\.to|fwd4\.me|fwib\.net|g\.ro\.lt|gizmo\.do|gl\.am|go\.9nl\.com|go\.ign\.com|go\.usa\.gov|goo\.gl|goshrink\.com|gurl\.es|hex\.io|hiderefer\.com|hmm\.ph|href\.in|hsblinks\.com|htxt\.it|huff\.to|hulu\.com|hurl\.me|hurl\.ws|icanhaz\.com|idek\.net|ilix\.in|is\.gd|its\.my|ix\.lt|j\.mp|jijr\.com|kl\.am|klck\.me|korta\.nu|krunchd\.com|l9k\.net|lat\.ms|liip\.to|liltext\.com|linkbee\.com|linkbun\.ch|liurl\.cn|ln-s\.net|ln-s\.ru|lnk\.gd|lnk\.ms|lnkd\.in|lnkurl\.com|lru\.jp|lt\.tl|lurl\.no|macte\.ch|mash\.to|merky\.de|migre\.me|miniurl\.com|minurl\.fr|mke\.me|moby\.to|moourl\.com|mrte\.ch|myloc\.me|myurl\.in|n\.pr|nbc\.co|nblo\.gs|nn\.nf|not\.my|notlong\.com|nsfw\.in|nutshellurl\.com|nxy\.in|nyti\.ms|o-x\.fr|oc1\.us|om\.ly|omf\.gd|omoikane\.net|on\.cnn\.com|on\.mktw\.net|onforb\.es|orz\.se|ow\.ly|ping\.fm|pli\.gs|pnt\.me|politi\.co|post\.ly|pp\.gg|profile\.to|ptiturl\.com|pub\.vitrue\.com|qlnk\.net|qte\.me|qu\.tc|qy\.fi|r\.im|rb6\.me|read\.bi|readthis\.ca|reallytinyurl\.com|redir\.ec|redirects\.ca|redirx\.com|retwt\.me|ri\.ms|rickroll\.it|riz\.gd|rt\.nu|ru\.ly|rubyurl\.com|rurl\.org|rww\.tw|s4c\.in|s7y\.us|safe\.mn|sameurl\.com|sdut\.us|shar\.es|shink\.de|shorl\.com|short\.ie|short\.to|shortlinks\.co\.uk|shorturl\.com|shout\.to|show\.my|shrinkify\.com|shrinkr\.com|shrt\.fr|shrt\.st|shrten\.com|shrunkin\.com|simurl\.com|slate\.me|smallr\.com|smsh\.me|smurl\.name|sn\.im|snipr\.com|snipurl\.com|snurl\.com|sp2\.ro|spedr\.com|srnk\.net|srs\.li|starturl\.com|su\.pr|surl\.co\.uk|surl\.hu|t\.cn|t\.co|t\.lh\.com|ta\.gd|tbd\.ly|tcrn\.ch|tgr\.me|tgr\.ph|tighturl\.com|tiniuri\.com|tiny\.cc|tiny\.ly|tiny\.pl|tinylink\.in|tinyuri\.ca|tinyurl\.com|tk\.|tl\.gd|tmi\.me|tnij\.org|tnw\.to|tny\.com|to\.|to\.ly|togoto\.us|totc\.us|toysr\.us|tpm\.ly|tr\.im|tra\.kz|trunc\.it|twhub\.com|twirl\.at|twitclicks\.com|twitterurl\.net|twitterurl\.org|twiturl\.de|twurl\.cc|twurl\.nl|u\.mavrev\.com|u\.nu|u76\.org|ub0\.cc|ulu\.lu|updating\.me|ur1\.ca|url\.az|url\.co\.uk|url\.ie|url360\.me|url4\.eu|urlborg\.com|urlbrief\.com|urlcover\.com|urlcut\.com|urlenco\.de|urli\.nl|urls\.im|urlshorteningservicefortwitter\.com|urlx\.ie|urlzen\.com|usat\.ly|use\.my|vb\.ly|vgn\.am|vl\.am|vm\.lc|w55\.de|wapo\.st|wapurl\.co\.uk|wipi\.es|wp\.me|x\.vu|xr\.com|xrl\.in|xrl\.us|xurl\.es|xurl\.jp|y\.ahoo\.it|yatuc\.com|ye\.pe|yep\.it|yfrog\.com|yhoo\.it|yiyd\.com|youtu\.be|yuarel\.com|z0p\.de|zi\.ma|zi\.mu|zipmyurl\.com|zud\.me|zurl\.ws|zz\.gd|zzang\.kr|r\.ebay\.com)\/.*/,
			method: function(e, cb) {
				var surl = StringTools.urlEncode('http://${e.matched(0)}');
				Reditn.getJSON('http://api.longurl.org/v2/expand?url=${surl}&format=json&User-Agent=Reditn', function(data) {
					var url:String = Reflect.field(data, "long-url");
					var r = resolve(url);
					if(r != null)
						r.method(r.regex, cb);
				});
			}
		},
		{
			regex: ~/(youtube\.com\/watch|youtu\.be\/).*/,
			method: function(e, cb) {
				var url = "http://www." + e.matched(0);
				Reditn.getJSON('http://www.youtube.com/oembed?url=${url.urlEncode()}', function(data:data.OEmbed) {
					cb({
						title: data.title,
						html: data.html,
						author: data.author_name
					});
				});
			}
		},
		{
			regex: ~/vine\.co\/v\/(.*)/,
			method: function(e, cb) {
				var id = e.matched(1);
				cb({
					title: null,
					author: null,
					html: '<iframe class="vine-embed" src="https://vine.co/v/${id}/embed/simple" width="610" height="348" frameborder="0"></iframe><script async src="//platform.vine.co/static/scripts/embed.js" charset="utf-8"></script>'
				});
			}
		},
		{
			regex: ~/vimeo\.com\/([0-9]*)/,
			method: function(e, cb) {
				var id = e.matched(1);
				Reditn.getJSON('http://vimeo.com/api/oembed.json?url=http%3A//vimeo.com/${id}&maxwidth=500',function(data:Dynamic) {
					cb({
						title: null,
						author: null,
						html: data.html
					});
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
		if(url.indexOf("?") != -1 && !url.startsWith("facebook.com/") && url.indexOf("youtube") == -1)
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
	public static function createButton(url:String, cont:Element, ?expalign:Element, ?btnalign:Element):DivElement {
		var site = Link.resolve(url);
		var btn = null;
		if(site != null) {
			for(e in cont.getElementsByClassName("expando"))
				e.parentNode.removeChild(e);
			var b = document.createDivElement();
			var cn = "expando-button reditn-expando-button ";
			var isToggled = Expand.toggled;
			var cl = isToggled ? "expanded" : "collapsed";
			var exp = null;
			b.className = '$cn $cl';
			btn = {
				toggled: function():Bool {
					return isToggled;
				},
				toggle: function(v, ps) {
					isToggled = v;
					b.className = cn + (cl = isToggled ? "expanded" : "collapsed");
					if(exp != null)
						Reditn.show(exp, v);
					if(ps)
						Reditn.pushState();
				},
				url: url,
				element: b
			};
			b.onclick = function(_) {
				btn.toggle(!isToggled, true);
			}
			site.method(site.regex, function(d:Dynamic) {
				var name = "selftext";
				var content = if(Reflect.hasField(d, "urls")) { // profile
					var p:data.Profile = d;
					var urls = [for(uk in p.urls.keys()) '<li><a href="${p.urls.get(uk)}">${uk}</a></li>'];
					var div = Browser.document.createDivElement();
					div.className = "usertext";
					var content = Browser.document.createDivElement();
					content.appendChild(Reditn.embedMap([
						"Name" => d.name,
						"Description" => d.description,
						"Links" => urls.join("")
					]));
					if(p.album.length > 0) {
						content.appendChild(Browser.document.createBRElement());
						content.appendChild(Reditn.embedAlbum(p.album));
					}
					div.appendChild(content);
					div;
				} else if(Reflect.hasField(d, "price")) { // shop item
					var i:ShopItem = d;
					trace(i);
					var div = Browser.document.createDivElement();
					div.className = "usertext";
					var cont = Browser.document.createDivElement();
					cont.appendChild(Reditn.embedMap([
						"Category" => i.category.htmlEscape(),
						"Location" => i.location.htmlEscape(),
						"Price" => i.price.htmlEscape(),
						"Description" => i.description
					]));
					cont.appendChild(Reditn.embedAlbum(i.images));
					div.appendChild(cont);
					name = "item";
					div;
				} else if(Reflect.hasField(d, "subscribers")) { // subreddit
					var s:data.Subreddit = d;
					var div = Browser.document.createDivElement();
					div.className = "usertext";
					div.appendChild(Reditn.embedMap([
						"Age" => Reditn.age(s.created_utc),
						"Subscribers" => Reditn.formatNumber(s.subscribers),
						"Active users" => Reditn.formatNumber(s.accounts_active),
						"Description" => parser.Markdown.parse(s.description)
					]));
					div;
				} else if(Reflect.hasField(d, "html")) { // video
					var v:Video = d;
					var div = Browser.document.createDivElement();
					div.innerHTML = v.html;
					name = "video";
					div;
				} else if(Reflect.hasField(d, "content")) { // article
					var a:Article = d;
					var div = Browser.document.createDivElement();
					div.className = "usertext";
					var art = Browser.document.createDivElement();
					var inner = Browser.document.createSpanElement();
					inner.innerHTML = a.content;
					art.appendChild(inner);
					if(a.images != null && a.images.length > 0) {
						art.appendChild(Browser.document.createBRElement());
						art.appendChild(Reditn.embedAlbum(a.images));
					}
					art.className = "md";
					div.appendChild(art);
					div;
				} else if(Std.is(d, Array) && Reflect.hasField(untyped d[0], "url")) {
					var a:Album = d;
					var div = Reditn.embedAlbum(a);
					name = "image";
					div;
				} else if(Reflect.hasField(d, "developers")) {
					trace(url);
					var r:Repo = d;
					var div = js.Browser.document.createDivElement();
					div.className = "usertext";
					var cont = Browser.document.createDivElement();
					var inner = Browser.document.createSpanElement();
					inner.innerHTML = '${d.description}<br><a href="${d.url}"><b>Clone repo</b></a><br>';
					if(r.album != null && r.album.length > 0)
						inner.appendChild(Reditn.embedAlbum(r.album));
					cont.appendChild(inner);
					cont.className = "md";
					div.appendChild(cont);
					div;
				} else {
					trace('Unknown value: $d');
					null;
				}
				if(content != null) {
					exp = document.createDivElement();
					exp.className = "expando";
					exp.appendChild(content);
					cn += '$name ';
					b.className = '$cn $cl';
					Expand.buttons.push(btn);
					Reditn.show(exp, isToggled);
					if(expalign == null) 
						cont.appendChild(exp);
					else
						cont.insertBefore(exp, expalign);
					if(btnalign == null)
						cont.insertBefore(b, exp);
					else
						cont.insertBefore(b, btnalign);
				}
			});
		}
		return btn != null ? btn.element : null;
	}
}