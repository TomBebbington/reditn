import js.*;
import js.html.*;
import data.*;
import haxe.ds.StringMap;
import haxe.crypto.BaseCode;
import ext.Storage.*;
import ext.*;
class Settings {
	static inline var NOTE_TEXT = "Close this dialog and refresh the page to see your changes in effect. Changes will be saved automatically.";
	static var settings:Map<String, Setting<Dynamic>> = [
		"adblock" => { def: true, desc: "Block advertisements and sponsors" },
		"userinfo" => { def: true, desc: "Show information about a user upon hover" },
		"subinfo" => { def: true, desc: "Show information about a subreddit upon hover" },
		"expand" => { def: true, desc: "Allow expansion of articles, images, albums and the like" },
		"text-expand" => { def: true, desc: "Allow expansion of links found in comments and posts" },
		"dup-hider" => { def: true, desc: "Hide duplicates" },
		"user-tag" => { def: true, desc: "Tag users with nicknames" },
		"sub-tag" => { def: true, desc: "Tag subreddits with nicknames" },
		"autoscroll" => { def: true, desc: "Seamless scrolling between pages" },
		"preview" => { def: true, desc: "Preview comments and self posts before they are published" },
		"keyboard" => { def: false, desc: "Keyboard navigation of the links in the page" },
		"nsfw-filter" => { def: false, desc: "Filter NSFW posts" },
		"user-tags" => { def: new Map<String, String>(), desc: null },
		"sub-tags" => { def: new Map<String, String>(), desc: null }
	];
	public static var data(get, never):Map<String, Dynamic>;
	static inline function get_data() {
		return Storage.data;
	}
	static function optimise() {
		for(k in settings.keys()) {
			var sv = settings.get(k), cv = data.get(k);
			if(sv.def != cv)
				data.set(k, cv);
			else
				data.remove(k);
		}
	}
	public static inline function save() {
		optimise();
		Storage.flush();
		fixMissing();
		Browser.notify({title: "Reditn", message: "Saved settings", timeout: 5, icon: "http://f.thumbs.redditmedia.com/9czWHOWglYtAM40q.jpg"});
	}
	static function fixMissing(def:Bool=false) {
		for(k in settings.keys())
			if(!data.exists(k) || def || data.get(k) == untyped __js__("undefined"))
				data.set(k, settings.get(k).def);
	}
	public static function init() {
		fixMissing();
		var h = Browser.document.getElementById("header-bottom-right");
		if(h == null)
			return;
		var prefs:Element = cast h.getElementsByTagName("ul")[0];
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
			if(Browser.window.confirm("Are you sure? This will delete all user tags, subreddit tags and settings!")) {
				fixMissing(true);
				save();
				settingsPopUp();
			}
		}
		form.appendChild(delb);
		/*
		var export = makeButton("Export settings to text", function() Browser.window.alert(Browser.window.btoa(data)));
		form.appendChild(export);
		var importbtn = makeButton("Import settings", function() {
			data = haxe.Unserializer.run(Browser.window.atob(Browser.window.prompt("Settings to import", Browser.window.btoa(data))));
			fixMissing();
			flush();
			settingsPopUp();
		});
		form.appendChild(importbtn);*/
		form.appendChild(Browser.document.createBRElement());
		for(k in settings.keys()) {
			var s = settings.get(k);
			var d = data.get(k);
			if(s.desc != null) {
				var label = Browser.document.createLabelElement();
				label.setAttribute("for", k);
				label.style.position = "absolute";
				label.style.width = "46%";
				label.style.textAlign = "right";
				label.innerHTML = s.desc;
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
				else
					"text";
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
}
typedef Setting<T> = {
	var desc:String;
	var def:T;
}