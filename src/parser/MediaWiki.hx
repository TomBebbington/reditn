package parser;
import js.*;
import js.html.*;
import data.*;
using StringTools;
class MediaWiki {
	static var regex = [
		~/\[\[([^\]\|]*)\]\]/ => '<a href="${base}/wiki/$$1">$$1</a>',
		~/\[\[([^\]\|]*)\|([^\]\|]*)\]\]/ => '<a href="${base}/wiki/$$1">$$2</a>',
		~/\[\[File:([^\]]*)\]\]/ => "",
		~/{{spaced ndash}}/ => " - ",
		~/{{([^{}]*)}}/ => "",
		~/\[([^ \[\]]*) ([^\[\]]*)\]/ => "",
		~/'''([^']*)'''/ => "<b>$1</b>",
		~/''([^']*)''/ => "<em>$1</em>",
		~/======([^=]*)======/ => "<h6>$1</h6>",
		~/=====([^=]*)=====/ => "<h5>$1</h5>",
		~/====([^=]*)====/ => "<h4>$1</h4>",
		~/===([^=]*)===/ => "<h3>$1</h3>",
		~/==([^=]*)==/ => "<h2>$1</h2>",
		~/\n\* ?([^\n]*)/ => "<li>$1</li>",
		~/<ref>[^<>]*<\/ref>/ => "",
		~/\n/ => "",
		~/<br><br>/ => "<br>",
		~/<!--Interwiki links-->.*/ => ""
	];
	public static function parse(s:String):String {
		for(r in regex.keys())
			while(r.match(s))
				s = r.replace(s, regex.get(r));
		return s;
	}
}