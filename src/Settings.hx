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
	public static inline var USER_TAGS = "User tags";
	public static var values = {
		var m = new Map<String, Dynamic>();
		m.set(ADBLOCK_ENABLED, true);
		m.set(USERINFO_ENABLED, true);
		m.set(SUBINFO_ENABLED, true);
		m.set(EXPAND_ENABLED, true);
		m.set(DUPLICATE_HIDER_ENABLED, true);
		m.set(USER_TAGGER_ENABLED, true);
		m.set(USER_TAGS, new StringMap<String>());
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
		for(k in values.keys())
			if(!data.exists(k))
				data.set(k, values.get(k));
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
		h.insertBefore(sep, prefs);
	}
	static function settingsPopUp() {
		var e = Browser.document.createDivElement();
		var h = Browser.document.createElement("h1");
		h.innerHTML = "Reditn settings";
		e.appendChild(h);
		e.appendChild(createForm(values));
		Reditn.fullPopUp(e);
	}
	static function createForm(values:StringMap<Dynamic>, create:Bool=false):FormElement {
		var form = Browser.document.createFormElement();
		form.action = "javascript:void(0);";
		form.onchange = function(ev) {
			var a:Array<Element> = cast form.childNodes;
			for(i in a) {
				if(i.nodeName.toLowerCase() != "input")
					continue;
				var i:js.html.InputElement = cast i;
				var val:Dynamic = switch(i.type.toLowerCase()) {
					case "checkbox": i.checked == true;
					default: i.value;
				}
				data.set(i.name, i.value);
			}
			save();
		}
		for(k in values.keys()) {
			var d = values.get(k);
			if(!Std.is(d, StringMap)) {
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
}