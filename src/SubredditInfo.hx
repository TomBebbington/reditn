import js.*;
import js.html.*;
class SubredditInfo {
	public static inline var offset = 3;
	public static function init() {
		var subs:Array<Element> = cast Browser.document.body.getElementsByClassName("subreddit");
		for(i in subs)
			i.onmouseover = _onMouseOverSubreddit;
	}
	static function _onMouseOverSubreddit(e:Dynamic) {
		var e:Element = e.target;
		var name:String = e.innerHTML;
		var div = Browser.document.createElement("div");
		Reditn.popUp(e, div, e.offsetLeft + e.offsetWidth + offset, e.offsetTop);
		Reditn.getJSON('/r/${name}/about.json', function(d:Dynamic){
			if(d.data != null)
				d = d.data;
			var html = '<b>Name:</b> ${d.display_name}<br>';
			html += '<b>Subscribers:</b> ${Reditn.formatNumber(d.subscribers)}<br>';
			html += '<b>Description:</b> ${d.public_description}<br>';
			var age = Reditn.age(d.created_utc);
			html += '<b>Age:</b> ${age}<br>';
			div.innerHTML = html;
		});
	}
}