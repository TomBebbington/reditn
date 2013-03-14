import js.*;
import js.html.*;
import haxe.ds.StringMap;
class Settings {
	public static inline var ADBLOCK_ENABLED = "Block advertisements and sponsors";
	public static inline var USERINFO_ENABLED = "Show information about a user upon hover";
	public static inline var SUBINFO_ENABLED = "Show information about a subreddit upon hover";
	public static inline var EXPAND_ENABLED = "Show image expansion buttons";
	public static inline var DUPLICATE_HIDER_ENABLED = "Hide duplicates";
	public static inline var USER_TAGGER_ENABLED = "Tag nicknames to users";
	public static inline var SUBREDDIT_TAGGER_ENABLED = "Tag nicknames to subreddits";
	public static inline var PREVIEW_ENABLED = "Preview any comments or posts I make";
	public static inline var USER_TAGS = "User tags";
	public static inline var SUBREDDIT_TAGS = "Subreddit tags";
	public static var defaults = {
		var m = new Map<String, Dynamic>();
		m.set(ADBLOCK_ENABLED, true);
		m.set(USERINFO_ENABLED, true);
		m.set(SUBINFO_ENABLED, true);
		m.set(EXPAND_ENABLED, true);
		m.set(DUPLICATE_HIDER_ENABLED, true);
		m.set(USER_TAGGER_ENABLED, true);
		m.set(SUBREDDIT_TAGGER_ENABLED, true);
		m.set(PREVIEW_ENABLED, true);
		m.set(USER_TAGS, new StringMap<String>());
		m.set(SUBREDDIT_TAGS, new StringMap<String>());
		m;
	};
	public static var data = new StringMap<Dynamic>();
	public static function save() {
		haxe.Serializer.USE_CACHE = false;
		Browser.window.localStorage.setItem("reditn", haxe.Serializer.run(data));
	}
	public static function init() {
		var dt = Browser.window.localStorage.getItem("reditn");
		if(dt != null)
			data = haxe.Unserializer.run(dt);
		for(k in defaults.keys())
			if(!data.exists(k) || !Std.is(data.get(k), Type.getClass(defaults.get(k))))
				data.set(k, defaults.get(k));
		var h = Browser.document.getElementById("header-bottom-right");
		var prefs = untyped h.getElementsByTagName("ul")[0];
		var d = Browser.document.createAnchorElement();
		d.innerHTML = "reditn";
		d.className = "pref-lang";
		d.href = "javascript:void(0);";
		d.onclick = function(e) settingsPopUp();
		if(prefs == null)
			h.appendChild(d);
		else
			h.insertBefore(d, prefs);
		var sep = Browser.document.createSpanElement();
		sep.innerHTML = " | ";
		sep.className = "seperator";
		sep.style.fontWeight = "none";
		h.insertBefore(sep, prefs);
	}
	static function settingsPopUp() {
		var old = Browser.document.getElementById("reditn-config");
		if(old != null)
			Reditn.remove(old);
		var e = Browser.document.createDivElement();
		var h = Browser.document.createElement("h1");
		h.innerHTML = "Reditn settings";
		e.appendChild(h);
		e.appendChild(createForm());
		Reditn.fullPopUp(e);
	}
	static function createForm():FormElement {
		var form = Browser.document.createFormElement();
		form.id = "reditn-config";
		form.action = "javascript:void(0);";
		form.onchange = function(ev) {
			var a:Array<InputElement> = cast form.childNodes;
			for(i in a) {
				if(i.type == "button")
					continue;
				if(i.nodeName.toLowerCase() != "input")
					continue;
				var i:js.html.InputElement = cast i;
				var val:Dynamic = switch(i.type.toLowerCase()) {
					case "checkbox": i.checked;
					default: i.value;
				}
				data.set(i.name, val);
			}
			save();
		}
		var delb = Browser.document.createInputElement();
		delb.type = "button";
		delb.value = "Restore default settings";
		delb.onclick = function(_) {
			restoreDefaults();
			settingsPopUp();
		}
		form.appendChild(delb);
		form.appendChild(Browser.document.createBRElement());
		for(k in data.keys()) {
			var d = data.get(k);
			if(!Std.is(d, StringMap) && defaults.exists(k)) {
				var label = Browser.document.createLabelElement();
				label.setAttribute("for", k);
				label.style.position = "absolute";
				label.style.width = "46%";
				label.style.textAlign = "right";
				label.innerHTML = k+" ";
				form.appendChild(label);
				var input = Browser.document.createInputElement();
				input.style.position = "absolute";
				input.style.left = "54%";
				input.style.textAlign = "left";
				input.style.width = "46%";
				input.name = k;
				form.appendChild(input);
				form.appendChild(Browser.document.createBRElement());
				input.type = if(Std.is(d, Bool))
					"checkbox";
				else if(Std.is(d, String))
					"text";
				else if(Std.is(d, Date))
					"datetime";
				else if(Std.is(d, Int))
					"number";
				if(Std.is(d, Bool))
					input.checked = data.get(k);
				else input.value = data.get(k);
			}
		}
		return form;
	}
	static function restoreDefaults() {
		for(k in defaults.keys())
			data.set(k, defaults.get(k));
	}
}