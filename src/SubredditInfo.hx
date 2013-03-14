import js.*;
import js.html.*;
class SubredditInfo {
	public static function init() {
		var subs:Array<Element> = cast Browser.document.body.getElementsByClassName("subreddit");
		for(i in subs)
			i.onmouseover = _onMouseOverSubreddit;
	}
	static function _onMouseOverSubreddit(e:Dynamic) {
		var e:Element = e.target;
		var name:String = e.innerHTML;
		var div = Browser.document.createElement("div");
		Reditn.popUp(e, div, e.offsetLeft + e.offsetWidth, e.offsetTop);
		Reditn.getJSON('/r/${name}/about.json', function(d:Dynamic){
			if(d.data != null)
				d = d.data;
			var title:String = d.display_name,
				subs:String = Reditn.formatNumber(d.subscribers),
				desc:String = Markdown.parse(d.public_description == null ? d.description : d.public_description),
				age:String = Reditn.age(d.created_utc);
			var html = '<b>Name:</b> ${name}<br>';
			html += '<b>Subscribers:</b> ${subs}<br>';
			html += '<b>Description:</b> ${desc}<br>';
			html += '<b>Age:</b> ${age}<br>';
			div.innerHTML = html;
		});
	}
}