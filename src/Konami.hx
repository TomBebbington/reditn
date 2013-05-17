import js.html.*;
import js.*;
class Konami {
	static var words = ["wubba", "mcwubber", "dubba", "dadubber"];
	static function combo() {
		var len = Std.random(6) + 2;
		var s = "";
		for(i in 0...len)
			s += words[Std.random(words.length)] + " ";
		s = s.substr(0, s.length-1);
		s = s.charAt(0).toUpperCase() + s.substr(1);
		return s;
	}
	public static function run() {
		Browser.document.title = "Dubbit - the front page of the wubbanet";
		for(l in Reditn.links)
			l.innerHTML = combo();
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
	}
}