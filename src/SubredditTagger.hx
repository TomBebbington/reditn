import js.*;
import js.html.*;
import haxe.ds.*;
using StringTools;
class SubredditTagger {
	static var tags(get, null):StringMap<String>;
	static inline function get_tags() {
		return Settings.data.get(Settings.SUBREDDIT_TAGS);
	}
	public static function init() {
		var d:Array<AnchorElement> = cast Browser.document.body.getElementsByClassName("subreddit");
		for(s in d)
			getTag(s);
	}
	public static function getTag(a:AnchorElement) {
		var tagline = a.parentNode;
		var tag = Browser.document.createSpanElement();
		var sub = a.innerHTML.trim();
		var currentTag = tags.exists(sub) ? tags.get(sub) : null;
		tag.className="flair";
		var tagName = Browser.document.createSpanElement();
		tagName.innerHTML = currentTag == null ? "" : currentTag.htmlEscape()+" ";
		tag.appendChild(tagName);
		var link = Browser.document.createAnchorElement();
		link.href = "javascript:void(0);";
		link.innerHTML = "[+]";
		tag.appendChild(link);
		link.onclick = function(e) {
			var div = Browser.document.createDivElement();
			var label = Browser.document.createLabelElement();
			label.setAttribute("for", "tag-change");
			label.innerHTML = 'Tag for $sub ';
			div.appendChild(label);
			var box = Browser.document.createInputElement();
			box.name = "tag-change";
			box.value = currentTag;
			box.style.width = "100%";
			box.onchange = function(ev) {
				tags.set(sub, box.value);
				tagName.innerHTML = box.value.htmlEscape()+" ";
				Settings.save();
			}
			div.appendChild(box);
			Reditn.fullPopUp(div, link);
			box.focus();
		}
		Reditn.insertAfter(tag, a);
	}
}