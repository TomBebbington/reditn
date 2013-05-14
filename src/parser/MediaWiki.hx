package parser;
import js.*;
import js.html.*;
import data.*;
using StringTools;
class MediaWiki {
	static var regex:Array<Entry> = [
		{ from: ~/\[\[Category:([^\]]*)\]\]/, to: ""},
		{ from: ~/\[\[([^\]\|\n]*)\]\]/, to: "<a href=\"$BASE/wiki/$1\">$1</a>"},
		{ from: ~/\[\[([^\]\n]*)\|([^\]\|\n]*)\]\]/, to: "<a href=\"$BASE/wiki/$1\">$2</a>"},
		{ from: ~/<gallery>(.|\n|\n\r)*<\/gallery>/, to: ""},
		{ from: ~/\[\[File:([^\]]*)\]\]/, to: "" },
		{ from: ~/(=*) ?(References|Gallery) ?\1.*\1?/, to: ""},
		{ from: ~/{{spaced ndash}}/, to: " - " },
		{ from: ~/\{\{convert\|([0-9]*)\|([^\|]*)([^\}]*)\}\}/, to: "$1 $2" },
		{ from: ~/\{\{([^\}]*)\}\}/, to: "" },
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
		{ from: ~/\n\r?\n\r?/, to: "<br>"},
		{ from: ~/\n/, to: "" },
		{ from: ~/<br><br>/, to: "<br>" },
		{ from: ~/<!--Interwiki links-->.*/, to: "" },
		{ from: ~/\[\]/, to: ""}
	];
	static var sections = ~/'=(=*)([^=]*)=\\1\n\r?(.|\n|\n\r)*(\\1)?'/;
	public static var IMAGES = ~/(File:|img=|Image:)([^\.\|\]\}\{\[<>=]*)\.(gif|jpg|jpeg|bmp|png|webp|svg|raw)(\|([^\)]*))?/;
	static inline var MAX_LOOPS = 64;
	public static function parse(s:String, base:String):String {
		for(r in regex) {
			var i = 0;
			while(r.from.match(s) && i++ < MAX_LOOPS) {
				s = r.from.replace(s, r.to);
				var p = r.from.matchedPos();
			}
		}
		s = s.replace("$BASE", 'http://${base}');
		if(s.startsWith("<br>"))
			s = s.substr(4);
		if(s.split("{{").length < s.split("}}").length)
			s = s.substr(s.indexOf("}}") + 2);
		return s;
	}
	public static function trimTo(h:String, s:String) {
		trace("Trimming...");
		s = s.replace("_", " ").trim();
		var pos = {pos:0, len:0}, level = null;
		while(sections.matchSub(h, pos.pos + pos.len)) {
			pos = sections.matchedPos();
			if(sections.matched(2).trim() == s.trim()) {
				level = sections.matched(1).length;
				break;
			}
			trace('Pos: $pos level: $level name: ${sections.matched(1)}');
		}
			trace('MATCHED IN SECCCTIYSHION: ${sections.matched(1)}');
		if(level != null) {
			h = h.substr(pos.pos + pos.len);
			h = h.substr(0, h.indexOf('<h${level}>'));
		}
		return h;
	}
	public static function getAlbum(s:String):data.Album {
		var a = [];
		while(IMAGES.match(s)) {
			var p = IMAGES.matchedPos();
			s = s.substr(p.pos + p.len);
			var name = IMAGES.matched(2) + "." + IMAGES.matched(3);
			if(!name.startsWith("File:"))
				name = 'File:${name}';
			a.push({
				url: name,
				caption: null
			});
		}
		trace('Images: $a');
		return a;
	}
}