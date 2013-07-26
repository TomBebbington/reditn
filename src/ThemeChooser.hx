#if macro
import sys.io.File;
import sys.FileSystem;
#else
import ext.Browser.*;
#end
class ThemeChooser {
	static inline var RSS_URL = "http://userstyles.org/styles/browse/reddit.rss";
	static inline var RSS_LOC = "reddit_themes.rss";
	static var data:Xml;
	public static var themes:Array<Theme> = getRssInfo();
	static macro function getRssInfo():haxe.macro.Expr.ExprOf<Array<Theme>> {
		function getPageItems(p:Int):Array<Xml> {
			var url = '${RSS_URL}?page=$p';
			var data:Xml = Xml.parse(haxe.Http.requestUrl(url)).firstElement();
			var channel:Xml = data.elementsNamed("channel").next();
			var items = [for(i in channel.elementsNamed("item")) i];
			return items;
		}
		function itemName(i:Xml):String {
			return i.elementsNamed("title").next().firstChild().nodeValue;
		}
		if(!FileSystem.exists(RSS_LOC)) {
			var allItems:Array<Xml> = [];
			var page:Int = 1;
			while(true) {
				var items = getPageItems(page++);
				if(allItems.length != 0 && (items.length == 0 || items[0].toString() == allItems[0].toString()))
					break;
				allItems = allItems.concat(items);
			}
			var xml:Xml = Xml.createDocument();
			var rss = Xml.createElement("rss");
			xml.addChild(rss);
			var chan = Xml.createElement("channel");
			rss.addChild(chan);
			for(i in allItems)
				chan.addChild(i);
			File.saveContent(RSS_LOC, xml.toString());
		}
		var data:Xml = Xml.parse(File.getContent(RSS_LOC)).firstElement();
		data = data.elementsNamed("channel").next();
		var themes:Array<Theme> = [for(item in data.elementsNamed("item")) {
			var item:Xml = item;
			var vals:Map<String, String> = new Map();
			for(i in item)
				try vals.set(i.nodeName, i.firstChild().nodeValue) catch(e:Dynamic) {};
			{name: vals["title"], url: vals["link"]+".css", author: vals["author"]};
		}];
		return haxe.macro.Context.makeExpr(themes, haxe.macro.Context.currentPos());
	}
	#if !macro
	public static function update():Void {
		var theme:String = Settings.data["theme-chooser"];
		var prev = document.getElementById("reditn-theme");
		if(prev != null && prev.parentElement != null)
			prev.parentElement.removeChild(prev);
		if(theme != "default") {
			var t:Theme = [for(t in themes) if(t.name == theme) t][0];
			trace(t);
			var link = document.createLinkElement();
			link.type = "text/css";
			link.rel = "stylesheet";
			link.href = t.url;
			link.id = "reditn-theme";
			document.head.appendChild(link);
		}
	}
	public static function init() {
		Settings.settings["theme-chooser"].options = ["default"].concat([for(t in themes) t.name]);
		update();
	}
	#end
}
typedef Theme = {
	var name:String;
	@:optional var desc:String;
	@:optional var screen:String;
	var author:String;
	var url:String;
}