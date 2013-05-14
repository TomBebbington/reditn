package parser;
import js.*;
import js.html.*;
import data.*;
using StringTools;
class MediaWiki {
	static var regex:Array<Entry> = [
		{ from: ~/\[\[([^\]\|]*)\]\]/, to: "<a href=\"$BASE/wiki/$1\">$1</a>" },
		{ from: ~/\[\[([^\]\|]*)\|([^\]\|]*)\]\]/, to: "<a href=\"$BASE/wiki/$1\">$2</a>" },
		{ from: ~/\[\[File:([^\]]*)\]\]/, to: "" },
		{ from: ~/{{spaced ndash}}/, to: " - " },
		{ from: ~/\{\{convert\|([0-9]*)\|([^\|]*)([^\}]*)\}\}/, to: "$1 $2" },
		{ from: ~/\{\{Infobox(([^\}]|\n|\n\r|.)*)\}\}/, to: "" },
		{ from: ~/\{\{([^\}]*)\}\}/, to: "" },
		{ from: ~/<gallery>(.|\n|\n\r)*<\/gallery>/, to: ""},
		{ from: ~/\{\|(.|\n|\n\r)*\|\}/, to: ""},
		{ from: ~/\[([^ \[\]]*) ([^\[\]]*)\]/, to: "" },
		{ from: ~/'''([^']*)'''/, to: "<b>$1</b>" },
		{ from: ~/''([^']*)''/, to: "<em>$1</em>" },
		{ from: ~/======([^=]*)======/, to: "<h6>$1</h6>" },
		{ from: ~/=====([^=]*)=====/, to: "<h5>$1</h5>" },
		{ from: ~/====([^=]*)====/, to: "<h4>$1</h4>" },
		{ from: ~/===([^=]*)===/, to: "<h3>$1</h3>" },
		{ from: ~/==([^=]*)==/, to: "<h2>$1</h2>" },
		{ from: ~/\n\* ?([^\n]*)/, to: "<li>$1</li>" },
		{ from: ~/<ref>[^<>]*<\/ref>/, to: "" },
		{ from: ~/\n/, to: "" },
		{ from: ~/<br><br>/, to: "<br>" },
		{ from: ~/<!--Interwiki links-->.*/, to: "" }
	];
	static var sections:EReg = ~/<h([1-6])>([^<>]*)<\/h[1-6]>/;
	public static function parse(s:String, base:String):String {
		for(r in regex)
			while(r.from.match(s)) {
				trace(r.from);
				try s = r.from.replace(s, r.to) catch(e:Dynamic) trace('Error $e while replacing ${r.from} with ${r.to}');
			}
		return s;
	}
	public static function trimTo(h:String, s:String) {
		s = s.replace("_", " ").trim();
		var pos = {pos:0, len:0}, level = null;
		while(sections.matchSub(h, pos.pos + pos.len)) {
			pos = sections.matchedPos();
			if(sections.matched(2).trim() == s) {
				level = sections.matched(1);
				break;
			}
		}
		if(level != null) {
			h = h.substr(pos.pos + pos.len);
			h = h.substr(0, h.indexOf('<h${level}>'));
		}
		return h;
	}
}