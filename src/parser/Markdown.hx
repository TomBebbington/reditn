package parser;
import js.*;
import js.html.*;
import data.*;
using StringTools;
class Markdown {
	static var regex = [
		~/\*\*([^\*]*)\*\*/ => "<b>$1</b>",
		~/\*([^\*]*)\*/ => "<em>$1</em>",
		~/~~([^~]*)~~/ => "<del>$1</del>",
		~/\^([^\^]*)/ => "<sup>$1</sup>"
		//~/\[([^\]]*)\]\(([^\)]*)\)/ => "<a href=\"$2\">$1</a>"
	];
	public static function parse(s:String):String {
		for(r in regex.keys())
			while(r.match(s))
				s = r.replace(s, regex.get(r));
		return s;
	}
}