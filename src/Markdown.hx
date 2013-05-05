import js.*;
import js.html.*;
import data.*;
using StringTools;
class Markdown {
	static var regex:Array<Regex> = [
		{from: ~/\x3E ([^\n]+)/g, to: "<blockquote>$1</blockquote>"},
		{from: ~/___([^___]+)___/g, to: "<b><i>$1</i></b>"},
		{from: ~/\*\*([^\*\*|\*]+)\*\*/g, to: "<b>$1</b>"},
		{from: ~/__([^__|_]+)__/g, to: "<b>$1</b>"},
		{from: ~/\*([^\*|\*\*]+)\*/g, to: "<i>$1</i>"},
		{from: ~/_([^_|__]+)_/g, to: "<i>$1</i>"},
		{from: ~/\[([^\]]+)\]\(([^\)]+)\)/g, to: "<a href=\"$2\">$1</a>"},
		{from: ~/(.*?)\n\x3D=*/g, to: "<h2>$1</h2>"},
		{from: ~/(.*?)\n\x2D-*/g, to: "<h3>$1</h3>"},
		{from: ~/\x23\x23\x23\x23\x23\x23([^\n]+)\n/g, to: "<h6>$1</h6>"},
		{from: ~/\x23\x23\x23\x23\x23([^\n]+)\n/g, to: "<h5>$1/h5>"},
		{from: ~/\x23\x23\x23\x23([^\n]+)\n/g, to: "<h4>$1</h4>"},
		{from: ~/\x23\x23\x23([^\n]+)\n/g, to: "<h3>$1</h3>"},
		{from: ~/\x23\x23([^\n]+)\n/g, to: "<h2>$1</h2>"},
		{from: ~/\x23([^\n]+)\n/g, to: "<h1>$1</h1>"},
		{from: ~/\n?([^\n]+)\n\n/g, to: "<p>$1</p>"},
		{from: ~/\n?([^\n]+)\n/g, to: "$1 "},
		{from: ~/\n[\+\*\-] ([^\n]+)/g, to: "<li><p>$1</p></li>"},
		{from: ~/\n[0-9]*[.\):]([^\n]+)/g, to: "<li><p>$1</p></li>"},
		{from: ~/\x3Cli\x3E([^\n+]+)\x3C\/li\x3E/, to: "<ul><li>$1</li></ul>"}
	];
	public static function parse(s:String):String {
		for(r in regex)
			s = r.from.replace(s, r.to);
		return s.trim();
	}
}
typedef Regex = {
	var from:EReg;
	var to:String;
}