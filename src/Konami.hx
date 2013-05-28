import js.html.*;
import js.*;
using StringTools;
class Konami {
	static var words = ["wubba", "mcwubber", "dubba", "dadubber"];
	static var filter:EReg = ~/[a-zA-Z]*/;
	static function translate(p:String):String {
		var pos = 0;
		while(filter.matchSub(p, pos)) {
			var mp = filter.matchedPos();
			var word = words[Std.random(words.length)];
			pos = mp.pos + word.length;
			p = filter.matchedLeft() + word + filter.matchedRight();
		}
		return p;
	}
	public static function run() {
		Browser.document.title = "Dubbit - the back page of the wubbanet";
		for(l in Reditn.links)
			l.innerHTML = translate(l.innerHTML);
		for(a in Browser.document.body.getElementsByClassName("author")) {
			var a:Element = cast a;
			a.innerHTML = "dubstep";
		}
		for(s in Browser.document.body.getElementsByClassName("subreddit")) {
			var s:Element = cast s;
			s.innerHTML = "people with brains";
		}
		for(s in Browser.document.body.getElementsByClassName("score")) {
			var s:Element = cast s;
			s.innerHTML = "-&infin;";
		}
		for(p in ext.Browser.document.body.getElementsByTagName("p")) {
			var p:Element = cast p;
			if(p.className == "parent")
				continue;
			p.innerHTML = translate(p.innerHTML);
		}
	}
}