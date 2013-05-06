import js.*;
import js.html.*;
import data.*;
class SubredditInfo {
	public static function init() {
		var subs:Array<Element> = cast Browser.document.body.getElementsByClassName("subreddit");
		for(i in subs)
			i.onmouseover = _onMouseOverSubreddit;
	}
	static function _onMouseOverSubreddit(e:Event) {
		var e:Element = cast e.target;
		var name:String = e.innerHTML;
		var div = Browser.document.createElement("div");
		Reditn.popUp(e, div, e.offsetLeft + e.offsetWidth, e.offsetTop);
		Reditn.getJSON('/r/${name}/about.json', function(d:Subreddit){
			var title:String = d.display_name,
				subs:String = Reditn.formatNumber(d.subscribers),
				users:String = Reditn.formatNumber(d.accounts_active),
				desc:String = if(d.description_html != null)
					StringTools.htmlUnescape(d.description_html);
				else if(d.public_description != null)
					Markdown.parse(d.public_description);
				else
					Markdown.parse(d.description),
				age:String = Reditn.age(d.created_utc);
			var html = '<b>Name:</b> $name <br>';
			var ts = SubredditTagger.tags;
			if(ts.exists(name))
				html += '<b>Tag:</b> ${ts.get(name)}<br>';
			html += '<b>Subscribers:</b> $subs <br>';
			html += '<b>Active Users:</b> $users <br>';
			html += '<b>Description:</b> $desc <br>';
			html += '<b>Age:</b> $age <br>';
			div.innerHTML = html;
		});
	}
}