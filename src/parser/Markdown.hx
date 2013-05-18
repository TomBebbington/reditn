package parser;
import js.*;
import js.html.*;
import data.*;
using StringTools;
class Markdown {
	public static var images:EReg = ~/!\[([^\]\(]*)]\(([^\)]*)\)/;
	static var regex = [ // adapted from Slimdown
		{ from: ~/(\*\*|__)([^\1\n]*?)\1/, to: "<b>$2</b>" },
		{ from: ~/(\*|_)([^\1\n]*?)\1/, to: "<em>$2</em>" },
		{ from: ~/^[\*|+|-] (.*)$/m, to: "<ul><li>$1</li></ul>"},
		{ from: ~/<\/ul><ul>/, to: ""},
		{ from: ~/\n> ([^\n\r]*)/, to: "<blockquote>$1</blockquote>"},
		{ from: ~/<\/blockquote>\n?\r?<blockquote>$/, to: ""},
		{ from: ~/~~([^~]*?)~~/, to: "<del>$1</del>" },
		{ from: ~/\^([^\^]+)/, to: "<sup>$1</sup>" },
		{ from: ~/:"([^:"]*?)":/, to: "<q>$1</q>"},
		{ from: images, to: "" },
		{ from: ~/\[([^\]\(]*)]\(([^\)]*)\)/, to: "<a href=\"$2\">$1</a>" },
		{ from: ~/!\[([^\]\(]*)]\(([^\)]*)\)/, to: "" },
		{ from: ~/(.*)\n\r?(==+)\n/, to: "<h2>$1</h2>"},
		{ from: ~/(.*)\n\r?((-|#)+)\n/, to: "<h3>$1</h3>"},
		{ from: ~/(```*)([^`]+)\1/m, to: "<code>$2</code>"},
		{ from: ~/<pre>(.*)\n\n(.*)<\/pre>/, to: "<pre>$1\n$2</pre>"},
		{ from: ~/\n\n+/, to: "<br>\n"}
	];
	static var header = ~/^([#|=]+)([^#=]+)\1?$/m;
	static var quotes = ~/"([^"]*)"/;
	public static function parse(s:String):String {
		while(header.match(s)) {
			var pos = header.matchedPos(), len = 1 + header.matched(1).length;
			if(len > 6)
				len = 6;
			s = header.matchedLeft() + '<h${len}>${header.matched(2)}</h${len}>' + header.matchedRight();
		}
		for(r in regex)
			while(r.from.match(s))
				s = r.from.replace(s, r.to);
		return s;
	}
}