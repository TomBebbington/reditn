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
		{ from: ~/{{([^{}]*)}}/, to: "" },
		{ from: ~/\[([^ \[\]]*) ([^\[\]]*)\]/, to: "" },
		{ from: ~/'''([^']*)'''/, to: "<b>$1</b>" },
		{ from: ~/''([^']*)''/, to: "<em>$1</em>" },
		{ from: ~/^======([^=]*)======/m, to: "<h6>$1</h6>" },
		{ from: ~/^=====([^=]*)=====/m, to: "<h5>$1</h5>" },
		{ from: ~/^====([^=]*)====/m, to: "<h4>$1</h4>" },
		{ from: ~/^===([^=]*)===/m, to: "<h3>$1</h3>" },
		{ from: ~/^==([^=]*)==/m, to: "<h2>$1</h2>" },
		{ from: ~/\n\* ?([^\n]*)/, to: "<li>$1</li>" },
		{ from: ~/<ref>[^<>]*<\/ref>/, to: "" },
		{ from: ~/\n/, to: "" },
		{ from: ~/<br><br>/, to: "<br>" },
		{ from: ~/<!--Interwiki links-->.*/, to: "" }
	];
	public static function parse(s:String, base:String):String {
		for(r in regex)
			while(r.from.match(s))
				s = r.from.replace(s, r.to);
		s = s.replace("$BASE", base);
		return s;
	}
}