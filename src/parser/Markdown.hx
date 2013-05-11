package parser;
import js.*;
import js.html.*;
import data.*;
using StringTools;
class Markdown {
	public static var images:EReg = ~/!\[([^\]]*)\]\(([^\)\.]*\.(jpg|bmp|png|jpeg|gif))\)/;
	static var regex = [
		{ from: ~/\*\*([^\*]*)\*\*/, to: "<b>$1</b>" },
		{ from: ~/\*([^\*]*)\*/, to: "<em>$1</em>" },
		{ from: ~/~~([^~]*)~~/, to: "<del>$1</del>" },
		{ from: ~/\^([^\^]*)/, to: "<sup>$1</sup>" },
		{ from: ~/^(\*|\+|\-) ([^\n]*)$/, to: "<li>$1</li>"},
		{ from: images, to: "" },
		{ from: ~/\[([^\]]*)\]\(([^\)]*)\)/, to: "<a href=\"$2\">$1</a>" },
		{ from: ~/^#*([^#\n])(#*)?$/m, to: "<h2>$1</h2>"},
		{ from: ~/^#####([^#\n]*)(#####)?$/m, to: "<h2>$1</h2>" },
		{ from: ~/^([^\n]*)$^[=]*$/m, to: "<h2>$1</h2>"},
		{ from: ~/^([^\n]*)$^\n[#]*$/m, to: "<h2>$1</h2>"},
		{ from: ~/^####([^#\n]*)(####)?$/m, to: "<h3>$1</h3>" },
		{ from: ~/^([^\n]*)$^[-]*$/m, to: "<h3>$1</h3>"},
		{ from: ~/^###([^#\n]*)(###)?$/m, to: "<h4>$1</h4>" },
		{ from: ~/^##([^#\n]*)(##)?$/m, to: "<h5>$1</h5>" },
		{ from: ~/^#([^#\n]*)(#)?$/m, to: "<h6>$1</h6>" },
		{ from: ~/```([^`]*)```/m, to: "<pre>$1</pre>"},
		{ from: ~/\n\n/, to: "<br>\n"}
	];
	public static function parse(s:String):String {
		for(r in regex)
			while(r.from.match(s))
				s = r.from.replace(s, r.to);
		return s;
	}
}