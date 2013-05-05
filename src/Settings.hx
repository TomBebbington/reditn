import js.*;
import js.html.*;
import data.*;
import haxe.ds.StringMap;
import haxe.crypto.BaseCode;
class Settings {
	static inline var NOTE_TEXT = "Close this dialog and refresh the page to see your changes in effect. Changes will be saved automatically.";
	public static inline var ADBLOCK = "adblock";
	public static inline var USERINFO = "userinfo";
	public static inline var SUBINFO = "subinfo";
	public static inline var EXPAND = "expand";
	public static inline var DUPLICATE_HIDER = "dup-hider";
	public static inline var USER_TAGGER = "user-tag";
	public static inline var SUBREDDIT_TAGGER = "sub-tag";
	public static inline var PREVIEW = "preview";
	public static inline var KEYBOARD = "keys";
	public static inline var USER_TAGS = "user-tags";
	public static inline var SUBREDDIT_TAGS = "sub-tags";
	public static inline var FILTER_NSFW = "nsfw-filter";
	static var SAVE_BASE = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ=/";
	static var DESC = [
		ADBLOCK => "Block advertisements and sponsors",
		USERINFO => "Show information about a user upon hover",
		SUBINFO => "Show information about a subreddit upon hover",
		EXPAND => "Allow expansion of images",
		DUPLICATE_HIDER => "Hide duplicate links",
		USER_TAGGER => "Tag users",
		SUBREDDIT_TAGGER => "Tag subreddits",
		PREVIEW => "Preview comments and posts",
		KEYBOARD => "Keyboard shortcuts",
		FILTER_NSFW => "Hide NSFW content"
	];
	public static var DEFAULTS:StringMap<Dynamic> = untyped [
		ADBLOCK => true,
		USERINFO => true,
		SUBINFO => true,
		EXPAND => true,
		DUPLICATE_HIDER => true,
		USER_TAGGER => true,
		SUBREDDIT_TAGGER => true,
		PREVIEW => true,
		KEYBOARD => true,
		FILTER_NSFW => true,
		USER_TAGS => new Map<String, String>(),
		SUBREDDIT_TAGS => new Map<String, String>()
	];
	public static var data = new StringMap<Dynamic>();
	static function optimisedData():String {
		var e = new Map<String, Dynamic>();
		for(k in data.keys()) {
			var v:Dynamic = data.get(k);
			if(DEFAULTS.get(k) != v)
				e.set(k, v);
		}
		return haxe.Serializer.run(e);
	}
	public static function save() {
		haxe.Serializer.USE_CACHE = false;
		Browser.window.localStorage.setItem("reditn", optimisedData());
	}
	public static function init() {
		var dt = Browser.window.localStorage.getItem("reditn");
		if(dt != null)
			Settings.data = try haxe.Unserializer.run(dt) catch(e:Dynamic) data;
		fixMissing();
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
		Reditn.fullPopUp(e);

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
			fixMissing(true);
			save();
			settingsPopUp();
		}
		form.appendChild(delb);
		var export = makeButton("Export settings to text", function() Browser.window.alert(Browser.window.btoa(optimisedData())));
		form.appendChild(export);
		var importbtn = makeButton("Import settings", function() {
			data = haxe.Unserializer.run(Browser.window.atob(Browser.window.prompt("Settings to import", Browser.window.btoa(optimisedData()))));
			fixMissing();
			save();
			settingsPopUp();
		});
		form.appendChild(importbtn);
		form.appendChild(Browser.document.createBRElement());
		for(k in data.keys()) {
			var d = data.get(k);
			if(!Std.is(d, StringMap) && DESC.exists(k)) {
				var l = DESC.get(k);
				var label = Browser.document.createLabelElement();
				label.setAttribute("for", k);
				label.style.position = "absolute";
				label.style.width = "46%";
				label.style.textAlign = "right";
				label.innerHTML = '$l ';
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
		var note = Browser.document.createDivElement();
		note.style.fontWeight = "bold";
		note.innerHTML = NOTE_TEXT;
		form.appendChild(note);
		e.appendChild(form);
	}
	static function makeButton(t:String, ?fn:Void->Void) {
		var b = Browser.document.createInputElement();
		b.type = "button";
		b.value = t;
		b.onclick = untyped fn;
		return b;
	}
	static function fixMissing(all:Bool=false) {
		for(k in DEFAULTS.keys()) {
			if(all || !data.exists(k))
				data.set(k, Std.is(DEFAULTS.get(k), StringMap) ? new StringMap() : DEFAULTS.get(k));
		}
	}
}