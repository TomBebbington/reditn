import js.*;
import js.html.*;
import data.*;
using StringTools;
class Markdown {
	static var regex = [
		~/\*\*([^\*]*)\*\*/ => "<b>$1</b>",
		~/\*([^\*]*)\*/ => "<em>$1</em>"
		//~/~~([^~]*)~~/ => "<del>$1</del>",
		//~/\^([^\^]*)/ => "<sup>$1</sup>",
		//~/\[([^\]]*)\]\(([^\)]*)\)/ => "<a href=\"$2\">$1</a>"
	];
	public static function parse(s:String):String {
		for(r in regex.keys()) {
			trace('$r does ${!r.match(s)?"not ":""}match $s');
			while(r.match(s)) {
				var t = s;
				s = r.replace(s, regex.get(r));
				trace('$t after $r => $s');
			}
		}
		return s;
	}
}