import js.Browser;
import js.html.*;
import haxe.ds.StringMap;
import data.*;
using StringTools;
class UserTagger {
	static var tags(get, null):StringMap<String>;
	static inline function get_tags() {
		return Settings.data.get(Settings.USER_TAGS);
	}
	public static function init() {
		var authors:Array<AnchorElement> = cast Browser.document.body.getElementsByClassName("author");
		for(a in authors)
			getTag(a);
	}
	public static function getTag(a:AnchorElement) {
		var tagline = a.parentNode;
		var tag = Browser.document.createSpanElement();
		var user = a.innerHTML.trim();
		var currentTag = tags.exists(user) ? tags.get(user) : null;
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
			label.innerHTML = 'Tag for $user ';
			div.appendChild(label);
			var box = Browser.document.createInputElement();
			box.name = "tag-change";
			box.value = currentTag;
			box.style.width = "100%";
			box.onchange = function(ev) {
				tags.set(user, box.value);
				tagName.innerHTML = box.value.htmlEscape()+" ";
				Settings.save();
				Reditn.remove(div);
			}
			div.appendChild(box);
			Reditn.fullPopUp(div, link.offsetTop + link.offsetHeight);
			box.focus();
		}
		Reditn.insertAfter(tag, a);
	}
}