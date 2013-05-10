package parser;
import js.*;
import js.html.*;
import data.*;
using StringTools;
class Markdown {
	static var regex = [
		{ from: ~/\*\*([^\*]*)\*\*/, to: "<b>$1</b>" },
		{ from: ~/\*([^\*]*)\*/, to: "<em>$1</em>" },
		{ from: ~/~~([^~]*)~~/, to: "<del>$1</del>" },
		{ from: ~/\^([^\^]*)/, to: "<sup>$1</sup>" },
		{ from: ~/\[([^\]]*)\]\(([^\)]*)\)/, to: "<a href=\"$2\">$1</a>" },
		{ from: ~/\n\n/, to: "<br>"},
		{ from: ~/^#####([^#\n]*)(#####)?/m, to: "<h5>$1</h5>" },
		{ from: ~/^####([^#\n]*)(####)?/m, to: "<h4>$1</h4>" },
		{ from: ~/^###([^#\n]*)(###)?/m, to: "<h3>$1</h3>" },
		{ from: ~/^##([^#\n]*)(##)?/m, to: "<h2>$1</h2>" },
		{ from: ~/^#([^#\n]*)(#)?/m, to: "<h1>$1</h1>" }
	];
	public static function parse(s:String):String {
		trace('Parsing $s');
		for(r in regex)
			while(r.from.match(s))
				s = r.from.replace(s, r.to);
		trace('Parsed $s');
		return s;
	}
}